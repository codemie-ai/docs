# How do I connect my own GitLab, Jira, or Confluence account to a shared OAuth integration?

When a project integration for GitLab, Jira, or Confluence is configured with OAuth 2.0
(instead of a shared Personal Access Token), each team member must authorize under their
own account before the integration can be used in chat.

There are two ways to connect:

**At integration create time** — if creating a new integration with the "Use OAuth 2.0
sign-in" toggle enabled, a Sign-in button appears in the form. Click it, complete the
authorization in the popup, and then save the integration. A completed sign-in is required
before the Save button becomes active.

**From the chat on first use** — if a run starts and the integration is not yet connected
for the current member, a "Connect your `<provider>` account" prompt appears in the chat
with a Sign-in button. Click Sign in, authorize in the popup, and then resend the message
that triggered the prompt. The run retries with the newly connected account.

In both cases the authorization is per-user: the token stored is the member's own and is
not shared with any other project member. The OAuth application credentials
(`client_id` / `client_secret`) are configured once by an administrator and are invisible
to regular members.

If the OAuth sign-in option is not visible in the integration form, the platform
administrator has not yet enabled that provider's OAuth flag
(`GITLAB_OAUTH_ENABLED`, `JIRA_OAUTH_ENABLED`, or `CONFLUENCE_OAUTH_ENABLED`).

## Sources

- [Jira Integration](https://docs.codemie.ai/user-guide/tools_integrations/tools/jira)
- [Confluence Integration](https://docs.codemie.ai/user-guide/tools_integrations/tools/confluence)
- [GitHub/GitLab/Bitbucket Integration](https://docs.codemie.ai/user-guide/tools_integrations/tools/git-github-gitlab-bitbucket)
- [OAuth Integration Setup (Admin)](https://docs.codemie.ai/admin/configuration/oauth-integrations)
