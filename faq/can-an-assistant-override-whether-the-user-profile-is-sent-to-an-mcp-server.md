# Can an assistant override whether the user profile is sent to an MCP server?

Yes. The `allow_user_context` value on the MCP server is the default for every assistant that uses it, and the user profile is sent by default. An assistant can override that default with an `allow_user_context` field in its MCP server entry. This field is a top-level property of the entry, next to `config`. It is not part of the configuration JSON, and the assistant form has no control for it, so it can only be set through the assistant API.

For a catalog server in Global mode, the catalog value is a ceiling:

- **Not set**: the catalog value applies.
- **`false`**: the user profile is not sent, whatever the catalog value.
- **`true`**: the catalog value still applies. If the administrator turned the option off, the assistant cannot turn it back on.

For a server with its own configuration, including a catalog server switched to Custom mode, the assistant value wins when it is set. A Custom copy carries its own `allow_user_context` and ignores the catalog value, so the ceiling does not apply. If the administrator turned off custom MCP servers, Custom mode is not available and the catalog ceiling applies:

- **Not set**: the MCP server value applies.
- **`true`**: the user profile is sent, whatever the server value.
- **`false`**: the user profile is not sent, whatever the server value.

The override is useful when a shared catalog server sends the profile to most assistants, but one assistant must not expose user identity to the tool.

## Sources

- [Adding an MCP Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/adding-an-mcp-server#overriding-it-per-assistant)
