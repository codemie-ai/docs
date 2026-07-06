---
id: mcp-integration-credentials
title: MCP Integration Credentials
sidebar_label: MCP Integration Credentials
pagination_prev: user-guide/tools_integrations/tools/adding-an-mcp-server
pagination_next: user-guide/tools_integrations/tools/using-mcp-tools-in-assistants
sidebar_position: 22
---

# MCP Integration Credentials

Many MCP servers need credentials — such as API keys or tokens — supplied as environment variables. When you add an MCP server to an assistant, you decide **how those credentials are provided to each person who uses the assistant**.

CodeMie resolves these credentials **per user at run time**. Your own secrets are never exposed to other users of the same assistant, and if a person has no matching integration the MCP server still runs on its base configuration.

## Choosing how credentials are provided

You set this per MCP server, in the server's environment-variables configuration, using the **Automatic Credentials Lookup** toggle:

- **On (default)** — credentials are resolved automatically, per user.
- **Off** — you pick an explicit **Integration source**: **By alias** or **Pinned integration**.

| Mode                    | How to set it                                                 | Who provides the credentials                            |
| ----------------------- | ------------------------------------------------------------- | ------------------------------------------------------- |
| **Automatic** (default) | Keep **Automatic Credentials Lookup** on                      | Each user automatically uses their own MCP integration  |
| **By alias**            | Turn Automatic off, choose **By alias**, enter an alias       | Each user uses their own integration matching the alias |
| **Pinned integration**  | Turn Automatic off, choose **Pinned integration**, select one | One integration you pick, shared by everyone            |

### Automatic (default)

With **Automatic Credentials Lookup** on, every person who uses the assistant automatically works under their **own** MCP integration — they do not need to configure anything on the server beyond having an integration of their own. If a user has no suitable integration, the server simply runs on its base configuration (the values already defined in the server).

This is the recommended option for shared assistants: each user brings their own credentials, and no one sees anyone else's.

### By alias

Turn **Automatic Credentials Lookup** off, choose **By alias**, and enter an **alias** — a short, shared name for the integration. At run time, each user resolves **their own** integration that carries that alias and that they are allowed to use. As the author, you do **not** need to own the integration yourself — you only publish the alias.

If a user has no accessible integration with that alias, the server runs on its base configuration. A pinned integration is never used as a fallback in this mode.

:::tip
Use **By alias** when different users should connect with their own accounts, but you want everyone to standardize on the same shared name for the integration.
:::

### Pinned integration

Turn **Automatic Credentials Lookup** off, choose **Pinned integration**, and select a specific integration. That integration is **shared by everyone** who uses the assistant.

:::note
If you choose **Pinned integration** but do not select one, you will see a reminder to select an integration. Until one is selected, the server runs on its base configuration.
:::

## Privacy and fallback

:::info

- Credentials are resolved **separately for each user** at run time. One user's secrets are never revealed to another user of the same assistant.
- In **By alias** mode, a user only ever resolves an integration they can access — their own, or one shared within a project they belong to.
- If no integration is available for a given user, the MCP server keeps working on its **base configuration** instead of failing.

:::
