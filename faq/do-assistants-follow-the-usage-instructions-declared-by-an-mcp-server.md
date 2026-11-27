# Do assistants follow the usage instructions declared by an MCP server?

Yes. When an MCP server declares usage instructions during its connection handshake, AI/Run CodeMie adds them to the system prompt of the assistant or skill that uses the server. The assistant therefore has the instructions before it makes the first tool call.

No assistant configuration is needed. The text is treated as tool documentation from the server, not as an instruction from the user or the platform, and it is limited to 4000 characters per server and 12000 characters in total. The behavior is controlled by the `features:mcpServerInstructions` component in `customer-config.yaml` and is enabled by default.

## Sources

- [MCP Server Instructions](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/mcp-server-instructions)
