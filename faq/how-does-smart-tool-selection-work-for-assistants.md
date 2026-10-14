# How does Smart Tool Selection work for assistants? What is the Enable Smart Tools selection toggle and how do I use it?

Smart Tool Selection lets an assistant choose the tools to use for each request, based on the meaning of the request and the recent conversation, instead of relying only on tools picked manually.

To use it, open the assistant's **Create** or **Edit** page, switch on **Enable Smart Tools selection** above the **Tools configuration** section, and click **Save**. The feature also has to be enabled on the platform level; otherwise the toggle has no effect.

While it is on:

- The assistant chooses from all tools available on the platform, not only from the tools picked manually.
- Manually picked tools are ignored. They stay visible in **Tools configuration** but cannot be changed.
- Web search and similar tools still follow their usual rules, and Git tools still require the **Git** toolkit on the assistant.
- Workflows are not affected and keep using manually selected tools.

Switching the toggle off restores the previous manual selection. Keep it off when precise control over available tools is required.

## Sources

- [Assistant's Tools Overview](https://docs.codemie.ai/user-guide/tools_integrations/tools/overview)
