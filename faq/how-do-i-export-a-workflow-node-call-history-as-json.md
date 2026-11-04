# How do I export a workflow node's call history as JSON?

Open a workflow execution and click the node whose call history is needed. In the **Call history** popup that appears, click the **Download** button in the popup header. The platform saves a `.json` file to the browser's default download location. The filename is derived from the node name and execution ID.

The exported file contains every call visible in the popup — including inputs, outputs, statuses, timestamps, duration, and any sub-calls — formatted as indented JSON.

## Sources

- [Workflows Overview](https://codemie-ai.github.io/docs/user-guide/workflows/workflows-overview#node-call-history)
