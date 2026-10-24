# Can I filter workflows by MCP server?

Yes. The **All Workflows** and **My Workflows** lists have an **MCP Servers** filter available to all users. It is a searchable multi-select; a workflow is shown when an assistant node or a tool node in its configuration has any of the selected servers attached and enabled. The filter is also pre-selected when the Workflows count is clicked on the **MCPs management** page.

If the selected MCP server was deleted or is not accessible, a message is displayed instead of the generic empty list. The same filter is available in the API as the `mcp_config_ids` key of the `filters` parameter of `GET /v1/workflows`.

## Sources

- [Workflows Overview](https://docs.codemie.ai/user-guide/workflows/workflows-overview)
- [MCP Management](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/mcp-management)
