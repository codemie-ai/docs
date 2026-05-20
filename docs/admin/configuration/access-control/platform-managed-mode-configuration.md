---
id: platform-managed-mode-configuration
sidebar_position: 3
title: Platform-managed Mode Configuration
description: How to enable Platform-managed mode for fresh installations and when switching from Keycloak-managed mode
pagination_prev: admin/configuration/access-control/access-control-overview
pagination_next: null
---

In **Platform-managed mode** (`ENABLE_USER_MANAGEMENT=true`), user roles and project
assignments are stored in the platform database and managed through the in-app UI
(**Settings → Administration**). This is in contrast to the default Keycloak-managed
mode, where roles and project access are read from JWT claims on every request.

For a comparison of both modes, see the
[Access Control Overview](./index.md#deployment-modes).

## Deployment Scenarios

| Scenario                                                                              | Steps required                                                                                                          |
| ------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Fresh installation** — deploying AI/Run CodeMie for the first time                  | [Step 1](#step-1-configure-helm-values) only                                                                            |
| **Switching from Keycloak-managed mode** — existing deployment with users in Keycloak | [Step 1](#step-1-configure-helm-values) and [Step 2](#step-2-migrate-existing-keycloak-users-existing-deployments-only) |

## Prerequisites

- Access to the Kubernetes cluster and Helm values file of AI/Run CodeMie Backend and UI
- If migrating from an existing Keycloak deployment: Keycloak service account client with `realm-management` roles in the target realm (see [Create Keycloak service account client](#create-keycloak-service-account-client))

---

## Step 1: Configure Helm Values

:::warning Both components must be updated
The AI/Run CodeMie backend and the UI must be configured consistently. Enabling only one of them results
in either missing UI controls or API errors.
:::

### AI/Run CodeMie Backend

In the `codemie-api` Helm chart, add the following variables to the `extraEnv` list:

```yaml
extraEnv:
  - name: ENABLE_USER_MANAGEMENT
    value: 'true'
  - name: USER_PROJECT_LIMIT
    value: '3'
```

`ENABLE_USER_MANAGEMENT` activates Platform-managed mode. When set to `true`, user roles
and project assignments are stored in the platform database and managed through the in-app
UI instead of being read from Keycloak JWT claims.

`USER_PROJECT_LIMIT` sets the maximum number of shared projects a regular user can be
assigned to. Super Admins are always exempt from this limit. Adjust the value to match
your organisation's policy.

Apply the changes to the deployment.

### AI/Run CodeMie UI

The UI must be told that Platform-managed mode is active so it shows the in-app
**Users management** and **Projects management** tabs under **Settings → Administration**.

In the `codemie-ui` Helm chart `values.yaml`, set:

```yaml
viteEnableUserManagement: true
viteEnableBudgetManagement: true
```

`viteEnableUserManagement` tells the UI that Platform-managed mode is active. When set to
`true`, the **Users management** and **Projects management** tabs appear under
**Settings → Administration**.

`viteEnableBudgetManagement` enables budget columns and the budget management section on
project detail pages. Set it to `false` if your deployment does not use budget tracking.

Apply the changes to the deployment.

---

## Step 2: Migrate Existing Keycloak Users (existing deployments only)

:::info When is this step required?
Only perform this step if you are **switching an existing deployment** from Keycloak-managed
mode to Platform-managed mode and you are using `IDP_PROVIDER=keycloak`.

For **new installations** where `ENABLE_USER_MANAGEMENT=true` is set from the start, skip
this step entirely.
:::

When switching to Platform-managed mode on an existing deployment, the platform database
has no knowledge of existing Keycloak users or their project assignments. The one-time
Keycloak User Migration reads users and their `applications` / `applications_admin`
attributes from Keycloak and imports them into the platform database.

### 2.1 Configure migration environment variables

#### Create Keycloak service account client

In the Keycloak Admin Console, create a new client in the target realm:

1. Go to **Clients** and click **Create client**.
2. Set **Client ID** to `codemie-migration-client`, **Client type** to `OpenID Connect`. Click **Next**.
3. In **Capability config**, enable **Client authentication** and **Authorization**. Enable **Service accounts roles** under **Authentication flow**. Click **Next**.
4. In **Access settings**, set **Valid redirect URIs** and **Web origins** to `/*`. Click **Save**.
5. Go to the **Service accounts roles** tab and assign the following `realm-management` roles:
   - `view-users`
   - `view-clients`
   - `view-authorization`
   - `view-events`
   - `view-realm`
   - `view-identity-providers`
   - `query-users`
   - `query-clients`
   - `query-groups`
   - `query-realms`
6. Go to the **Credentials** tab and copy the **Client secret**.

#### Configure environment variables

Add the following environment variables to the AI/Run CodeMie Backend deployment alongside
`ENABLE_USER_MANAGEMENT=true`:

| Variable                       | Example value                  | Description                                                      |
| ------------------------------ | ------------------------------ | ---------------------------------------------------------------- |
| `KEYCLOAK_MIGRATION_ENABLED`   | `true`                         | Enables the one-time import on startup. Disable after first run. |
| `KEYCLOAK_ADMIN_URL`           | `https://keycloak.example.com` | Keycloak base URL (no trailing slash, no `/auth` path).          |
| `KEYCLOAK_ADMIN_REALM`         | `codemie-prod`                 | Realm that contains the users to migrate.                        |
| `KEYCLOAK_ADMIN_CLIENT_ID`     | `codemie-migration-client`     | Service account client ID with admin read permissions.           |
| `KEYCLOAK_ADMIN_CLIENT_SECRET` | _(from Kubernetes secret)_     | Service account client secret. Use a Kubernetes secret.          |

#### Create Kubernetes secret for the client secret

Before applying the Helm configuration, create a Kubernetes secret to store the Keycloak
service account client secret:

```bash
kubectl create secret generic codemie-migration-secret \
  --from-literal=client_secret=<keycloak-client-secret> \
  -n codemie
```

#### Example Helm configuration

```yaml
extraEnv:
  - name: ENABLE_USER_MANAGEMENT
    value: 'true'
  - name: KEYCLOAK_MIGRATION_ENABLED
    value: 'true'
  - name: KEYCLOAK_ADMIN_URL
    value: 'https://keycloak.example.com'
  - name: KEYCLOAK_ADMIN_REALM
    value: 'codemie-prod'
  - name: KEYCLOAK_ADMIN_CLIENT_ID
    value: 'codemie-migration-client'
  - name: KEYCLOAK_ADMIN_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: codemie-migration-secret
        key: client_secret
```

### 2.2 Disable migration after the first run

:::danger Disable after migration
Leave `KEYCLOAK_MIGRATION_ENABLED=true` running beyond the first successful startup will
re-import users on every pod restart, potentially overwriting manual changes made in the
in-app UI.
:::

After confirming the migration completed successfully, remove all migration-specific
variables from `extraEnv`. The following variables are only needed for the one-time import
and must not remain in your configuration:

- `KEYCLOAK_MIGRATION_ENABLED`
- `KEYCLOAK_ADMIN_URL`
- `KEYCLOAK_ADMIN_REALM`
- `KEYCLOAK_ADMIN_CLIENT_ID`
- `KEYCLOAK_ADMIN_CLIENT_SECRET`

Your final `extraEnv` should contain only the Platform-managed mode setting:

```yaml
extraEnv:
  - name: ENABLE_USER_MANAGEMENT
    value: 'true'
```

Apply the changes to the deployment.

---

## Verification

After completing all steps, verify the setup:

1. Log in to the AI/Run CodeMie UI as an `admin` user.
2. Navigate to **Settings → Administration**.
3. Confirm the **Users management** and **Projects management** tabs are visible.
4. Check that existing users (if migrated) appear under **Users management** with their
   project assignments intact.

## Granting Maintainer Role

The **Maintainer** role is a superset of Admin that additionally grants access to budget management. To assign it to a user, run the following SQL against the platform database:

```sql
UPDATE users SET is_maintainer = true, is_admin = true WHERE email = '<user-email>';
```

:::info
`is_admin` must also be set to `true` — the Maintainer role implies Admin.
:::

## Upgrading from 2.18.x to 2.19.0

AI/Run CodeMie 2.19.0 introduces Platform-managed mode. The table below summarizes what
changes during the upgrade and what action, if any, is required from you.

| Area                               | What happens                                                                                                            | Action required                                                                                                                                                                 |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Database schema                    | New user management tables (`users`, `user_projects`, and related tables) are created automatically when the pod starts | None — Alembic migrations run on startup                                                                                                                                        |
| Platform-managed mode activation   | Off by default in 2.19.0 (`ENABLE_USER_MANAGEMENT=false`)                                                               | Add the Helm values from [Step 1](#step-1-configure-helm-values) before or during the upgrade if you want to enable it                                                          |
| Existing Keycloak user assignments | Not migrated automatically                                                                                              | Follow [Step 2](#step-2-migrate-existing-keycloak-users-existing-deployments-only) on first startup if you use `IDP_PROVIDER=keycloak` and want to preserve project assignments |

### How to upgrade

1. Update your Helm values to add the Platform-managed mode parameters from
   [Step 1](#step-1-configure-helm-values).

2. Run `helm upgrade` for both components:

   ```bash
   helm upgrade codemie-api <chart> -f values.yaml -n codemie
   helm upgrade codemie-ui <chart> -f values.yaml -n codemie
   ```

3. The `codemie-api` pod runs Alembic database migrations automatically on startup — no
   manual database steps are required. The startup probe allows up to **600 seconds** for
   migrations to complete.

   :::info Multiple replicas
   If you run multiple `codemie-api` replicas, the migration runner acquires an exclusive
   lock on the `alembic_version` table. Only the first replica to acquire the lock runs
   the migration; the others wait and proceed once the lock is released.
   :::

4. Verify the upgrade: log in as an admin and confirm the **Projects management** and
   **Users management** tabs appear under **Settings → Administration**.

---

## See Also

- [API Configuration Reference — User Management Mode](../codemie/api-configuration.md#user-management-mode)
- [Platform Administration Guide](../codemie/platform-administration.md)
- [Project & User Management](../../../user-guide/project-user-management/projects.md)
