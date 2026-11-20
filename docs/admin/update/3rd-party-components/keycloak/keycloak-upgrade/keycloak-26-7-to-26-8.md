---
id: keycloak-26-7-to-26-8
sidebar_position: 4
title: Keycloak Upgrade 26.7.5 → 26.8.2
description: Upgrade Keycloak from 26.7.5 to 26.8.2
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.7.5 to 26.8.2

Before the upgrade, complete the [Pre-Upgrade Requirements](./index.md#pre-upgrade-requirements), then apply the changes below with the [Upgrade Procedure](./index.md#upgrade-procedure).

:::warning IMPORTANT
Review the Keycloak upgrading guide from [Migrating to 26.8.0](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-8-0) to [Migrating to 26.8.2](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-8-2) before the upgrade.

This page covers only the CodeMie Helm chart and cannot account for custom Keycloak settings.
:::

## Changes for `keycloak-helm/Chart.yaml`

| Parameter  | Current Value | New Value |
| ---------- | ------------- | --------- |
| appVersion | 26.7.5        | 26.8.2    |

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

| Parameter           | Current Value | New Value |
| ------------------- | ------------- | --------- |
| keycloakx.image.tag | `26.7.5`      | `26.8.2`  |

```yaml
keycloakx:
  image:
    tag: 26.8.2
```

## Admin API Scope `kc-admin-api`

Since 26.8.2, the Keycloak Admin API accepts only tokens with the `kc-admin-api` scope. Other tokens get `401`, even with admin roles.

The upgrade adds the scope to `admin-cli` and `security-admin-console` in every realm, so the Admin Console and keycloak-operator, which logs in through `admin-cli`, keep working. These CodeMie clients need it added by hand:

- `codemie-migration-client` of the [Keycloak user migration](../../../../configuration/access-control/platform-managed-mode-configuration.md#create-keycloak-service-account-client), if the migration has not run yet.
- The client of a [Keycloak tool integration](../../../../../user-guide/tools_integrations/tools/keycloak.md), unless it is `admin-cli`.

:::warning
Do not create the `kc-admin-api` scope before the upgrade. The upgrade reuses an existing scope without the required audience mapper, and tokens still get `401`.
:::

After the upgrade, for each client:

1. Open **Clients** → the client → **Client scopes**.
2. Click **Add client scope**.
3. Select `kc-admin-api`, click **Add** → **Default**.

## Verification

```sql
SELECT version FROM migration_model ORDER BY update_time DESC LIMIT 1;   -- 26.8.2
```

New warnings in the log, no action needed:

- At startup: ``The option `shouldAttachRoute` is deprecated``.
- On every token request from a client with **Full Scope Allowed**: a warning about this setting. To hide it, add `KC_LOG_LEVEL` with the value `info,org.keycloak.protocol.oidc.endpoints.TokenEndpoint.full-scope-allowed:error` to `keycloakx.extraEnv`.
