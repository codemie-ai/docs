---
id: project-code-config
title: Project Claude Code Configuration
sidebar_label: Project Code Config
sidebar_position: 4
description: Centrally managed Claude Code settings.json per CodeMie project, automatically synced to the local CLI.
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Project Claude Code Configuration

<EnterpriseFeature />

## Overview

Project Claude Code Configuration lets project administrators store the
Claude Code `settings.json` body centrally on the CodeMie backend and
have the CodeMie CLI apply it automatically to `~/.claude/settings.json`
before each chat invocation.

The feature is intended for teams that need consistent permission modes,
hooks, and other Claude Code settings across all developers working on a
project, without relying on each developer to keep their local file in
sync manually.

## How it works

1. A project administrator opens the project page in the CodeMie UI and
   enables **Claude Code Configuration**, then edits the JSON body.
2. The backend stores every successful change as a new revision and
   keeps an audit log of all access attempts (allowed and denied).
3. When a developer runs `codemie chat --project <name>`, the CLI
   fetches the active server-side configuration and merges it on top of
   the local `~/.claude/settings.json`. Server-managed keys win on
   conflict; user-side keys (e.g. a personal `statusLine`) survive the
   merge.
4. While Claude Code is running, the agent layer periodically POSTs the
   local hash to `/v1/admin/projects/{name}/code-config/verify`. If the
   server-side configuration has changed mid-session, the verify call
   returns HTTP 409 with structured `CODE_CONFIG_HASH_MISMATCH` details
   and the CLI surfaces a "restart required" message.

## CLI usage

The chat command exposes two new flags:

```bash
# Sync the project configuration before chatting
codemie chat --project my-project <assistantId> "<message>"

# Skip the pre-run sync (useful when working offline or debugging)
codemie chat --project my-project --skip-config-sync <assistantId> "<message>"
```

When `--project` is omitted, the project name is taken from the active
profile (`codeMieProject` in the configuration). If neither is present,
the sync is silently skipped.

### What gets written

The CLI writes the merged configuration to `~/.claude/settings.json`
atomically (temp file + `rename`) so a crash mid-write cannot leave the
file half-flushed. The file is written even when its content has not
changed so that the modification timestamp reflects the last sync.

### Drift detection and recovery

If the server-side configuration changes while a Claude Code session is
running, the next verify call returns HTTP 409. The CLI prints:

```
Project Claude Code config changed on the server (version 7).
Restart 'codemie chat --project <name>' to pull the latest version.
```

The session is **not** terminated automatically — the operator decides
when to restart. Until restart, Claude Code continues using the
previously synced configuration.

### Disabling the feature for a project

When a project administrator disables the feature in the UI, the backend
stores the empty configuration sentinel (`EMPTY_CONFIG_HASH`) and stops
writing to `~/.claude/settings.json` on subsequent CLI runs. Pre-existing
local content is left in place.

## Hash protocol

The CLI and backend agree on a canonical JSON serialization (sorted
keys, compact separators, UTF-8 preserved) and a SHA-256 of the
canonical bytes. The full specification with golden vectors is in
[code-config-hash.md](https://github.com/epam/codemie/blob/main/docs/specs/code-config-hash.md).

## Permissions

| Action                              | Required role                       |
| ----------------------------------- | ----------------------------------- |
| View configuration / hash / version | Any project member with read access |
| View revisions and audit log        | Project administrator               |
| Edit / enable / disable / rollback  | Project administrator               |
| Verify hash (`/verify` endpoint)    | Any project member with read access |

All denied attempts are recorded in the audit log with the requester's
IP and user agent.
