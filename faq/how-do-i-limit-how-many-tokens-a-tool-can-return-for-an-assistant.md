# How do I limit how many tokens a tool can return for an assistant?

Open the assistant configuration form and expand the **Extra configuration** section, where the **Limit Tool Output Tokens** field appears alongside **LLM model**, **Temperature**, and **Top P**. Enter a positive whole number and save the assistant. The value is applied as a single, assistant-wide cap on every tool's output and is retained when the assistant is edited again.

To remove the cap, clear the field and save. With no value set, each tool falls back to its own default output limit.

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant#limit-tool-output-tokens)
