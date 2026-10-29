# How do I create an assistant with the Assistant Creator skill?

**Assistant Creator** is a public marketplace skill, pre-published on every AI/Run CodeMie
instance, that builds an assistant through conversation instead of the configuration form.

1. Start or open a chat with any assistant.
2. Click the **Skills** button in the chat input field.
3. In the **Attach Skills** modal, search for `assistant-creator`, select it from the list,
   then click **Confirm**. Searching for `assistant` or `creator` also works.
4. Describe the assistant to create — for example, "an assistant that reviews pull requests
   against our coding standards."
5. Answer any follow-up questions about the project, purpose, or required tools.
6. Review the proposed configuration (name, description, system instructions, model, tools,
   and data sources). No assistant is created yet; a temporary draft is saved for approval.
7. Send `CONFIRM CREATE` back verbatim within five minutes (a plain "yes" is not enough) to create the
   assistant.
8. Optionally ask for a single test exchange within 24 hours of creation.

Missing credentials block creation. Configure the missing integrations or remove the affected
tools before proceeding. Credentials are checked before approval is issued and again before it
is used. A failed check does not consume an existing approval. Approval payloads are cleared
when used or replaced; expired drafts are removed by periodic cleanup.

If the requested project is unavailable, creation stops and the assistant suggests up to 20
accessible projects. Ask to narrow the suggestions if more projects are available.

The created assistant is private by default; sharing it with a project follows the normal
assistant-sharing process.

## Sources

- [Create an Assistant with the Assistant Creator Skill](https://docs.codemie.ai/user-guide/assistants/assistant-creator-skill)
