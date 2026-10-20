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

| Component                   | Delivery                                                                                                      | Notes                                                                                                                                                                                           |
| --------------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Frontend + Backend + nginx  | Single Docker image, published on Docker Hub as `codemie/codemie-oss-standalone` or built by `build-image.sh` | nginx proxies `/api/`, `/v1/`, `/code-assistant-api/` to the backend and serves the frontend static assets                                                                                      |
| PostgreSQL                  | `postgres:17` container                                                                                       | Primary application database                                                                                                                                                                    |
| Authentication              | Built-in local auth (`IDP_PROVIDER=local`)                                                                    | Seeded with a superadmin account from `.env.standalone`; no Keycloak required                                                                                                                   |
| Retrieval (Elasticsearch)   | Disabled by default (`RETRIEVAL_BACKEND=none`)                                                                | Knowledge Bases, Data Sources, and code indexing are unavailable unless a retrieval backend is configured — see [Configuration](../../admin/configuration/codemie/datasources-configuration.md) |
| Budget Management (LiteLLM) | Not included                                                                                                  | Disable `features:budgetManagement` — see [Run Guide](./run-guide.md#disabling-budget-management)                                                                                               |

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
environment, and start the stack.
