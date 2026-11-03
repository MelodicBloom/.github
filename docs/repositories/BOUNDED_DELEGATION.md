# Bounded Canonical Delegation — Phase 2 Registry Vocabulary (draft)

Home: [Issue #5](https://github.com/MelodicBloom/.github/issues/5) · Phase 1: [DECISION_RECORD_2026-10-26.md](DECISION_RECORD_2026-10-26.md)
Status: **proposed vocabulary**. No new repository records are added by this change. No shader-grammar, shader-gallery, or MelodicBloom/svg-filter-lab rows are added; those come in steps 2–4.

## Principle

> Delegate authority to the narrowest repository that possesses the strongest evidence, validation machinery, and operational fit for that responsibility. Require every other repository to consume or reference that authority rather than duplicate it.
>
> A repo should not own a concept merely because it uses it.

Use **CANONICAL FOR \<BOUNDED DOMAIN\>**, not a flat **CANONICAL REPOSITORY**. A single repository can be authoritative for semantics while another holds implementation authority and a third holds deployment authority.

## REG-AUTH-01 — `authority_facets` (optional, additive)

```yaml
authority_facets:
  - domain: optical_material_semantics      # snake_case token
    role: canonical | candidate_canonical | consumes | not_authoritative | unknown
    confidence: confirmed | provisional | unresolved
    exclusive: true                         # default true for canonical/candidate_canonical
    scope: [parameter_schema, field_schema, operator_schema, recipe_schema, material_taxonomy]
    exclusions: [deployment_authority, portfolio_presentation, framework_component_api]
    basis: [repository_declared_purpose, validated_schema_package, cross_specimen_reuse_test]
    review_triggers: [ontology_split, incompatible_schema_version, second_repo_claiming_same_authority]
```

`exclusions` records what the repository **must refuse to own**. It matters as much as `scope`.

Relationship to Phase 1 `canonical_status`: unchanged and still required. Facets are more specific than the flat field. When they disagree, the facets express the bounded claim and the disagreement goes in `uncertainties` (see Known tension below).

## REG-AUTH-02 — continuity edge types (`relationships[].type`, additive)

| type | meaning |
|---|---|
| `implements` | Source realizes the target's semantic contract faithfully in a concrete language/runtime (e.g. GLSL implementation of a grammar operator). |
| `approximates` | Source produces a visually or behaviorally similar result but **cannot** realize the target semantics exactly (e.g. SVG filter approximating microfacet scatter). Visual similarity ≠ semantic equivalence. |
| `visualizes` | Source renders or displays target data/semantics without implementing them. |
| `instantiates` | Source is a concrete instance (specimen, recipe) of a target-defined type. |
| `consumes_schema` | Source reads/depends on a schema published by target; must not redefine it. |
| `exports_to` | Source emits artifacts into target (build output, data feed). |
| `validates_against` | Source's tests/CI check conformance to target's contract. |

Existing types (`predecessor`, `successor`, `mirror`, `fork`, `deployment-sibling`, `governed-by`, `related`) are unchanged.

## REG-AUTH-03 — proposals are not edges

A candidate interpretation must never become a graph edge. Unproven readings go in `relationship_proposals`, which the validator treats as a separate non-edge field. It warns with `relationship-proposal-unproven` and never resolves the proposal:

```yaml
relationship_proposals:
  - target: qt314wink/svg-filter-lab
    candidate_interpretation: reference_to_framework_adapter
    evidence_status: insufficient | partial | pending_review
    required_evidence: [commit_ancestry, shared_file_history, package_identity, deployment_history,
                        readme_chronology, unique_implementation_inventory, issue_pr_intent]
```

Using a candidate interpretation as `relationships[].type` is a schema error.

## REG-AUTH-04 — conflict rule

If two repositories whose `lifecycle` is not `archived` both declare a facet for the same `domain` with role `canonical` or `candidate_canonical`, and neither sets `exclusive: false`, the validator fails with **`authority-conflict`**. CI fails as a result. Additional checks:
- `authority-duplicate-facet`: one repository declares the same domain twice.
- `authority-unresolved-canonical`: role `canonical` with confidence `unresolved`. Use `candidate_canonical` instead.

One canonical repository plus any number of `consumes` / `not_authoritative` facets on the same domain is valid.

## REG-AUTH-05 — fixtures

`tests/fixtures/registry/`:
- `authority-conflict-exclusive-claims.json`: expected to fail with `authority-conflict`.
- `authority-canonical-plus-consumer.json`: expected to pass, and also exercises `consumes_schema` and a proposal warning.
- `authority-proposal-as-edge-rejected.json`: expected to fail with a schema error.

The fixtures put a synthetic `fixture_test_domain` on existing Phase 1 records. They are **not** claims about those repositories.

## REG-AUTH-06 — five-part determination record (human docs; not yet schema)

1. **CLAIM**: e.g. "qt314wink/shader-grammar is semantic authority for optical material recipes."
2. **EVIDENCE**: declared purpose, schemas, catalogs, and passing tests, each with links/SHAs.
3. **ALTERNATIVES**: the other repositories that could plausibly hold this authority.
4. **REJECTION BASIS**: the reason each alternative is rejected.
5. **DETERMINATION**: `<repo> canonical_for <domain>`, **or** `UNRESOLVED` with CANDIDATES and REQUIRED EVIDENCE.

Worked unresolved example (status: proposed, not registered):

```
DETERMINATION: UNRESOLVED
CANDIDATE: MelodicBloom/svg-filter-lab → native SVG reference
CANDIDATE: qt314wink/svg-filter-lab → React/Next adapter
REQUIRED EVIDENCE: commit ancestry, shared file history, package identity, deployment history,
                   README chronology, unique implementation inventory, issue/PR intent
```

## Known tension (open, not changed here)

`qt314wink/svg-filter-lab` has flat `canonical_status: canonical` in Phase 1. Under bounded delegation, that reads as an unbounded claim, while its lineage against `MelodicBloom/svg-filter-lab` is still **UNRESOLVED** (Phase 1 decision #4 already leaves deployment authority unknown). This PR does **not** change that record. Step 2 (SVG Filter Lab lineage audit) should settle it by adding facets, or a proposal, backed by evidence.

## Sequence

1. This PR: vocabulary. 2. SVG Filter Lab lineage audit. 3. Shader Grammar attestation. 4. Shader Gallery attestation. 5. Cross-system translation contract. 6. Seed Loom crosswalk. 7. Project Constellation consumption.
