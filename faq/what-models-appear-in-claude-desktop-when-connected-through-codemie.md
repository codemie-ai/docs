# What models appear in Claude Desktop when connected through CodeMie?

Claude Desktop discovers Claude-compatible models from the CodeMie gateway at
`http://127.0.0.1:4001/v1/models`. By default, the list includes the Claude models of the project
catalog configured in the organization's CodeMie platform — for example, `claude-sonnet-4-6`,
`claude-opus-4-8`, and `claude-haiku-4-5` variants, depending on which providers and model
versions are enabled by the organization's admin.

Non-Claude models, such as Grok, Gemini, or Kimi, appear only if they were selected for the profile
with `codemie-claude models select`. They are listed under their real display name, with an opaque
`claude-x-<hash>` ID behind it.

The model list is fetched automatically at every Claude Desktop launch. To see which models
were discovered, go to **Settings → Inference configuration → Connection → Models** and check
the **Model discovery** banner.

## Sources

- [Claude Desktop Integration](https://codemie-ai.github.io/docs/user-guide/codemie-cli/claude/claude-desktop)
- [Claude with CodeMie: Available Models](https://codemie-ai.github.io/docs/user-guide/codemie-cli/claude/#available-models)
