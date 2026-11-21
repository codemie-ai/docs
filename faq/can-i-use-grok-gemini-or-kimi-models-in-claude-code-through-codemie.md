# Can I use Grok, Gemini, or Kimi models in Claude Code through CodeMie?

Yes, if the model is part of the project catalog linked to the CodeMie profile. Claude models are
always available. Other models are opt-in: they are selected per profile with
`codemie-claude models select` and stored in the profile as `claudeExtraModels`. The selection
applies to both Claude Code and Claude Desktop. With no selection, behavior is unchanged.

Non-Claude models are not supported by Anthropic in Claude Code and may not handle every
Claude-specific feature, such as extended thinking, prompt caching, or some tools.

## Sources

- [Claude with CodeMie: Available Models](https://codemie-ai.github.io/docs/user-guide/codemie-cli/claude/#available-models)
