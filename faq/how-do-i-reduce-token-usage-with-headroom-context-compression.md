# How do I reduce token usage with Headroom context compression?

Open the assistant for editing, find **Context compression (Headroom)** in the **Context**
section, turn on **Enable context compression**, select whether to compress user input and tool
outputs, and pick a strategy: **Lossless**, **Balanced** (default) or **Aggressive**. Workflows can
override the setting for the whole workflow or for a single node with a `headroom` block in the
YAML.

**Balanced** and **Aggressive** can lower the LLM provider's prompt-cache hit rate; choose
**Lossless** when prompt caching matters more. Saved tokens appear in the chat usage details and
in the **Context Compression** section of Analytics.

## Sources

- [Context Compression (Headroom)](https://docs.codemie.ai/user-guide/assistants/context-compression)
