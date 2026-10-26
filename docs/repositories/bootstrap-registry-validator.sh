#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/MelodicBloom/.github.git}"
BRANCH="${BRANCH:-docs/canonical-repository-registry-v1}"
WORKDIR="${1:-$PWD/melodicbloom-control-plane}"

if [[ ! -d "$WORKDIR/.git" ]]; then
  git clone "$REPO_URL" "$WORKDIR"
fi

cd "$WORKDIR"
git fetch origin --prune

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git checkout "$BRANCH"
else
  git checkout -b "$BRANCH" "origin/$BRANCH"
fi

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

echo "No npm dependencies are required for phase 1."
echo "Validator uses only the Node.js standard library."
node scripts/automation/validate-repository-registry.mjs

echo
echo "Environment ready:"
echo "  repo:   $WORKDIR"
echo "  branch: $BRANCH"
echo "  node:   $(node --version)"
