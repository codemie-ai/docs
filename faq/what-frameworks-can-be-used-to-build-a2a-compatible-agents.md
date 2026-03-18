# What frameworks can be used to build A2A-compatible agents?

A2A is framework-agnostic. You can connect agents built with:

- LangGraph
- LangChain
- CrewAI
- Any other framework supporting A2A protocol

The key requirement is that the agent must expose HTTP endpoints and implement the A2A protocol specification using JSON-RPC 2.0 over HTTP/HTTPS.

## Sources

- [A2A](https://docs.codemie.ai/user-guide/tools_integrations/tools/a2a)
