# What's the difference between an Application and an Integration in CodeMie?

They are two separate mechanisms. An **Integration** is a configured connection — API tokens, OAuth, or a service account — that lets an assistant's tools call out to an external system such as Jira, GitHub, or an MCP server. It has no UI of its own inside CodeMie.

An **Application** is a tile in the left navigation that opens a third-party product's own UI. CodeMie does not build, deploy, or run the product; it stores a pointer to it and renders a card that opens it, either as a link, an embedded iframe, or a Module Federation module running inside CodeMie's own page.

If the goal is for an assistant to call an API or run logic, that's an MCP server or Integration. If the goal is for a human to open a product's own screen from inside CodeMie, that's an Application.

## Sources

- [Application Onboarding Guide](https://docs.codemie.ai/admin/configuration/codemie/applications-onboarding/)
- [Integrations](https://docs.codemie.ai/user-guide/tools_integrations/integrations/)
