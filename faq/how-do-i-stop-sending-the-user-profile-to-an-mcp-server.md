# How do I stop sending the user profile to an MCP server?

CodeMie can attach a small, non-sensitive profile of the authenticated user to every tool call made on an MCP server. The profile is **enabled by default**, so every MCP server receives it unless you switch it off.

To stop sending it to a server, set `allow_user_context` to `false` in the MCP server configuration JSON:

```json
{
  "name": "example-http-server",
  "type": "streamable-http",
  "url": "http://127.0.0.1:3001/mcp",
  "allow_user_context": false
}
```

The field can be set when adding a server with **Manual Setup**, when editing an existing server, or by an administrator as the default on a catalog server under **Settings** > **Administration** > **MCPs catalog management**.

The tool receives the profile in the request `_meta` object under the key `codemie.ai/user-context`. The profile never contains tokens or passwords.

## Sources

- [Adding an MCP Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/adding-an-mcp-server#sending-the-user-profile-to-an-mcp-server)
