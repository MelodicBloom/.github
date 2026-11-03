#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git init --bare --quiet "$tmp/remote.git"
git push --quiet "$tmp/remote.git" HEAD:refs/heads/main
mkdir -p "$tmp/bin"
cat > "$tmp/bin/npm" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
[[ "$1" = ci ]]
if [[ ! -d node_modules ]]; then mkdir node_modules; cp -a "$BOOTSTRAP_TEST_DEPS/." node_modules/; fi
printf 'npm ci invoked\n' >> "$BOOTSTRAP_TEST_LOG"
SH
chmod +x "$tmp/bin/npm"
export PATH="$tmp/bin:$PATH" BOOTSTRAP_TEST_DEPS="$root/node_modules" BOOTSTRAP_TEST_LOG="$tmp/npm.log"
export REPO_URL="$tmp/remote.git" BRANCH=main
bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
[[ "$(wc -l < "$tmp/npm.log")" = 2 ]]
printf 'preserve me\n' > "$tmp/checkout/untracked-local.txt"
if bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null 2>&1; then
  echo 'dirty checkout was accepted' >&2; exit 1
fi
[[ "$(cat "$tmp/checkout/untracked-local.txt")" = 'preserve me' ]]
rm "$tmp/checkout/untracked-local.txt"
git -C "$tmp/checkout" remote set-url origin "$tmp/other.git"
if bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null 2>&1; then
  echo 'mismatched origin was accepted' >&2; exit 1
fi
echo 'PASS: clean clone and reuse; dirty checkout and wrong origin fail closed'
