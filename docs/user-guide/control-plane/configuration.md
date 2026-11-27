---
id: configuration
title: Control Plane Configuration Reference
sidebar_label: Configuration
sidebar_position: 4
pagination_prev: user-guide/control-plane/control-plane
pagination_next: null
---

# Control Plane Configuration Reference

This document lists the configuration parameters of the Control Plane.

## Server

| Parameter  | Type    | Default                          | Description                                                                              |
| ---------- | ------- | -------------------------------- | ---------------------------------------------------------------------------------------- |
| `HOST`     | string  | `"0.0.0.0"` (container image)    | Address the server listens on. Outside the container image the default is `"127.0.0.1"`. |
| `PORT`     | integer | `4411`                           | Port of the UI and the API.                                                              |
| `NODE_ENV` | string  | `"production"` (container image) | `production` serves the built UI together with the API.                                  |

## Installation and Storage

| Parameter                | Type   | Default                                          | Description                                                                                                                                                      |
| ------------------------ | ------ | ------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CONTROL_PLANE_CONFIG`   | string | `"/app/config/epam"` (container image)           | Configuration folder of the installation: clients, projects, sources and defaults. Empty: an empty installation is created in `config/local` on the first start. |
| `CONTROL_PLANE_DB`       | string | `"/app/data/control-plane.db"` (container image) | SQLite database with the harvested data. A database belongs to the installation that first wrote to it.                                                          |
| `CP_APP_DB`              | string | Folder of `CONTROL_PLANE_DB`                     | SQLite database with the application state, such as the feature switches saved in **Settings → Features**.                                                       |
| `CONTROL_PLANE_JOBS_DIR` | string | `".work/jobs"`                                   | Folder with the harvest and transform jobs: their state and logs.                                                                                                |

## Authentication and Access

By default, the Control Plane expects to run behind an OAuth2 proxy and reads the signed-in user from
the headers the proxy forwards. With authentication on, set `CP_ADMIN_ROLES`, `CP_CODEMIE_API_URL` or
both; otherwise the server does not start.

| Parameter             | Type    | Default                | Description                                                                                                                                                                   |
| --------------------- | ------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CP_AUTH_DISABLED`    | boolean | `false`                | `true` turns off sign-in: every caller has full access. Use only on a host that nobody else can reach.                                                                        |
| `CP_OPS_ALLOW_REMOTE` | string  | `""`                   | `1` allows configuration changes and harvests from a non-loopback address while authentication is off. Required in a container with `CP_AUTH_DISABLED=true`.                  |
| `CP_ADMIN_ROLES`      | string  | `""`                   | Comma-separated token roles that make a user an administrator, for example `admin`.                                                                                           |
| `CP_ROLE_CLAIM`       | string  | `"realm_access.roles"` | Token claim that holds the roles checked against `CP_ADMIN_ROLES`.                                                                                                            |
| `CP_CODEMIE_API_URL`  | string  | `""`                   | CodeMie API URL. When set, CodeMie decides who is an administrator (while `CP_ADMIN_ROLES` is empty), auditor or project administrator, and CodeMie becomes the LLM provider. |

## Data Sources

| Parameter                    | Type   | Default | Description                                                                                                                                                                 |
| ---------------------------- | ------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `JIRA_TOKEN`                 | string | `""`    | Jira personal access token. For Jira Cloud, an API token.                                                                                                                   |
| `JIRA_EMAIL`                 | string | `""`    | Jira Cloud (`*.atlassian.net`) only: the account email that owns the API token.                                                                                             |
| `GITLAB_TOKEN_<HOST>`        | string | `""`    | GitLab token for one host. The host is upper-cased and every other character than a letter or digit becomes `_`: `gitlab.example.com` is `GITLAB_TOKEN_GITLAB_EXAMPLE_COM`. |
| `GH_TOKEN`                   | string | `""`    | GitHub token. `GITHUB_TOKEN` is also accepted.                                                                                                                              |
| `SONAR_TOKEN`                | string | `""`    | SonarQube user token, for code quality figures. A SonarQube source can name another variable.                                                                               |
| `CODEMIE_ANALYTICS_PG_URL`   | string | `""`    | Read-only connection string to the CodeMie analytics database, for example `postgresql://<role>@<host>:5432/<db>`. Needed only to read CLI sessions from CodeMie.           |
| `CP_CODEMIE_TOKEN_<PROJECT>` | string | `""`    | CodeMie service account token for scheduled harvests of one project. The project ID is converted like the GitLab host: `epm-cdme` is `CP_CODEMIE_TOKEN_EPM_CDME`.           |

## LLM Provider

An LLM is optional. It is used by the Chat page and by AI matching, which links AI sessions to
tickets and merge requests.

| Parameter         | Type   | Default                       | Description                                                                                                                                |
| ----------------- | ------ | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `LLM_PROVIDER`    | string | `""`                          | `codemie`, `litellm` or `openai`. Empty: chosen automatically, in this order: `CP_CODEMIE_API_URL`, then `LITELLM_URL`, then `OPENAI_KEY`. |
| `LLM_CHAT_MODEL`  | string | `""`                          | Model for the Chat page. Empty: Chat is off, except on CodeMie, where the user's default model is used.                                    |
| `LLM_MATCH_MODEL` | string | `""`                          | Model for AI matching. Empty: AI matching with a model is off, except on CodeMie, where the CodeMie default model is used.                 |
| `LLM_CHECK_MODEL` | string | `""`                          | Model that checks the AI matching answers. Empty: the check is off, except on CodeMie, where a model of another family is used.            |
| `LITELLM_URL`     | string | `""`                          | LiteLLM proxy URL. Also used to load model prices from the proxy.                                                                          |
| `LITELLM_KEY`     | string | `""`                          | LiteLLM proxy key.                                                                                                                         |
| `OPENAI_KEY`      | string | `""`                          | OpenAI API key.                                                                                                                            |
| `OPENAI_BASE_URL` | string | `"https://api.openai.com/v1"` | OpenAI-compatible API URL.                                                                                                                 |

## Chat

| Parameter                         | Type    | Default  | Description                                                             |
| --------------------------------- | ------- | -------- | ----------------------------------------------------------------------- |
| `CP_CHAT_TIMEOUT_MS`              | integer | `120000` | Max milliseconds one Chat answer can take.                              |
| `CP_CHAT_HEARTBEAT_MS`            | integer | `15000`  | Interval of keep-alive messages, so a proxy does not cut a long answer. |
| `CP_CHAT_MAX_CONCURRENT`          | integer | `4`      | Max Chat answers in progress at once.                                   |
| `CP_CHAT_MAX_CONCURRENT_PER_USER` | integer | `2`      | Max Chat answers in progress at once for one user.                      |

## Feature Flags

Every feature is on by default. A feature can also be turned off in **Settings → Features**. A value
set in the environment wins and cannot be changed in the UI: `true` turns the feature on, any other
value turns it off.

| Parameter                     | Type    | Default | Description                                                                  |
| ----------------------------- | ------- | ------- | ---------------------------------------------------------------------------- |
| `FEATURE_CHAT`                | boolean | on      | The Chat page.                                                               |
| `FEATURE_AI_MATCH`            | boolean | on      | AI matching in a harvest.                                                    |
| `FEATURE_SCHEDULES`           | boolean | on      | Scheduled harvests.                                                          |
| `FEATURE_CODEMIE_IMPORT`      | boolean | on      | Importing clients, projects and people from CodeMie.                         |
| `FEATURE_DELIVERY_MANAGEMENT` | boolean | on      | Reading sprints from Jira for projects that fill their iterations from them. |

## Harvest

| Parameter            | Type    | Default | Description                                                         |
| -------------------- | ------- | ------- | ------------------------------------------------------------------- |
| `CP_HARVEST_WORKERS` | integer | `8`     | Parallel requests per source during a harvest.                      |
| `CP_DEBUG`           | string  | `""`    | Any value: a failing source prints its full error trace to the log. |
