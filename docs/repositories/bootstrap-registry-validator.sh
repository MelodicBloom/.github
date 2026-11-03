#!/usr/bin/env bash
set -euo pipefail

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
  [[ -z "$(git -C "$WORKDIR" status --porcelain)" ]] || { echo "Existing checkout has changes; refusing to switch." >&2; exit 2; }
  git -C "$WORKDIR" fetch --no-tags origin "+refs/heads/$BRANCH:refs/remotes/origin/$BRANCH"
  if git -C "$WORKDIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git -C "$WORKDIR" checkout "$BRANCH"
  else
    git -C "$WORKDIR" checkout -b "$BRANCH" --track "origin/$BRANCH"
  fi
  [[ "$(git -C "$WORKDIR" rev-parse HEAD)" = "$(git -C "$WORKDIR" rev-parse "refs/remotes/origin/$BRANCH")" ]] || {
    echo "Local branch differs from origin/$BRANCH; reconcile it explicitly before validation." >&2; exit 2;
  }
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

npm ci --ignore-scripts --no-audit --no-fund
node scripts/automation/validate-repository-registry.mjs

echo
echo "Environment ready:"
echo "  repo:   $WORKDIR"
echo "  branch: $BRANCH"
echo "  node:   $(node --version)"
