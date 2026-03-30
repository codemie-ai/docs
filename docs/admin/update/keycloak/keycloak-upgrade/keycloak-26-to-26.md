---
id: keycloak-26-to-26
sidebar_position: 8
title: Keycloak Upgrade 26.X.Y -> 26.X.Y
description: Upgrade Keycloak from 26.4.5 to 26.5.6
pagination_next: null
---

# Upgrade Keycloak from 26.4.5 to 26.5.6

The full description of Keycloak migration changes available [here](https://www.keycloak.org/docs/latest/upgrading/index.html#migration-changes).

## Pre-Upgrade Requirements

**Before proceeding with any upgrade, ensure you have:**

- Planned for potential downtime
- Tested the upgrade process in a non-production environment

**Before starting the upgrade**

- Check the list of available chart versions:

```bash
  helm search repo codecentric/keycloakx --versions
```

:::info

> The Helm chart version and the application version may differ.
> All the component's version included in the helm chart might be different from **APP VERSION**.
> Always rely on the **Chart version** when determining compatibility and deployment behavior.

:::

| NAME                    | CHART VERSION | APP VERSION | DESCRIPTION                                        |
| ----------------------- | ------------- | ----------- | -------------------------------------------------- |
| `codecentric/keycloakx` | `7.1.9`       | `26.5.5`    | Keycloak.X - Open Source Identity and Access Ma... |
| `codecentric/keycloakx` | `7.1.8`       | `26.5.3`    | Keycloak.X - Open Source Identity and Access Ma... |

- Once you identify the target chart version, you can inspect the container image tags used in that release:

```bash
  helm show values codecentric/keycloakx --version <TARGET_CHART_VERSION> | grep -A 4 image:
```

> This helps verify the underlying images before proceeding with the upgrade.

## Changes for `keycloak-helm/Chart.yaml`

| Parameter              | Current Value | New Value |
| ---------------------- | ------------- | --------- |
| version                | 2.1.5         | 7.1.9     |
| appVersion             | 26.4.5        | 26.5.6    |
| dependencies[].version | 7.1.5         | 7.1.9     |

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

### Settings to be added

```yaml
  keycloakx:
    image:
        tag: 26.5.6
```

:::warning IMPORTANT
Ensure `keycloak-helm/Chart.lock` file and `keycloak-helm/charts/` directory do not exist before apply changes.
:::
