#!/usr/bin/env bash
set -euo pipefail

# A caller may be inside another Git checkout with repository-location variables
# exported. Never let those variables redirect operations on WORKDIR.
while IFS= read -r git_var; do unset "$git_var"; done < <(git rev-parse --local-env-vars)

REPO_URL="${REPO_URL:-https://github.com/MelodicBloom/.github.git}"
BRANCH="${BRANCH:-main}"
WORKDIR="${1:-$PWD/melodicbloom-control-plane}"

git check-ref-format --branch "$BRANCH" >/dev/null
if [[ ! -e "$WORKDIR" ]]; then
  git clone --branch "$BRANCH" --single-branch -- "$REPO_URL" "$WORKDIR"
else
  [[ -d "$WORKDIR" ]] || { echo "Workdir exists but is not a directory." >&2; exit 2; }
  root="$(git -C "$WORKDIR" rev-parse --show-toplevel 2>/dev/null)" || { echo "Workdir is not a Git checkout." >&2; exit 2; }
  [[ "$(cd "$root" && pwd -P)" = "$(cd "$WORKDIR" && pwd -P)" ]] || { echo "Workdir is not a repository root." >&2; exit 2; }
  [[ "$(git -C "$WORKDIR" remote get-url origin)" = "$REPO_URL" ]] || { echo "Existing origin differs from REPO_URL; refusing to switch." >&2; exit 2; }
  [[ -z "$(git -C "$WORKDIR" status --porcelain --untracked-files=all)" ]] || { echo "Existing checkout has changes; refusing to switch." >&2; exit 2; }
  git -C "$WORKDIR" fetch --no-tags origin "+refs/heads/$BRANCH:refs/remotes/origin/$BRANCH"
  if git -C "$WORKDIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git -C "$WORKDIR" merge-base --is-ancestor "refs/heads/$BRANCH" "refs/remotes/origin/$BRANCH" || {
      echo "Local branch is ahead of or diverged from origin/$BRANCH; reconcile explicitly." >&2; exit 2;
    }
    git -C "$WORKDIR" checkout --no-overwrite-ignore "$BRANCH"
  else
    # The original single-branch clone may not map this ref for upstream tracking.
    # The bootstrap fetches it explicitly on every run, so do not alter origin's fetch configuration.
    git -C "$WORKDIR" checkout --no-overwrite-ignore --no-track -b "$BRANCH" "refs/remotes/origin/$BRANCH"
  fi
  if [[ "$(git -C "$WORKDIR" rev-parse HEAD)" != "$(git -C "$WORKDIR" rev-parse "refs/remotes/origin/$BRANCH")" ]]; then
    git -C "$WORKDIR" merge-base --is-ancestor HEAD "refs/remotes/origin/$BRANCH" || {
      echo "Local branch is ahead of or diverged from origin/$BRANCH; reconcile explicitly." >&2; exit 2;
    }
    git -C "$WORKDIR" merge --ff-only --no-overwrite-ignore "refs/remotes/origin/$BRANCH"
  fi
fi
cd "$WORKDIR"

if ! command -v node >/dev/null 2>&1; then
  if command -v nvm >/dev/null 2>&1; then
    nvm install 22.23.2
    nvm use 22.23.2
  else
    echo "Node.js is required. Install Node 22.23.2 or newer, then rerun." >&2
    exit 2
  fi
fi

NODE_MAJOR="$(node -p 'Number(process.versions.node.split(".")[0])')"
if (( NODE_MAJOR < 22 )); then
  echo "Node >=22 is required; found $(node --version)." >&2
  exit 2
fi

# npm ci removes node_modules. Preserve existing local edits and links inside
# Git metadata, which is excluded from checkout status and must be writable to fetch.
backup_dir=''
if [[ -e node_modules || -L node_modules ]]; then
  git_dir="$(git rev-parse --absolute-git-dir)"
  backup_dir="$(mktemp -d "$git_dir/registry-bootstrap-backup.XXXXXXXX")"
  mv -- node_modules "$backup_dir/node_modules"
  echo "Preserved previous node_modules at $backup_dir/node_modules" >&2
fi
install_pid=''
restore_failed_install() {
  local result=$?
  trap - EXIT
  if (( result != 0 )) && [[ -n "$backup_dir" ]]; then
    if [[ -e node_modules || -L node_modules ]]; then
      mv -- node_modules "$backup_dir/failed-install-node_modules" || { echo "Could not save partial install; original remains at $backup_dir/node_modules" >&2; return; }
    fi
    mv -- "$backup_dir/node_modules" node_modules || { echo "Could not restore dependencies; original remains at $backup_dir/node_modules" >&2; return; }
    echo "Install failed; previous node_modules restored. Partial install retained at $backup_dir" >&2
  fi
}
stop_install() {
  trap - INT TERM
  if [[ -n "$install_pid" ]]; then kill -TERM "$install_pid" 2>/dev/null || true; wait "$install_pid" 2>/dev/null || true; install_pid=''; fi
  exit "$1"
}
trap restore_failed_install EXIT
trap 'stop_install 130' INT
trap 'stop_install 143' TERM
npm ci --include=dev --ignore-scripts --no-audit --no-fund &
install_pid=$!
if wait "$install_pid"; then
  install_pid=''
  trap - EXIT INT TERM
else
  result=$?; install_pid=''; exit "$result"
fi
node scripts/automation/validate-repository-registry.mjs

echo
echo "Environment ready:"
echo "  repo:   $WORKDIR"
echo "  branch: $BRANCH"
echo "  node:   $(node --version)"

