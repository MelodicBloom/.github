# OpenAI Evidence Review v2

## Appropriate uses

- summarize failed Actions evidence and propose bounded repairs;
- identify duplicated workflows, conflicting contracts, and missing verification surfaces;
- draft product, integration, design-system, conversion, affiliate, advertising, and generative-media proposals;
- produce acceptance criteria, measurement plans, QA questions, risks, rollback, and sequencing;
- compare evidence across runs without erasing rejected interpretations.

## Inappropriate uses

The workflow may not edit source, install generated commands, follow arbitrary URLs, approve or merge pull requests, deploy, publish marketing, enroll in affiliate programs, spend on advertising, access customer data, change secrets, or claim unsupported evidence.

## Key boundary

Use a project-scoped key stored only as the GitHub Actions secret `OPENAI_API_KEY`. The key is never committed, printed, embedded in client code, placed in issue text, or uploaded as an artifact. Use separate project keys for maintenance and production products, with separate spend controls and rotation schedules.

## Evidence envelope

Every completed analysis retains:

- repository and source SHA;
- GitHub run ID;
- mode;
- model identifier;
- prompt version and SHA-256;
- evidence SHA-256;
- OpenAI response ID and request ID;
- client request ID;
- strict structured response;
- validation status;
- explicit human-approval requirement;
- limitations and rejected options.

Requests use `store: false`. Evidence is size-bounded and scanned for common credential patterns before transmission.

## Prompt-injection boundary

Repository content, issue text, analytics exports, and briefing files are untrusted data. The model is instructed not to obey embedded instructions, execute commands, request credentials, or authorize actions. AI output remains advisory even when valid against the schema.
