# When should I disable Automatic Credentials Lookup for a tool in an assistant?

Disable **Automatic Credentials Lookup** only when the assistant must always use one specific
integration regardless of who is running it — for example, a dedicated service account shared
by all users of the assistant.

Keep the toggle on in all other cases, especially for shared assistants. With automatic lookup
enabled, each user's integration is resolved at runtime using their own credentials, which
prevents one user's integration from being applied to another user's session.

:::warning
If the toggle is off and the selected integration belongs to a specific user, other users who
do not have access to that integration will not be able to use the tool.
:::

## Sources

- [Integrations — Automatic Credentials Lookup](https://docs.codemie.ai/user-guide/tools_integrations/integrations/integrations#automatic-credentials-lookup)
