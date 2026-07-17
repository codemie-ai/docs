---
id: request-tagging
title: LLM Request Tagging
sidebar_label: Request Tagging
sidebar_position: 3
pagination_prev: admin/configuration/observability/observability-overview
pagination_next: null
---

CodeMie automatically injects metadata headers into every outbound LLM API request so that
cloud provider logs and in-cluster observability tools can attribute traffic to the running
platform version and the active project context.

## Injected Headers

Two HTTP headers are added to outbound requests:

| Header              | Value                                              | Example      |
| ------------------- | -------------------------------------------------- | ------------ |
| `X-CodeMie-Version` | Value of the `APP_VERSION` environment variable    | `1.4.2`      |
| `X-CodeMie-Project` | Name of the active CodeMie project at request time | `my-project` |

`X-CodeMie-Version` is always present. `X-CodeMie-Project` is included only when a project
context is active; it is omitted entirely when no project is set for the request.

## Provider Coverage

Headers are injected at the LLM client construction layer. Coverage depends on the AI
provider path used by the model:

| Provider path       | Headers injected | Notes                                                                                                                      |
| ------------------- | ---------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Azure OpenAI / DIAL | Yes              | Added to `default_headers` on the `AzureChatOpenAI` client                                                                 |
| Google Vertex AI    | Yes              | Passed via `client_options.additional_headers` on the `ChatVertexAI` client                                                |
| Anthropic (direct)  | Yes              | Passed via `extra_headers` on the `ChatAnthropic` client                                                                   |
| AWS Bedrock         | No               | Bedrock does not support custom HTTP request headers; request attribution uses request-body fields instead                 |
| LiteLLM proxy       | No               | LiteLLM receives project context via `x-litellm-tags`; the `X-CodeMie-*` headers are not forwarded to avoid double-tagging |

## Purpose and Use Cases

**Cost and traffic attribution** — cloud provider portals (Azure Monitor, Vertex AI quotas,
Anthropic usage dashboards) expose custom headers in request logs, enabling filtering and
grouping by CodeMie version or project.

**Multi-version deployments** — when multiple CodeMie versions run in parallel (canary
rollout, blue/green), `X-CodeMie-Version` identifies which instance originated a request
without requiring log correlation.

**Project-level analysis** — `X-CodeMie-Project` allows isolating LLM usage by team or
workspace in provider-side logs and in Langfuse traces, complementing the project-level
spend tracking available through the LiteLLM proxy path.

## Configuration

No explicit configuration is required. Tag injection is always active for the supported
provider paths. The values are derived from two existing environment variables:

| Variable            | Description                                         | Default                    |
| ------------------- | --------------------------------------------------- | -------------------------- |
| `APP_VERSION`       | Platform version string used as `X-CodeMie-Version` | Set at build time          |
| _(project context)_ | Resolved from the active request context at runtime | _(empty — header omitted)_ |

`APP_VERSION` is set during deployment and is not modified at runtime. See
[API Configuration](../codemie/api-configuration.md) for the full environment
variable reference.

## Verifying Header Injection

### Azure / DIAL

Request headers forwarded through Azure API Management or DIAL are visible in Azure API
Management diagnostic logs and in DIAL request traces. Filter for requests containing
`x-codemie-version` to confirm injection.

### Google Vertex AI

Enable Cloud Logging for Vertex AI API calls in the Google Cloud Console. Custom headers
appear under `httpRequest.requestHeaders` in the log entries.

### Anthropic (direct)

Anthropic's usage dashboard does not expose custom request headers. Verify injection
locally by enabling `DEBUG` log level in the CodeMie deployment and inspecting the
outbound HTTP request logs, or by routing traffic through an HTTP proxy during
development.

:::info LiteLLM path
For models routed through the LiteLLM proxy, project context reaches LiteLLM via the
`x-litellm-tags` header instead. See the
[LiteLLM Model Tagging](../codemie/api-configuration.md) section of the API
Configuration reference for the related `LITE_LLM_PROJECTS_TO_TAGS_LIST` and
`LITE_LLM_TAGS_HEADER_VALUE` environment variables.
:::

## Related Documentation

- [Observability Overview](./index.md) — infrastructure logging and Langfuse tracing
- [API Configuration](../codemie/api-configuration.md) — full environment variable
  reference including `APP_VERSION` and LiteLLM tagging variables
