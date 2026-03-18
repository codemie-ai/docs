# How to start working with my Jira? How to integrate Jira with CodeMie?

To integrate Jira with CodeMie, follow the steps below:

1. In Jira generate access token:

- Click on your profile in the right upper corner.
- Click by API Token Authentication.
- Click New API Token.
- Click Create API Token.

2. In the CodeMie main menu, click the integrations button.
3. Select Integration Type: User or Project and click Create
4. Select the Project Name.
5. Select the Credential Type.
6. Fill in the Alias is a representation of the user setting.
7. Fill in the URL field. For example: [https://jiraeu.epam.com/](https://jiraeu.epam.com/) or [https://jiraeu.epam.com/jira/](https://jiraeu.epam.com/jira/) .
8. Fill in the Token field with the API Token created at step 1.
9. Click + Save.
10. Click Explore Assistant, select Templates and choose for example CodeMie Feedback.
11. Select your Project, switch Global (visible for all projects) to off and type Name and select Alias name from Project Management - Generic Jira the drop down list.
12. Align System Instructions, Jira API Context for work with your project.
13. Click Create.
14. Click Explore Assistant, select My Assistant and choose by Name your assistant.  
    Note: The project name must be specified without dash (-) since it is indicated in brackets in Jira Projects. Tokens have an expiration date.

## Sources

- [Jira](https://docs.codemie.ai/user-guide/tools_integrations/tools/jira)
- [Add Jira Data Source](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-jira-data-source)
