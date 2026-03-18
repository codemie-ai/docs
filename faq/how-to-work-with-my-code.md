# How to work with my code? Personal access token for repository? Required scopes for repository?

To integrate Version Control System tool in CodeMie, follow the steps below:

1. In Git generate access token for GitLab or GitHub account with the following rights:

Permissions for access token for GitHub integration:  
 repo:

- repo: status
- repo_deployment
- public repo
- repo:invite
- security_events

      project:

- read: project

Permissions for access token for Gitlab integration:

- api
- read_api
- read_repository
- write_repository

2. In the CodeMie main menu, click the integrations button.
3. Select Integration Type: User or Project and click Create
4. Select the Project Name.
5. Select the Credential Type: Git.
6. Fill in the Alias is a representation of the user setting.
7. Fill in the URL field. For example: [https://github.com](https://github.com).
8. Fill in the Token name field.
9. Fill in the Token field with the token created at step 1.
10. Click + Save.
11. Click Explore Assistant, select Templates and choose for example [Template] Coder.
12. Select your Project and type Name and Datasource Context.
13. Click Create.
14. Click Explore Assistant, select My Assistant and choose by Name your assistant.  
    Note: Tokens have an expiration date.

## Sources

- [Git Github Gitlab Bitbucket](https://docs.codemie.ai/user-guide/tools_integrations/tools/git-github-gitlab-bitbucket)
- [Git Overview](https://docs.codemie.ai/user-guide/tools_integrations/tools/git-overview)
