#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import process from "node:process";

const root = process.cwd();
const registryPath = path.join(root, "repositories", "registry.yml");
const schemaPath = path.join(root, "schemas", "repositories", "registry.schema.json");

const errors = [];
const warnings = [];

function fail(code, message) { errors.push({ code, message }); }
function warn(code, message) { warnings.push({ code, message }); }
function readJson(file, label) {
  try { return JSON.parse(fs.readFileSync(file, "utf8")); }
  catch (error) {
    fail("parse", `${label} is not valid JSON-compatible YAML/JSON: ${error.message}`);
    return null;
  }
}
function isSha(value) { return typeof value === "string" && /^[0-9a-f]{40}$/.test(value); }
function hasString(value) { return typeof value === "string" && value.length > 0; }

const schema = readJson(schemaPath, "schema");
const registry = readJson(registryPath, "registry");

if (schema && schema.$schema !== "https://json-schema.org/draft/2020-12/schema") {
  fail("schema-version", "schema must declare JSON Schema draft 2020-12");
}

if (registry) {
  if (registry.version !== "1.0.0") fail("version", "registry version must be 1.0.0");
  if (!registry.control_plane || !isSha(registry.control_plane.baseline_sha)) {
    fail("baseline", "control_plane.baseline_sha must be a 40-character lowercase SHA");
  }
  if (!Array.isArray(registry.repositories)) {
    fail("repositories", "repositories must be an array");
  } else {
    const expected = [
      "MelodicBloom/.github",
      "MelodicBloom/agent-runtime-control-center",
      "MelodicBloom/aether",
      "MelodicBloom/chromaflora-prime",
      "MelodicBloom/nacre-orchid",
      "qt314wink/seed-loom",
      "qt314wink/observation-ad-pipeline",
      "qt314wink/nextjs-boilerplate",
      "qt314wink/svg-filter-lab",
      "qt314wink/neobrutalism-lab"
    ];
    const seen = new Set();
    const deploymentIds = new Map();

    for (const record of registry.repositories) {
      const id = record?.full_name ?? "<missing>";
      if (!hasString(record?.full_name) || !record.full_name.includes("/")) fail("full-name", `${id}: invalid full_name`);
      if (seen.has(id)) fail("duplicate-repo", `${id}: duplicate registry record`);
      seen.add(id);

      const prefix = hasString(record?.full_name) ? record.full_name.split("/")[0] : null;
      if (prefix && record.owner !== prefix) fail("owner", `${id}: owner must equal repository owner prefix ${prefix}`);
      if (!hasString(record?.default_branch)) fail("default-branch", `${id}: missing default_branch`);
      if (!isSha(record?.observed_sha)) fail("observed-sha", `${id}: observed_sha must be a full SHA`);
      if (!record?.runtime || !hasString(record.runtime.contract)) fail("runtime", `${id}: runtime contract is required`);
      if (!record?.deployment || !hasString(record.deployment.authority)) fail("deployment", `${id}: deployment authority is required`);
      if (!record?.runtime_access) fail("runtime-access", `${id}: runtime_access is required`);
      if (!record?.provenance || !hasString(record.provenance.commit_url)) fail("provenance", `${id}: commit provenance is required`);

      if (record?.runtime?.package_manager === "unknown") warn("package-manager-unknown", `${id}: package manager is still unknown`);
      if (record?.deployment?.disposition === "unknown") warn("deployment-unknown", `${id}: deployment disposition is still unknown`);
      if (record?.runtime_access?.vercel_connect !== "disabled" && record?.runtime_access?.github_permission_profile === "none") {
        fail("connect-profile", `${id}: Connect candidate/required records need a non-none GitHub permission profile`);
      }

      const vpid = record?.deployment?.vercel_project_id;
      if (vpid) {
        if (deploymentIds.has(vpid)) {
          fail("duplicate-vercel-project", `${id}: Vercel project ID ${vpid} is already assigned to ${deploymentIds.get(vpid)}`);
        } else {
          deploymentIds.set(vpid, id);
        }
      }

      for (const uncertainty of record?.uncertainties ?? []) {
        if (!hasString(uncertainty)) fail("uncertainty", `${id}: uncertainty entries must be non-empty strings`);
      }
    }

    const missing = expected.filter(name => !seen.has(name));
    const extra = [...seen].filter(name => !expected.includes(name));
    if (missing.length) fail("phase1-missing", `phase-1 records missing: ${missing.join(", ")}`);
    if (extra.length) fail("phase1-extra", `phase-1 registry must remain bounded; unexpected records: ${extra.join(", ")}`);
    if (registry.repositories.length !== expected.length) {
      fail("phase1-count", `phase-1 registry must contain exactly ${expected.length} records`);
    }
  }
}

errors.sort((a,b) => (a.code + a.message).localeCompare(b.code + b.message));
warnings.sort((a,b) => (a.code + a.message).localeCompare(b.code + b.message));

console.log(JSON.stringify({
  ok: errors.length === 0,
  errors,
  warnings,
  records: registry?.repositories?.length ?? 0
}, null, 2));

process.exit(errors.length ? 1 : 0);
