# How do I run MCP servers with the codemie-plugins package?

The codemie-plugins package allows you to run various MCP (Model Context Protocol) servers directly from the command line:

Listing available servers

codemie-plugins mcp list  
Running servers

Run a single server  
codemie-plugins mcp run -s filesystem

Run multiple servers  
codemie-plugins mcp run -s filesystem,cli-mcp-server

Run with environment variables  
codemie-plugins mcp run -s filesystem -e filesystem=FILE_PATHS  
Available server types

## Sources

- [Plugin](https://docs.codemie.ai/user-guide/tools_integrations/tools/plugin)
- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
