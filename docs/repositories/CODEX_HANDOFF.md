# Codex handoff — canonical repository registry v1

## Mission

Finish phase 1 of the MelodicBloom canonical repository registry without changing product source, production deployment settings, repository settings, GitHub App installations, Vercel Connect attachments, secrets, or archive/delete state.

This is an observe-and-document pass with one deterministic offline validator.

## Working environment

- Repository: `MelodicBloom/.github`
- Branch: `docs/canonical-repository-registry-v1`
- Branch baseline: `957198fb890ad424af8dea469873e903a886fd48`
- Original Issue #5 baseline: `51d2de7b08a91cadc59a82899b25a46d78151fa2`
- Runtime for the validator: Node.js >=22; target local version 22.23.2
- Third-party dependencies: none for phase 1
- Setup: `bash docs/repositories/bootstrap-registry-validator.sh`

The branch deliberately starts from the newer observed `main` head because Issue #5's original baseline was stale by 2026-09-20. Preserve this provenance; do not rewrite history to the old SHA.

## Allowed paths

- `repositories/registry.yml`
- `schemas/repositories/registry.schema.json`
- `docs/repositories/**`
- `scripts/automation/validate-repository-registry.mjs`

Do not edit anything else in this phase.

## Bounded initial estate

Exactly these ten repositories:

1. `MelodicBloom/.github`
2. `MelodicBloom/agent-runtime-control-center`
3. `MelodicBloom/aether`
4. `MelodicBloom/chromaflora-prime`
5. `MelodicBloom/nacre-orchid`
6. `qt314wink/seed-loom`
7. `qt314wink/observation-ad-pipeline`
8. `qt314wink/nextjs-boilerplate`
9. `qt314wink/svg-filter-lab`
10. `qt314wink/neobrutalism-lab`

Do not expand to the full estate in this PR.

## Work order

### WS1 — evidence refresh

For each of the ten repositories, collect only:

- current default branch and HEAD SHA;
- README/documentation entry point;
- package manager evidence from lockfiles or package metadata;
- Node/Python/runtime version evidence;
- upstream/fork/mirror declarations;
- deployment evidence that can be proven from Vercel or repository configuration.

Update a field only when evidence exists. If evidence conflicts or is missing, keep `unknown` and append a precise uncertainty.

### WS2 — Vercel mapping audit

Cross-check only the Vercel identities already named in the registry.

Do not create, rename, delete, relink, redeploy, or change domains.

Special checks:

- `seed-loom`: verify project ID/name match before retaining `vercel-production`.
- `observation-ad-pipeline`: preserve the distinction between core Termux/ComfyUI execution and any Vercel auxiliary surface.
- `svg-filter-lab`: determine whether `svg-filter-lab-yodd` is actually the deployment of the canonical repository. If not provable, keep deployment authority unknown.
- `nextjs-boilerplate`: do not rename it to LITHOMEMPHIS in this phase.
- `neobrutalism-lab` and `chromaflora-prime`: verify only; no deployment mutation.

### WS3 — Connect authority model

Document, do not apply, the GitHub runtime-access profile.

Use these defaults:

- visual/demo products: `vercel_connect=disabled`;
- evidence/research system needing runtime GitHub context: `candidate`;
- agent control plane: `candidate` until the exact runtime action is proven;
- no direct-to-main write profile.

For any candidate, identify the smallest needed profile:
- `read-only`;
- `review-agent` for issue/PR/status interaction;
- `bounded-branch-writer` only when branch creation + PR is the explicit workflow.

Do not attach `github/cordovan-ladder` from Codex in this phase.

### WS4 — deterministic validation

The validator applies `schemas/repositories/registry.schema.json` to the registry with Ajv
(draft 2020-12, `strict`, `allErrors`, `ajv-formats`) and then runs the hand-written
cross-record checks (owner prefix, provenance URLs, duplicates, bounded phase-1 set).
Any schema violation is an error and exits 1. Before this change (PR #14 state) the script
only checked the schema's `$schema` draft string and never applied the schema.

Run:

```bash
npm ci
node scripts/automation/validate-repository-registry.mjs            # canonical registry
node scripts/automation/validate-repository-registry.mjs <file>     # any other registry file
node scripts/automation/test-validate-repository-registry.mjs       # negative regression test
node scripts/automation/validate-repository-registry.mjs > /tmp/registry-a.json
node scripts/automation/validate-repository-registry.mjs > /tmp/registry-b.json
cmp /tmp/registry-a.json /tmp/registry-b.json
cat /tmp/registry-a.json
```

Acceptance:
- exit code 0 twice;
- byte-for-byte identical output;
- exactly ten registry records;
- no duplicate repository or Vercel project IDs;
- every record has full-SHA provenance;
- unresolved package/deployment/canonical questions remain explicit warnings/uncertainties rather than guesses.

### WS5 — review package

Produce one concise review note containing:
- verified changes;
- remaining unknowns;
- Vercel Connect candidates and why;
- decisions requiring the human operator;
- command receipts.

Keep the pull request draft until those human decisions are answered.

## Subagent operating contract

Use subagents only to parallelize evidence collection. The parent agent owns synthesis and final writes.

If subagents are available:
- Subagent A: GitHub runtime/package evidence for repositories 1–5.
- Subagent B: GitHub runtime/package evidence for repositories 6–10.
- Subagent C: Vercel project/deployment mapping only; read-only.
- Subagent D: authority/security review against Vercel Connect + GitHub App minimum-permission docs.
- Subagent E: adversarial QA of schema, registry, validator, provenance, and stop conditions.

Each subagent returns:
1. observation;
2. source URL or exact repository path + SHA;
3. confidence;
4. proposed registry delta;
5. unresolved ambiguity.

The parent must reject any delta without provenance.

If subagents are unavailable, execute A–E serially and preserve the same separation in notes.

## If/then rules

- IF `origin/main` has advanced since `957198f`, THEN compare changed paths first.
- IF main touched any phase-1 allowed path, THEN stop and reconcile explicitly before rebasing.
- IF main did not touch those paths, THEN rebase onto current main before final QA and record the new base SHA.
- IF a package manager cannot be proven from package metadata/lockfiles, THEN keep `unknown`.
- IF a Vercel project name resembles a repository but source linkage is not proven, THEN keep deployment authority `unknown`.
- IF a connector permission appears necessary only for convenience, THEN leave Connect disabled.
- IF a runtime action can be implemented read-only, THEN do not request write permission.
- IF a write action is needed, THEN constrain it to a branch/PR flow; never direct-to-main.
- IF a credential, API key, installation approval, Vercel dashboard mutation, organization setting, archive/delete, or production deployment change is required, THEN stop and return the exact human action needed.
- IF evidence conflicts across GitHub/Vercel/docs, THEN retain both observations and mark the record unresolved; do not normalize by guess.
- IF a proposed change expands beyond the ten-record estate, THEN defer it to phase 2.

## Definition of done

Phase 1 is complete when:

- the registry validates offline against the JSON Schema (Ajv) and the hand-written cross-record checks (`npm ci` required for Ajv);
- the validator is deterministic across two runs;
- all ten records use live full-SHA provenance;
- known duplicate/deployment relationships are explicit;
- unknown authority remains visible;
- no production/settings/connector mutation has occurred;
- the draft PR clearly separates observed facts, provisional classifications, and human decisions.

## Human decisions (answered 2026-10-26 — classification only)

Recorded from Jennipher's decision comment: https://github.com/MelodicBloom/.github/pull/14#issuecomment-6425652920 . Summary: `docs/repositories/DECISION_RECORD_2026-10-26.md`.

1. `github/cordovan-ladder`: **not installed** for either account in Phase 1; reconsider only via a separate, repository-scoped proof after a concrete runtime action is demonstrated.
2. Seed Loom: **`read-only`** first; escalate to `bounded-branch-writer` only via a separate acceptance-tested branch/PR workflow; never direct-to-main.
3. `agent-runtime-control-center`: Vercel Connect **`disabled`**; no runtime GitHub action proven.
4. `svg-filter-lab`: deployment authority stays **`unknown`**; neither `svg-filter-lab-yodd` nor `svg-filter-lab` is canonical (both repo-linked, preview-only, no production deploy).
5. Observation Ad Pipeline: Vercel project preserved as **auxiliary preview/dashboard surface**, not Termux/ComfyUI execution authority.
6. `nextjs-boilerplate`: **current identity retained**; LITHOMEMPHIS rename/consolidation deferred to a separately scoped issue.

These answers authorize registry classification only. They do **not** authorize connector/app installation, repository-setting changes, Vercel mutation, credentials, direct-to-main writes, transfers, archival, or deletion; those mutations remain blocked and require separate explicit human action.

### Decision log

- 2026-10-26 — Phase 1 decisions #1–#6 answered by Jennipher in PR #14 (issuecomment-6425652920); applied to `repositories/registry.yml` as classification-only updates. PR remains draft pending her ready-for-review/merge call.

## Schema enforcement regression fixture

`tests/fixtures/registry/invalid-schema-passes-hand-checks.json` is the canonical registry with
schema-only defects (bad `canonical_status`/`lifecycle`/`runtime.kind` enums, an unknown
property, a missing required `documentation`, and a non-date `observed_at`). It passes every
hand-written check but must fail the schema; `test-validate-repository-registry.mjs` asserts this.
