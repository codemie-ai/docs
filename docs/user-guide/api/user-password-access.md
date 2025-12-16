---
id: user-password-access
title: User Password Access
sidebar_label: User Password Access
sidebar_position: 2
---

# Creating Client Password (Python, NodeJS) Credentials

This guide provides step-by-step instructions for creating and configuring a Keycloak client for CodeMie Client Password integration.

:::note
You can use scripts to create and manage User Password clients in Keycloak: [User Password Script](https://gitbud.epam.com/epm-cdme/codemie-helm-charts/-/tree/main/keycloak-onboarding/scripts/keycloak_sdk)
:::

---

## Prerequisites

- Administrator access to Keycloak

---

## Step 1: Access the Keycloak Admin Console

1. Log into the Keycloak admin console with your administrator credentials
2. Select the appropriate realm from the dropdown in the top-left corner (e.g., `codemie-prod`)

## Step 2: Navigate to the Clients Section

1. In the left sidebar menu under "Manage", click on **Clients**
2. Click the **Create client** button to start the client creation process

## Step 3: Configure General Settings

| Field                    | Value          |
| ------------------------ | -------------- |
| **Client Type**          | OpenID Connect |
| **Client ID**            | codemie-sdk    |
| **Name**                 | CodeMie SDK    |
| **Always Display in UI** | Off            |

Click **Next** to continue.

## Step 4: Configure Capability Config

| Field                     | Value |
| ------------------------- | ----- |
| **Client Authentication** | Off   |
| **Authorization**         | Off   |

**Authentication Flow:**

| Flow                                     | Value |
| ---------------------------------------- | ----- |
| **Standard flow**                        | On    |
| **Direct access grants**                 | On    |
| **Implicit flow**                        | Off   |
| **OAuth 2.0 Device Authorization Grant** | Off   |

Click **Next** to proceed.

## Step 5: Configure Login Settings

| Field                               | Value                           |
| ----------------------------------- | ------------------------------- |
| **Root URL**                        | `https://codemie.example.com`   |
| **Home URL**                        |                                 |
| **Valid Redirect URIs**             | `https://codemie.example.com/*` |
| **Valid Post Logout Redirect URIs** | +                               |
| **Web Origins**                     | `https://codemie.example.com`   |

Click **Save** to create the client.

:::warning Important Note
Make sure to replace the example URLs with your actual CodeMie domain URLs in a production environment.
:::

## Step 6: Configure Client Scopes

1. After saving the client, click on the client `codemie-sdk`
2. Navigate to the **Client Scopes** tab in the client settings
3. Click on **Add client scopes**
4. Select the `codemie` scope from the dropdown and set the assignment type to **Default**

## Step 7: Add to User Password Authorization

1. In the left sidebar menu under **Manage**, click on **Users**
2. Select an existing user or create a new user
3. Go to the **Credentials** tab
4. Click on the **Set Password** button
5. Enter the password and confirm it
6. Set **Temporary** to **Off**
7. Click **Save** to proceed

## Step 8: Create Authorization Credentials

Prepare the following credentials to interact with CodeMie services using the SDK:

```bash
codemie_api_domain=https://codemie.example.com/code-assistant-api
username=<your-username>
password=<your-password>
auth_client_id=codemie-sdk
auth_realm_name=codemie-prod
auth_server_url=https://keycloak.example.com/auth
verify_ssl=false
```

## Step 9: Start Using CodeMie

You can now interact with CodeMie services such as LLMs, assistants, workflows, and tools using the Python or NodeJS SDK. Follow the SDK documentation for integration details.

---

## Troubleshooting

### Common Issues

| Issue                      | Solution                                                                                   |
| -------------------------- | ------------------------------------------------------------------------------------------ |
| **Invalid redirect URI**   | Ensure that all redirect URIs are correctly configured and match your application settings |
| **Authentication failure** | Verify that your realm name, client ID, and user credentials are correct                   |
| **Scope issues**           | Make sure that the `codemie` scope is properly assigned to your client                     |
