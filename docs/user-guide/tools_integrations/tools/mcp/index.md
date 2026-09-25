---
id: mcp
title: MCP (Model Context Protocol)
sidebar_label: MCP
sidebar_position: 21
pagination_prev: user-guide/tools_integrations/tools/overview
pagination_next: user-guide/tools_integrations/tools/mcp/adding-an-mcp-server
---

# MCP (Model Context Protocol)

Model Context Protocol (MCP) lets you connect external tools and services to your assistants,
extending their capabilities beyond built-in tools.

:::info Where MCP servers run

MCP servers you configure in the platform are executed by the platform's built-in **MCP Connect** bridge — they do not run on your local machine or within your private network unless you self-host an MCP Connect instance. To give an assistant access to tools on your own machine, self-host an MCP Connect bridge and provide its URL when configuring the server, or use [CodeMie CLI](../../../codemie-cli/index.md) for local development work.

:::

## In this section

| Page                                                         | Description                                                     |
| ------------------------------------------------------------ | --------------------------------------------------------------- |
| [Adding an MCP Server](./adding-an-mcp-server)               | Add and configure MCP servers in your assistants                |
| [MCP Integration Credentials](./mcp-integration-credentials) | Configure whose credentials each user runs the MCP server under |
