# What happens to existing assistants and workflows when custom MCP servers are disabled?

Saved items are not rewritten. An assistant, skill, or workflow that already holds a hand-written MCP server keeps its data, but the server is skipped at run time and the item cannot be saved again, or restored from version history, until the server is replaced with a catalog entry or removed.

Before enabling the `mcpCustomServersDisabled` component on an environment with existing users, find items that use hand-written MCP servers and ask their owners to move them to the catalog. Switching the component off restores the previous behavior within the cache interval (60 seconds by default).

## Sources

- [MCP Catalogue Governance](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration#mcp-catalogue-governance)
