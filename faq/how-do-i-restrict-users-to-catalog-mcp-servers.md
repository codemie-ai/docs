# How do I restrict users to catalog MCP servers only?

Enable the `mcpCustomServersDisabled` component. In restricted mode every MCP server on an assistant, skill, or workflow must reference an active, public entry of the admin-managed MCP catalog. Saving a hand-written server, or a catalog server with its own configuration, is refused with an error message, and the **Manual Setup** option is no longer offered in the UI.

The component can be set in `customer-config.yaml` or switched at runtime from **Settings → Administration → Customer Configuration** (card **MCP Custom Servers Disabled**, switch **Restrict to catalog MCP servers**). The switch applies to the whole environment and requires the platform `admin` or `maintainer` role.

## Sources

- [MCP Catalogue Governance](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration#mcp-catalogue-governance)
