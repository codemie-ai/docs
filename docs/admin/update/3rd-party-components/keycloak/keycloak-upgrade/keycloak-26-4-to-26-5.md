---
id: keycloak-26-4-to-26-5
sidebar_position: 9
title: Keycloak Upgrade 26.4.5 → 26.5.7
description: Upgrade Keycloak from 26.4.5 to 26.5.7
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.4.5 to 26.5.7

The full description of Keycloak migration changes is in the [Keycloak upgrading guide](https://www.keycloak.org/docs/latest/upgrading/index.html).

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

## Pre-Upgrade Checks

### PostgreSQL Version

PostgreSQL 13 is no longer supported. Check that the version is 14 or later:

```sql
SHOW server_version;
```

### Client Session Timeouts

Keycloak now rejects saving a client whose Client Session Idle or Client Session Max is longer than the realm SSO Session Idle or SSO Session Max. Find such clients:

```sql
SELECT * FROM (
  SELECT r.name AS realm, c.client_id, a.name AS setting,
         CASE WHEN a.value ~ '^[0-9]+$' THEN a.value::bigint END AS client_value,
         CASE a.name WHEN 'client.session.idle.timeout' THEN r.sso_idle_timeout
                     ELSE r.sso_max_lifespan END AS realm_value
    FROM client_attributes a
    JOIN client c ON c.id = a.client_id
    JOIN realm  r ON r.id = c.realm_id
   WHERE a.name IN ('client.session.idle.timeout', 'client.session.max.lifespan')
) t
WHERE client_value > 0 AND client_value > realm_value;
```

For each row, open **Clients** → the client → **Advanced** → **Advanced settings** in the realm, set **Client Session Idle** and **Client Session Max** to **Inherits from realm settings**, and click **Save**.

## Upgrade Procedure

Follow the [generic upgrade procedure](./index.md):

1. Back up the Keycloak database.
2. Scale down to a single replica and disable ingress, and apply this change on its own.
3. Apply the version change:

   ```shell
   helm upgrade --install keycloak keycloak-helm/. \
     --namespace security \
     --values keycloak-helm/values-<cloud_name>.yaml \
     --wait \
     --timeout 900s \
     --dependency-update
   ```

4. Follow the migration in the pod log:

   ```shell
   kubectl -n security logs -f keycloakx-0
   ```

5. Enable ingress, scale up to the previous replica count, and test logins, including logins through SAML identity providers if a realm uses them.

To roll back, follow [Restore From Backup](./index.md#restore-from-backup).
