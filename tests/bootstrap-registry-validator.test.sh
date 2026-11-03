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
[[ " $* " = *' --include=dev '* && " $* " = *' --ignore-scripts '* ]]
if [[ "${BOOTSTRAP_TEST_FAIL:-0}" = 1 ]]; then mkdir -p node_modules; printf 'partial install\n' > node_modules/partial.txt; exit 42; fi
if [[ "${BOOTSTRAP_TEST_HANG:-0}" = 1 ]]; then
  mkdir -p node_modules; printf 'interrupted install\n' > node_modules/partial.txt
  printf 'ready\n' > "$BOOTSTRAP_TEST_READY"
  trap 'exit 143' TERM
  while :; do read -r -t 1 _ </dev/null || true; done
fi
if [[ ! -d node_modules ]]; then mkdir node_modules; cp -a "$BOOTSTRAP_TEST_DEPS/." node_modules/; fi
printf 'npm ci invoked\n' >> "$BOOTSTRAP_TEST_LOG"
SH
chmod +x "$tmp/bin/npm"
export PATH="$tmp/bin:$PATH" BOOTSTRAP_TEST_DEPS="$root/node_modules" BOOTSTRAP_TEST_LOG="$tmp/npm.log"
export REPO_URL="$tmp/remote.git" BRANCH=main
bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
printf 'preserve local dependency edits\n' > "$tmp/checkout/node_modules/local-edit.txt"
bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
[[ "$(wc -l < "$tmp/npm.log")" = 2 ]]
shopt -s nullglob
backups=("$tmp"/checkout/.git/registry-bootstrap-backup.*/node_modules/local-edit.txt)
[[ ${#backups[@]} = 1 && "$(cat "${backups[0]}")" = 'preserve local dependency edits' ]]
shopt -u nullglob
printf 'restore after interruption\n' > "$tmp/checkout/node_modules/interrupt-me.txt"
BOOTSTRAP_TEST_HANG=1 BOOTSTRAP_TEST_READY="$tmp/ready" bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >"$tmp/interrupted.log" 2>&1 &
bootstrap_pid=$!
for _ in {1..100}; do [[ -f "$tmp/ready" ]] && break; sleep 0.05; done
[[ -f "$tmp/ready" ]] || { kill -TERM "$bootstrap_pid" 2>/dev/null || true; wait "$bootstrap_pid" || true; echo 'install did not start' >&2; exit 1; }
kill -TERM "$bootstrap_pid"
if wait "$bootstrap_pid"; then echo 'interrupted install was accepted' >&2; exit 1; fi
[[ "$(cat "$tmp/checkout/node_modules/interrupt-me.txt")" = 'restore after interruption' ]]
source_head="$(git -C "$tmp/source" rev-parse HEAD)"
GIT_DIR="$tmp/source/.git" GIT_WORK_TREE="$tmp/source" bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
[[ "$(git -C "$tmp/source" rev-parse HEAD)" = "$source_head" ]]
printf 'restore after failure\n' > "$tmp/checkout/node_modules/restore-me.txt"
if BOOTSTRAP_TEST_FAIL=1 bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null 2>&1; then
  echo 'failed install was accepted' >&2; exit 1
fi
[[ "$(cat "$tmp/checkout/node_modules/restore-me.txt")" = 'restore after failure' ]]
shopt -s nullglob
partial=("$tmp"/checkout/.git/registry-bootstrap-backup.*/failed-install-node_modules/partial.txt)
[[ ${#partial[@]} = 2 ]]
grep -lqx 'partial install' "${partial[@]}" >/dev/null
grep -lqx 'interrupted install' "${partial[@]}" >/dev/null
shopt -u nullglob
printf 'new remote content\n' > "$tmp/source/updated.txt"
git -C "$tmp/source" add updated.txt
git -C "$tmp/source" -c user.name='Bootstrap Test' -c user.email=test@example.invalid commit --quiet -m update
git -C "$tmp/source" push --quiet "$tmp/remote.git" HEAD:refs/heads/main
printf 'preserve ignored fast-forward file\n' > "$tmp/checkout/updated.txt"
printf 'updated.txt\n' >> "$tmp/checkout/.git/info/exclude"
old_head="$(git -C "$tmp/checkout" rev-parse HEAD)"
if bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >"$tmp/ff-collision.log" 2>&1; then
  echo 'ignored fast-forward file would be overwritten' >&2; exit 1
fi
grep -q 'updated.txt' "$tmp/ff-collision.log"
[[ "$(cat "$tmp/checkout/updated.txt")" = 'preserve ignored fast-forward file' ]]
[[ "$(git -C "$tmp/checkout" rev-parse HEAD)" = "$old_head" ]]
rm "$tmp/checkout/updated.txt"
bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
[[ "$(cat "$tmp/checkout/updated.txt")" = 'new remote content' ]]
git -C "$tmp/source" checkout --quiet -b other
printf 'tracked on other branch\n' > "$tmp/source/local-artifact.dat"
git -C "$tmp/source" add local-artifact.dat
git -C "$tmp/source" -c user.name='Bootstrap Test' -c user.email=test@example.invalid commit --quiet -m other
git -C "$tmp/source" push --quiet "$tmp/remote.git" HEAD:refs/heads/other
printf 'preserve ignored file\n' > "$tmp/checkout/local-artifact.dat"
printf 'local-artifact.dat\n' >> "$tmp/checkout/.git/info/exclude"
if BRANCH=other bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >"$tmp/collision.log" 2>&1; then
  echo 'ignored local file would be overwritten' >&2; exit 1
fi
grep -q 'local-artifact.dat' "$tmp/collision.log"
[[ "$(cat "$tmp/checkout/local-artifact.dat")" = 'preserve ignored file' ]]
[[ "$(git -C "$tmp/checkout" branch --show-current)" = main ]]
rm "$tmp/checkout/local-artifact.dat"
BRANCH=other bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
[[ "$(git -C "$tmp/checkout" branch --show-current)" = other ]]
[[ "$(cat "$tmp/checkout/local-artifact.dat")" = 'tracked on other branch' ]]
bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null
[[ "$(git -C "$tmp/checkout" branch --show-current)" = main ]]
# A diverged target must be rejected before changing the current branch.
divergent="$(printf 'divergent\n' | git -C "$tmp/checkout" -c user.name='Bootstrap Test' -c user.email=test@example.invalid commit-tree "$(git -C "$tmp/checkout" rev-parse 'HEAD^{tree}')" -p HEAD)"
git -C "$tmp/checkout" update-ref refs/heads/other "$divergent"
if BRANCH=other bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null 2>&1; then
  echo 'diverged branch was accepted' >&2; exit 1
fi
[[ "$(git -C "$tmp/checkout" branch --show-current)" = main ]]
printf 'preserve me\n' > "$tmp/checkout/untracked-local.txt"
git -C "$tmp/checkout" config status.showUntrackedFiles no
if bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null 2>&1; then
  echo 'dirty checkout was accepted' >&2; exit 1
fi
[[ "$(cat "$tmp/checkout/untracked-local.txt")" = 'preserve me' ]]
rm "$tmp/checkout/untracked-local.txt"
git -C "$tmp/checkout" config --unset status.showUntrackedFiles
mkdir "$tmp/restricted"
bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/restricted/checkout" >/dev/null
printf 'parent is read only\n' > "$tmp/restricted/checkout/node_modules/local-edit.txt"
chmod u-w "$tmp/restricted"
if ! bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/restricted/checkout" >/dev/null 2>&1; then
  chmod u+w "$tmp/restricted"; echo 'writable checkout under read-only parent failed' >&2; exit 1
fi
chmod u+w "$tmp/restricted"
shopt -s nullglob
restricted=("$tmp"/restricted/checkout/.git/registry-bootstrap-backup.*/node_modules/local-edit.txt)
[[ ${#restricted[@]} = 1 && "$(cat "${restricted[0]}")" = 'parent is read only' ]]
shopt -u nullglob
git -C "$tmp/checkout" remote set-url origin "$tmp/other.git"
if bash "$root/docs/repositories/bootstrap-registry-validator.sh" "$tmp/checkout" >/dev/null 2>&1; then
  echo 'mismatched origin was accepted' >&2; exit 1
fi
echo 'PASS: clean clone and reuse; dirty checkout and wrong origin fail closed'

