# Can an assistant override whether the user profile is sent to an MCP server?

Yes. The `allow_user_context` value on the MCP server is the default for every assistant that uses it. An assistant can override that default in its own MCP server entry using the same `allow_user_context` field:

- **Not set**: the MCP server value applies.
- **`true`**: the user profile is sent, whatever the server value.
- **`false`**: the user profile is not sent, whatever the server value.

The override is useful when a shared catalog server is enabled for most assistants, but one assistant must not expose user identity to the tool, or the other way around.

## Sources

- [Adding an MCP Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/adding-an-mcp-server#overriding-it-per-assistant)
