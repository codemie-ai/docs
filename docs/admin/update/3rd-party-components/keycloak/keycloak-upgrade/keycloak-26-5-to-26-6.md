---
id: keycloak-26-5-to-26-6
sidebar_position: 6
title: Keycloak Upgrade 26.5.7 → 26.6.4
description: Upgrade Keycloak from 26.5.7 to 26.6.4
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.5.7 to 26.6.4

Before the upgrade, complete the [Pre-Upgrade Requirements](./index.md#pre-upgrade-requirements), then apply the changes below with the [Upgrade Procedure](./index.md#upgrade-procedure).

:::warning IMPORTANT
Review the Keycloak upgrading guide from [Migrating to 26.6.0](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-6-0) to [Migrating to 26.6.4](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-6-4) before the upgrade.

This page covers only the CodeMie Helm chart and cannot account for custom Keycloak settings.
:::

## Changes for `keycloak-helm/Chart.yaml`

| Parameter  | Current Value | New Value |
| ---------- | ------------- | --------- |
| appVersion | 26.5.7        | 26.6.4    |

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

| Parameter           | Current Value | New Value |
| ------------------- | ------------- | --------- |
| keycloakx.image.tag | `26.5.7`      | `26.6.4`  |

```yaml
keycloakx:
  image:
    tag: 26.6.4
```

## JavaScript Policies

Since 26.6.0, JavaScript authorization policies work only with the `scripts` feature enabled. Find them before the upgrade:

```sql
SELECT r.name AS realm, c.client_id, p.name, pc.value AS code
  FROM resource_server_policy p
  JOIN client c ON c.id = p.resource_server_id
  JOIN realm r ON r.id = c.realm_id
  LEFT JOIN policy_config pc ON pc.policy_id = p.id AND pc.name = 'code'
 WHERE p.type = 'js';
```

An empty result means no action. Otherwise, check the `code` column of each row.

**If `code` is `$evaluation.grant();`**, Keycloak created the policy automatically. Delete it:

1. Open **Clients** → the client → **Authorization**.
2. Delete **Default Permission**.
3. Delete **Default Policy**.

For `codemie-migration-client` of a finished [Keycloak user migration](../../../../configuration/access-control/platform-managed-mode-configuration.md#create-keycloak-service-account-client), delete the whole client instead.

**If `code` is anything else**, the policy is a custom check. To keep it, enable the `scripts` feature in `keycloakx.extraEnv`:

```yaml
- name: KC_FEATURES
  value: "scripts"
```

## Verification

```sql
SELECT version FROM migration_model ORDER BY update_time DESC LIMIT 1;   -- 26.6.4
```
