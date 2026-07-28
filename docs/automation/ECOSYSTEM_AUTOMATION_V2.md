# MelodicBloom Ecosystem Automation v2

## Objective

Turn GitHub Actions from a collection of repository-local scripts into a governed delivery system that improves build health, preserves evidence, reduces repeated work, and advances products without granting AI or maintenance automation uncontrolled authority.

## Constitutional rules

1. GitHub remains the source of truth.
2. Deterministic verification runs before AI interpretation.
3. Lockfiles are source artifacts; ordinary CI may verify them but may not rewrite or push them.
4. Missing tests, visual baselines, data, or permissions are omissions—not passes.
5. Every workflow retains a machine-readable receipt on success and failure.
6. Reusable workflows are pinned by immutable commit SHA in caller repositories.
7. Source mutation occurs only through a bounded branch and draft pull request.
8. Deployment, merge, ad spend, publication, affiliate enrollment, customer-data use, and secret changes require separate human approval.
9. Jennipher remains the final approval gate for promotion.

## Workflow layers

### L0 — trigger hygiene

Use path filters, concurrency cancellation, manual dispatch for costly or secret-bearing work, and no `pull_request_target` for workflows that consume untrusted content.

### L1 — reproducibility

Require a declared runtime, package manager, committed lockfile, frozen install, and repository verification profile.

### L2 — deterministic verification

Run lint, typecheck, tests, build, accessibility, schema checks, browser checks, and specialized domain QA. Build once and reuse artifacts where possible.

### L3 — evidence

Retain source SHA, workflow SHA, profile hash, lockfile hash, command logs, artifact digest, omissions, status, run ID, and interpretation boundary.

### L4 — AI interpretation

OpenAI receives bounded, redacted evidence only after deterministic checks. It returns strict structured output and cannot create branches, edit source, deploy, merge, publish, buy ads, or establish affiliate relationships.

### L5 — governed implementation

A human disposition can create one repository-specific issue with allowed paths, forbidden paths, validation commands, risks, rollback, and expected changed-file inventory. Implementation proceeds through a draft PR.

### L6 — promotion

Promotion requires the declared gates, human design/accessibility review where applicable, evidence artifact retention, and Jennipher approval.

## Job design standard

- One frozen dependency installation per deterministic job.
- Combine cheap static checks when they share the same environment.
- Split browser/visual work from deterministic checks so flakes do not hide compiler or build truth.
- Reuse the built Storybook/site artifact for visual tests.
- Cache package-manager stores and browser binaries by lockfile hash.
- Upload failure artifacts with `if: always()`.
- Set timeouts and concurrency cancellation.
- Never run a lockfile-writing step during normal CI.
- Use scheduled workflows to open issues or draft PRs, never to merge or deploy.

## Rollout sequence

1. Merge control-plane v2 after schema/YAML review.
2. Pin caller workflows to the merge commit SHA.
3. Repair the highest-failure repositories in this order: Flore Orthography, Wildfire Iridescent, Nacre Orchid Atelier, Omni-Loom Case Study, AETHER, Mochi UI, ChromaFlora Prime.
4. Establish seven consecutive green deterministic runs before making any gate required.
5. Add OpenAI health review manually to the first three stabilized canaries.
6. Add governed opportunity modes only after product evidence templates and disclosure/privacy gates are accepted.
