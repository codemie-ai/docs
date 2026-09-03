# Can I use a different integration for an assistant in one workflow only?

Yes. Open the assistant panel by clicking the assistant node on the workflow page, change the integration in **Your Integration Settings**, and save with the **Apply to the whole assistant, not just this workflow** checkbox **cleared**. The choice then applies only to that workflow, that assistant, and you — your chat, the assistant page, and your other workflows keep the integration they had.

Selecting the checkbox instead saves the choice at assistant scope: it applies to the assistant everywhere for you, and the workflow-scoped selection for the current workflow is removed. Selections you saved for other workflows are not changed. The checkbox is selected by default when you have no personal selection for the assistant yet, and cleared by default when you already have one.

At run time, the integration is resolved in this order: your workflow-scoped selection, then your assistant-scoped selection, then no integration (the tool runs on its base configuration). Integrations pinned by the assistant author are not part of this — they are not offered for personal selection at all. Your selections are private and never affect other users of the same workflow, and cloning a workflow does not copy workflow-scoped selections.

## Sources

- [Assistant Panel on the Executions Page — Where the selection applies](https://docs.codemie.ai/user-guide/workflows/assistant-panel-in-executions#where-the-selection-applies)
- [MCP Integration Credentials](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/mcp-integration-credentials)
