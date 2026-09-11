# Why does my assistant ask in plain text instead of showing a form?

Interactive elements require four conditions at once, and the assistant falls back to plain text if
any of them is missing:

1. The platform-level `features:interactiveElements` flag is enabled for the deployment.
2. **Interactive features** is switched on for that specific assistant.
3. The request runs on a streaming execution path.
4. The chat client can render interactive elements.

The last condition is the most common cause when everything looks correctly configured. A browser
tab left open across a platform upgrade, or a client such as an IDE integration, does not declare
support and therefore receives no form — reloading the chat resolves the stale-tab case.

If the configuration is correct and the client is current, check the system instructions: the
assistant is free to answer in prose unless it is told to prefer interactive forms.

## Sources

- [Interactive Chat Elements](https://docs.codemie.ai/user-guide/assistants/interactive-elements)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
