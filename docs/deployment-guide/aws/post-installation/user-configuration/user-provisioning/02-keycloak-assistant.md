---
id: keycloak-assistant
sidebar_position: 3
title: 'Option B: Keycloak Assistant'
sidebar_label: Keycloak Assistant
description: Bulk user creation using the AI/Run CodeMie Keycloak Manager assistant
---

# Option B: Create Users with the Keycloak Assistant

For creating users or managing them programmatically, you can use the AI/Run CodeMie `Keycloak Manager`. This is a powerful system agent that interacts directly with your Keycloak instance.

The process involves a one-time setup to create a secure connection, followed by instructions on how to use the assistant.

## Prerequisites

Before you begin, ensure you meet the following requirements:

1. **Platform Administrator:** You must have a fully configured administrator account. If you do not have one, please complete [Option A: Create Users Manually](./manual-creation) and then all the steps in [Part 2: User Authorization](../user-authorization/assign-roles) before proceeding.

2. **Repository Access:** You must have access to the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository.

## Keycloak Assistant Setup

The Keycloak Assistant is disabled by default. First, you need to enable it.

#### 1. Locate the `codemie-api/values-<cloud>.yaml` file for your environment.

#### 2. Inside this file, find the `preconfigured_assistants` section within the `codemie-custom-customer-config` ConfigMap definition.

#### 3. Set `enabled: true` for the `keycloak-manager` assistant, as shown below:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-custom-customer-config
    data:
      customer-config.yaml: |
        ---
        # ... other components
        preconfigured_assistants:
          # ... other assistants
          - id: "keycloak-manager"
            settings:
              enabled: true
          # ... other assistants
```

#### 4. Apply the configuration change by redeploying the `codemie-api`:

```bash
bash helm-charts.sh --cloud <cloud> --version x.y.z --mode recommended
```

#### 5. Restart the `codemie` deployment to apply the changes immediately:

```bash
kubectl rollout restart deployment/codemie -n codemie
```

#### 6. Create a secret in a `oauth2-proxy` namespace:

```bash
kubectl create secret generic keycloak-assistant \
    --namespace=oauth2-proxy \
    --from-literal=client-id="keycloak-assistant" \
    --from-literal=client-secret="$(openssl rand -base64 12)" \
    --type=Opaque
```

#### 7. Add the following `KeycloakClient` object to the `oauth2-proxy` chart `values-<cloud>.yaml`:

```yaml
extraObjects:
  - apiVersion: v1.edp.epam.com/v1
    kind: KeycloakClient
    metadata:
      name: keycloak-assistant
      annotations:
        edp.epam.com/preserve-resources-on-deletion: 'true'
    spec:
      advancedProtocolMappers: true
      clientAuthenticatorType: client-secret
      secret: '$keycloak-assistant:client-secret'
      clientId: keycloak-assistant
      defaultClientScopes:
        - profile
        - email
        - codemie
      enabled: true
      directAccess: false
      fullScopeAllowed: true
      protocolMappers:
        - config:
            access.token.claim: 'false'
            claim.name: roles
            id.token.claim: 'true'
            multivalued: 'true'
            userinfo.token.claim: 'true'
          name: roles
          protocol: openid-connect
          protocolMapper: oidc-usermodel-realm-role-mapper
      realmRef:
        kind: KeycloakRealm
        name: codemie-prod
      standardFlowEnabled: true
      serviceAccount:
        enabled: true
        realmRoles:
          - default-roles-codemie-prod
        clientRoles:
          - clientId: realm-management
            roles:
              - manage-clients
              - manage-events
              - manage-identity-providers
              - create-client
              - manage-authorization
              - manage-realm
              - manage-users
              - query-clients
              - query-groups
              - query-realms
              - query-users
              - realm-admin
              - view-authorization
              - view-clients
              - view-events
              - view-identity-providers
              - view-realm
              - view-users
```

#### 8. Apply the configuration change by redeploying the `oauth2-proxy` chart:

```bash
bash helm-charts.sh --cloud <cloud> --version x.y.z --mode recommended
```

#### 9. Restart the `oauth2-proxy` deployment:

```bash
kubectl rollout restart deployment/oauth2-proxy -n oauth2-proxy
```

#### 10. As a platform admin, open the AI/Run CodeMie UI and navigate to the `Integrations` tab.

![Integrations Tab](../../../images/user-configuration/image-2025-9-17_10-15-44.png)

#### 11. Click the `Create` button in the top right corner and select `Create Project Integration`.

![Create Integration](../../../images/user-configuration/image-2025-9-17_10-16-37.png)

#### 12. Fill in the required fields:

- **Project:** `codemie`

:::info
**Note:** The `codemie` project is pre-existing. You do not need to create it. Simply start typing "cod" in the field, and it will appear in the dropdown list.
:::

- **Type:** `Keycloak`

- **Alias:** `keycloak-assistant`

- **URL:** `https://keycloak.example.com`

:::note
Pay attention that newer Keycloak versions might not include the `/auth` path in their endpoint URL.
:::

- **Realm:** `codemie-prod`

- **ClientID:** `keycloak-assistant`

- **ClientSecret:** _(Paste the secret here)_

:::info
**To get the ClientSecret, run this command:**
`kubectl get secret keycloak-assistant -n oauth2-proxy -o jsonpath="{.data.client-secret}" | base64 --decode`
:::

![Integration Configuration](../../../images/user-configuration/image-2025-9-17_10-18-27.png)

#### 13. Click the `Create` button to save the integration.

## Keycloak Assistant Usage

The process of using the assistant involves three main stages: initiating the chat, creating the users, and then setting their initial passwords in Keycloak.

#### 1. Start a Chat with the Keycloak Manager

Navigate to the **Assistants** tab and click the **Start chat** button for the `Keycloak Manager`.

![Start Chat](../../../images/user-configuration/image-2025-9-17_10-44-43.png)

#### 2. Create Users with a Prompt

First, verify the connection with a simple prompt like `Show number of users in the realm`.

![Verify Connection](../../../images/user-configuration/image-2025-9-17_13-58-17.png)

Next, use a clear, structured prompt to create users in bulk. You can specify the project, user emails, and roles all in one command. The assistant will create the users but will **not** set their passwords.

> `Create and add the following people to the "project_name" project – first_lastname1@example.com, first_lastname2@example.com. Assign to each of them the developer role. Output the results in a table format.`

![User Creation Process](../../../images/user-configuration/image-2025-9-17_13-49-58.png)
![Creation in Progress](../../../images/user-configuration/image-2025-9-17_13-50-15.png)
![Creation Complete](../../../images/user-configuration/image-2025-9-17_13-50-28.png)

#### 3. Set Passwords and Finalize

After the assistant confirms the users have been created, you must manually set their initial passwords in Keycloak.

1. Verify that the new users appear in the Keycloak UI under the **Users** section.
2. For each new user, follow the instructions in the [Assign Credentials](#assign-credentials) section (under Option A) to set their temporary password.
3. Securely share the login information and temporary passwords with the new users.

:::note Next Step:
After creating a user, proceed to [Part 2: User Authorization](../user-authorization/assign-roles) to assign the necessary permissions.
:::
