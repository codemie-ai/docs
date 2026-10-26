# How does Smart Tool Selection work for assistants? What is the Enable Smart Tools selection toggle and how do I use it?

Smart Tool Selection lets an assistant choose the tools to use for each request, based on the meaning of the request and the recent conversation, instead of relying only on tools picked manually.

To use it, open the assistant's **Create** or **Edit** page, switch on **Enable Smart Tools selection** above the **Tools configuration** section, and click **Save**. The toggle is shown only when the feature is enabled on the platform level; otherwise contact the platform administrator.

While it is on:

- The assistant chooses from all tools available on the platform, not only from the tools picked manually.
- Narrowing applies only when enough tools are found; with fewer, all found tools are used. The tools picked in the form are used only when no relevant tool is found.
- Manually picked tools do not decide which tools run. They stay visible in **Tools configuration** but cannot be changed.
- The tools required by attached skills are always added next to the matched tools, and the tools of the assistant's data sources and MCP servers stay available. Web search and code interpreter are used only when switched on for the request, image generation only when enabled for the assistant and not switched off for the request, and code and Git tools are added whenever the assistant has a code data source.
- Only tools picked in the form use the integration pinned to the assistant; all other tools use the integration settings of the user running the request, or of the project, and are skipped when none matches.
- Workflows are not affected and keep using manually selected tools.

Switching the toggle off restores the previous manual selection. Keep it off when precise control over available tools is required.

## Sources

- [Assistant's Tools Overview](https://docs.codemie.ai/user-guide/tools_integrations/tools/overview)
