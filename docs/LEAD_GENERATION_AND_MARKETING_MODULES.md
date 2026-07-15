# Lead Generation and Marketing Interaction Modules

## Purpose

MelodicBloom site automation may propose lead-generation and marketing interactions, but it must not treat conversion as permission to manipulate visitors or to insert unreviewed collection mechanisms into production. The system exists to discover ethically persuasive opportunities, translate them into reviewable concepts, and preserve enough evidence for a reviewer to understand why each concept was suggested, how it is expected to work, what it costs, what it measures, and what could go wrong.

A proposal is not an implementation. It is a bounded hypothesis package. The site repository remains unchanged until a human accepts the proposal and authorizes a separate implementation pull request.

## Operating model

The proposal engine reads a repository manifest, site structure, available product or service context, existing analytics conventions, and declared audience assumptions. It then produces a small set of differentiated concepts rather than a volume of generic marketing patterns. Every concept must identify the user problem it addresses, the moment in the visitor journey where it appears, the intended exchange of value, the interaction behavior, the data it collects, the evidence that would support or falsify it, and the constraints that prevent dark-pattern behavior.

The review package contains a written rationale, a scoped implementation contract, a state-by-state interaction specification, responsive mockup descriptions, event instrumentation, an experiment design, accessibility requirements, privacy implications, dependencies, rollback conditions, and a clear recommendation. When image or browser-rendered mockups are available, they are attached as workflow artifacts. When they are not, the package must say that explicitly instead of implying visual validation occurred.

## Conversion philosophy

High conversion is treated as the result of relevance, clarity, confidence, reduced friction, and a credible value exchange. It is not treated as the result of urgency theater, hidden defaults, obstructive dismissal, misleading scarcity, forced continuity, or excessive interruption. A proposal must explain why the interaction belongs at that point in the experience and what would make the visitor reasonably welcome it.

The preferred modules are context-sensitive. A portfolio may invite a project inquiry after evidence of depth has been shown. A design system may offer a downloadable specimen or implementation guide after the visitor explores relevant components. A product site may offer a comparison, calculator, saved configuration, waitlist, guided recommendation, consultation request, or email course when those exchanges genuinely advance the visitor's task. The module should feel like the next useful capability of the site, not an unrelated overlay imposed upon it.

## Explainability contract

Every proposed module must make its reasoning inspectable. The proposal records the repository and commit analyzed, the workflow and proposal-schema versions, the assumptions used, the source files or routes that informed the concept, the intended audience segment, the user need, the conversion event, the expected mechanism, competing alternatives, reasons for rejection, foreseeable harms, and confidence level.

The proposal must distinguish observed facts from inference. For example, the presence of a pricing route is an observation. The claim that visitors need reassurance before requesting a consultation is an inference unless supported by analytics, interviews, search behavior, or prior experiments. Unsupported inference is allowed during ideation, but it must be labeled and given a validation plan.

## Review package

Each concept is delivered as a proposal directory containing a machine-readable `proposal.json`, a human-readable `proposal.md`, a mockup specification, an event map, and an experiment contract. The mockup specification describes every relevant state, including entry, idle, focus, completion, validation failure, loading, success, dismissal, return visit, mobile adaptation, keyboard use, reduced motion, and unavailable-service behavior.

The proposal includes implementation boundaries. It names the expected routes, components, data contracts, external services, environment variables, content dependencies, analytics events, test additions, performance budget, and files likely to change. It also identifies what the implementation must not do. This prevents a seemingly small lead form from quietly becoming an uncontrolled CRM integration, tracking expansion, or redesign of unrelated site surfaces.

## Measurement and defensibility

A proposed conversion event must have a denominator and a quality measure. Form submissions alone are not sufficient. Depending on the site, quality may be represented by qualified inquiries, confirmed subscriptions, completed onboarding, booked consultations, activated downloads, retained users, or downstream revenue. The proposal must name possible failure signals such as increased bounce, lower engagement with primary content, complaint rates, accidental submissions, poor lead quality, accessibility regressions, or performance degradation.

Experiments should be designed so that a negative result is informative. The package therefore identifies the hypothesis, primary metric, guardrail metrics, audience, exposure rule, expected duration or sample requirement, stopping conditions, and interpretation limits. The system must not claim statistical certainty merely because one variant produced a larger number.

## Privacy and consent

Data minimization is mandatory. A proposal requests only information required for the stated exchange. Optional fields must be visibly optional. Consent language must be specific to the action being taken. Marketing subscription cannot be bundled invisibly with an unrelated request. Sensitive personal data, invasive fingerprinting, cross-site tracking, pre-checked consent, and hidden enrichment are outside the default authority of the automation system.

Any external form, CRM, analytics, scheduling, enrichment, or email provider must be named in the proposal with the data transferred, retention assumptions, failure behavior, and required secrets. The implementation cannot be promoted until those choices are reviewed.

## Approval boundary

Proposal generation may run automatically because it changes no production behavior. Opening a review issue may be automated when the repository manifest permits issue creation. Creating an implementation branch, adding a form provider, enabling analytics, changing consent text, or deploying a marketing module requires a separate approved action. Agents may prepare the implementation only within the repository, branch, tool, and data scopes granted by the runtime-control policy.

## Relationship to agent runtime controls

The proposal engine is a read-mostly planning agent. It may inspect declared repository content and produce artifacts. It may not access production customer data, private analytics, CRM records, email lists, or secrets unless a later runtime profile explicitly grants that capability. An implementation agent receives a different identity and narrower task contract. A validation agent should evaluate the resulting interaction independently so the system does not rely on the same agent to propose, implement, and approve its own work.

## Definition of a review-ready proposal

A proposal is review-ready when a reviewer can understand the visitor need, see the interaction concept across states and breakpoints, identify the expected conversion mechanism, assess the ethical and privacy consequences, estimate the work, understand the measurement design, compare alternatives, and reject or approve the idea without first reverse-engineering unstated assumptions.
