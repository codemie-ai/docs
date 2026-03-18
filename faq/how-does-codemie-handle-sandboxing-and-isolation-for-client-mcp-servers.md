# How does CodeMie handle sandboxing and isolation for client MCP Servers?

CodeMie employs a Kubernetes-based infrastructure, leveraging a pool of Kubernetes Pods to host client MCP Servers.

Each conversation initiated within CodeMie is provisioned with a dedicated and isolated set of MCP Servers. This isolation is achieved by running each set of MCP Servers within distinct operating system processes, ensuring complete separation between different conversations and users.

The allocated MCP Servers are cached specifically for a conversation and will automatically expire and be terminated after a defined period of inactivity. Should a user revisit the same conversation after the timeout period, a fresh set of MCP Servers is instantiated.

Consequently, even distinct conversations involving the same Assistant will operate within entirely separate MCP Server environments, preserving security, isolation, and efficient resource management.

## Sources

- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
