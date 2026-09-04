# What can an Invoker do in CodeMie?

An **Invoker** is the least-privileged, run-only role. An Invoker can chat with assistants shared with their projects, run shared workflows, clone Marketplace assistants into their personal project, keep a full conversation history, and create personal integrations for the credential types those assistants need.

An Invoker cannot view or edit any assistant or workflow configuration (not even the system prompt), change the LLM model in a chat, create or edit assistants, workflows, skills, or data sources, share conversations, or open administration and analytics screens. The interface is reduced to a chat-first layout, and the backend rejects any request outside the allowed set with **Access denied**. Every Invoker action is recorded in the audit trail.

## Sources

- [Invoker Role](https://docs.codemie.ai/user-guide/project-user-management/invoker-role/)
- [CodeMie Roles Overview](https://docs.codemie.ai/admin/security/roles-rbac/)
