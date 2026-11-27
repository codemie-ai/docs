---
id: on-dedicated-vdi
title: Control Plane on Dedicated VDI
sidebar_label: On Dedicated VDI
sidebar_position: 3
pagination_prev: user-guide/control-plane/control-plane
pagination_next: null
---

# Control Plane on Dedicated VDI

This guide covers getting the Control Plane image, configuring it, and starting the Control Plane
with Docker Compose on a dedicated VDI or workstation, with no new server. In this mode the
Control Plane reads CodeMie CLI session export files, the issue tracker and Git, and keeps all data
in local folders.

## Overview

Running the Control Plane on a dedicated VDI takes four steps:

1. Check the [prerequisites](#prerequisites).
2. [Get the image](#getting-the-image).
3. [Get the Compose file](#getting-the-compose-file) and fill in the tokens.
4. [Start the stack](#starting-the-stack) and open the Control Plane at `http://127.0.0.1:4411`.

## Prerequisites

- **Docker** with Docker Compose v2
- Read-only tokens for the issue tracker (Jira) and Git (GitLab, GitHub)
- Access to the [control-plane](https://ext.git.epam.com/epm-cdme/control-plane) repository

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
[Getting the Compose File](#getting-the-compose-file).

## Getting the Compose File

The Compose file is stored in the
[control-plane](https://ext.git.epam.com/epm-cdme/control-plane) repository, in the
[control-plane-vdi](https://ext.git.epam.com/epm-cdme/control-plane/-/blob/main/control-plane-vdi/docker-compose.yml)
folder. Clone the repository, go to the folder and create the folders for the data:

```bash
git clone git@ext.git.epam.com:epm-cdme/control-plane.git
cd control-plane/control-plane-vdi
mkdir -p config data work exports
```

The folder of the stack looks as follows:

```text
control-plane-vdi/
├── docker-compose.yml
├── config/       # clients, projects, streams, members and sources (YAML)
├── data/         # harvested data and application state (SQLite)
├── work/         # harvest cache, job logs and uploaded files
└── exports/      # CodeMie CLI session export files
```

## Configuring the Environment

Fill in the tokens in the `environment` section of `docker-compose.yml` and remove the lines of the
sources that are not used. For the description of all variables, see
[Control Plane Configuration Reference](./configuration.md).

:::info Authentication
The Control Plane on a dedicated VDI runs without sign-in (`CP_AUTH_DISABLED=true`): every user who reaches the
port has full access. The port is published on `127.0.0.1` only, so the UI is available on the host
itself. Do not publish it on other addresses.
:::

:::warning
`docker-compose.yml` holds the tokens. Restrict access to it and do not commit it back to the
repository.
:::

## Starting the Stack

Run the following command from the `control-plane-vdi` folder:

```bash
docker compose up -d
```

Once the `control-plane` container reports healthy, open the Control Plane at
`http://127.0.0.1:4411`. The first start opens an empty installation: add a client, its projects,
streams and members, and their sources in **Settings → Clients**.

### Managing the Stack

Run the commands from the `control-plane-vdi` folder:

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
