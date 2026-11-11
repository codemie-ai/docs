---
id: standalone
title: Running Control Plane Standalone
sidebar_label: Standalone
sidebar_position: 3
pagination_prev: user-guide/control-plane/control-plane
pagination_next: null
---

# Running Control Plane Standalone

This guide covers getting the Control Plane image, configuring it, and starting Control Plane
Standalone with Docker Compose on a single host, such as a VDI or a workstation. In this mode the
Control Plane reads CodeMie CLI session export files, the issue tracker and Git, and keeps all data
in local folders.

## Overview

Running Control Plane Standalone takes four steps:

1. Check the [prerequisites](#prerequisites).
2. [Get the image](#getting-the-image).
3. [Create the Compose file](#creating-the-compose-file) and fill in the tokens.
4. [Start the stack](#starting-the-stack) and open the Control Plane at `http://127.0.0.1:4411`.

## Prerequisites

- **Docker** with Docker Compose v2
- Read-only tokens for the issue tracker (Jira) and Git (GitLab, GitHub)
- The [CodeMie CLI](../codemie-cli/index.md) on every engineer's machine, to export sessions

## Getting the Image

The Control Plane image is available on request.

1. Optionally pre-pull the image (Compose pulls it automatically on first start):

   ```bash
   docker pull <registry>/control-plane:<version>
   ```

2. Set `CONTROL_PLANE_IMAGE` to the exact image tag:

   ```bash
   export CONTROL_PLANE_IMAGE=<registry>/control-plane:<version>
   ```

`CONTROL_PLANE_IMAGE` is evaluated by Compose and is not passed to the container. Continue with
[Creating the Compose File](#creating-the-compose-file).

## Creating the Compose File

Create a folder for the stack with `docker-compose.yml` and the folders for the data:

```text
control-plane-standalone/
├── docker-compose.yml
├── config/       # clients, projects, streams, members and sources (YAML)
├── data/         # harvested data and application state (SQLite)
├── work/         # harvest cache, job logs and uploaded files
└── exports/      # CodeMie CLI session export files
```

```bash
mkdir -p control-plane-standalone/{config,data,work,exports}
touch control-plane-standalone/docker-compose.yml
```

```yaml title="control-plane-standalone/docker-compose.yml"
name: control-plane

services:
  init-volumes:
    image: busybox:1.38
    user: '0:0'
    command: ['sh', '-c', 'chown -R 1000:1000 /app/config/local /app/data /app/.work']
    volumes:
      - ./config:/app/config/local
      - ./data:/app/data
      - ./work:/app/.work
    restart: 'no'

  control-plane:
    image: ${CONTROL_PLANE_IMAGE:?set CONTROL_PLANE_IMAGE}
    depends_on:
      init-volumes:
        condition: service_completed_successfully
    environment:
      CONTROL_PLANE_CONFIG: ''
      CP_AUTH_DISABLED: 'true'
      CP_OPS_ALLOW_REMOTE: '1'

      JIRA_TOKEN: ''
      JIRA_EMAIL: ''
      GITLAB_TOKEN_GITLAB_EXAMPLE_COM: ''
      GH_TOKEN: ''
    ports:
      - '127.0.0.1:4411:4411'
    volumes:
      - ./config:/app/config/local
      - ./data:/app/data
      - ./work:/app/.work
      - ./exports:/exports:ro
    healthcheck:
      test:
        [
          'CMD',
          'node',
          '-e',
          "fetch('http://127.0.0.1:4411/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))",
        ]
      interval: 15s
      timeout: 5s
      retries: 5
      start_period: 30s
    restart: unless-stopped
```

## Configuring the Environment

Fill in the values in the `environment` section. Remove the lines of the sources that are not used.

| Variable               | Default | Description                                                                                                       |
| ---------------------- | ------- | ----------------------------------------------------------------------------------------------------------------- |
| `JIRA_TOKEN`           | `""`    | Jira personal access token. For Jira Cloud, an API token.                                                         |
| `JIRA_EMAIL`           | `""`    | Jira Cloud only: the account email that owns the API token.                                                       |
| `GITLAB_TOKEN_<HOST>`  | `""`    | GitLab token for one host: `gitlab.example.com` becomes `GITLAB_TOKEN_GITLAB_EXAMPLE_COM`. Add one line per host. |
| `GH_TOKEN`             | `""`    | GitHub token.                                                                                                     |
| `CONTROL_PLANE_CONFIG` | `""`    | Must stay empty: the Control Plane creates an empty installation in the `config` folder on the first start.       |

The other variables of the Compose file do not need changes. For the full parameter reference, see
[Control Plane Configuration Reference](./configuration.md).

:::info Authentication
Control Plane Standalone runs without sign-in (`CP_AUTH_DISABLED=true`): every user who reaches the
port has full access. The port is published on `127.0.0.1` only, so the UI is available on the host
itself. Do not publish it on other addresses.
:::

:::warning
`docker-compose.yml` holds the tokens. Restrict access to it and do not commit it to a repository.
:::

## Starting the Stack

```bash
cd control-plane-standalone
docker compose up -d
```

Once the `control-plane` container reports healthy, open the Control Plane at
`http://127.0.0.1:4411`. The first start opens an empty installation: add a client, its projects,
streams and members, and their sources in **Settings → Clients**.

### Managing the Stack

Run the commands from the `control-plane-standalone` folder:

| Task                       | Command                                |
| -------------------------- | -------------------------------------- |
| Check status               | `docker compose ps`                    |
| Follow logs                | `docker compose logs -f control-plane` |
| Apply changes              | `docker compose up -d`                 |
| Stop and remove containers | `docker compose down`                  |

:::info Data
`docker compose down` keeps the data, and the next start uses it again:

| Location   | Path in the container | Contents                                               |
| ---------- | --------------------- | ------------------------------------------------------ |
| `./config` | `/app/config/local`   | Clients, projects, streams, members and sources (YAML) |
| `./data`   | `/app/data`           | Harvested data and application state (SQLite)          |
| `./work`   | `/app/.work`          | Harvest cache, job logs and uploaded files             |

Deleting `./work` keeps the configuration and the harvested data, but removes the uploaded files and
the job logs. The next harvest fetches all data from the sources again.
:::

:::tip Copying the data
Files in `./config`, `./data` and `./work` can be opened, edited or copied on the host. Stop the
stack with `docker compose down` before copying `./data`: SQLite keeps recent changes in extra
`-wal` and `-shm` files until it closes the database. Do not place `./data` in a folder synced by OneDrive or
SharePoint.
:::

## See Also

- [Control Plane Overview](./index.mdx)
- [Control Plane Configuration Reference](./configuration.md)
- [CodeMie CLI](../codemie-cli/index.md)
