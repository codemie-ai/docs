# How to start working with my Azure? How to integrate Azure with CodeMie?

To integrate Azure with CodeMie, follow the steps below:

1. In Azure:  
    1.1. In the search bar enter Subscription.  
    1.2. Click +Add or select the Subscription that already exists  
    1.3. Copy Subscription ID.  
   1.4. In the search bar enter App registrations.  
   1.5. Click + New registrations or select the application that already exists.  
   1.6. Copy Application Client ID.  
   1.7. Navigate Manage > Certificates & secrets > clients secrets.  
   1.8. Navigate Client secrets tab > Click + New client secret > Create Add.  
   1.9. Copy Secret ID and Value.
2. In the CodeMie main menu, click the Integrations button.
3. Select Integration Type: User or Project and click Create
4. Select the Project Name.
5. Select the Credential Type: Azure.
6. Fill in the Alias is a representation of the user setting.
7. Fill in the Subscription ID field with the values from step 1.3.
8. Fill in the Tenant ID field with the Application Client ID copied from step 1.6.
9. Fill in the Client ID field with the values from Secret ID 1.9.
10. Fill in the Client Secret field with the values from Value 1.9.
11. Click Create Integration.
12. Create or edit assistant.
13. Click Explore Assistant, Click Create Assistant fill in the following parameters:

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Cloud and select from drop down list Azure of credentials from step 7.

17. Click Create.

## Sources

- [Azure](https://docs.codemie.ai/user-guide/tools_integrations/tools/azure)
