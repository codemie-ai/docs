---
id: codemie-claude
title: Claude with CodeMie
sidebar_label: Claude
sidebar_position: 1
description: Run Claude Code through CodeMie CLI with codemie-claude and connect Claude Desktop to the CodeMie gateway, including model selection, assistants, skills, and MCP servers.
pagination_prev: user-guide/codemie-cli/codemie-cli
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Claude with CodeMie

<EnterpriseFeature />

CodeMie CLI runs Claude Code and Claude Desktop on top of the CodeMie platform. Requests go through
the CodeMie gateway, so SSO authentication, budgets, analytics, and the organization's LLM
providers apply, and no Anthropic subscription is required.

| Client         | How it is started                                              | Details                               |
| -------------- | -------------------------------------------------------------- | ------------------------------------- |
| Claude Code    | `codemie-claude` command from CodeMie CLI                      | This page and the pages listed below  |
| Claude Desktop | `codemie proxy connect --claude-desktop`, a local proxy daemon | [Claude Desktop](./claude-desktop.md) |

## Quick Start

```bash
# 1. Sign in and configure the profile
codemie setup

# 2. Install Claude Code
codemie install claude --supported

# 3. Start Claude Code with CodeMie
codemie-claude
```

For CodeMie CLI installation and the setup wizard, see [CodeMie CLI](../index.md#installation).

## Running codemie-claude

`codemie-claude` starts Claude Code with the active CodeMie profile.

```bash
codemie-claude                          # Interactive mode
codemie-claude --task "<prompt>"        # Single task mode: runs the prompt and exits
codemie-claude --profile <name>         # Use a specific profile
codemie-claude --model <model>          # Override the default model
codemie-claude --help                   # Show agent-specific help
```

Examples:

```bash
# Bug fixing
codemie-claude --task "Fix the authentication bug in src/auth.ts"

# A different profile for a single run
codemie-claude --profile work --task "Review company codebase"

# Interactive mode for exploratory work
codemie-claude
> Review my authentication code
> Now refactor it to use JWT tokens
> exit
```

## Available Models

By default, only Claude models are available in Claude Code and Claude Desktop. The `/model` picker
in Claude Code and the model list in Claude Desktop show the Claude-family models of the project
catalog that the profile is linked to. Other models in the catalog, for example Grok, Gemini, or
Kimi, are not offered, because they may not support every Claude-specific feature.

Non-Claude models can be added per profile with the `codemie-claude models` command. The selection
is stored in the profile as `claudeExtraModels` and applies to both Claude Code and Claude Desktop.
Only models of the project catalog that the profile is linked to can be selected, so the profile
must be connected to CodeMie. Claude models are always available and are not affected.

### Manage extra models

```bash
codemie-claude models list                          # Show the extra models selected for a profile
codemie-claude models select                        # Pick extra models from the project catalog
codemie-claude models add <models...>               # Add models by ID or name
codemie-claude models remove <models...>            # Remove models by ID
```

All four commands accept `--profile <name>`. Without it, the active profile is used.

| Command  | Description                                                                                                                                                                               |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `list`   | Shows the models selected for the profile. A selected model that is not available in the project anymore is marked and is not shown in Claude Code or Claude Desktop.                     |
| `select` | Opens an interactive checklist of the non-Claude models of the project catalog. Requires an interactive terminal. Checked models are saved; clearing all of them restores the default.    |
| `add`    | Adds one or more models by ID or name, for example `gemini-3.1-pro`. Matching is case-insensitive. Claude models are skipped, and a model that is not in the project catalog is rejected. |
| `remove` | Removes one or more models by the ID shown by `list`. Works without a connection to CodeMie, so a model that was removed from the catalog can still be cleared.                           |

Examples:

```bash
# Choose models interactively for the active profile
codemie-claude models select

# Add a model to a specific profile
codemie-claude models add gemini-3.1-pro --profile work

# Check what is selected, then remove a model
codemie-claude models list --profile work
codemie-claude models remove gemini-3.1-pro --profile work
```

Claude Code picks up the change on its next start. Claude Desktop must be restarted to refresh its
model list. With no models selected, Claude Code and Claude Desktop behave as before.

### Non-Claude models in Claude Code

Selected models appear in the `/model` picker under their real ID and are marked **Not a Claude
model**. Requests to them are sent through the CodeMie gateway like requests to any other model.

### Non-Claude models in Claude Desktop

Claude Desktop accepts only model IDs that read as Claude and rejects IDs that name another model
family. Selected models are therefore listed under an opaque `claude-x-<hash>` ID, with the real
model name as the display name. The local CodeMie proxy maps the ID back to the real model on each
request, so the requests reach the model that was selected. The `claude-x-<hash>` ID is calculated
from the real ID, so it stays the same between restarts.

The Claude Desktop connection itself is described in [Claude Desktop](./claude-desktop.md).

:::warning Limitations

- The `claude-x-<hash>` ID works around a model ID check in Claude Desktop. A Claude Desktop update
  may break it.
- Anthropic does not support non-Claude models in Claude Code or Claude Desktop. Non-Claude models
  may not support every feature, such as extended thinking, prompt caching, or some tools.

:::

## Assistants and Skills

CodeMie assistants and skills can be registered in Claude Code and called from a coding session.

| Capability                   | Command                    | In Claude Code                | Details                                        |
| ---------------------------- | -------------------------- | ----------------------------- | ---------------------------------------------- |
| CodeMie assistants           | `codemie setup assistants` | `@assistant-name` or `/name`  | [Assistants](./assistants-integration.md)      |
| CodeMie skills               | `codemie setup skills`     | `/skill-name`                 | [Skills](./skills-integration.md)              |
| Pre-built skills for CodeMie | none, available at launch  | Described in natural language | [Built-in Skills](./codemie-claude-skills.md)  |
| Platform asset management    | `codemie sdk`              | `codemie-sdk` skill           | [SDK CLI Reference](./sdk-asset-management.md) |

## MCP Servers

Remote MCP servers can be registered with Claude Code through CodeMie CLI. All MCP traffic is
routed through the built-in `codemie-mcp-proxy`, which handles OAuth automatically, so tokens do
not need to be managed manually.

```bash
codemie mcp add <name> <url>                    # Register an MCP server for the current user
codemie mcp add <name> <url> --scope project    # Register for the current project only
codemie mcp remove <name>                       # Remove a registered MCP server
codemie mcp list                                # List all registered MCP servers
```

Examples:

```bash
# Add a remote MCP server for the current user
codemie mcp add my-server https://mcp.example.com/sse

# Add a project-scoped MCP server
codemie mcp add my-server https://mcp.example.com/sse --scope project

# List all registered MCP servers
codemie mcp list

# Remove an MCP server
codemie mcp remove my-server
```

## In This Section

| Page                                           | Description                                                                     |
| ---------------------------------------------- | ------------------------------------------------------------------------------- |
| [Assistants](./assistants-integration.md)      | Register CodeMie assistants in Claude Code and chat with them from the terminal |
| [Skills](./skills-integration.md)              | Install CodeMie skills in Claude Code as slash commands                         |
| [Built-in Skills](./codemie-claude-skills.md)  | Six pre-built skills available automatically in `codemie-claude`                |
| [SDK CLI Reference](./sdk-asset-management.md) | Reference for the `codemie sdk` commands used by the `codemie-sdk` skill        |
| [Claude Desktop](./claude-desktop.md)          | Connect Claude Desktop to the CodeMie gateway                                   |
