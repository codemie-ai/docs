# Can a sub-assistant ask for Allow or Deny before running a tool call?

Yes. A sub-assistant follows its **Tool Calls** policy the same way as a single assistant. With **Manual**, or with **Guarded** for write tools, the call waits and the **Allow** and **Deny** buttons appear inside the sub-assistant's step, under the orchestrator's delegation step.

After **Allow**, the call runs and the orchestrator finishes its reply. After **Deny**, the call does not run, the sub-assistant is told that it was denied, and both finish their turns. A customer-wide minimum policy applies to sub-assistants as well, and a waiting call stays open after the page is reloaded.

## Sources

- [Sub-Assistants and Orchestration](https://docs.codemie.ai/user-guide/assistants/sub-assistants-multi-assistant-orchestrator/)
