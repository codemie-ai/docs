# Can I set tool output visibility through the CodeMie SDK?

Yes. The setting is exposed as the `hide_tool_outputs` boolean field on the assistant model in both the Python and Node.js SDKs, defaulting to `false`.

Set it on creation by passing `hide_tool_outputs=True` to `AssistantCreateRequest` (Python) or including `hide_tool_outputs: true` in the Node.js `create()` call. To change it on an existing assistant, use the **Hide tool outputs from end users** toggle in the UI, or load the assistant, change the field, and send the full configuration back. The SDK `update` methods replace the whole configuration, so sending only the required fields resets the assistant's tools, data sources, and conversation starters. Leaving `hide_tool_outputs` out of an update keeps the stored value, and `hide_tool_outputs=False` turns the setting off. The field is also returned on the assistant detail response and on the assistant data attached to conversation messages.

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
