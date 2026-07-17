# MelodicBloom Automation Control Plane

This repository is the governing source for shared GitHub Actions, repository automation policy, evidence conventions, and agent-runtime controls across the MelodicBloom organization.

The control plane is intentionally centralized without making every repository identical. Shared rules live here because permission boundaries, provenance, artifact identity, deployment gates, and audit expectations should not drift. Repository-specific behavior remains inside each product repository because build commands, design surfaces, deployment targets, and runtime risks differ.

The operating model is declarative. A repository identifies its class, stack, package manager, quality surfaces, deployment target, and permitted automation capabilities. Reusable workflows interpret those declarations and produce verification evidence. A repository may deviate only through a documented, owned, expiring exception.

The first release contains the architecture rationale, rollout standard, repository manifest schema, policy defaults, and a reusable Node web verification workflow. It is deliberately introduced through a reviewable pull request. No production deployment, branch protection, secret mutation, or cross-repository write is performed by this initial version.

Read `docs/AUTOMATION_CONTROL_PLANE.md` for the full explainability model and `docs/ADOPTION_RUNBOOK.md` for the controlled per-repository adoption process.
