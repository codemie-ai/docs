# How to create Azure DevOps integration? How to work with Azure Devops? How to work with Azure Devops Wiki ?

1. The user must have an active Azure DevOps account with access to at least one repository.
2. The user must have the necessary permissions (clone, create pull requests, etc.) for operations on Azure DevOps repositories.
3. CodeMie must securely handle and store Azure DevOps credentials.

2.1. In the new user setting menu, fill in the following parameters:

- Project Name: Select the name of your project.
- Credential Type: AzureDevOps.
- Alias: Alias is a representation of the user setting.
- URL: Fill in the URL field. (e.g., https://dev.azure.com).
- Project Name: Fill in the field.
- Organization Name: Fill in the field.
- Personal Access token: Fill in the Token field with the token created from step 3.

  2.2. Click + Save.

3. Click Explore Assistant, Click Create Assistant fill in the following parameters::

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Cloud - Azure Devops and select from drop down list Alias of credentials from step 2.1.

  3.1. Click Create.

4. Click Explore Assistant, select My Assistant and choose by Name your assistant, Enjoy.

## Scenarios of Use:

Cloning a Repository: User is able to add new code datasource from Azure DevOps repo (by providing integrations credentials first)

Creating a Pull Request: User asks Assistant to 'Create Pull Request'. The user fills in the necessary details (source branch, target branch, title, description) and submits the request.

Monitoring Build Pipelines: User asks Assistant to 'Build Pipelines' section to view the current status of pipelines.

Query Example: Please create a pull request.

### 1.2.34. How to start working with my Sonar? How to integrate sonar with CodeMie? How can I test if my Sonar integrations is working correctly?

To integrate Sonar with CodeMie, follow the steps below:

## Preconditions of Use:

- The SonarQube server must be operational and accessible.

1. In Sonar generate access token:

- Click on your profile in the right upper corner.
- Click by security in the navigation bar.
- Type Name of token.
- Select Type of token.
- Select Project name.
- Select Expires in of token (by default 30 days).
- Click the Generate button.

2. Click on the Copy button.
3. In the CodeMie main menu, click the integrations button.
4. Select Integration Type: User or Project and click Create
5. Select the Project Name.
6. Select the Credential Type: Sonar.
7. Fill in the Alias is a representation of the user setting.
8. Fill in the URL field. For example: [https://sonar.com](https://jiraeu.epam.com/) or [https://sonar.example.com](https://jiraeu.epam.com/jira/) .
9. Fill in the Token field with the API Token copied at step 2.(Optional) you can verify that webhook works properly by clicking the test button
10. Fill in the Project field name of the project name inside the sonar.
11. Click + Save.
12. Create or edit assistant.
13. Click on Codebase Tools and Sonar
14. Align System Instructions for work with your project.
15. Click Create/Update.
16. Click Explore Assistant, select My Assistant and choose by Name your assistant.

Query Example: Please get me code smells. How to fix all issues in this project?

## Sources

- [Git Azuredevops](https://docs.codemie.ai/user-guide/tools_integrations/tools/git-azuredevops)
