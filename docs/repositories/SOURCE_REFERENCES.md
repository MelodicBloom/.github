# Source references — canonical repository registry v1

These references are for the human reviewer and coding agent. Prefer primary documentation and live repository evidence over inferred behavior.

## Vercel Connect

- Vercel Connect overview: https://vercel.com/connect
- Connector API: https://vercel.com/docs/rest-api/connect/get-a-connector
- Core rule: use Connect only when a deployed app/agent needs delegated runtime credentials to an external provider. A GitHub-backed Vercel deployment does not, by itself, justify attaching a GitHub Connect connector.
- Environment boundary: keep development/preview/production credential authority separable. Do not broaden a production connector merely to make preview testing easier.
- Trigger caution: verify current provider support before configuring webhook trigger destinations. Do not infer trigger support from the dashboard UI alone.

## GitHub Apps and permissions

- Choosing permissions: https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/choosing-permissions-for-a-github-app
- Installed app repository access: https://docs.github.com/en/apps/using-github-apps/reviewing-and-modifying-installed-github-apps
- REST permission mapping: https://docs.github.com/en/rest/authentication/permissions-required-for-github-apps
- Rule: request the minimum repository permissions and install the app only on the repositories that need runtime access.
- Contents write is not a default. Prefer read-only or PR/review-oriented profiles until a bounded branch-write use case is proven.
- Editing GitHub Actions workflow files may require the Workflows permission in addition to Contents.

## OpenAI API projects

- Managing projects, keys, service accounts, limits, and usage: https://help.openai.com/en/articles/9186755
- API-key safety and environment separation: https://help.openai.com/en/articles/5008148
- Rule: do not share one broad personal key across unrelated production workloads. Keep project/environment usage separable and never commit secrets.

## Live evidence captured for this phase

GitHub repository/default-branch/head-SHA evidence was observed on 2026-09-20 through the connected GitHub account. Vercel project-name/project-ID evidence was observed on 2026-09-20 through the connected melodicbloom Vercel team.

The registry intentionally records unknown values where a runtime, lockfile, deployment authority, or canonical relationship was not proven in this pass.
