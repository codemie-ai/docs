# How do I test a saved MCP server configuration as an administrator?

Open **Settings** → **Administration** → **MCPs management**, click the three dots menu (⋮) in the server row, and select **Test Integration**. The same action is available in the **View Details** sidebar. The platform connects to the MCP server and reports the outcome in a notification:

1. **Success**: the connection works, and the number of retrieved tools is shown.
2. **Warning**: the connection works, but the server returned no tools.
3. **Failure**: an error message with a diagnostic hint is shown.

If the server has required environment variables, the **Integration required** window opens first. Select or create an MCP integration and click **Test Integration**. Inactive servers can be tested before activation. The result is not stored.

This capability requires the Administrator role and the Enterprise package.

## Sources

- [Testing a Saved MCP Server Configuration](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/adding-an-mcp-server#testing-a-saved-mcp-server-configuration-administrators)
