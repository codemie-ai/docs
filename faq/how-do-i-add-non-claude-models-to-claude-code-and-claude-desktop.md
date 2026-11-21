# How do I add non-Claude models to Claude Code and Claude Desktop in CodeMie?

By default, `codemie-claude` and Claude Desktop offer only the Claude models of the project catalog
linked to the CodeMie profile. Other models, such as Grok, Gemini, or Kimi, can be added per profile:

1. Run `codemie-claude models select` (optionally with `--profile <name>`) and check the models to add.
   Only non-Claude models of the profile's project catalog are listed.
2. Alternatively, run `codemie-claude models add <model>` or `codemie-claude models remove <model>`
   to change the selection, and `codemie-claude models list` to review it.
3. Start Claude Code again, or restart Claude Desktop, to refresh the model list.

In Claude Code, the models appear in the `/model` picker marked **Not a Claude model**. In Claude
Desktop, they appear under their regular names in the model picker. Non-Claude models may not work
well with Claude Code and Claude Desktop: some Claude-specific features may be unsupported.
Anthropic does not support non-Claude models in these clients.

## Sources

- [Claude with CodeMie: Available Models](https://codemie-ai.github.io/docs/user-guide/codemie-cli/claude/#available-models)
- [Claude Desktop Integration](https://codemie-ai.github.io/docs/user-guide/codemie-cli/claude/claude-desktop)
