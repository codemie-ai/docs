# What is the difference between URL-based and header-based authentication for Git in CodeMie?

CodeMie supports two ways to authenticate during git clone operations:

| Method                  | How it works                                                                              | When to use                                              |
| ----------------------- | ----------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| **URL-based** (default) | Credentials are embedded directly in the clone URL as `https://token_name:token@host/...` | Azure DevOps Services (cloud), GitHub, GitLab, Bitbucket |
| **Header-based**        | Token is Base64-encoded and sent via the `Authorization: Basic` HTTP header               | Azure DevOps Server (on-premises)                        |

On-premises Azure DevOps Server installations typically reject URL-embedded credentials. Use the **Use Header-Based Authentication** toggle in the **Git** credential form (visible when Authentication Type is **Personal Access Token**) to switch to header-based auth.

## Sources

- [Git AzureDevops Integration](https://codemie-ai.github.io/docs/user-guide/tools_integrations/tools/git-azuredevops)
