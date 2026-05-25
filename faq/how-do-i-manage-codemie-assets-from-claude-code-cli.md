# How do I manage CodeMie assets from Claude Code CLI?

Claude Code can manage CodeMie platform assets directly from your terminal using the
built-in `codemie-sdk` skill, which is available automatically when you launch Claude Code
with `codemie-claude`.

Just describe what you need in natural language:

```
list my assistants in the Engineering project
create a new assistant called "Code Reviewer" with a code review system prompt
delete workflow <id>
update the company-wiki datasource description
```

Claude asks which project to use before proceeding, proposing your default or letting you
pick another.

**Supported asset types:** assistants, workflows, datasources, integrations, skills, users,
assistant categories

## Sources

- [Manage CodeMie Assets from CLI](https://codemie-ai.github.io/docs/user-guide/codemie-cli/sdk-asset-management)
