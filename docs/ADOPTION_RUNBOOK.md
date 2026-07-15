# Adoption Runbook

## Intent

Adoption begins with observation rather than enforcement. The purpose of the first pass is to discover the repository's actual operating contract and make hidden assumptions visible. A workflow is not considered successfully adopted merely because it runs; it is adopted when the repository's declared class, commands, permissions, evidence, and deployment behavior agree with observable reality.

## Entry condition

A repository enters adoption with a named owner, an identified default branch, a known package manager or explicit non-package classification, and a repository manifest proposed in a pull request. Empty scaffolds, archives, imported upstream projects, and asset-only repositories are not forced through application CI. Their manifests explain why a lighter control set is appropriate.

## Discovery pass

The discovery pass reads manifests, lockfiles, scripts, framework configuration, deployment files, workflow files, route structure, test configuration, and generated-output conventions. It records ambiguity instead of guessing. Where two repositories appear to represent the same product, neither is treated as canonical until ownership and purpose are resolved.

The discovery result becomes a proposed manifest. The proposal states what the repository is, what it is not, which verification surfaces matter, which automated capabilities are permitted, and which evidence will demonstrate success. Review of that manifest is review of the automation's reasoning boundary.

## Observational pass

The initial workflow runs without becoming a required branch check. It installs dependencies using the frozen lockfile, executes only commands that the repository explicitly exposes, and uploads diagnostic output when a command fails. Missing tests are reported as an absent verification surface rather than silently represented as passing tests.

The observational pass establishes normal duration, artifact size, bundle size, route count, accessibility findings, flaky behavior, and environmental dependencies. A control is not promoted while its signal remains noisy or unexplained.

## Required verification pass

After the baseline is accepted, deterministic checks become required on pull requests. Required status names remain stable so branch protection does not break when internal workflow structure changes. Expensive visual and browser checks may be path-sensitive, but a lightweight integrity check still confirms that the classification and workflow invocation are valid.

The required pass does not deploy production. It creates the verified artifact and records its identity. Preview environments may be created when their credentials are isolated from untrusted pull-request code.

## Deployment pass

Production deployment consumes the verified artifact. It does not perform an unrelated build. The deployment environment applies concurrency control, named approval where consequence warrants it, and a rollback identifier. Database migrations, destructive asset transformations, workflow permission escalation, and cross-repository mutation remain separately authorized transitions.

## Agent-enabled pass

An agent begins with read and propose capability. It may inspect failures, prepare a branch, and open a pull request. Write access to protected branches, production deployment, secret mutation, administrative settings, and database migration are not implied. Expansion of authority requires evidence that the narrower role is insufficient and that the proposed control contains the resulting risk.

Every agent-authored pull request records the task, repository scope, base revision, agent and model identity where available, tools used, commands executed, files changed, verification results, unresolved uncertainty, and requested human decision. The purpose is not surveillance; it is reconstructability.

## Promotion and rollback

A workflow version is promoted through representative canaries before organization-wide recommendation. Repositories remain pinned to a known release. If a new control-plane version causes unexplained failures, callers return to the previous reference while the new version is corrected. Rollback is therefore a version-selection operation rather than emergency editing across many repositories.

## Completion condition

Adoption is complete when the manifest matches the repository, required checks are stable, permissions are minimal and explicit, verification produces interpretable evidence, the production artifact can be traced to the verified source, exceptions are owned and expiring, and the recovery path has been exercised or documented convincingly.
