# Can I use a GitHub App instead of a Personal Access Token for Git integration?

Yes. When creating or editing a Git integration in CodeMie, you can choose between two authentication methods from the **Authentication Type** dropdown:

- **Personal Access Token** — uses a GitHub/GitLab PAT or a Bitbucket App Password.
- **GitHub Application** — uses a GitHub App with App ID, Private Key, and an optional Installation ID.

GitHub App authentication is available for GitHub and provides stronger, organization-level security compared to PATs. GitLab and Bitbucket integrations continue to use Personal Access Token only.

To use a GitHub App, you need to create a GitHub App in your account or organization, generate a private key, install the App on the target repositories, and then enter the App ID, private key contents, and Installation ID in the CodeMie integration form.

## Sources

- [GitHub/GitLab/Bitbucket Integration](https://codemie-ai.github.io/docs/user-guide/tools_integrations/tools/git-github-gitlab-bitbucket)
