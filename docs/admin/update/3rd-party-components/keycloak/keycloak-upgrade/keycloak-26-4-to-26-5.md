---
id: keycloak-26-4-to-26-5
sidebar_position: 7
title: Keycloak Upgrade 26.4.5 → 26.5.7
description: Upgrade Keycloak from 26.4.5 to 26.5.7
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.4.5 to 26.5.7

Before you start, complete the [Pre-Upgrade Requirements](./index.md#pre-upgrade-requirements), then apply the changes below with the [Upgrade Procedure](./index.md#upgrade-procedure).

:::warning IMPORTANT
Review the Keycloak upgrading guide from [Migrating to 26.4.6](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-4-6) to [Migrating to 26.5.7](https://www.keycloak.org/docs/latest/upgrading/index.html#migrating-to-26-5-7) before the upgrade.

This page covers only the CodeMie Helm chart and cannot account for custom Keycloak settings.
:::

## Changes for `keycloak-helm/Chart.yaml`

| Parameter              | Current Value | New Value |
| ---------------------- | ------------- | --------- |
| version                | 7.1.5         | 7.1.9     |
| appVersion             | 26.4.5        | 26.5.7    |
| dependencies[].version | 7.1.5         | 7.1.9     |

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

| Parameter           | Current Value | New Value |
| ------------------- | ------------- | --------- |
| keycloakx.image.tag | `26.4.5`      | `26.5.7`  |

```yaml
keycloakx:
  image:
    tag: 26.5.7
```

:::warning IMPORTANT
Ensure `keycloak-helm/Chart.lock` file and `keycloak-helm/charts/` directory do not exist before apply changes.
:::
