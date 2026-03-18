# How does A2A handle situations when the agent needs additional information?

According to the A2A protocol flow, when an agent needs more information:

1. CodeMie sends a task with user query to the A2A Server
2. If the agent has incomplete information, it requests additional input
3. The A2A Server sets state to "input-required"
4. CodeMie sends additional information
5. The A2A Server forwards it to the agent
6. The agent processes and returns the result

This allows A2A agents to have interactive conversations where they can ask clarifying questions before providing responses.

## Sources

- [A2A](https://docs.codemie.ai/user-guide/tools_integrations/tools/a2a)
