# How do I copy a workflow node's call history to the clipboard?

Open a workflow execution, select the node whose call history is needed in the node list at the bottom of the page, below the workflow graph, and click **Call history**. In the `Calls history for` popup that opens, click the **Copy to clipboard** button in the popup header. The button appears once the node's calls are loaded and is hidden for a node without calls. The full call history JSON is copied to the clipboard and a confirmation toast is shown.

The copied content is indented JSON. It contains a node summary (status, start time, end time, and duration) followed by every call in the popup, including sub-calls, with each call's input, output, error value, and date. This is useful for sharing a node's activity in a ticket, chat, or log.

If copying fails (for example, because clipboard access is unavailable in the current browser context), an error notification is shown.

## Sources

- [Workflows Overview](https://codemie-ai.github.io/docs/user-guide/workflows/workflows-overview#node-call-history)
