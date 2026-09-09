# How do I open assistant details from a workflow execution?

Click the assistant node directly in the execution graph. Open the workflow, go to the **Executions** tab, open an execution, and click an assistant node — a panel opens on the right with the full assistant view: profile details, conversation starters, instructions, tools and integrations, and metadata.

Everything in the panel is read-only, except the **Your Integration Settings** section, which stays editable if the assistant supports per-user integration selection. The execution graph keeps working as usual while the panel is open — you can still pan and zoom, and the workflow editor is not affected.

The panel opens only for assistant nodes with a valid assistant. It does not open for tool nodes, inline nodes, or virtual assistants. If you have no access to the assistant, the panel still opens and shows a placeholder instead of an empty view.

## Sources

- [Assistant Panel on the Executions Page](https://docs.codemie.ai/user-guide/workflows/assistant-panel-in-executions#opening-the-panel)
