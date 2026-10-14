# Why are tool checkboxes and MCP server toggles disabled in the assistant configuration form?

The **Enable Smart Tools selection** toggle is on for the assistant. In that mode the assistant chooses tools for each request, so manually picked tools are ignored. The tool checkboxes, **Select all**, MCP server toggles, and integration selectors stay visible but cannot be changed, and a message in **Tools configuration** explains this.

To change the tools manually, switch **Enable Smart Tools selection** off, adjust the selection, and save. The assistant details sidebar shows the current state as **Smart Tools: ON** or **Smart Tools: OFF** under **Tools & Capabilities**.

## Sources

- [Assistant's Tools Overview](https://docs.codemie.ai/user-guide/tools_integrations/tools/overview)
