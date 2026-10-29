# How do I build an A2A-compatible agent for CodeMie?

An A2A-compatible agent needs three things: a JSON-RPC endpoint that implements A2A protocol 1.0,
an Agent Card served at `/.well-known/agent-card.json`, and a structure that separates agent logic
from protocol handling.

The recommended pattern uses an _executor_ class in `__main__.py` that receives the A2A request,
extracts text input via `context.get_user_input()`, calls the existing agent logic, and emits
the result as either a `message` (for short non-streaming answers) or a `task` with artifact events
(for streaming or multi-part results). The agent logic itself contains no A2A types.

For streaming agents, events must be emitted in order: task (`TASK_STATE_SUBMITTED`), artifact
updates, and a final status update with a terminal state. The stream must always end in a terminal
state — there is no separate `final` flag in A2A 1.0.

The `supportedInterfaces[].url` field in the Agent Card must be an address reachable from the
CodeMie process. When running on a Docker network, use a container hostname rather than `0.0.0.0`.

Reference implementations using the `a2a-sdk` 1.x are available in the
[ai-run-demo-agents](https://github.com/epam-gen-ai-run/ai-run-demo-agents) repository:
`python/agents/text-insights-agent` (non-streaming) and `python/agents/howto-guide-agent` (streaming).

## Sources

- [Building A2A-Compatible Agents](https://codemie-ai.github.io/docs/user-guide/tools_integrations/tools/a2a-building-agents)
- [A2A Protocol](https://codemie-ai.github.io/docs/user-guide/tools_integrations/tools/a2a)
