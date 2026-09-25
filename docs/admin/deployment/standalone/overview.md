---
id: overview
title: AI/Run CodeMie Standalone Deployment Guide
sidebar_label: Overview
sidebar_position: 1
pagination_prev: admin/deployment/index
pagination_next: admin/deployment/standalone/deployment-guide
---

# AI/Run CodeMie Standalone Deployment

CodeMie Standalone packages the frontend, backend API, and an nginx reverse proxy into a **single
Docker image**, paired with a separate PostgreSQL container through Docker Compose. It is the
fastest path to a running CodeMie instance, with no Elasticsearch, Keycloak, or LiteLLM
dependency.

## When to Use

CodeMie Standalone is designed for:

- **Proof of Concept (PoC) and demos** — a single image and two containers are enough to explore
  the platform.
- **Local development and testing** — no external identity provider, search cluster, or LLM proxy
  is required to start the application.

:::warning Not for Production
CodeMie Standalone runs a single instance of every component with no high availability, scaling,
or automated backups. For production workloads, use one of the [Kubernetes](/admin/deployment/aws/kubernetes/overview)
or [On VM](/admin/deployment/aws/on-vm/overview) deployment guides.
:::

## What's Included

| Component                   | Delivery                                        | Notes                                                                                                                                                                                     |
| --------------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Frontend + Backend + nginx  | Single Docker image, built by `build-image.sh`  | Frontend is built with `VITE_IS_ENTERPRISE_EDITION=false`; nginx proxies `/api/`, `/v1/`, `/code-assistant-api/` to the backend and serves the frontend static assets                     |
| PostgreSQL                  | `postgres:17` container                         | Primary application database                                                                                                                                                              |
| Authentication              | Built-in local auth (`IDP_PROVIDER=local`)      | Seeded with a superadmin account from `.env.standalone`; no Keycloak required                                                                                                             |
| Retrieval (Elasticsearch)   | Disabled by default (`RETRIEVAL_BACKEND=none`)  | Knowledge Bases, Data Sources, and code indexing are unavailable unless a retrieval backend is configured — see [Configuration](../../configuration/codemie/datasources-configuration.md) |
| Budget Management (LiteLLM) | Not included                                    | Disable `features:budgetManagement` — see [Deployment Guide](./deployment-guide.md#disabling-budget-management)                                                                           |
| CLI Analytics               | Optional `standalone-analytics` Compose profile | Adds ClickHouse and an OpenTelemetry Collector                                                                                                                                            |

## Deployment Profiles

| Profile                             | Command                                                                                           | Adds                          |
| ----------------------------------- | ------------------------------------------------------------------------------------------------- | ----------------------------- |
| **Default**                         | `docker compose -f standalone/docker-compose.standalone.yml up -d`                                | `codemie`, `postgres`         |
| **Standalone Analytics** (optional) | `docker compose -f standalone/docker-compose.standalone.yml --profile standalone-analytics up -d` | `clickhouse`, `otelcollector` |

## Repository

The packaging assets (`Dockerfile`, `build-image.sh`, Compose file, nginx and entrypoint scripts)
live under `standalone/` in the `codemie` backend repository. The image bundles the frontend from
the `codemie-ui` repository at build time — no separate frontend repository checkout is required
to run the image, only to build it. Consumers of a published release use its version-matched
standalone deployment files and image tag; they do not need either source checkout.

## Next Steps

Proceed to the [Deployment Guide](./deployment-guide.md) to build the image, configure the
environment, and start the stack.
