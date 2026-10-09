# Can I set tool output visibility through the CodeMie SDK?

Yes. The setting is exposed as the `hide_tool_outputs` boolean field on the assistant model in both the Python and Node.js SDKs, defaulting to `false`.

Set it on creation by passing `hide_tool_outputs=True` to `AssistantCreateRequest` (Python) or including `hide_tool_outputs: true` in the Node.js `create()` call. To change it on an existing assistant, pass the field explicitly to the update request — in the Python SDK, omitting the field from an update request leaves the stored value unchanged rather than resetting it to `false`. The field is also returned on the assistant detail response and on the assistant data attached to conversation messages.

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
