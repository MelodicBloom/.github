# Immersive systems — authoritative repository routing v0.1

**State:** candidate routing map, not adopted policy.
**Branch scope:** document-only, no deployment/secret/permission changes; additive to existing organization control plane.
**Registry conflict:** draft [canonical registry PR #14](https://github.com/MelodicBloom/.github/pull/14) remains authoritative **as a proposal only** for its ten explicitly scoped initial repositories. This document is NOT a claim that its limited registry is approved or updated.

## Determination
The controlling standard is a **federation of narrow ownership contracts**:

| Domain | Governing owner | Responsibilities |
|---|---|---|
| Organization-level authority | MelodicBloom/.github | repository classification, changeset consequences, policy, exceptions, evidence requirements |
| Optical physical mechanisms | qt314wink/shader-grammar | typed field/parameter/operator/recipe catalogs and experimental optical evidence |
| Material/scene semantics and epistemics | qt314wink/seed-loom | semantic identity, material genome, relationships, explanations, provenance, unresolved alternatives, temporal validity |
| Visual/interactive design | MelodicBloom/design-standards-2026-2027 | appearance, interface motion, accessibility, scene presentation and candidate performance budgets |
| Per-product implementation | shader-gallery, aether, project-constellation, other product repos | runtime renderer adapters, demo assets, local CI, deployment-specific QA; never fork canonical semantics without declared exception |
| Agent execution | agent-runtime-control-center | credentials, task scheduling, scoped writes and approval gates; not Seed Loom |

The machine-readable companion is `examples/immersive-authority-route.seed.json`; its **proposal-only** structure is `schemas/immersive-authority-route.schema.json`.

## Cross-repo seed contract
Every consumer handoff should identify:
- use case, intended viewer and measurable task;
- source entity IDs / material taxonomy IDs / optical mechanism IDs / spectral units;
- stack / shader language / version / supported browser and fallback;
- optical algorithm (and stated approximation), scene camera/light/exposure, geometry;
- behaviors / interaction states / keyboard & touch / accessible 2D representation;
- timeline cue events, motion semantic token references, reduced-motion variant;
- render quality profile and *measurement context* for FPS/frame time/memory/draw calls;
- evidence records for source/inference/test, uncertainty, alternatives and contradiction;
- owners, change boundaries, dependency versions, artifact SHA, release/rollback plans.

Source document annotations are not performance tests. A historical reference is not proof of current runtime equivalence. An illustrative value never inherits scientific validation merely because it appears inside a valid schema.

## Propagation policy
The branch/PR author may propose pointers across repos but must not automatically merge, re-run deployment, update the pending canonical registry, change protected settings or upgrade recipes. Each governed package releases its own reviewed version. Consumer adapters pin a version or commit and record compatibility evidence. Unknown authority or package version remains unknown and blocks promotion, not exploratory documentation.

## Comparison of operating models
- **Central monolith:** easy discovery; falsely centralizes specialized physics and UI decisions. Rejected for canonical definitions.
- **Duplicated local manifests:** fast prototyping; divergence and explanation loss. Allow only as explicit, traceable projections.
- **Federated typed authority + declared consumer contracts:** preserves specialization and reviewability, but requires link integrity checks and change notification. Preferred *proposal*.

## QA / definition of done for this seed
1. New files validate structurally and existing control plane workflows remain unchanged.
2. Each owner describes exactly what it does **not** own; optical/acoustic confusion is explicitly rejected.
3. Candidate budgets are not framed as measured pass/fail standards.
4. Registry PR #14 has no changed files or permission side effects from this branch.
5. Four seeded branches are offered as reviewable draft PRs; only human-approved cross-repo adoption can elevate them.
6. Each PR supplies file links, decisions, risks, validation limits and rollback (revert additive files).

## Research trace
Historical source: Brian Karis, *Real Shading in Unreal Engine 4*, SIGGRAPH 2013. Other informing papers: Stanton et al. dual-mode Web UI, 2017; Yeow et al. immersive acoustic environments, 2020; Winchester et al. UE5 live storytelling, 2025. The authority federation and candidate budgets are **new synthesis**, not extracted claims of the papers.
