# How to Create a Client in Keycloak for SDK? How to prepare SDK with keycloak?

## 1. Access the Keycloak Admin Console

- Log in to the Keycloak admin console with your administrator credentials
- Select the appropriate realm from the dropdown in the top-left corner ("codemie-prod")

## 2. Navigate to Clients Section

- In the left sidebar menu under "Manage", click on "Clients"
- Click the "Create client" button to start the client creation process

## 3. Configure General Settings

- Client type: Select "OpenID Connect" from the dropdown menu
- Client ID: "codemie-sdk"
- Name: “CodeMie SDK"
- Always display in UI: Off
- Click "Next" to continue

## 4. Configure Capability Settings

- Set the appropriate capability configuration based on your requirements:
  - Client authentication: Off
  - Authorization: Off
  - Authentication flow:
  - Standard flow: Enable
  - Direct access grants: Enable
- Click "Next" to proceed

## 5. Configure Login Settings

- Root URL: “[https://codemie.example.com](https://codemie.example.com)”
- Home URL: “[https://codemie.example.com](https://codemie.example.com)”
- Valid redirect URIs: “[https://codemie.example.com](https://codemie.example.com)/\*”
- Valid post logout redirect URIs: “+”
- Web origins: URLs “[https://codemie.example.com](https://codemie.example.com)/\*”
- Click "Save" to create the client

6. Configure [Client scopes](https://keycloak.eks-core.aws.main.edp.projects.epam.com/auth/admin/master/console/#/codemie-prod/clients/52477e97-cad1-47c4-a859-7c69bb6112e0/clientScopes)

- After saving the client
- Click on the client "codemie-sdk"
- Click on the "Client scopes" tab in the client settings
- Click on the "Add client scopes"
- Select the “codemie” scope from the dropdown and set the assignment type (Default)

7. Add to user password authorization:

- In the left sidebar menu under "Manage", click on "Users"
- Click on the existing “User” or create “new”
- Click on the "Credentials" tab in the client settings
- Click on “Set password” button
- Password: set password
- Password confirmation: repeat password
- Temporary: Off
- Click "Save" to proceed

8. From now you can create authorization credentials:

codemie_api_domain=https://codemie.example.com/code-assistant-api

username=\<username>

password=\<password>

auth_client_id=codemie-sdk

auth_realm_name=codemie-prod

auth_server_url=https://auth.example.com

verify_ssl=false

Now you can proceed with that guide [https://gitbud.epam.com/epm-cdme/codemie-sdk/-/tree/main/sdk](https://gitbud.epam.com/epm-cdme/codemie-sdk/-/tree/main/sdk)

Python SDK for CodeMie services. This SDK provides a comprehensive interface to interact with CodeMie services, including LLM (Large Language Models), assistants, workflows, and tools.

## Sources

- [Keycloak Assistant](https://docs.codemie.ai/admin/configuration/access-control/user-provisioning/keycloak-assistant)
- [Client Secret Access](https://docs.codemie.ai/user-guide/api/client-secret-access)
