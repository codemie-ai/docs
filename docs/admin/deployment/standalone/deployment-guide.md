---
id: deployment-guide
title: CodeMie Standalone Deployment Guide
sidebar_label: Deployment Guide
sidebar_position: 2
pagination_prev: admin/deployment/standalone/overview
pagination_next: null
---

# CodeMie Standalone Deployment Guide

This guide covers running a published standalone image, configuring the environment, and starting
the CodeMie Standalone stack with Docker Compose. It also explains how contributors can build the
same image directly from the `codemie` and `codemie-ui` source repositories.

## Runtime Prerequisites

- **Docker Compose** or **Podman Compose**
- The version-matched standalone deployment files supplied with the release, or the same files
  from the corresponding `codemie` repository tag. Keep their relative directory layout intact:
  the Compose file mounts the ClickHouse schema and OpenTelemetry Collector configuration from
  `config/` when the optional Analytics profile is used.

## Using a Published Image

Use the image tag and standalone deployment files from the same CodeMie release. Do not combine a
Compose file or configuration files from one release with an image from another release.

Set `CODEMIE_IMAGE` to the exact published image tag supplied with the release:

```bash
export CODEMIE_IMAGE=<image-tag-from-the-release>
```

`CODEMIE_IMAGE` is evaluated by Compose and is separate from the container variables stored in
`standalone/.env.standalone`. Continue with [Configuring the Environment](#configuring-the-environment)
and [Starting the Stack](#starting-the-stack); no backend or frontend source checkout is required
to run a published image.

## Building from Source

Building the image locally additionally requires:

- **Docker** with BuildKit enabled (required for named build-context support), or **Podman**
- **Bash**
- **Git**
- Local checkouts of both repositories:
  - `codemie` — backend repository; the packaging assets described in this guide live under
    `standalone/` in this repository
  - `codemie-ui` — frontend repository

The default paths assume a sibling layout:

```
parent/
├── codemie/        # backend repository (this guide runs commands from here)
└── codemie-ui/      # frontend repository
```

Explicit `--backend-root`/`--frontend-root` arguments can point anywhere if the sibling layout is
not used.

The standalone image bundles the frontend, backend, and nginx into a single image. `--image-tag`
is the only required argument.

**Minimal** — both repository paths default from the sibling layout above:

```bash
standalone/build-image.sh --image-tag localhost/codemie:local
```

**Explicit paths** — used when the two repositories are not siblings:

```bash
standalone/build-image.sh \
  --image-tag     localhost/codemie:local \
  --backend-root  /path/to/codemie \
  --frontend-root /path/to/codemie-ui
```

**Force a full rebuild, bypassing the build cache:**

```bash
standalone/build-image.sh --image-tag localhost/codemie:local --no-cache
```

**Use Podman instead of Docker** (the default engine is `docker`):

```bash
standalone/build-image.sh --image-tag localhost/codemie:local --engine podman
```

### What the Build Script Does

1. Validates that all required source files exist before invoking the builder.
2. Verifies the chosen engine is installed and its daemon is reachable.
3. Prints and logs the git branch, SHA, and dirty status for both the backend and frontend
   repositories.
4. Runs the engine's `build` command with the backend repository as the main build context and
   the frontend repository passed as the named build context `frontend`. The Dockerfile copies
   only the specific files needed for the production frontend build — never a `.git` directory or
   other VCS metadata from either source repository.
5. Writes a timestamped log to `standalone/build-<timestamp>.log`.
6. Exits with the engine's exact build exit code.

:::info Open file limit
The build uses `--ulimit nofile=65536:65536` to avoid environment-dependent open-file limits
during the Vite/Tailwind frontend build step, which reads many source files concurrently.
:::

## Configuring the Environment

Copy the example environment file and fill in real values:

```bash
cp standalone/.env.standalone.example standalone/.env.standalone
```

`standalone/.env.standalone` is read by `docker-compose.standalone.yml` via `env_file`. At
minimum, configure:

| Variable                                   | Default                         | Description                                                                                                                                                        |
| ------------------------------------------ | ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `RETRIEVAL_BACKEND`                        | `none`                          | `elasticsearch` \| `none`. When `none`, Knowledge Bases, Data Sources, and code indexing are disabled — no Elasticsearch container is part of the standalone stack |
| `ADMIN_LOG_LOOKUP_ENABLED`                 | `false`                         | Must be `false` when `RETRIEVAL_BACKEND=none` — the admin log lookup endpoint depends on the same backend and returns HTTP 503 if enabled without it               |
| `ENABLE_USER_MANAGEMENT`                   | `true`                          | Enables local user self-management in the built-in auth provider                                                                                                   |
| `MODELS_ENV`                               | `azure`                         | Selects the LLM provider profile; set exactly one provider block (Azure OpenAI or AWS Bedrock)                                                                     |
| `SUPERADMIN_EMAIL` / `SUPERADMIN_PASSWORD` | `admin@codemie.ai` / `password` | Seeded local superadmin credentials — change before any shared or long-lived deployment                                                                            |

CodeMie Standalone authenticates with the platform's **built-in local provider**
(`IDP_PROVIDER=local`, set inside the image) rather than an external identity provider such as
Keycloak — there is no Keycloak container in the standalone stack.

:::tip At least one LLM provider is required
Configure exactly one of the two LLM provider blocks in `.env.standalone` — Azure OpenAI
(`AZURE_OPENAI_API_KEY`, `AZURE_OPENAI_URL`, `OPENAI_API_VERSION`) or AWS Bedrock
(`AWS_BEDROCK_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`), matching the chosen
`MODELS_ENV`. See [API Configuration Reference](../../configuration/codemie/api-configuration.md)
for the full parameter reference.
:::

### External Customer Configuration

CodeMie reads customer configuration from `/app/backend/config/customer/customer-config.yaml`
inside the image. By default this file is bundled at build time. A directory containing an
external YAML file can be mounted to override it without rebuilding the image.

The `codemie` service always mounts a host directory read-only at `/app/external-config`
(`CODEMIE_EXTERNAL_CONFIG_DIR`, default `standalone/external-config`). At startup, the entrypoint
looks for `customer-config.yaml` inside that directory:

- If it exists, it **fully replaces** the bundled config.
- If it does not exist, startup continues with the config bundled in the image.

There is no minimal example file — always start from the canonical, version-matched
`config/customer/customer-config.yaml` supplied with the deployment files or obtained from the
matching `codemie` repository tag. It declares every feature ID, component, and default value for
the exact image in use; mounting anything less than the full file disables every component it
omits.

To use an external configuration:

```bash
cp config/customer/customer-config.yaml standalone/external-config/customer-config.yaml
# edit standalone/external-config/customer-config.yaml, keeping every section and feature ID
docker compose -f standalone/docker-compose.standalone.yml up -d
```

To keep the external directory elsewhere, set `CODEMIE_EXTERNAL_CONFIG_DIR` to an absolute path
before running Compose; the file inside it must still be named `customer-config.yaml`:

```bash
export CODEMIE_EXTERNAL_CONFIG_DIR=/path/to/config-dir
```

:::warning Full replacement, no merge
When an external `customer-config.yaml` is found, it completely replaces the bundled file — there
is no merge, overlay, or cascading of defaults. Every section and value must be present in the
external YAML, or the corresponding component is disabled.
:::

Other behavior to note:

- The mount is read-only (`:ro`) — the container cannot modify the directory or its contents.
- No image rebuild is required — place the file in the mounted directory and restart or recreate
  the container.
- Changes to the YAML require a restart or recreate of the `codemie` container to take effect.
- Removing the external file and restarting falls back cleanly to the bundled config: the
  entrypoint always resets `customer-config.yaml` from a pristine image-bundled copy before
  re-checking for the external file on every start.

### Disabling Budget Management

The `features:budgetManagement` component requires LiteLLM, which is not included in the
standalone stack. Leaving it enabled exposes Budget Management controls in the UI even though the
corresponding LiteLLM-backed admin endpoints are unavailable. Disable it for standalone
deployments using one of:

- With an external customer configuration, set `features:budgetManagement` to `enabled: false` in
  the mounted YAML.
- With the bundled customer configuration, add `FEATURE_BUDGET_MANAGEMENT=false` to
  `standalone/.env.standalone`. The generic `FEATURE_<ID>` override mechanism takes precedence
  over the mounted YAML, so the same override also works with an external configuration.

Restart or recreate the `codemie` container after changing either setting. No image rebuild is
required.

## Starting the Stack

```bash
docker compose -f standalone/docker-compose.standalone.yml up -d
# or, with Podman:
podman compose -f standalone/docker-compose.standalone.yml up -d
```

The Compose file only references an image tag — it never builds it. For a published release,
`CODEMIE_IMAGE` must contain the exact image tag supplied with that release. For a local
build-from-source workflow, leave it unset to use `localhost/codemie:local`, the default tag used
in the examples above.

Once the `codemie` container reports healthy, open CodeMie at `http://localhost:8080`.

Other useful commands:

```bash
# Status
docker compose -f standalone/docker-compose.standalone.yml ps

# Follow logs
docker compose -f standalone/docker-compose.standalone.yml logs -f

# Stop and remove containers
docker compose -f standalone/docker-compose.standalone.yml down
```

(swap `docker` for `podman` as needed).

:::info Windows bind-mount migration
`codemie-storage` and `codemie-repos` are Docker named volumes rather than host bind mounts, for
Windows compatibility. If data exists in a prior `./codemie-storage` or `./codemie-repos` host
directory, migrate it once before running `docker compose up`:

```bash
docker run --rm -v ./codemie-storage:/src -v codemie_storage:/dst docker.io/library/alpine:latest sh -c "cp -a /src/. /dst/"
docker run --rm -v ./codemie-repos:/src -v codemie_repos:/dst docker.io/library/alpine:latest sh -c "cp -a /src/. /dst/"
```

:::

## Optional: CLI Analytics

ClickHouse and an OpenTelemetry Collector live in the same `docker-compose.standalone.yml`, gated
behind the `standalone-analytics` Compose profile — running the standalone stack without this
profile does not start them.

To enable CLI Analytics:

1. CLI Analytics is gated by `features:cliAnalytics` in the customer configuration, not by a
   dedicated environment variable. Using an [external customer configuration](#external-customer-configuration),
   set that component's `enabled` to `true`. The generic `FEATURE_<ID>` override mechanism still
   applies to every `features:*` component, including this one — if `FEATURE_CLI_ANALYTICS` is
   set in the environment, it overrides whatever the mounted YAML says. Unset it if CLI Analytics
   does not behave as configured.
2. `standalone/.env.standalone` must set `CLICKHOUSE_HOST`, `CLICKHOUSE_PORT`, `CLICKHOUSE_USER`,
   `CLICKHOUSE_PASSWORD`, and `ANALYTICS_INGEST_OTLP_HTTP_ENDPOINT` to match the hardcoded service
   names in `docker-compose.standalone.yml`. `.env.standalone.example` already sets these to
   matching values — keep them as-is unless the hardcoded names or ports in the Compose file were
   changed. The backend's built-in defaults point elsewhere and fail to connect if left unset.
3. Start the stack with the `standalone-analytics` profile:

   ```bash
   docker compose -f standalone/docker-compose.standalone.yml --profile standalone-analytics up -d
   ```

   If the default stack is already running, this command reconciles it in place — `clickhouse`
   and `otelcollector` are added while `codemie` and `postgres` keep running.

4. Verify the analytics services are running:

   ```bash
   docker compose -f standalone/docker-compose.standalone.yml --profile standalone-analytics ps
   curl http://localhost:8123/ping
   ```

5. To stop only the analytics services, leaving `codemie` and `postgres` running:

   ```bash
   docker compose -f standalone/docker-compose.standalone.yml --profile standalone-analytics stop clickhouse otelcollector
   ```

   To stop everything, including the analytics services, add the profile flag to `down`:

   ```bash
   docker compose -f standalone/docker-compose.standalone.yml --profile standalone-analytics down
   ```

   A plain `down` without `--profile standalone-analytics` leaves `clickhouse` and
   `otelcollector` running, since Compose only tears down services from profiles it was told
   about.

The Analytics navigation item is available to every authenticated user. The CLI Analytics tab is
displayed only to system administrators and project administrators when `features:cliAnalytics`
is enabled. Other Analytics tabs retain their existing role and feature-flag visibility rules.

## Generated Files

The following files are created locally and are not tracked in the `codemie` repository:

| Path                                              | Contents                                                              |
| ------------------------------------------------- | --------------------------------------------------------------------- |
| `standalone/build-*.log`                          | Per-run timestamped build log                                         |
| `standalone/.env.standalone`                      | Local environment configuration (copy of the example, filled in)      |
| `standalone/external-config/customer-config.yaml` | Local full customer configuration mounted into `/app/external-config` |

## See Also

- [Standalone Overview](./overview.md)
- [API Configuration Reference](../../configuration/codemie/api-configuration.md)
- [CodeMie Customer Feature Configuration](../../configuration/codemie/customer-feature-configuration.md)
- [Data Sources Configuration](../../configuration/codemie/datasources-configuration.md)
