# Automation Control Plane

## Purpose

The MelodicBloom repository estate contains web applications, visual systems, agents, knowledge infrastructure, schemas, experiments, archives, asset collections, and imported upstream projects. A single copied workflow would confuse similarity of ownership with similarity of operational behavior. This control plane therefore standardizes the reasons automation exists, the evidence it must produce, and the authority it may exercise while allowing each repository to retain its own implementation contract.

The central claim is that automation is trustworthy only when its action can be reconstructed. A successful green check is not sufficient. A reviewer should be able to determine which source revision ran, which workflow revision interpreted it, which dependencies were installed, which commands executed, which permissions were available, which artifact emerged, and which human or machine decision allowed the next transition.

## Why the architecture is hybrid

Fully local workflows maximize independence but produce duplicated policy, uneven security fixes, inconsistent evidence, and silent drift. A fully centralized workflow minimizes duplication but becomes brittle when repositories have different frameworks, maturity levels, visual surfaces, and deployment consequences. The hybrid model keeps security and evidence semantics central while repositories declare their own build and verification surfaces through narrow inputs.

This is defensible because the boundary is explicit. The control plane determines how a capability is granted, how an artifact is identified, how failures are reported, and how exceptions expire. The repository determines what constitutes a valid build, which routes and states must be rendered, which tests express intended behavior, and which provider receives an approved artifact.

## Decision model

Every workflow transition answers four questions. The first is identity: what exact source, workflow, dependency graph, and environment produced the result. The second is authority: what permissions and credentials were available, and why they were necessary. The third is verification: what observable evidence supports the claim that the result is acceptable. The fourth is consequence: what may happen next, and whether that transition requires a human gate.

This model separates verification from deployment. Continuous integration may inspect source, install frozen dependencies, run checks, create an immutable artifact, and record its digest. Deployment receives that verified artifact rather than rebuilding from mutable inputs. Production approval therefore authorizes promotion of known evidence, not execution of an unverified second build.

## Repository classification

Classification is an executable routing decision rather than a descriptive label. A web application exposes routes, responsive states, interaction behavior, accessibility requirements, visual assets, and a deployable bundle. An agent runtime exposes tools, permissions, prompt and model versions, evaluation cases, action budgets, and escalation behavior. A schema or knowledge repository exposes structural validity, references, semantic consistency, and provenance. An asset repository exposes integrity, metadata, licensing, dimensions, duplication, and size constraints. Imported upstream repositories expose sync and drift risk rather than MelodicBloom product behavior.

A repository manifest records this distinction. The manifest is reviewed like code because changing classification changes which controls execute and which permissions may become available.

## Permission model

Workflows begin without ambient authority. Read-only verification receives repository contents read access. Pull-request annotation receives only the additional pull-request permission needed to publish findings. Deployment identity receives an OIDC token only inside the deployment job. Source mutation, release publication, secret changes, workflow edits, branch protection changes, database migration, and cross-repository writes are separate capabilities and are never inferred merely because an agent or workflow can build a project.

An agent follows the same model. Read, propose, verify, merge, deploy, migrate, and administer are distinct grants. A grant is repository-scoped, branch-scoped, purpose-scoped, time-bounded where practical, and represented in the evidence record.

## Evidence contract

A verification run should preserve the repository and commit identity, workflow reference, runner and toolchain versions, package-manager and lockfile digest, executed commands, test and audit summaries, generated artifact digest, permission declaration, exception identifiers, and transition decision. Evidence may be stored in job summaries, signed attestations, retained artifacts, deployment records, or an append-only external ledger. The storage mechanism may evolve, but the semantic contract should remain stable.

Corrections append a new record. They do not rewrite the historical meaning of a previous run. This preserves the distinction between what was believed at execution time and what was learned later.

## Progressive enforcement

A control enters as observational when its baseline is unknown. It becomes advisory after the output is intelligible and false positives are understood. It becomes required for pull requests after repositories can satisfy it consistently. It becomes a deployment gate only when failure indicates unacceptable production risk. This progression avoids both ceremonial checks that everyone ignores and premature gates that halt development without improving confidence.

## Failure containment

Every workflow should have a bounded runtime, explicit concurrency behavior, predictable cancellation semantics, retained diagnostic evidence, and a recovery path. Automated source changes should normally become pull requests. Direct default-branch mutation is reserved for narrowly scoped, reversible machine records whose review would add no material safety.

A central workflow is versioned. Repositories call a release tag or immutable commit rather than the moving default branch. A new release is exercised on canary repositories before broader adoption. This prevents one control-plane edit from unexpectedly changing every active product.

## Exception model

An exception identifies the waived control, explains the incompatibility, names an accountable owner, records a compensating control, and expires. Expiry is essential because an undocumented permanent exception is indistinguishable from forgotten policy. The control plane treats visible, reasoned deviation as more trustworthy than false uniformity.

## Relationship to web-design automation and agent runtime controls

Web-design automation defines the evidence a designed interface must produce: build integrity, route coverage, state capture, responsive behavior, accessibility, visual regression, motion behavior, asset validity, performance, and deployment identity. Agent runtime control defines what an agent may inspect or alter while attempting to satisfy those requirements. The verification layer judges the output. The evidence layer records the path. These are not separate products; they are adjacent layers of one governed execution system.
