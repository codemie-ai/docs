---
id: mcp-server-instructions
title: MCP Server Instructions
sidebar_label: MCP Server Instructions
sidebar_position: 4
pagination_prev: user-guide/tools_integrations/tools/mcp/mcp
pagination_next: null
---

# MCP Server Instructions

An MCP server can describe how its tools are meant to be used, for example "call the help tool before the first use" or "always pass a project key". The server declares this text, called _instructions_, when AI/Run CodeMie connects to it. When the feature is enabled, assistants and skills receive the instructions together with the system prompt, so they are followed from the first tool call onward.

No configuration is needed in the assistant. The instructions are picked up automatically for every MCP server that declares them.

## How It Works

1. An assistant or skill with one or more MCP servers receives a message.
2. AI/Run CodeMie connects to each MCP server through MCP Connect and lists its tools. If a server declared instructions during the connection handshake, they are returned together with the tool list.
3. The instructions of every server that contributes at least one tool to the assistant are appended to the system prompt, after the assistant's own prompt.
4. The assistant plans and executes tool calls with the instructions already in context.

Skills use the same path as assistants: instructions of MCP servers that a skill contributes are included as well.

Servers that declare no instructions change nothing. The system prompt stays exactly as it was.

## What the Assistant Receives

Each server's instructions are placed in a separate block labelled with the server name:

```text
BEGIN MCP SERVER INSTRUCTIONS <id> (server: support-portal)
Always call the tool with sysparm_help=true before first use.
END MCP SERVER INSTRUCTIONS <id>
```

A short preamble before the blocks tells the model that this text comes from the MCP server, not from the user or the platform operator. The assistant treats it as tool documentation and does not follow requests inside it to change its role, ignore earlier instructions, or reveal information.

`<id>` is a unique identifier that is the same for every turn of one conversation. Text inside a block that imitates a delimiter without this exact identifier is treated as part of the server's text.

## Limits

Instructions come from third-party servers, so the platform bounds and cleans them before they reach the prompt.

| Limit                          | Value            | Behavior when exceeded                                       |
| ------------------------------ | ---------------- | ------------------------------------------------------------ |
| Instructions per MCP server    | 4000 characters  | Text is cut and ends with `[truncated]`                      |
| Whole instructions section     | 12000 characters | Remaining servers are omitted and listed by name in a notice |
| Server name in the block label | 100 characters   | Name is shortened                                            |

Additional rules:

- Control characters and invisible or direction-changing Unicode characters are removed.
- Identical instructions from the same server name are included once.
- A server whose tools are all filtered out or replaced by another server's tools of the same name contributes no instructions.

:::note
MCP Connect applies its own limit before the platform does. Its default is 8192 characters and is set by the `MCP_CONNECT_MAX_INSTRUCTIONS_CHARS` environment variable of the MCP Connect service. The stricter of the two limits wins.
:::

## Availability

The feature is controlled by the `features:mcpServerInstructions` component of the [customer configuration](../../../../admin/configuration/codemie/customer-feature-configuration.md#mcp-server-instructions), which is enabled by default. When it is disabled, instructions are not added to any prompt and MCP servers behave as before.

Platform administrators can find the deployment-side settings in [MCP Server Instructions](../../../../admin/configuration/codemie/customer-feature-configuration.md#mcp-server-instructions).
