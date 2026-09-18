---
id: overview
title: Standalone Deployment
sidebar_label: Standalone
sidebar_position: 1
pagination_prev: admin/deployment/index
pagination_next: null
---

# Standalone Deployment

Standalone deployment runs AI/Run CodeMie as a single self-contained Docker/Podman container backed by PostgreSQL only. No Elasticsearch, Kubernetes cluster, or cloud infrastructure is required. This mode is suited to lightweight, air-gapped, or evaluation environments where the retrieval-dependent features (Data Sources, Knowledge Bases, code indexing) are not needed.

:::info Feature trade-off
Standalone deployment sets `RETRIEVAL_BACKEND=none`, which disables Elasticsearch-dependent capabilities across the platform. See [Feature Availability](#feature-availability) below for the full list of what is unavailable.
:::

## Prerequisites

- **Bash** and **git**
- **Docker** (BuildKit-enabled, required for named build-context support) or **Podman** available on `PATH`
- **PostgreSQL** is provisioned automatically by the compose file; no external database is required
- At least one AI provider configured (Azure OpenAI or AWS Bedrock)
- The `codemie` and `codemie-ui` repositories checked out as sibling directories (only required for the default paths; `--backend-root`/`--frontend-root` may point anywhere):

  ```
  parent/
    codemie/           # Backend + standalone packaging assets (standalone/)
    codemie-ui/        # Frontend
  ```

## Step 1: Build the Image

The build script builds a single image containing the backend, the built frontend, and an nginx reverse proxy. It uses the backend repository as the main build context and passes the frontend repository as the named build context `frontend`, so no source is copied or checked out ahead of time. Run it from the `codemie` repository:

```bash
standalone/build-image.sh --image-tag localhost/codemie:local
```

The full parameter set, for a non-default layout (used by the release pipeline, where the two repos are not siblings):

```bash
standalone/build-image.sh \
  --image-tag    localhost/codemie:local \
  --backend-root /path/to/codemie \
  --frontend-root /path/to/codemie-ui \
  --engine       docker
```

| Parameter         | Default                        | Description                                                                   |
| ----------------- | ------------------------------ | ----------------------------------------------------------------------------- |
| `--image-tag`     | _(required)_                   | Tag applied to the built image                                                |
| `--backend-root`  | Repo containing the script     | Path to the backend repository (also the Dockerfile's build context)          |
| `--frontend-root` | `<backend-root>/../codemie-ui` | Path to the frontend repository, passed as the named build context `frontend` |
| `--engine`        | `docker`                       | Container engine: `docker` or `podman`                                        |
| `--no-cache`      | off                            | Forces a full rebuild, bypassing the build cache                              |

The script validates required source files, logs the git branch/SHA/dirty status of both repositories, and writes a timestamped log to `standalone/build-<timestamp>.log`. The build runs with `--ulimit nofile=65536:65536` to avoid environment-dependent open-file limits during the Vite/Tailwind frontend build, which reads many source files concurrently.

:::tip Podman preserves HEALTHCHECK
The build runs with `--format docker` to preserve the image's `HEALTHCHECK` instruction. This flag is Podman-specific; building with `--engine docker` (the default) skips it.
:::

## Step 2: Configure the Environment

Copy the example environment file and fill in real values:

```bash
cp standalone/.env.standalone.example standalone/.env.standalone
```

<details>
<summary><code>standalone/.env.standalone.example</code></summary>

```bash
# --- Core platform ---
RETRIEVAL_BACKEND=none
ADMIN_LOG_LOOKUP_ENABLED=false
ENABLE_USER_MANAGEMENT=true

# --- LLM provider selection ---
# MODELS_ENV picks codemie/config/llms/llm-{MODELS_ENV}-config.yaml.
# Use exactly one of the two blocks below (Azure OpenAI or AWS Bedrock).

# Azure OpenAI
MODELS_ENV=azure
AZURE_OPENAI_API_KEY=<your-azure-openai-key>
AZURE_OPENAI_URL=<https://your-resource.openai.azure.com>
OPENAI_API_VERSION=2025-04-01-preview

# AWS Bedrock (comment out the Azure block above and uncomment this one instead)
# MODELS_ENV=aws
# AWS_BEDROCK_REGION=us-east-1
# AWS_ACCESS_KEY_ID=<access-key>
# AWS_SECRET_ACCESS_KEY=<secret-key>
```

</details>

| Parameter                  | Required value for standalone | Description                                                                                                                                                    |
| -------------------------- | ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `RETRIEVAL_BACKEND`        | `none`                        | Disables Elasticsearch-dependent code paths platform-wide. See [Feature Availability](#feature-availability).                                                  |
| `ADMIN_LOG_LOOKUP_ENABLED` | `false`                       | The admin log-lookup endpoint (`POST /v1/logs`) queries Elasticsearch; keep disabled without an Elasticsearch instance.                                        |
| `ENABLE_USER_MANAGEMENT`   | `true`                        | Enables Platform-managed mode, storing roles and project membership in PostgreSQL. See [Access Control Overview](../../configuration/access-control/index.md). |
| `MODELS_ENV`               | `azure` or `aws`              | Selects which LLM provider configuration block is loaded.                                                                                                      |

Choose exactly one LLM provider block (Azure OpenAI or AWS Bedrock) and fill in its credentials. Full parameter reference: [API Configuration](../../configuration/codemie/api-configuration.md).

## Step 3: Run with Docker Compose

<details>
<summary><code>standalone/docker-compose.standalone.yml</code></summary>

```yaml
services:
  codemie:
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    container_name: codemie
    depends_on:
      postgres:
        condition: service_healthy
    # Image produced by `standalone/build-image.sh --image-tag localhost/codemie:local`
    # (backend + frontend + nginx baked into one image). Rebuild via that script to refresh it —
    # this compose file only ever references the tag, it never builds it.
    image: localhost/codemie:local
    env_file:
      - .env.standalone
    volumes:
      - codemie_repos:/app/codemie-repos
      - codemie_storage:/app/codemie-storage
    # nginx listens on 8080 inside the image (standalone/docker/nginx.conf, EXPOSE 8080
    # in standalone/Dockerfile).
    ports:
      - 8080:8080
    restart: on-failure
    environment:
      - PG_URL=postgresql://postgres:password@postgres:5432/postgres
      - KEYCLOAK_LOGOUT_URL=http://localhost:5010/docs

  postgres:
    image: docker.io/library/postgres:17
    container_name: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=postgres
    ports:
      - 5432:5432
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U postgres']
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
  codemie_storage:
  codemie_repos:
```

</details>

Start the stack:

```bash
docker compose -f standalone/docker-compose.standalone.yml up -d
```

Replace `docker compose` with `podman-compose` if using Podman.

:::warning Change default credentials
The `POSTGRES_PASSWORD` and `PG_URL` values shown are development defaults. Set stronger values before running in a shared or production-like environment.
:::

:::note Named volumes
`codemie_storage` and `codemie_repos` are named Docker volumes, not host bind mounts, for Windows compatibility. To migrate existing data from bind-mounted `./codemie-storage` or `./codemie-repos` directories, copy it into the named volumes once before starting the stack:

```bash
docker run --rm -v ./codemie-storage:/src -v codemie_storage:/dst docker.io/library/alpine:latest sh -c "cp -a /src/. /dst/"
docker run --rm -v ./codemie-repos:/src -v codemie_repos:/dst docker.io/library/alpine:latest sh -c "cp -a /src/. /dst/"
```

:::

## Step 4: Verify the Deployment

Check container health and startup logs:

```bash
docker compose -f standalone/docker-compose.standalone.yml logs -f codemie
```

Confirm retrieval-dependent startup paths were skipped (expected on a fresh database):

```
Skipping retrieval contexts for preconfigured assistant '<slug>': RETRIEVAL_BACKEND=none
```

Check application health and AI provider readiness:

```bash
curl http://localhost:8080/v1/healthcheck
```

The response includes a `model_provider` field reporting whether a supported provider (Azure OpenAI or AWS Bedrock) was detected at startup:

```json
{
  "status": "healthy",
  "model_provider": {
    "status": "configured",
    "provider": "azure",
    "missing": []
  }
}
```

`status` is one of `configured`, `not_configured`, or `not_checked`. This check is informational only — it does not block startup or route requests to the provider.

Confirm which retrieval-dependent features are disabled by checking the runtime config endpoint:

```bash
curl http://localhost:8080/v1/config
```

`features:knowledgeBases`, `features:datasources`, and `features:codeIndexing` should each report `enabled: false`.

## Feature Availability

With `RETRIEVAL_BACKEND=none`, the following capabilities are disabled or degraded platform-wide:

| Area                                | Behavior when disabled                                                                                                    |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Data Sources / Knowledge Bases      | UI navigation, routes, and API endpoints for creating and managing data sources are unavailable.                          |
| LLM/Embedding Providers admin pages | Hidden in Settings → Administration (gated by the same flags as Data Sources).                                            |
| Assistant context selector          | The "Data Sources" option is removed from assistant context configuration; only supporting agents remain.                 |
| Integrations                        | The `datasource` resource type is not selectable when configuring integration credentials.                                |
| Code context & knowledge base tools | Tool calls that require indexed content return an error indicating the capability is unavailable.                         |
| Preconfigured assistant contexts    | Retrieval contexts are skipped when creating built-in assistants; no Elasticsearch index-creation calls occur at startup. |
| Datasource background jobs          | Reindexing and stale-datasource jobs no-op rather than running against an unreachable backend.                            |
| Workflow code-index search          | Workflow steps that query indexed code raise an error instead of returning results.                                       |
| Admin Log Lookup (`POST /v1/logs`)  | Returns `503` unless separately re-enabled — the endpoint queries Elasticsearch directly.                                 |

:::note Analytics gating is separate
The Analytics dashboard's Insights and CLI Insights tabs, and custom dashboard management, are gated by the `codemie-enterprise` package being installed, not by `RETRIEVAL_BACKEND`. In Community Edition (no `codemie-enterprise` package) these are unavailable regardless of retrieval backend. See [Customer Feature Configuration](../../configuration/codemie/customer-feature-configuration.md#read-only-runtime-fields).
:::

## Rebuilding After Source Changes

Re-run the build script to pick up local source changes, then restart the stack:

```bash
standalone/build-image.sh --image-tag localhost/codemie:local --no-cache
docker compose -f standalone/docker-compose.standalone.yml up -d --force-recreate codemie
```

`--no-cache` forces a full rebuild, bypassing the build cache.

## Troubleshooting

**Build fails with a missing packaging asset error** — the build script requires `Dockerfile`, `docker/entrypoint.sh`, and `docker/nginx.conf` to be present under `standalone/` in the backend repository (`--backend-root`). Verify the `codemie` repository checkout is complete.

**Container fails to start with an Elasticsearch connection error** — confirm `RETRIEVAL_BACKEND=none` is set in `.env.standalone` and that the file is correctly referenced by `env_file` in the compose file. With this flag set, preconfigured assistant creation skips retrieval contexts entirely and does not attempt to reach Elasticsearch.

**`model_provider.status` reports `not_configured`** — verify the credentials for the selected `MODELS_ENV` block (Azure OpenAI or AWS Bedrock) are present in `.env.standalone`. Full parameter reference: [AI Providers Configuration](../../configuration/codemie/api-configuration.md#ai-providers-configuration).

## Related Documentation

- [API Configuration](../../configuration/codemie/api-configuration.md) — full environment variable reference
- [Customer Feature Configuration](../../configuration/codemie/customer-feature-configuration.md) — read-only runtime feature fields
- [Data Processing & Storage Architecture](../../security/data-processing-storage.md) — platform data flow, including retrieval-backend-dependent paths
