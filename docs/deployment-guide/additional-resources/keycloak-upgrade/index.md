---
id: keycloak-upgrade
sidebar_position: 1
title: Keycloak Upgrade
description: Keycloak upgrade guide
---

# Keycloak Upgrade

## Keycloak Versioning

Keycloak **minor** and **patch** version upgrade typically backward compatible and do not lead to any significant changes in configuration.
The **major** version upgrade typically leads to database structure update and/or changing configuration.

:::warning IMPORTANT
Keycloak doesn't support Major release downgrade. It is not possible to use the same database with older Keycloak version after upgrade applied.
:::

## Pre-Upgrade Requirements

**Before proceeding with any upgrade, ensure you have:**

- Created a complete backup of Keycloak database
- Planned for potential downtime
- Tested the upgrade process in a non-production environment

## Upgrade Procedure

The generic steps to upgrade Keycloak describe below.
The upgrade specifics described in the separate documents according to the target versions.

- Disable ingress and scale down to single replica by setting following Helm values:

```yaml
keycloakx.replicas: 1
keycloakx.ingress.enabled: false
```

- Make the database backup to have the most recent data.
- Delete the file `keycloak-helm/Chart.lock` if present and the directory `keycloak-helm/charts/` recursively.
- Update helm chart version and make necessary changes in values file. Refer the subsections to get mor details.
- Apply changes and read the logs of keycloak pod:

```shell
kubectl -n security logs -f keycloakx-0
```

:::warning IMPORTANT
In certain cases Keycloak migration requires manual execution of SQL statements that are provided in the log file. If you don't see anything that recommend executing SQL queries than it is not required.
:::

- Enable ingress and check whether the Keycloak instance works as expected.
- Scale up to desired count of replicas.

## Restore From Backup

:::warning IMPORTANT
Keycloak doesn't support downgrade operations. It's only possible to restore database backup with Keycloak version newer or same that was in use prior database backup.
:::

- Disable ingress and scale down to 0 replicas:

```yaml
keycloakx.replicas: 0
keycloakx.ingress.enabled: false
```

- Drop current database and restore if from backup.
- Revert all changes made in Helm chart and values files.
- Enable ingress and scale up to desired replicas count.
