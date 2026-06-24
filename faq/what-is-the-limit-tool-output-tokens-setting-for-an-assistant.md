# What is the Limit Tool Output Tokens setting for an assistant?

**Limit Tool Output Tokens** caps how many tokens a single tool's output may contribute to the conversation for a given assistant. It helps prevent large tool results — such as a full file read, a long API response, or a wide search result — from consuming too much of the model's context window.

The setting is optional and empty by default. When it is left empty, each tool applies its own built-in output limit. When a value is set, that value overrides every tool's individual default (including per-MCP-server limits) for that assistant, and larger outputs are truncated before they reach the model. Only positive whole numbers are accepted; the `30000` placeholder is a visual hint and does not set a value automatically.

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant#limit-tool-output-tokens)
