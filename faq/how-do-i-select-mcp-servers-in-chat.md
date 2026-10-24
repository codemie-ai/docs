# How do I select MCP servers in chat? Can I enable MCP servers for a single conversation without editing the assistant?

MCP servers can be selected directly in the chat, similarly to tools in **Tools Settings**.
The selection applies to the current conversation only and does not change the assistant's
configuration.

1. Open a new or existing chat.
2. Click the **MCP** button in the chat input toolbar.
3. Select one or more MCP servers. The selector lists only the servers available to the
   current user and authorized for the current chat context.
4. The selected servers are shown as active in the chat, and their tools are available to the
   assistant for subsequent requests.

Servers can be added, removed, or switched at any time without leaving the conversation; the
change applies to the next request. If an active server becomes unavailable or the user loses
access to it, the server is not used and the chat shows a status indication, while the rest of
the conversation keeps working.

MCP selection follows the existing governance rules: the administrator-managed catalog, user
access rights, and per-user credential resolution all still apply.

## Sources

- [Chat Input Settings: MCP Servers](https://docs.codemie.ai/user-guide/assistants/chat-input-settings#mcp-servers)
- [MCP Integration Credentials](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/mcp-integration-credentials)
