# How to start working with my AWS cloud? How to integrate AWS cloud with CodeMie?

To integrate AWS cloud with CodeMie, follow the steps below:

1. In AWS cloud:  
    1.1. In the search bar enter IAM and click it.  
   1.2. Navigate Access management > Users.  
    1.3. Named and set permissions for that user and click Create.  
    1.4. Click on created user  
    1.5. Navigate to the Security credentials > access keys and click Create access key.  
    1.6. Select command line interface(CLI), add tag.  
    1.7. Copy Access key and Secret access key and click done.
2. In the CodeMie main menu, click the Integrations button.
3. Select Integration Type: User or Project and click Create
4. Select the Project Name.
5. Select the Credential Type: AWS.
6. Fill in the Alias is a representation of the user setting.
7. Fill in the Region field.
8. Fill in the Access Key ID field with the Access key copied from step 1.7.
9. Fill in the Secret Access Key field with the Secret access key copied from step 1.7.
10. Click Create Integration.
11. Create or edit assistant.
12. Click Explore Assistant, Click Create Assistant fill in the following parameters:

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Cloud and select from drop down list AWS of credentials from step 7.

13. Click Create.

Query Example: The query example depends on what permissions you give to this user.

## Sources

- [Aws](https://docs.codemie.ai/user-guide/tools_integrations/tools/aws)
