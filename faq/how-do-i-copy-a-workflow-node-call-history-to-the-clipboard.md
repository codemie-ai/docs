# How do I copy a workflow node's call history to the clipboard?

Open a workflow execution and click the node whose call history is needed. In the **Call history** popup that appears, click the **Copy to clipboard** button in the popup header. The full call history JSON is copied to the clipboard and a confirmation toast is shown.

The copied content includes every call visible in the popup — inputs, outputs, statuses, timestamps, duration, and sub-calls — formatted as indented JSON. This is useful for sharing a node's activity in a ticket, chat, or log.

If copying fails (for example, because clipboard access is unavailable in the current browser context), an error notification is shown.

## Sources

- [Workflows Overview](https://codemie-ai.github.io/docs/user-guide/workflows/workflows-overview#node-call-history)
