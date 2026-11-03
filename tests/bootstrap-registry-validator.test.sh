#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git init --bare --quiet "$tmp/remote.git"
mkdir -p "$tmp/source/scripts/automation" "$tmp/source/schemas/repositories" "$tmp/source/repositories"
cp "$root/package.json" "$root/package-lock.json" "$root/.gitignore" "$tmp/source/"
cp "$root/scripts/automation/validate-repository-registry.mjs" "$tmp/source/scripts/automation/"
cp "$root/schemas/repositories/registry.schema.json" "$tmp/source/schemas/repositories/"
cp "$root/repositories/registry.yml" "$tmp/source/repositories/"
git -C "$tmp/source" init --quiet -b main
git -C "$tmp/source" add .
git -C "$tmp/source" -c user.name='Bootstrap Test' -c user.email=test@example.invalid commit --quiet -m fixture
git -C "$tmp/source" push --quiet "$tmp/remote.git" HEAD:refs/heads/main
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
git -C "$tmp/source" checkout --quiet -b other
printf 'tracked on other branch\n' > "$tmp/source/local-artifact.dat"
git -C "$tmp/source" add local-artifact.dat
git -C "$tmp/source" -c user.name='Bootstrap Test' -c user.email=test@example.invalid commit --quiet -m other
git -C "$tmp/source" push --quiet "$tmp/remote.git" HEAD:refs/heads/other
printf 'preserve ignored file\n' > "$tmp/checkout/local-artifact.dat"
printf 'local-artifact.dat\n' >> "$tmp/checkout/.git/info/exclude"
if BRANCH=other bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null 2>&1; then
  echo 'ignored local file would be overwritten' >&2; exit 1
fi
[[ "$(cat "$tmp/checkout/local-artifact.dat")" = 'preserve ignored file' ]]
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
