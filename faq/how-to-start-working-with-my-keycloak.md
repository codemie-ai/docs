# How to start working with my Keycloak? How to integrate Keycloak with CodeMie?

To integrate Keycloak with CodeMie, follow the steps below:

1. In Keycloak select the realm which you want to manage.  
   1.1. Create a client or use an existing one e.g. (admin-cli).  
   1.2. Select the Settings tab.  
   1.3. On the Settings, set the following parameters:

- Capability config:
- Turn on Client authentication.
- Turn on Standard flow
- Turn on Direct access grants
- Turn on Service accounts roles

  1.4. Select the Service accounts roles tab and click **Assign role**.  
  1.5. Select role and click **Assign role: developer** and click **Assign.**  
  1.6. Select role and click **Assign role,** click filter and select **filter by clients** and click **Assign**:  
  view-users, query-users, manage-users, view-realm, view-identity-providers, impersonation, query-groups

  1.7. Select the **Credentials** tab and copy the **Client secret**.

2. In the CodeMie main menu, click the integrations button.  
   2.1. Select Integration Type: User or Project and click Create  
   2.2. In the new user setting menu, fill in the following parameters:

- Project Name: Select the name of your project.
- Credential Type: Keycloak.
- Alias: Alias is a representation of the user setting (e.g., Keycloak).
- Keycloak Base URL: Fill in the URL field. (e.g., [https://auth.example.com](https://keycloak.example.com/auth)).
- Keycloak Realm: Fill in the Realm from step 1.
- Keycloak Client ID: Fill in the Client ID from step 1.1.
- Keycloak Client Secret: Fill in the Token field with the token created from step 1.5.

  2.3. Click + Save.

3. Click Explore Assistant, Click Create Assistant fill in the following parameters::

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Access Management - Keycloak and select from drop down list Alias of credentials from step 2.2.

  3.1. Click Create.

4. Click Explore Assistant, select My Assistant and choose by Name your assistant, Enjoy.

Query Example: Get a list of users. Get a list of clients.

## Sources

- [Keycloak](https://docs.codemie.ai/user-guide/tools_integrations/tools/keycloak)
- [Keycloak Assistant](https://docs.codemie.ai/admin/configuration/access-control/user-provisioning/keycloak-assistant)
