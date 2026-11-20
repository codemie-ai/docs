# What is the difference between codemie setup skills and codemie setup assistants?

Both commands register CodeMie platform items into Claude Code, but they differ in how the
registered item is invoked and what capabilities it has:

|                         | `codemie setup skills`           | `codemie setup assistants`                 |
| ----------------------- | -------------------------------- | ------------------------------------------ |
| **Invocation**          | Slash command (`/skill-name`)    | Subagent (`@name`) or slash command        |
| **Tools & MCP servers** | Not supported                    | Supported                                  |
| **Best for**            | Quick, focused single-turn tasks | Complex, multi-step tasks with tool access |

Use `codemie setup skills` for lightweight skills that don't need tools. If a skill requires
tools or MCP servers, attach it to an assistant on the CodeMie platform and register it with
`codemie setup assistants` instead.

## Sources

- [Access CodeMie Skills from CLI](https://docs.codemie.ai/user-guide/codemie-cli/skills-integration)
- [Access CodeMie Assistants from CLI](https://docs.codemie.ai/user-guide/codemie-cli/assistants-integration)
