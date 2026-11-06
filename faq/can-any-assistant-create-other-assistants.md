# Can any assistant create other assistants? What are Platform Tools?

Yes. **Platform Tools** is a built-in toolkit, requiring no integration or credentials, that
can be enabled on any assistant from **Available Tools**. It includes three tools — Get
Assistant Creation Options, Create Assistant, and Test Assistant — that let that assistant
discover what's available in a project and create (and optionally test) a new assistant on
request, using the requesting user's own permissions.

This is the same underlying capability as the **Assistant Creator** marketplace skill; Platform
Tools makes it available directly on any assistant, instead of through that dedicated skill.

An assistant is never created without explicit confirmation: the draft is shown first, and
creation only happens once `CONFIRM CREATE` — returned with the draft — is sent back verbatim
by the user in a later interactive chat message, within five minutes. Missing credentials for
selected tools block creation until the integrations are configured or those tools are removed.

Platform Tools also includes analytics tools (conversation metrics, spending, and usage
insights); two of these are restricted to admin users.

## Sources

- [Platform Tools](https://docs.codemie.ai/user-guide/tools_integrations/tools/platform-tools)
- [Create an Assistant with the Assistant Creator Skill](https://docs.codemie.ai/user-guide/assistants/assistant-creator-skill)
