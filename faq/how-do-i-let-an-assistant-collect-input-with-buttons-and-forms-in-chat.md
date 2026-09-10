# How do I let an assistant collect input with buttons and forms in chat?

Enable it on the assistant, then tell the assistant to use it:

1. Open the assistant for editing and expand the **Interactive features** block.
2. Turn on **Enable interactive features** and save.
3. In the system instructions, state that input should be requested with an interactive form when
   the possible answers are known in advance.

The switch only grants the capability — the assistant decides when to use it, so without an
instruction it may keep asking in prose. Note that showing a form ends the assistant's turn: the
answer arrives as the next message in the conversation.

If the **Interactive features** block is not present in the assistant form, the platform-level
`features:interactiveElements` flag is disabled for the deployment and an administrator has to
enable it.

## Sources

- [Interactive Chat Elements](https://docs.codemie.ai/user-guide/assistants/interactive-elements)
- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
