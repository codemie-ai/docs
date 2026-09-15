# Why does saving a workflow warn about tools without integrations?

Because those tools depend on each user's own setup rather than yours. When an assistant in the workflow uses a tool whose integration the assistant author did not pin, the slot belongs to whoever runs the workflow — resolved automatically or selected personally by that user. As the workflow author, you do not need to own an integration for it.

The save therefore succeeds: the message is a non-blocking warning, not an error. It simply lists the tools that will resolve against each user's own integrations at run time, so you know which parts of the workflow depend on how other people have set themselves up.

Each user can check and change what those tools will use by clicking the assistant node on the executions page and opening **Your Integration Settings** in the panel.

## Sources

- [Create Workflow — Assistant Integrations and Saving](https://docs.codemie.ai/user-guide/workflows/create-workflow#assistant-integrations-and-saving)
- [Assistant Panel on the Executions Page](https://docs.codemie.ai/user-guide/workflows/assistant-panel-in-executions)
