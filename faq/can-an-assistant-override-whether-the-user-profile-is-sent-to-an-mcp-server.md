# Can an assistant override whether the user profile is sent to an MCP server?

Yes. The `allow_user_context` value on the MCP server is the default for every assistant that uses it, and the user profile is sent by default. An assistant can override that default in its own MCP server entry using the same `allow_user_context` field.

For a server from the MCP catalog, the catalog value is a ceiling:

- **Not set**: the catalog value applies.
- **`false`**: the user profile is not sent, whatever the catalog value.
- **`true`**: the catalog value still applies. If the administrator turned the option off, the assistant cannot turn it back on.

For a server with its own configuration, the assistant value wins when it is set:

- **Not set**: the MCP server value applies.
- **`true`**: the user profile is sent, whatever the server value.
- **`false`**: the user profile is not sent, whatever the server value.

The override is useful when a shared catalog server sends the profile to most assistants, but one assistant must not expose user identity to the tool.

## Sources

- [Adding an MCP Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/adding-an-mcp-server#overriding-it-per-assistant)
