# What is the Automatic Credentials Lookup toggle in the assistant form?

When adding a tool to an assistant, each tool with at least one configured integration shows
an **Automatic Credentials Lookup** toggle.

When the toggle is **on** (the default), CodeMie automatically selects the integration to use
based on a fixed priority: User Integration first, then User Global Integration, then Project
Integration. The integration dropdown is hidden — no manual selection is required.

When the toggle is **off**, a specific integration must be selected from the dropdown. In this
case, other users of the assistant may not have access to that integration.

Leaving the toggle on is recommended for shared assistants, because each team member will then
use their own credentials automatically.

## Sources

- [Integrations — Automatic Credentials Lookup](https://docs.codemie.ai/user-guide/tools_integrations/integrations/integrations#automatic-credentials-lookup)
- [Integrations — How the Default Integration Is Selected](https://docs.codemie.ai/user-guide/tools_integrations/integrations/integrations#how-the-default-integration-is-selected)
