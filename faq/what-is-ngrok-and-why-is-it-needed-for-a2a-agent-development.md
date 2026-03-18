# What is ngrok and why is it needed for A2A agent development?

ngrok is a tunneling tool used to expose localhost agents publicly during development. For local A2A agent development:

- CodeMie must be able to access the agent URL
- Local agents run on localhost and are not publicly accessible
- ngrok creates a public URL that forwards to your local agent
- Run your agent with: uv run . --ngrok_enabled
- ngrok provides a URL like: https://easily-trasnocheoic-externally.ngrok-free.dev

For production agents, deploy to publicly accessible URLs with HTTPS instead of using ngrok.

## Sources

- [A2A](https://docs.codemie.ai/user-guide/tools_integrations/tools/a2a)
