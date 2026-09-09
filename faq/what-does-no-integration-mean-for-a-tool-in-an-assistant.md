# What does "No integration" mean for a tool in an assistant?

It means the tool's integration slot carries no credentials at all. The assistant author sets this by turning **Automatic Credentials Lookup** off and leaving the integration dropdown empty — a deliberate state, not an unfinished one. The slot shows **No integration**, nothing is looked up automatically, and the tool reports the missing integration when it is called instead of quietly disappearing from the assistant.

An integration slot has three possible author decisions: automatic lookup on (each user runs under their own integration of that type), an integration pinned by the author (applied to everyone, not selectable by users), or lookup off with nothing pinned (**No integration**).

You can still pick an integration yourself for any slot the author did not pin, in the **Your Integration Settings** section on the assistant page or in the assistant panel on a workflow execution. Your own choice — including an explicit **No integration** — is remembered and is never replaced by automatic lookup on the next run.

## Sources

- [Automatic Credentials Lookup](https://docs.codemie.ai/user-guide/tools_integrations/integrations/#automatic-credentials-lookup)
- [MCP Integration Credentials](https://docs.codemie.ai/user-guide/tools_integrations/tools/mcp/mcp-integration-credentials)
