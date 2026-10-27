#!/usr/bin/env node
// Regression test: the fixture below passes every hand-written check in
// validate-repository-registry.mjs but violates registry.schema.json.
// Before schema application was added, the validator exited 0 on it.
import { spawnSync } from "node:child_process";
import process from "node:process";

const script = "scripts/automation/validate-repository-registry.mjs";
const run = (...args) => {
  const r = spawnSync(process.execPath, [script, ...args], { encoding: "utf8" });
  return { status: r.status, out: JSON.parse(r.stdout) };
};
let failed = 0;
const check = (cond, msg) => { console.log(`${cond ? "ok  " : "FAIL"} ${msg}`); if (!cond) failed++; };

const good = run();
check(good.status === 0 && good.out.ok, "canonical registry validates (exit 0)");

const bad = run("tests/fixtures/registry/invalid-schema-passes-hand-checks.json");
const codes = new Set(bad.out.errors.map(e => e.code));
check(bad.status === 1, "invalid fixture exits 1");
check([...codes].every(c => c === "schema"), `only schema errors raised (hand checks pass): ${[...codes].join(",")}`);
for (const needle of ["/repositories/1/canonical_status", "/repositories/2/lifecycle", "/repositories/3/runtime/kind",
  "unreviewed_field", "documentation", "/observed_at"]) {
  check(bad.out.errors.some(e => e.message.includes(needle)), `schema error reported for ${needle}`);
}
process.exit(failed ? 1 : 0);
