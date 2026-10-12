# How to hide tool outputs from end users in an assistant?

In the assistant configuration form, enable the **Hide tool output** toggle in the header of the **Tools configuration** section, next to **Allow to override**. This is also available when editing the assistant from an active chat.

Enforcement happens on the server: once enabled, tool calls, intermediate outputs, raw payloads, and execution traces are stripped from the chat response, conversation history, shared conversation pages, and exports for everyone chatting with the assistant, including the creator. The per-conversation tool output toggle in the chat input toolbar is removed for a flagged assistant and cannot turn outputs back on. The setting is OFF by default, and full tool outputs remain stored — only what is served to end users is filtered.

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
