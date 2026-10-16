# Does CodeMie support A2A protocol version 1.0?

Yes. CodeMie implements the Agent-to-Agent (A2A) protocol version 1.0 in both directions:
CodeMie can call external A2A agents as remote assistants, and any CodeMie assistant can be
called by an external A2A 1.0 client.

The earlier v0.3 protocol is not supported. Agents that serve only a legacy `agent.json` card or
whose Agent Card declares a pre-1.0 JSON-RPC interface are refused at registration. Bedrock
AgentCore runtimes are checked the same way and must serve a v1.0 Agent Card.
Every JSON-RPC request must carry the `A2A-Version: 1.0` header; requests without it are
rejected with error `-32009`.

## Sources

- [A2A Protocol](https://codemie-ai.github.io/docs/user-guide/tools_integrations/tools/a2a)
