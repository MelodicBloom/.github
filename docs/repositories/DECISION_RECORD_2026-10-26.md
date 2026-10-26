# Phase 1 decision record — 2026-10-26

Source: Jennipher's decision comment on PR #14 — https://github.com/MelodicBloom/.github/pull/14#issuecomment-6425652920

**Boundary:** classification only. No connector/app installation, repository-setting change, Vercel mutation, credential change, direct-to-main write, transfer, archival, or deletion is authorized.

| # | Subject | Decision | Registry effect |
|---|---------|----------|-----------------|
| 1 | `github/cordovan-ladder` | Do not install for either account in Phase 1; reconsider via separate repo-scoped proof after a concrete runtime action is demonstrated. | No installs; seed-loom notes record install deferral. |
| 2 | Seed Loom access | Start `read-only`; escalate to `bounded-branch-writer` only via separate acceptance-tested branch/PR workflow; never direct-to-main. | `qt314wink/seed-loom` `github_permission_profile: read-only`. |
| 3 | agent-runtime-control-center | Vercel Connect `disabled`; no runtime GitHub action proven. | `vercel_connect: disabled`. |
| 4 | svg-filter-lab | Authority stays `unknown`; neither `svg-filter-lab-yodd` nor `svg-filter-lab` canonical (both repo-linked, preview-only, no production deploy). | Disposition `unknown`; authority/uncertainties updated. |
| 5 | Observation Ad Pipeline | Preserve Vercel project as auxiliary preview/dashboard; not Termux/ComfyUI execution authority. | Disposition `vercel-auxiliary`; authority text updated. |
| 6 | nextjs-boilerplate | Retain identity in Phase 1; LITHOMEMPHIS rename/consolidation deferred to a separate issue. | Identity unchanged; uncertainty/upstream_sync record deferral. |
