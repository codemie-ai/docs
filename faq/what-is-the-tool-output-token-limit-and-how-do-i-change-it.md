# What is the tool output token limit and how do I change it?

The `limit_tool_output_tokens` parameter controls how many tokens a single tool response can
contribute to an assistant's context in a workflow. The default is **10000 tokens**.

When a tool returns a response larger than this limit, the output is truncated and an error is
logged. The workflow may continue with incomplete data, which can affect the quality of results.

## How to change it

Set `limit_tool_output_tokens` on the assistant in your workflow YAML:

```yaml
assistants:
  - id: my-assistant
    model: gpt-4.1
    limit_tool_output_tokens: 20000  # raise from the default 10000
```

There is no platform-level setting to change the default globally — each assistant in the
workflow must define the value explicitly.

Choose a value based on the tools your assistant uses:

| Tool type                             | Suggested value |
| ------------------------------------- | --------------- |
| Simple lookups, status checks         | 3000–5000       |
| General purpose (default)             | 10000           |
| GitHub / GitLab with large repos      | 15000–30000     |
| Filesystem reads, large API responses | 20000–50000     |

## Sources

- [Configuration Reference — Assistant Properties](https://codemie-ai.github.io/docs/user-guide/workflows/configuration/configuration-reference)
- [Troubleshooting — Tool Output Token Limit Exceeded](https://codemie-ai.github.io/docs/user-guide/workflows/configuration/troubleshooting#tool-output-token-limit-exceeded)
