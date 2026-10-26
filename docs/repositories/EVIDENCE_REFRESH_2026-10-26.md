# Evidence refresh — 2026-10-26 (America/New_York)

Observe-only pass for WS1/WS2/WS4. No product source, Vercel settings, GitHub App installs, secrets, or default branches were changed.

## Main rebase check
- `origin/main` = `957198fb890ad424af8dea469873e903a886fd48` = branch baseline. No rebase needed; `control_plane.baseline_sha` unchanged.

## WS1 — repository evidence (default branch `main` for all ten)

| Repository | HEAD SHA | Changed since 2026-09-20 | Package manager (evidence) | Runtime evidence |
|---|---|---|---|---|
| MelodicBloom/.github | 957198fb890ad424af8dea469873e903a886fd48 | no | none | CI Node 24; validator Node >=22 |
| MelodicBloom/agent-runtime-control-center | 4c74f1e1bd2e0e68f5ee835380c7ef69d14137ff | yes (was 8fa2886) | pnpm (root pnpm-lock.yaml) — conflicts with `npm ci` in read-only-audit.yml | CI Node 22 and 24; no engines |
| MelodicBloom/aether | dd45f60dd6c9195a9c29a2c311bf4cfab7705716 | no | npm (package-lock.json) | CI Node 20 and 22; no engines |
| MelodicBloom/chromaflora-prime | eb81c6b7db77597d2ac1302c40173bfe83a97bdd | no | npm (package-lock.json) | engines node >=18.17.0; CI Node 20; Vercel 24.x |
| MelodicBloom/nacre-orchid | e264e1cb86357c6f8718f0bc5cd5705ebe7209f1 | no | none (no manifest at root) | docs/schemas only |
| qt314wink/seed-loom | 574fdbb3320c06f8fa9b19c4c2e684ee6f53b645 | yes (was 5f329ea) | npm (packageManager npm@10.9.2 + package-lock.json) | engines ^20.19.0 \|\| >=22.12.0; CI Node 20/22, Python 3.11 |
| qt314wink/observation-ad-pipeline | f8454d5e4974ffc1d6c7cfdb7c6ef05f35604543 | no | pip (pyproject.toml + requirements.txt; no lockfile) | requires-python >=3.10; CI Python 3.12 |
| qt314wink/nextjs-boilerplate | b1bcbcc3199b41b37616bd377a0461e4a6f489bf | no | npm (package-lock.json) | no engines, no workflows; Vercel 24.x |
| qt314wink/svg-filter-lab | 951f95f974687ee03b574b95a5b96920c39c8172 | no | npm (package-lock.json) | engines node 22.x; CI Node 22; Vercel 24.x |
| qt314wink/neobrutalism-lab | ee133335df69ed188352a0894825c215477c5a6b | yes (was 76ec812) | npm (packageManager npm@10.9.8 + package-lock.json) | engines >=22.13.0 <23; CI Node 22; Vercel 24.x |

No repository is a fork (`gh api repos/<r>` `.fork=false`).

## WS2 — Vercel mapping (team melodicbloom, read-only `get_project` / `list_projects`)

| Project | ID | Git-linked repo (repoUrl filter) | Latest deployment |
|---|---|---|---|
| seed-loom | prj_86ORYoi9fhYFO5Gfuvp7utAdXLRt | qt314wink/seed-loom | production, CANCELED, 2026-10-26 07:52 EDT |
| observation-ad-pipeline | prj_oQd6jMBNBz8CHl2QxLPJmY3HdSJq | qt314wink/observation-ad-pipeline | preview, READY, 2026-10-18 09:45 EDT |
| nextjs-boilerplate | prj_WpeiM5erRAtGNyGez7IyI3KULOVF | qt314wink/nextjs-boilerplate | preview, READY, 2026-10-07 21:47 EDT |
| neobrutalism-lab | prj_H5TFrJkEgndykYT5bCCKRbyVjcNi | qt314wink/neobrutalism-lab | production, READY, 2026-10-26 11:32 EDT |
| chromaflora-prime | prj_ZufiixUV8BlWUNPplKwEnXMOIuhl | qt314wink/chromaflora-prime (pre-transfer path; same GitHub repo id 1261976307 as MelodicBloom/chromaflora-prime) | production, ERROR, 2026-06-25 09:56 EDT |
| svg-filter-lab-yodd | prj_ySihQ8ppJvUuuKEMjoaB4WYKOt5a | qt314wink/svg-filter-lab | preview, READY, 2026-06-25 09:47 EDT |
| svg-filter-lab | prj_mTECd1GEjjh3uBleE9m0s8Sagjlw | qt314wink/svg-filter-lab | preview, READY, 2026-06-25 09:47 EDT |
| aether-specimen (not in registry) | prj_TrnX6XVbmT7CUcVusRJSvFpS643x | MelodicBloom/aether | created 2026-10-26 11:35 EDT |

agent-runtime-control-center: no linked project found despite a root `vercel.json`.

**svg-filter-lab decision evidence:** two projects are linked to the same repo; neither has a production deployment. Deployment authority remains `unknown` (human decision #4).

## WS4 — validation receipts
- Node v20.19.2 (system) and Node v22.23.4 (downloaded tarball): each run exit 0 twice, `cmp` identical across all four outputs, 10 records, 0 errors, 4 `deployment-unknown` warnings (aether, agent-runtime-control-center, nacre-orchid, svg-filter-lab).
