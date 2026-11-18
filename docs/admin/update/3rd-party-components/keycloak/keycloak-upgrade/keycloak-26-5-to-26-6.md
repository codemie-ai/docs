---
id: keycloak-26-5-to-26-6
sidebar_position: 6
title: Keycloak Upgrade 26.5.7 → 26.6.5
description: Upgrade Keycloak from 26.5.7 to 26.6.5
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.5.7 to 26.6.5

Before you start, complete the [Pre-Upgrade Requirements](./index.md#pre-upgrade-requirements), then apply the changes below with the [Upgrade Procedure](./index.md#upgrade-procedure).

:::warning IMPORTANT
Review the Keycloak upgrading guide from [Migrating to 26.6.0](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-6-0) to [Migrating to 26.6.5](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-6-5) before the upgrade.

This page covers only the CodeMie Helm chart and cannot account for custom Keycloak settings.
:::

## Changes for `keycloak-helm/Chart.yaml`

| Parameter  | Current Value | New Value |
| ---------- | ------------- | --------- |
| appVersion | 26.5.7        | 26.6.5    |

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

| Parameter           | Current Value | New Value |
| ------------------- | ------------- | --------- |
| keycloakx.image.tag | `26.5.7`      | `26.6.5`  |

```yaml
keycloakx:
  image:
    tag: 26.6.5
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

An empty result means no action. A policy named `Default Policy` with the code `$evaluation.grant();` was created automatically when Authorization was enabled on the client in an older Keycloak version. To remove it, open **Clients** → the client → **Authorization**, delete **Default Permission**, then **Default Policy**. To keep JavaScript policies, add `scripts` to `KC_FEATURES`.
