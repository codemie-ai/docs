# Why does my Cloud Jira or Confluence integration fail with a scoped Atlassian API token?

Scoped (granular) API tokens are a Cloud-only feature. Atlassian Cloud offers two kinds of API tokens, and each one requires a different **URL** value in the CodeMie integration. CodeMie sends requests to exactly the URL provided, so the URL and the token type must match.

- **Classic (unscoped)** token: use the site URL `https://<your-domain>.atlassian.net`.
- **Scoped** token (created with specific permissions): use the Atlassian API gateway URL — `https://api.atlassian.com/ex/jira/<your-cloud-id>` for Jira or `https://api.atlassian.com/ex/confluence/<your-cloud-id>` for Confluence.

To find the cloud ID, open `https://<your-domain>.atlassian.net/_edge/tenant_info` in a browser while signed in to Atlassian and copy the returned `cloudId` value. Self-hosted (Server/Data Center) instances do not use scoped tokens or the gateway URL — they always use the site URL with a personal access token.

## Sources

- [Jira](https://docs.codemie.ai/user-guide/tools_integrations/tools/jira)
- [Confluence](https://docs.codemie.ai/user-guide/tools_integrations/tools/confluence)
