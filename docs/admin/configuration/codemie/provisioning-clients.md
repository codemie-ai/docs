---
id: provisioning-clients
title: Provisioning Clients Configuration
sidebar_label: Provisioning Clients
sidebar_position: 6
pagination_prev: admin/configuration/codemie/project-budget-management
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Provisioning Clients Configuration

<EnterpriseFeature />

A provisioning client is an external system, for example the EPAM Support Portal on ServiceNow, that applies approved business requests to CodeMie through the provisioning API, `/v1/provisioning`. Each client is registered in the `provisioning-clients-config.yaml` file. This page covers the required settings, the client identity, the file and its deployment, applying changes, verification, and troubleshooting.

For the endpoints a client calls, see [ServiceNow Budget Integration](./servicenow-budget-integration.md#provisioning-api-endpoints).

## How Registration Works

- The file lists the external systems that may call `/v1/provisioning` and what each one may do there.
- Each system is identified by its **CodeMie user ID**, which is the `sub` claim of the system's access token. The file holds no credentials: the system gets its tokens from the identity provider (IdP), like any other account.
- **Every account in the file can call only `/v1/provisioning`.** Any other CodeMie route answers `403`, even when the provisioning API is switched off. Internal service-to-service calls signed with the bind key are not affected.
- A caller that is not in the file gets `403` on every `/v1/provisioning` route. This includes CodeMie administrators.
- CodeMie treats a registered account as a service account: it gets no personal project, and the provisioning API never makes it a project admin.
- The file is read **once, at process start**. Any defect in it stops startup with an error that names the entry and the problem.

## Prerequisites

| Setting                           | Value    | Description                                                                                                                                                                                               |
| --------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `PROVISIONING_API_ENABLED`        | `true`   | Mounts `/v1/provisioning`. Default: `false`                                                                                                                                                               |
| `ENABLE_USER_MANAGEMENT`          | `true`   | Required as well. Without it, the router is not mounted and startup logs `provisioning_api_disabled`. See [Platform-Managed Mode Configuration](../access-control/platform-managed-mode-configuration.md) |
| `PROVISIONING_CLIENTS_CONFIG_DIR` | Optional | Directory that holds the file. Default: `config/provisioning_clients` in the repository, which is `/app/config/provisioning_clients` in the image                                                         |

Depending on what the client sends and how tokens are validated:

- **Cost centers.** If a request names a `cost_center`, the `features:costCenters` component must be enabled in the [customer configuration](./customer-feature-configuration.md), and the `codemie-enterprise` package must be installed. Otherwise, the request gets `403` "Cost centers are not enabled for this customer." See [Chargeback and Cost Centers](../../../user-guide/budget-management/chargeback-cost-centers.md).
- **Token validation (JWKS).** If `JWKS_VALIDATION_ENABLED=true`, `JWKS_TRUSTED_ISSUERS` must list the token's issuer, and the token's `aud` claim must match the `audience` of that entry. See [JWKS Signature Validation](./api-configuration.md#jwks-signature-validation) and [JWKS Validation and Audience](#jwks-validation-and-audience).

## File Location

- The file name is fixed: `provisioning-clients-config.yaml`.
- The path is `$PROVISIONING_CLIENTS_CONFIG_DIR/provisioning-clients-config.yaml`.
- The image ships the file with `provisioning_clients: []`. Each deployment provides its own file, either mounted over that directory or placed in the directory set by `PROVISIONING_CLIENTS_CONFIG_DIR`.
- Every process that runs the API image reads the file and applies the access rules. In Kubernetes, these are the **api**, **ds-pool**, and **proxy-pool** workloads, and all three need the same file.

## Find the Account's User ID

The `user_id` of an entry is the account's CodeMie user ID: the `sub` claim of its access token, a UUID.

:::warning
The username (`service-account-...`), the IdP client ID (for example, `support-portal`), and an email are all wrong values for `user_id`.
:::

### Keycloak Client Credentials Client

The Keycloak client has **Client authentication** turned on and **Service account roles** enabled. Its `user_id` is the ID of the client's service account user, which can be found in three ways.

**1. Decode a token.** This works with every Keycloak version and also shows the `iss` and `aud` claims needed for the [JWKS check](#jwks-validation-and-audience):

```bash
TOKEN=$(curl -s \
  -d grant_type=client_credentials \
  -d client_id="$CLIENT_ID" \
  -d client_secret="$CLIENT_SECRET" \
  "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" | jq -r .access_token)

python3 -c 'import base64,json,sys; p=sys.argv[1].split(".")[1]; c=json.loads(base64.urlsafe_b64decode(p+"="*(-len(p)%4))); print("sub:", c["sub"]); print("iss:", c.get("iss")); print("aud:", c.get("aud"))' "$TOKEN"
```

:::warning
The access token is a secret. Do not paste it into tickets or chats.
:::

**2. Admin console.** Go to **Clients** → the client → **Service account roles**, and follow the link to the `service-account-<client-id>` user. Its **ID** is the value.

**3. Admin REST API.**

- Before Keycloak 27: call `GET /admin/realms/{realm}/clients/{client-uuid}/service-account-user` and take `.id`.
- Keycloak 27 and later: call `GET /admin/realms/{realm}/clients/{client-uuid}` and take `.serviceAccountUserId`.

### JWKS Validation and Audience

If JWKS validation is on, the decoded `iss` must be listed in `JWKS_TRUSTED_ISSUERS`, and `aud` must contain the `audience` of that entry. Keycloak client credentials tokens often lack the required audience. In that case, add an **Audience** mapper to the client's dedicated client scope so that the token carries it.

### Other Identity Providers

The value is whatever the IdP integration reports as the user ID, and it must be a UUID. An account whose ID is not a UUID cannot be registered.

## File Format

```yaml
provisioning_clients:
  - name: support-portal
    user_id: '3f2b6c1e-8d4a-4b7e-9c2f-1a5d7e9b0c4d'
    permissions:
      - provisioning:read-projects
      - provisioning:manage-projects
      - provisioning:manage-budgets
```

### Document Rules

- The root is a mapping with exactly one key, `provisioning_clients`. Any other top-level key fails.
- `provisioning_clients` is a list. `[]` is valid and means no clients. An empty value (`provisioning_clients:`) is null, and it fails.
- A key repeated within one mapping fails. Plain YAML would silently keep the last value.
- The file is encoded in UTF-8.

### Entry Fields

No other fields are allowed.

| Field           | Required          | Rules                                                                                                                                                                                                                                              |
| --------------- | ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **name**        | Yes               | Trimmed and non-empty, at most **35** characters, unique across entries (case-sensitive), non-ASCII allowed. Names the client in log lines (`client=`) and in the name of every budget the client creates: `<name> <change reference>`             |
| **user_id**     | Yes               | The account's CodeMie user ID, a UUID (see [Find the Account's User ID](#find-the-accounts-user-id)). Quote it. Any UUID spelling is accepted and stored in lowercase. Must be unique across entries and must not equal `TEAMS_SERVICE_ACCOUNT_ID` |
| **permissions** | No (default `[]`) | Any subset of the [permissions](#permissions). An unknown value fails                                                                                                                                                                              |

The 35-character limit exists because a budget name holds 100 characters and a change reference up to 64: 35 + 1 space + 64 = 100, so the reference is never cut off.

## Permissions

| Permission                     | Allows the client to                                                                                  | Used by                                                                                                                                   |
| ------------------------------ | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `provisioning:read-projects`   | List the shared projects of given people                                                              | `GET /v1/provisioning/projects?member_email=...`                                                                                          |
| `provisioning:manage-budgets`  | Set, adjust, or cancel the budget of **any** shared project, including a budget a maintainer set      | `PUT`, `PATCH`, `DELETE /v1/provisioning/projects/{project_name}/budget`                                                                  |
| `provisioning:manage-projects` | Create shared projects, link a cost center, and add any active user as an admin of any shared project | A budget `PUT` or `PATCH` that creates the project, or whose `project` block names a `cost_center` or `admin_emails`. No route of its own |

Common grants:

| The client needs to                                                   | Grant                                                                     |
| --------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Look up people's projects only                                        | `read-projects`                                                           |
| Manage budgets of projects that already exist                         | `manage-budgets` (plus `read-projects` for lookups)                       |
| Create projects, link cost centers, and add admins along with budgets | `manage-budgets` and `manage-projects` (plus `read-projects` for lookups) |

:::warning
Grant the management permissions only to a system trusted with that reach.
:::

Every write call also needs the `X-Change-Reference` header (1–64 characters). The header is logged, but it is not a permission.

## Deploy with the Helm Chart

The `extraVolumes` and `extraVolumeMounts` values of the `codemie-api` Helm chart are block strings. The api, ds-pool, and proxy-pool templates (both Deployment and Rollout) all use them. The `extraEnv` and `customEnv` lists go to the same three workloads.

### 1. Create the ConfigMap

The file holds no secrets, so a ConfigMap is enough. Add it to the environment's values through `extraObjects`:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-provisioning-clients
    data:
      provisioning-clients-config.yaml: |
        provisioning_clients:
          - name: support-portal
            user_id: "3f2b6c1e-8d4a-4b7e-9c2f-1a5d7e9b0c4d"
            permissions:
              - provisioning:read-projects
              - provisioning:manage-projects
              - provisioning:manage-budgets
```

### 2. Mount the ConfigMap

Mount it over the default directory. A values file replaces the whole block string, so keep every existing entry and add the new one:

```yaml
extraVolumeMounts: |
  # ...existing mounts stay here...
  - name: codemie-provisioning-clients
    mountPath: /app/config/provisioning_clients
    readOnly: true

extraVolumes: |
  # ...existing volumes stay here...
  - name: codemie-provisioning-clients
    configMap:
      name: codemie-provisioning-clients
```

To mount the file in a different directory, set that directory in `PROVISIONING_CLIENTS_CONFIG_DIR`:

```yaml
extraEnv:
  - name: PROVISIONING_CLIENTS_CONFIG_DIR
    value: /app/config/custom-provisioning-clients
```

### 3. Enable the Provisioning API

If the API is not enabled yet, add both variables to `extraEnv`:

```yaml
extraEnv:
  - name: PROVISIONING_API_ENABLED
    value: 'true'
  - name: ENABLE_USER_MANAGEMENT
    value: 'true'
```

:::note
Outside Kubernetes, put the file in `config/provisioning_clients/` or point `PROVISIONING_CLIENTS_CONFIG_DIR` at its directory, then restart the process.
:::

## Apply Changes

The file is read at startup only. Kubernetes eventually syncs an edited ConfigMap into running pods, but the application does not re-read it. **Restart all three workloads right after every edit:**

```bash
kubectl -n <namespace> rollout restart deployment/<api> deployment/<ds-pool> deployment/<proxy-pool>
# For workloads managed by Argo Rollouts:
kubectl argo rollouts -n <namespace> restart <rollout-name>
```

- **Restart right away.** A pod that restarts for any other reason picks up the new file, so until all pods restart, different pods enforce different registries.
- **Watch the rollout.** A bad file crashes the new pods at startup with a `[ProvisioningClientsConfig] ...` error (see [Startup Fails](#startup-fails)). The old pods keep serving until the file is fixed.

## Client Lifecycle

### Onboarding

1. Create the IdP client (client credentials) and get its `user_id` (see [Find the Account's User ID](#find-the-accounts-user-id)).
2. Add the entry and restart the workloads (see [Deploy with the Helm Chart](#deploy-with-the-helm-chart) and [Apply Changes](#apply-changes)).
3. **Only then** give the credentials to the third party.
4. Verify the setup (see [Verify the Setup](#verify-the-setup)).

:::danger
Before registration, the account is an ordinary user with access to the whole API, and its first sign-in creates a personal project for it. Register the account before handing over its credentials.
:::

### Change Permissions or the Name

Edit the file and restart the workloads. A new name appears in log lines and in budgets created after the change; existing budgets keep their names.

### Offboarding

1. **Stop new tokens.** Disable the IdP client or rotate its secret.
2. **Revoke tokens already issued.** Deactivate the account's CodeMie user. Tokens are validated offline, so disabling the IdP client alone leaves issued tokens valid until they expire. A deactivated user gets `401` within `AUTH_TOKEN_CACHE_TTL` (default: 30 seconds).
3. **Set `permissions: []` and restart.** Keep the entry: only listed accounts are confined to the provisioning API, so deleting the entry releases the account back to the full API. Delete the entry only after its credentials are revoked.

## Verify the Setup

1. Check the startup logs. They must show no `[ProvisioningClientsConfig]` error, no `provisioning_api_disabled` warning, and no `provisioning_api_no_clients` warning.
2. Call the API with the client's token. `$CODEMIE_API` is the API base URL, for example `https://codemie.example.com/code-assistant-api`:

   ```bash
   curl -s -H "Authorization: Bearer $TOKEN" \
     "$CODEMIE_API/v1/provisioning/projects?member_email=user@example.com"
   ```

   Use the email of an existing CodeMie user.

   | Result                                                          | Meaning                                                            |
   | --------------------------------------------------------------- | ------------------------------------------------------------------ |
   | `200`                                                           | Registered and granted `read-projects`                             |
   | `403` "does not hold the permission provisioning:read-projects" | Registered, but not granted `read-projects`                        |
   | `403` "reserved for registered provisioning clients"            | Not registered under this ID (see [Requests Fail](#requests-fail)) |

3. Call any route outside `/v1/provisioning` with the same token. Expect `403` "A provisioning client may only call the provisioning API."

:::warning
Budget writes change real budgets and sync to LiteLLM. Test them only on a project created for that purpose.
:::

## Troubleshooting

### Startup Fails

Every message starts with `[ProvisioningClientsConfig]`.

| Message                                                                                                                                                          | Fix                                                                                                                        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `cannot read <path>: [Errno 2] No such file or directory`                                                                                                        | The file is missing, the mount is wrong, or the name is wrong. The name must be exactly `provisioning-clients-config.yaml` |
| `cannot read <path>: ... found duplicate key 'name'`                                                                                                             | A key is repeated inside one entry                                                                                         |
| `cannot read <path>: ...` with a YAML parser message                                                                                                             | YAML syntax error, such as wrong indentation in the ConfigMap's block string                                               |
| `<path>: root must be a mapping`                                                                                                                                 | The file is empty, or its root is a list                                                                                   |
| `<path>: root must hold only provisioning_clients, found [...]`                                                                                                  | A typo or an extra top-level key                                                                                           |
| `<path>: provisioning_clients must be a list`                                                                                                                    | `provisioning_clients:` has no value. Use `[]`                                                                             |
| `provisioning_clients[i] (<name>): name: Value error, name must be at most 35 characters`                                                                        | Shorten the name                                                                                                           |
| `provisioning_clients[i] (<name>): user_id: Value error, user_id must be the client's CodeMie user id (a UUID)`                                                  | The value is not a UUID: a username or client ID was used (see [Find the Account's User ID](#find-the-accounts-user-id))   |
| `provisioning_clients[i] (<name>): user_id: Field required`                                                                                                      | Add `user_id`                                                                                                              |
| `provisioning_clients[i] (<name>): permissions.0: Input should be 'provisioning:read-projects', 'provisioning:manage-projects' or 'provisioning:manage-budgets'` | Unknown permission. Check the spelling                                                                                     |
| `provisioning_clients[i] (<name>): <field>: Extra inputs are not permitted`                                                                                      | Remove the unknown field                                                                                                   |
| `provisioning_clients[i] (<name>): duplicate name` or `duplicate user_id`                                                                                        | Each name and each account must appear only once                                                                           |
| `provisioning_clients[i] (<name>): user_id must not be TEAMS_SERVICE_ACCOUNT_ID`                                                                                 | The Microsoft Teams bot account cannot be a provisioning client                                                            |

### Requests Fail

| Symptom                                                                       | Cause and Fix                                                                                                                                                                                          |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `404` on every `/v1/provisioning` route                                       | The API is not mounted. Check `PROVISIONING_API_ENABLED` and `ENABLE_USER_MANAGEMENT`, and look for the `provisioning_api_disabled` log line                                                           |
| `401`                                                                         | Token problem: it has expired, JWKS validation rejected its issuer or audience (see [JWKS Validation and Audience](#jwks-validation-and-audience)), or the CodeMie user is deactivated                 |
| `403` "This endpoint is reserved for registered provisioning clients."        | The token's user ID is not in the file, or the pods were not restarted. The log line `access_denied_provisioning_client: actor_user_id=<id>` shows the ID CodeMie received; register that value        |
| `403` "This provisioning client does not hold the permission `<permission>`." | The grant is missing. A `PUT` or `PATCH` that would create the project, or that sends `cost_center` or `admin_emails`, also needs `manage-projects`. Log line: `access_denied_provisioning_permission` |
| `403` "A provisioning client may only call the provisioning API."             | Expected for routes outside `/v1/provisioning`. Log line: `access_denied_provisioning_scope`                                                                                                           |
| `403` "Cost centers are not enabled for this customer."                       | Enable the `features:costCenters` component in the customer configuration and install `codemie-enterprise`                                                                                             |
| The same request sometimes passes and sometimes gets `403`                    | Pods are running with different versions of the file. Restart all three workloads (see [Apply Changes](#apply-changes))                                                                                |

## See Also

- [ServiceNow Budget Integration](./servicenow-budget-integration.md) — the provisioning API endpoints and how ServiceNow uses them
- [Project Budget Management](./project-budget-management.md) — platform configuration required for project budgets
- [API Configuration Reference](./api-configuration.md#provisioning-api) — environment variables of the provisioning API
- [Creating Client Secret Credentials](../../../user-guide/api/client-secret-access.md) — creating a Keycloak client with the client credentials grant
