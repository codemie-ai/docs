---
id: index
title: AI/Run CodeMie Standalone
sidebar_label: Standalone
sidebar_position: 9
pagination_prev: user-guide/index
pagination_next: null
---

# AI/Run CodeMie Standalone

CodeMie Standalone packages the frontend, backend API, and an nginx reverse proxy into a **single
Docker image**, paired with a separate PostgreSQL container through Docker Compose. It is the
fastest path to a running CodeMie instance, with no Elasticsearch, Keycloak, or LiteLLM
dependency.

The image is published on Docker Hub as
[`codemie/codemie-oss-standalone`](https://hub.docker.com/repository/docker/codemie/codemie-oss-standalone),
so no source checkout or local build is required to try the platform.

## When to Use

CodeMie Standalone is designed for:

- **Proof of Concept (PoC) and demos** — a single image and two containers are enough to explore
  the platform.
- **Local development and testing** — no external identity provider, search cluster, or LLM proxy
  is required to start the application.

:::warning Not for Production
CodeMie Standalone runs a single instance of every component with no high availability, scaling,
or automated backups. For production workloads, use the
[Kubernetes](../../admin/deployment/infrastructure-deployment/kubernetes.mdx) or
[On VM](../../admin/deployment/infrastructure-deployment/on-vm.mdx) deployment guides.
:::

## What's Included

The application container holds the frontend, backend API, and nginx. PostgreSQL and every optional
service are **external dependencies**: they run outside the image and are owned by the operator.

| Component                   | Delivery                                                                                                      | Notes                                                                                                      |
| --------------------------- | ------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Frontend + Backend + nginx  | Single Docker image, published on Docker Hub as `codemie/codemie-oss-standalone` or built by `build-image.sh` | nginx proxies `/api/`, `/v1/`, `/code-assistant-api/` to the backend and serves the frontend static assets |
| PostgreSQL                  | External. The Compose file starts a `postgres:17` container; an existing server can be used via `PG_URL`      | Required. Primary application database                                                                     |
| Authentication              | Built-in local auth (`IDP_PROVIDER=local`)                                                                    | Seeded with a superadmin account from `.env.standalone`; no Keycloak required                              |
| LLM provider                | External (Azure OpenAI or AWS Bedrock)                                                                        | Required for Chats, Assistants, and Workflows                                                              |
| Elasticsearch               | External, optional. Not included                                                                              | Enabled by setting `ELASTIC_URL`. pgvector is not supported as a vector store                              |
| Redis                       | External, optional. Not included                                                                              | Enabled by setting `REDIS_HOST`                                                                            |
| Budget Management (LiteLLM) | Not included                                                                                                  | Disable `features:budgetManagement` — see [Run Guide](./run-guide.md#disabling-budget-management)          |

## Capabilities

| Capability                                    | Default standalone                      | Requirement to enable                                                          |
| --------------------------------------------- | --------------------------------------- | ------------------------------------------------------------------------------ |
| Local login, user management                  | Available                               | `SUPERADMIN_*` variables                                                       |
| Chats, Assistants, Workflows, Skills          | Off until an LLM provider is configured | One LLM provider block; restart after setting                                  |
| Knowledge Bases, Data Sources, code indexing  | Unavailable                             | `ELASTIC_URL` pointing to Elasticsearch                                        |
| CLI Analytics                                 | Available                               | Stored in the application PostgreSQL; needs `features:cliAnalytics`            |
| AI Champions Leaderboard                      | Incomplete data                         | Elasticsearch; otherwise disable it, see the repository `standalone/README.md` |
| Budget Management                             | Unavailable                             | LiteLLM is not part of standalone; disable the feature                         |
| Google integration OAuth, webhook rate limits | Disabled                                | `REDIS_HOST` (and `GOOGLE_OAUTH_ENABLED=true` for OAuth)                       |
| MCP Servers on assistants                     | Degraded                                | `MCP_CONNECT_URL` pointing to an MCP Connect service                           |
| Diagram rendering (Mermaid)                   | Degraded                                | `MERMAID_SERVER_URL`                                                           |
| Code Executor                                 | Unavailable                             | Kubernetes cluster connection for the executor                                 |

Unavailable features are removed from the UI and API rather than left failing. Each degraded
capability logs one warning at startup that names the setting that would enable it.

## Known Limitations

- **No data migration between storage providers.** Moving data between the bundled PostgreSQL
  container and another database, or between the former bind mounts and Docker named volumes, is
  a manual operation. Backups and any export or import of data are the operator's responsibility.
- **Single instance.** Backend runs with one worker, without high availability or scaling.
- **Startup requires a writable data volume.** `codemie-storage` and `codemie-repos` must be
  writable by uid 1001, or the container exits at start.
- **Release matching.** The image, Compose file, and configuration files must come from the same
  release.

## Support

Standalone is intended for proof of concept, demos, and local development. The CodeMie team owns
the published image and its deployment files. The operator owns PostgreSQL, Elasticsearch, Redis,
the LLM provider account, credentials, backups, and the host runtime. When reporting an issue,
include the image tag, the output of `/api/v1/info`, and the `codemie` container logs.
See [Troubleshooting](./troubleshooting.md).

## Repository

The packaging assets (`Dockerfile`, `build-image.sh`, Compose file, nginx and entrypoint scripts)
live under `standalone/` in the [`codemie`](https://github.com/codemie-ai/codemie) backend
repository. The image bundles the frontend from the
[`codemie-ui`](https://github.com/codemie-ai/codemie-ui) repository at build time — no separate frontend repository checkout is required
to run the image, only to build it. Consumers of a published release use its version-matched
standalone deployment files and the image from Docker Hub; they do not need either source
checkout.

## Next Steps

Proceed to the [Run Guide](./run-guide.md) to pull the image, configure the
environment, and start the stack. If startup fails, see [Troubleshooting](./troubleshooting.md).
