# How does CodeMie maintain conversation context across turns?

When a follow-up request is sent within the same conversation, the platform replays the
full conversation history from persisted data, including prior tool execution activity.
The replayed context includes: tool names, inputs, outputs (or summarized outputs when
outputs are large), and success or failure state for each tool call. Skill and loaded
context from earlier turns is also preserved, so the assistant can reuse already-loaded
instructions without reloading them unnecessarily.

This means the assistant can reason about what was already done in the conversation and
build accurate follow-up responses without repeating completed steps.

If a tool call in a prior turn failed or was interrupted, that failure is also visible
to the assistant in the replayed history, allowing it to reason about the error and
choose an alternative or corrected approach.

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
