---
id: client-secret-access
title: Client Secret Access
sidebar_label: Client Secret Access
sidebar_position: 1
---

# Creating Client Secret Credentials

This guide provides step-by-step instructions for creating and configuring a Keycloak client for CodeMie Client Secret integration.

:::note
You can use scripts to create and manage Client Secret clients in Keycloak: [Client Secret Script](https://gitbud.epam.com/epm-cdme/codemie-helm-charts/-/tree/main/keycloak-onboarding/scripts/keycloak_api_client)
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

| Field                    | Value            |
| ------------------------ | ---------------- |
| **Client Type**          | OpenID Connect   |
| **Client ID**            | api-demo-project |
| **Name**                 | api-demo-project |
| **Always Display in UI** | Off              |

Click **Next** to continue.

## Step 4: Configure Capability Config

| Field                     | Value |
| ------------------------- | ----- |
| **Client Authentication** | ON    |
| **Authorization**         | Off   |

**Authentication Flow:**

| Flow                                     | Value |
| ---------------------------------------- | ----- |
| **Standard flow**                        | On    |
| **Direct access grants**                 | On    |
| **Service accounts roles**               | On    |
| **Implicit flow**                        | Off   |
| **OAuth 2.0 Device Authorization Grant** | Off   |
| **OIDC CIBA Grant**                      | Off   |

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

1. After saving the client, click on the client `api-demo-project`
2. Navigate to the **Client Scopes** tab in the client settings
3. Click on **Add client scopes**
4. Select the `codemie` scope from the dropdown and set the assignment type to **Default**

## Step 7: Configure Service Accounts Roles

1. Navigate to the **Service accounts roles** tab in the client settings
2. Click on **Assign role** button
3. Choose: **Developer** (see only associated projects) or **Admin** (see all projects) role
4. Click on **Assign**

## Step 8: Configure Service Account User

1. Navigate to the **Service accounts roles** tab in the client settings
2. Click on `service-account-api-demo-project` link
3. Input **Email**: `api-demo-project@domain.com`
4. Input **First name**: `api-demo`
5. Input **Last name**: `project`
6. Click on the **Attributes** tab
7. Type **Key**: `applications` and **Values**: name of your project `demo-project`
8. Click **Save** button

:::info Notes

- E-mail, First name, Last name can be any values — the example is shown above. The important thing is that they must be provided.
- If you assigned the **Admin** role to the client in the previous step, there's no need to set any additional attributes.
  :::

## Step 9: Copy Secret Token

1. Click on the client `api-demo-project`
2. Click on **Credentials** tab
3. Copy **Client Secret**

Now you can use `api-demo-project` and Client Secret as credentials for Client Secret authorization.

## Step 10: Create Authorization Credentials

Prepare the following credentials to interact with CodeMie services using the Client Secret:

```bash
curl -X POST 'https://keycloak.example.com/auth/realms/codemie-prod/protocol/openid-connect/token' \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'client_id=<client-id>' \
  --data-urlencode 'grant_type=client_credentials' \
  --data-urlencode 'client_secret=<client-secret>'
```

**Response Example:**

```json
{
  "access_token": "<your-access-token>",
  "expires_in": 28500,
  "refresh_expires_in": 0,
  "token_type": "Bearer",
  "not-before-policy": 0,
  "scope": "profile email"
}
```

## Step 11: Using the Token

Once you have the JWT token, include it in the `Authorization` header of your requests to interact with the CodeMie API.

**Authorization Header:**

```
Authorization: Bearer <access_token>
```

---

## Troubleshooting

### Common Issues

| Issue                      | Solution                                                                                   |
| -------------------------- | ------------------------------------------------------------------------------------------ |
| **Invalid redirect URI**   | Ensure that all redirect URIs are correctly configured and match your application settings |
| **Authentication failure** | Verify that your realm name, client ID, and client secret are correct                      |
| **Scope issues**           | Make sure that the `codemie` scope is properly assigned to your client                     |
