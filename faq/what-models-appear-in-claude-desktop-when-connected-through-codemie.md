# What models appear in Claude Desktop when connected through CodeMie?

Claude Desktop discovers Claude-compatible models from the CodeMie gateway at
`http://127.0.0.1:4001/v1/models`. The list includes all Claude models configured in the
organization's CodeMie platform — for example, `claude-sonnet-4-6`, `claude-opus-4-8`, and
`claude-haiku-4-5` variants, depending on which providers and model versions are enabled by
the organization's admin.

The model list is fetched automatically at every Claude Desktop launch. To see which models
were discovered, go to **Settings → Inference configuration → Connection → Models** and check
the **Model discovery** banner.

## Sources

- [Claude Desktop Integration](https://codemie-ai.github.io/docs/user-guide/codemie-cli/claude-desktop)
