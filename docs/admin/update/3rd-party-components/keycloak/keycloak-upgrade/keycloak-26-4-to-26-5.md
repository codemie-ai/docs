---
id: keycloak-26-4-to-26-5
sidebar_position: 9
title: Keycloak Upgrade 26.4.5 → 26.5.7
description: Upgrade Keycloak from 26.4.5 to 26.5.7
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.4.5 to 26.5.7

The full description of Keycloak migration changes is in the [Keycloak upgrading guide](https://www.keycloak.org/docs/latest/upgrading/index.html). Apply the changes below with the [generic upgrade procedure](./index.md).

:::warning IMPORTANT
Make sure only one Keycloak pod runs during the upgrade, and back up the database first.
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
| keycloakx.image.tag | UNSET         | `26.5.7`  |

```yaml
keycloakx:
  image:
    tag: 26.5.7
```

:::warning IMPORTANT
Ensure `keycloak-helm/Chart.lock` file and `keycloak-helm/charts/` directory do not exist before apply changes.
:::
