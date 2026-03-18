# How do I create a Personal Access Token in Azure DevOps for CodeMie integration? What permissions does my Azure DevOps Personal Access Token need for CodeMie? Where can I find the Personal Access Tokens settings in Azure DevOps? How to create Azure DevOps GIT integration?

To integrate Version Control System Azure DevOps tool in CodeMie, follow the steps below:

1. Generate access token for Azure DevOps GIT:  
   1.1 Navigate to Personal Access Tokens
1. Log in to your Azure DevOps account
1. Click on your **profile icon** in the top-right corner
1. Select **User Settings** from the dropdown menu
1. In the left sidebar, navigate to **Security** → **Personal Access Tokens**  
   1.2 Create New Token. Click the **+ New Token** button. Fill in the token creation form:
   - **Name**: Enter a descriptive name (e.g., "CodeMie Integration Token")
   - **Organization**: Select your organization from the dropdown
   - **Expiration (UTC)**: Set expiration date.
   - **Scopes**: Select **Full access** for comprehensive integration

1.3 Generate and Save Token

1. Click the **Create** button
2. **IMPORTANT**: Immediately copy the generated token from the success dialog
3. Store the token securely - it will not be displayed again

4. In the CodeMie main menu, click the integrations button.
5. Select Integration Type: User or Project and click Create
6. Select the Project Name.
7. Select the Credential Type: Git.
8. Fill in the Alias is a representation of the user setting.
9. Fill in the URL field. For example: https://dev.azure.com.
10. Fill in the Token name field.
11. Fill in the Token field with the token created at step 1.
12. Click + Save.
13. Click Explore Assistant, select Templates and choose for example [Template] Coder.
14. Select your Project and type Name and Datasource Context.
15. Click Create.
16. Click Explore Assistant, select My Assistant and choose by Name your assistant.  
    Note: Tokens have an expiration date.

## Sources

- [Git Azuredevops](https://docs.codemie.ai/user-guide/tools_integrations/tools/git-azuredevops)
