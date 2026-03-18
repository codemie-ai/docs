# How to start working with my Bitbucket? How to integrate Bitbucket with CodeMie? Can I create pull requests with my feat with codemie ?

To integrate Bitbucket with CodeMie, follow the steps below:

1. In Bitbucket generate access token:  
   1.1. Click settings(gears icon) in the right upper corner.  
   1.2. Click on Personal Bitbucket settings.  
   1.3. Click App passwords in the left navigation bar.  
   1.4. Click Create app password.  
   1.5. Fill the Label field and choose permission and click create.
2. Copy New app password and click close.
3. In the CodeMie main menu, click the integrations button.
4. Select Integration Type: User or Project and click Create
5. Select the Project Name.
6. Select the Credential Type: Git.
7. Fill in the Alias is a representation of the user setting.
8. Fill in the URL field. For example: https://bitbucket.org .
9. Fill in the Token name field with the bitbucket account name.
10. Fill in the Token field with the API Token copied at step 2.
11. Click Create Integration.
12. Click +Add Datasource:
13. Select the Project Name.
14. The Data Source name is a representation name.
15. Fill the Description field.
16. Fill the Repository Link.
17. Fill the Branch name.
18. Click Add.
19. Create or edit assistant.
20. Click Explore Assistant, Click Create Assistant fill in the following parameters::

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Datasource Context: Select from drop down list Data Source name from step 14.
- Available tools: Git and select from drop down list Alias of credentials from step 7.

  3.1. Click Create.

Query Example: List branches. Create a pull request. List all pull requests.

## Sources

- [Git Github Gitlab Bitbucket](https://docs.codemie.ai/user-guide/tools_integrations/tools/git-github-gitlab-bitbucket)
