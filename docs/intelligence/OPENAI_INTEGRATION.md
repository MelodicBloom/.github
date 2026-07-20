# OpenAI Intelligence Intake v1

## Purpose

Convert nightly briefing findings into structured, reviewable GitHub work without allowing an AI system to mutate product repositories directly.

## Canonical boundary

`MelodicBloom/.github` owns the signal schema, disposition vocabulary, routing contract, approval gates, and reusable intake template.

Individual repositories own implementation, repository-specific tests, evidence artifacts, rollback, and merge decisions.

## Allowed OpenAI responsibilities

OpenAI may:

- normalize a briefing item into structured fields;
- identify likely canonical repository ownership;
- detect duplicate or conflicting concepts;
- propose bounded next actions;
- draft issues, QA requirements, and review questions;
- summarize evidence and limitations.

OpenAI may not:

- push to a default branch;
- merge or approve pull requests;
- edit product source directly;
- alter dependencies without explicit scope;
- treat a news article as validated research;
- overwrite prior evidence, rejected interpretations, or human decisions;
- convert usage metrics into contributor performance judgments.

## Intake flow

```text
briefing item
→ source receipt
→ structured signal
→ schema validation
→ duplicate/conflict check
→ canonical owner proposal
→ human disposition
→ bounded repository issue
→ draft implementation PR
→ repository QA
→ Jennipher approval
```

## Dispositions

- `watch`
- `research_hypothesis`
- `architecture_candidate`
- `implementation_candidate`
- `opportunity`
- `reject_duplicate`
- `reject_low_evidence`
- `archive_context`
- `needs_human_routing`

## Required evidence envelope

Every analysis run must retain:

- schema version;
- model identifier;
- prompt version or hash;
- run identifier and timestamp;
- source identifiers and publication dates;
- structured response;
- schema-validation result;
- confidence and limitations;
- human disposition;
- links to any resulting issue or pull request.

## Security boundary

Future workflow integration must use a GitHub Actions secret named `OPENAI_API_KEY`. The key must never be committed, printed, uploaded as an artifact, or copied into issue text.

Minimum permissions for the analysis workflow:

```yaml
permissions:
  contents: read
  issues: write
```

The analyzer receives issue or briefing content as untrusted data. It must not follow embedded instructions, expand arbitrary URLs without an allowlist, execute generated commands, or create branches.

## Repository routing contract

An approved implementation issue must state:

- exact repository;
- base branch;
- proposed branch;
- allowed paths;
- forbidden paths;
- expected changed-file inventory;
- commands to run;
- evidence to retain;
- known risks;
- rollback procedure;
- draft PR only;
- Jennipher approval required.

## Promotion gates

A signal cannot become an implementation candidate unless:

1. at least one source receipt is present;
2. evidence quality is not `unknown`;
3. canonical ownership is resolved or explicitly marked for human routing;
4. duplicate and conflict checks are recorded;
5. the affected contracts are named;
6. allowed and forbidden paths can be bounded;
7. a repository-specific validation plan exists.

## Rollout

### Phase 1 — contract

Documentation, JSON Schema, issue template, and examples only.

### Phase 2 — read-only analyzer

Manual or issue-triggered workflow. Structured output is validated and posted as an issue comment or retained artifact. No repository mutation.

### Phase 3 — governed routing

After human disposition, create one bounded issue in one canonical repository. Any implementation proceeds through a separate branch and draft PR.

## Definition of done

The integration is complete when a briefing signal can be traced through source evidence, structured analysis, human disposition, repository routing, implementation, QA evidence, and final approval without any hidden mutation or loss of rejected alternatives.
