# How do I hide prompts and project details in CodeMie CLI analytics?

Turn on analytics privacy (prompt reduction). Run `codemie setup` and, at the last step,
**Analytics privacy**, answer "Hide prompts in analytics?" with **On for all projects** or
**On for this project only**. The project choice is saved in `.codemie/codemie-cli.config.json`
and can be committed to apply it to the whole team. The same setting is the
`analytics.promptReduction` key in the global or project `codemie-cli.config.json`.

With reduction on, analytics keeps only command, skill and agent names, ticket and MR numbers,
the repository name and metrics. Prompt text, tool input and output, file paths, session titles
and branch names are replaced by `REDACTED:<FIELD>` placeholders. A prompt such as
`/review-pr !456 check auth` is sent as `/review-pr !456 REDACTED:REST_PROMPT`, and a prompt with
no command or reference is sent as `REDACTED:PROMPT`.

Reduction covers every analytics route, including `codemie analytics sync`. It does not change
conversation history in CodeMie chat or analytics collected before it was turned on. The local
report can still be viewed in full with `codemie analytics --unreduced`.

## Sources

- [Analytics Privacy: Hide Prompts in Analytics](https://docs.codemie.ai/user-guide/codemie-cli/analytics-privacy)
- [Enable AI Analytics](https://docs.codemie.ai/user-guide/codemie-cli/enable-analytics)
