# How do I export a workflow node's call history as JSON?

Open a workflow execution, select the node whose call history is needed in the **States** list at the bottom of the page, and click **Call history**. In the `Calls history for` popup that opens, click the **Download** button in the popup header. The button appears once the node's calls are loaded and is hidden for a node without calls. The platform saves a `.json` file to the browser's default download location. The filename is derived from the node name and execution ID.

The exported file is indented JSON. It contains a node summary (status, start time, end time, and duration) followed by every call in the popup, including sub-calls, with each call's input, output, error value, and date.

## Sources

- [Workflows Overview](https://codemie-ai.github.io/docs/user-guide/workflows/workflows-overview#node-call-history)
