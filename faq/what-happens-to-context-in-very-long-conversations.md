# What happens to context in very long conversations?

When the conversation history grows too large to replay in full, the platform automatically
compacts older turns to stay within context limits. Recent turns retain full fidelity, while
earlier content is condensed. Tool execution context from recent turns is preserved so the
assistant remains accurate even in extended sessions.

If compaction fails for any reason, the conversation continues normally — no interruption
to the chat flow occurs.

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
