# Determination — optical_material_semantics / MelodicBloom/shader-grammar

Date: 2026-11-03 America/New_York · REG-AUTH-06 · Status: proposed live attestation (draft PR; no merge without review)

## 1. CLAIM
MelodicBloom/shader-grammar is semantic authority for optical material recipes, parameters, fields, operators, and material taxonomy (`optical_material_semantics`).

## 2. EVIDENCE
- Repository-declared purpose: package description states an ontology of shared optical primitives without named-effect flags.
- Validated schema package at HEAD `be11bde30962773999e2c37888e044970f5673d5` (measured 2026-11-03): `schemas/` (parameter, field, operator, recipe, implementation-profile, experiment-receipt, …), `catalog/`, `recipes/`, `taxonomy/`.
- Gate: `npm run validate` via `tools/validate.mjs` (Ajv) with root `package-lock.json`.
- Cross-specimen reuse stance preserved in `docs/CONTACT-SHEET-MATERIAL-INTAKE.md` (candidates route through existing grammar; no named-effect promotion).

## 3. ALTERNATIVES
- MelodicBloom/shader-gallery — specimen/runtime and recipe binding only; must refuse ontology ownership.
- qt314wink/svg-filter-lab and MelodicBloom/svg-filter-lab — SVG approximation path; lineage still UNRESOLVED (Phase 1 decision #4); do not publish the optical schema package.
- MelodicBloom/seed-loom — provenance and governed evidence pipeline; not optical ontology.

## 4. REJECTION BASIS
- Gallery must refuse ontology (`exclusions: optical_ontology, competing_material_taxonomy`) and instead `consumes_schema` from grammar.
- SVG labs do not publish the optical schema package; promoting them would conflate visual approximation with semantic authority.
- Seed Loom must not own shader semantics; it consumes evidence, it does not define material operators.

## 5. DETERMINATION
`MelodicBloom/shader-grammar canonical_for optical_material_semantics`

Companion continuity edge (same slice): MelodicBloom/shader-gallery `consumes_schema` → MelodicBloom/shader-grammar, with facet role `consumes` on the same domain.

Explicit non-goals of this determination: no SVG lineage edges; no MelodicBloom/svg-filter-lab record; no flip of qt314wink/svg-filter-lab flat `canonical_status`; no translation-contract schema; no Seed Loom / Constellation writes.
