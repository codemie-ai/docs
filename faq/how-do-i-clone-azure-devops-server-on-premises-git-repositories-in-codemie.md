# How do I clone Azure DevOps Server (on-premises) Git repositories in CodeMie?

When setting up a **Git** integration in CodeMie for an on-premises Azure DevOps Server, enable the **Use Header-Based Authentication** toggle in the credential form.

1. Go to **Integrations**, create or edit a **Git** integration.
2. Set **Authentication Type** to **Personal Access Token**.
3. Enable the **Use Header-Based Authentication** toggle.
4. Enter your PAT in the **Token** field. Leave **Token Name** blank — it is not used when header auth is enabled.
5. Save the integration.

CodeMie will encode your token using Base64 and send it via the `Authorization: Basic` HTTP header during git clone. The token is never embedded in the repository URL.

## Sources

- [Git AzureDevops Integration](https://codemie-ai.github.io/docs/user-guide/tools_integrations/tools/git-azuredevops)
