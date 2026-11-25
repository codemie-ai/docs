---
id: keycloak-26-6-to-26-7
sidebar_position: 5
title: Keycloak Upgrade 26.6.4 → 26.7.5
description: Upgrade Keycloak from 26.6.4 to 26.7.5
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.6.4 to 26.7.5

Before the upgrade, complete the [Pre-Upgrade Requirements](./index.md#pre-upgrade-requirements), then apply the changes below with the [Upgrade Procedure](./index.md#upgrade-procedure).

:::warning IMPORTANT
Review the Keycloak upgrading guide from [Migrating to 26.6.5](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-6-5) to [Migrating to 26.7.5](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-7-5) before the upgrade. 26.6.5 has no published image, so its changes arrive with 26.7.

This page covers only the CodeMie Helm chart and cannot account for custom Keycloak settings.
:::

## Changes for `keycloak-helm/Chart.yaml`

| Parameter  | Current Value | New Value |
| ---------- | ------------- | --------- |
| appVersion | 26.6.4        | 26.7.5    |

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

| Parameter           | Current Value | New Value |
| ------------------- | ------------- | --------- |
| keycloakx.image.tag | `26.6.4`      | `26.7.5`  |

```yaml
keycloakx:
  image:
    tag: 26.7.5
```

## Verification

```sql
SELECT version FROM migration_model ORDER BY update_time DESC LIMIT 1;   -- 26.7.5
```

The startup log shows a new warning, no action needed: `Deprecated features identity-brokering-api:v1, twitter-broker:v1 enabled by default`. Keycloak 26.7 marks these two features as deprecated and keeps them on.
