# GitHub Actions Export Audit — July 28, 2026

## Scope

Three uploaded GitHub Actions exports contained 37 workflows, 54 jobs, and 17 repositories.

## Portfolio signal

- CI/verification accounted for 254 job runs and approximately 6.12 million milliseconds of runner time, with roughly 175 failed job runs implied by the exported rates.
- Visual/browser QA accounted for 38 runs and approximately 3.81 million milliseconds, with roughly 17 failed runs.
- One Dependabot job accounted for 63 runs and approximately 4.75 million milliseconds with no failures; this is reliable but disproportionately expensive and should be cadence/path reviewed.

## Priority repair queue

| Priority | Repository | Exported signal | Immediate action |
|---|---|---|---|
| P0 | `MelodicBloom/flore-orthography-memphis-ui` | `build.yml` failed 59/59; `ci.yml` failed 29/29 | Delete or disable the CI workflow that runs a non-frozen install and pushes lockfile changes. Keep one read-only frozen verification caller. |
| P0 | `MelodicBloom/wildfire-iridescent` | Playwright VRT failed 83.33% across 18 runs; four jobs each reinstall dependencies | Commit a lockfile, reduce to two installs, build Storybook once, reuse artifact, separate deterministic and visual truth, retain screenshots/traces on all failures. |
| P0 | `MelodicBloom/nacre-orchid-atelier` | 97.37% failure across 38 job runs | Identify the first deterministic failing gate; collapse five duplicative jobs until install/profile validity is green. |
| P1 | `MelodicBloom/omni-loom-case-study` | 100% failure across five runs | Repair typecheck/lint/build before adding conversion features; then run the interaction/conversion audit as evidence-only. |
| P1 | `MelodicBloom/aether` | 62.5% failure across 24 runs; reproducible build failed 75% | Finish one canonical lockfile/build contract and remove overlapping verification authorities. |
| P1 | `MelodicBloom/mochi-ui` | 75% failure across eight runs | Keep the spring engine an independent SSR-safe slice; make its caller canonical and retire overlapping `main.yml` verification. |
| P1 | `MelodicBloom/chromaflora-prime` | 53.33% failure across 15 runs | Reconcile the lockfile and stabilize lint/typecheck before motion/accessibility expansion. |

## Structural defects observed

1. A normal CI workflow in Flore Orthography runs `pnpm install --no-frozen-lockfile`, commits lockfile changes, and pushes from the build job. This collapses verification and mutation into one authority.
2. Wildfire Iridescent uses `npm install` in four sequential jobs and has no committed `package-lock.json`, so neither reproducibility nor efficient cache identity is established.
3. Repeated repo-local workflows overlap with the central defensible vertical slice, creating multiple sources of verification truth.
4. Costly visual tests are allowed to dominate the failure signal instead of reporting deterministic build health separately.
5. Several workflows fail at 100% across multiple runs, indicating persistent configuration defects rather than occasional regressions.

## Required outcome

A repository is healthy when it has one canonical deterministic caller, one declared specialized QA layer, frozen dependencies, durable receipts on early failure, bounded workflow permissions, no CI source mutation, explicit omissions, and a documented promotion authority.
