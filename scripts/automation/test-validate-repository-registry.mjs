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

// REG-AUTH-04: two active repos with exclusive claims on the same domain must fail.
const conflict = run("tests/fixtures/registry/authority-conflict-exclusive-claims.json");
check(conflict.status === 1, "exclusive-claim conflict fixture exits 1");
check(conflict.out.errors.some(e => e.code === "authority-conflict" && e.message.includes("fixture_test_domain")), "authority-conflict reported");
check(conflict.out.errors.every(e => e.code === "authority-conflict"), "only authority-conflict raised");

// REG-AUTH-01/02/03: canonical + consumer on same domain passes; proposal is a warning, not an edge.
const ok = run("tests/fixtures/registry/authority-canonical-plus-consumer.json");
check(ok.status === 0 && ok.out.ok, "canonical + consumes fixture validates (exit 0)");
check(ok.out.warnings.some(w => w.code === "relationship-proposal-unproven"), "relationship proposal surfaced as non-edge warning");

// REG-AUTH-03: candidate interpretations may not be used as relationship types.
const edge = run("tests/fixtures/registry/authority-proposal-as-edge-rejected.json");
check(edge.status === 1 && edge.out.errors.some(e => e.code === "schema" && e.message.includes("/relationships/")), "candidate interpretation rejected as edge type");
process.exit(failed ? 1 : 0);
