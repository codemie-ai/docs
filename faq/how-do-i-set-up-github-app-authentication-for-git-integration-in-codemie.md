# How do I set up GitHub App authentication for Git integration in CodeMie?

To use a GitHub App for Git integration in CodeMie:

1. **Create a GitHub App** in your GitHub account or organization: go to **Settings → Developer settings → GitHub Apps → New GitHub App**. Set the required repository permissions (Contents: Read & Write, Pull requests: Read & Write, Metadata: Read) and note the **App ID** after creation.

2. **Generate a private key**: on the App settings page, scroll to **Private keys** and click **Generate a private key**. A `.pem` file will be downloaded — open it and copy the full contents including the `-----BEGIN` and `-----END` lines.

3. **Install the GitHub App** on the organization or repositories that CodeMie needs access to: go to **Settings → Developer settings → GitHub Apps → Edit → Install App**. After installation, note the **Installation ID** from the URL (e.g., `https://github.com/settings/installations/12345678`). The Installation ID is optional — CodeMie auto-detects it if left blank.

4. **Create the integration in CodeMie**: go to **Integrations → + Create**, set **Credential Type** to **Git**, enter a URL (e.g., `https://github.com`), select **GitHub Application** as the **Authentication Type**, and fill in the App ID, private key, and Installation ID.

## Sources

- [GitHub/GitLab/Bitbucket Integration](https://codemie-ai.github.io/docs/user-guide/tools_integrations/tools/git-github-gitlab-bitbucket)
