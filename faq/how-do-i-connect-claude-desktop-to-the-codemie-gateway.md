# How do I connect Claude Desktop to the CodeMie gateway?

Run the following command with the CodeMie CLI:

```bash
codemie proxy connect --claude-desktop
```

This starts the local CodeMie proxy daemon on `http://127.0.0.1:4001`, writes the inference
gateway configuration to Claude Desktop's config library, and registers the organization's
managed MCP servers. After the command completes, restart Claude Desktop — the active profile
appears at the bottom of the sidebar as `· Gateway`.

The model list is refreshed automatically at every launch. To manually verify or trigger model
discovery, go to **Settings → Inference configuration → Connection → Models** and click
**Test model discovery**.

## Sources

- [Claude Desktop Integration](https://codemie-ai.github.io/docs/user-guide/codemie-cli/claude-desktop)
