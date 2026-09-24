# Can I chat with a CodeMie assistant from a Microsoft Teams group chat or channel?

Yes. The CodeMie Bot supports personal chats, group chats, and team channels. In a group chat or channel, the bot only responds when @mentioned, and `/setup` must be run first to register an assistant for that group chat or channel — this uses assistants exposed through a Project-scoped MS Teams Bot integration, and only assistants that are shared with the project or marked global are offered. File attachments are only supported in personal chats.

If more than one assistant is registered for a scope, messages are routed automatically to the best match, or a specific one can be forced by prefixing the message with `/<assistant-slug>`.

## Sources

- [Microsoft Teams Bot](https://docs.codemie.ai/user-guide/ms-teams-bot/)
- [MS Teams Bot Integration](https://docs.codemie.ai/user-guide/ms-teams-bot/integration/)
