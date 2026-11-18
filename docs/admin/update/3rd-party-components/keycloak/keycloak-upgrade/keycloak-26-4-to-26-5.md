---
id: keycloak-26-4-to-26-5
sidebar_position: 9
title: Keycloak Upgrade 26.4.5 → 26.5.7
description: Upgrade Keycloak from 26.4.5 or 26.5.6 to 26.5.7
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak-upgrade/keycloak-upgrade
pagination_next: null
---

# Upgrade Keycloak from 26.4.5 to 26.5.7

The full list of changes is in the [Keycloak upgrading guide](https://www.keycloak.org/docs/latest/upgrading/index.html), sections "Migrating to 26.4.6" to "Migrating to 26.5.7". This page covers the changes that can affect a CodeMie installation, how to check for them, and the values to change.

| Current version | What applies                                                                        |
| --------------- | ----------------------------------------------------------------------------------- |
| 26.4.5          | All checks on this page                                                             |
| 26.5.6          | [Token endpoint parameter length](#token-endpoint-parameter-length-2657) check only |

:::warning IMPORTANT
26.4 to 26.5 is a minor upgrade. Keycloak supports rolling updates only between patch releases, starting with 26.6.0, so pods of the old and the new version must not run at the same time. Scale down to a single replica as a separate step before you change the version, as described in the [generic upgrade procedure](./index.md).

The upgrade migrates the database schema. Back up the database first: Keycloak cannot run an older version on a migrated schema.
:::

## Changes for `keycloak-helm/Chart.yaml`

| Parameter  | Current Value    | New Value |
| ---------- | ---------------- | --------- |
| appVersion | 26.4.5 or 26.5.6 | 26.5.7    |

The `keycloakx` chart version does not change.

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

| Parameter           | Current Value               | New Value |
| ------------------- | --------------------------- | --------- |
| keycloakx.image.tag | `26.5.6`, or unset (26.4.5) | `26.5.7`  |

```yaml
keycloakx:
  image:
    tag: 26.5.7
```

## Pre-Upgrade Checks

Run the SQL queries against the Keycloak database.

### PostgreSQL Version and Privileges (26.5.0)

PostgreSQL 13 is no longer supported. During the upgrade, Keycloak reads `pg_class` and `pg_namespace` to estimate table sizes; without access it logs a warning and falls back to a slower `SELECT COUNT(*)`.

```sql
SHOW server_version;   -- 14 or later
SELECT has_table_privilege('pg_catalog.pg_class', 'SELECT')     AS pg_class,
       has_table_privilege('pg_catalog.pg_namespace', 'SELECT') AS pg_namespace;   -- both true
```

### Client Session Timeouts (26.5.0)

Keycloak now rejects a client whose Client Session Idle or Client Session Max is longer than the realm SSO Session Idle or SSO Session Max. Existing clients keep working, but every later update of such a client fails, including updates made by the Keycloak Operator. A longer client value never took effect, because the SSO session ends first.

Find the clients that exceed their realm settings:

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

For each row, open the realm in the Admin Console, go to **Clients** → the client → **Advanced** → **Advanced settings**, set **Client Session Idle** and **Client Session Max** to **Inherits from realm settings** or to a value within the realm limit, and click **Save**. If the client is managed by a `KeycloakClient` resource, change the resource instead, or the operator restores the old value.

If Remember Me is enabled in a realm, compare against the Remember Me session settings of that realm as well.

### Token Endpoint Parameter Length (26.5.7)

The token endpoint rejects any OIDC or OAuth2 parameter longer than 4,000 characters. This matters for token exchange, where `subject_token` carries a whole token, and for long client assertions.

Check whether token exchange is used (requires stored events):

```sql
SELECT client_id, type, count(*) FROM event_entity
 WHERE type IN ('TOKEN_EXCHANGE', 'TOKEN_EXCHANGE_ERROR')
 GROUP BY 1, 2;
```

If it is, measure a real `subject_token`, for example with `printf %s "$TOKEN" | wc -c`. If tokens come from an identity provider with **Store tokens** enabled, the stored access tokens give the lengths without exposing them:

```sql
SELECT f.identity_provider, count(*) AS users,
       max(length(f.token::json->>'access_token')) AS max_length
  FROM federated_identity f
 WHERE f.token LIKE '{%'
 GROUP BY 1;
```

If a parameter can exceed 4,000 characters, raise the limit with the `req-params-default-max-size` option of the `openid-connect` login protocol provider, or `req-params-max-size` for one parameter. See the [login-protocol section of the Keycloak provider configuration guide](https://www.keycloak.org/server/all-provider-config) for the exact option names.

### Login Theme Messages (26.5.0)

Message keys in login themes no longer render HTML or HTML entities: `<br/>` or `&laquo;` in a message show as plain text.

- The CodeMie login theme (`codemie/codemie-keycloak-theme`, see [Keycloak Theme Setup](../keycloak-theme-setup.md)) renders its pages in the browser. After the upgrade, open the login page, enter a wrong password and check the error text, and open an error page.
- For realm localization overrides set in the Admin Console, find texts with HTML:

```sql
SELECT r.name, l.locale
  FROM realm_localizations l JOIN realm r ON r.id = l.realm_id
 WHERE l.texts ~ '<[a-zA-Z/][^>]*>|&[a-zA-Z#0-9]+;';
```

- For any other custom theme, replace HTML entities with UTF-8 characters and HTML with plain text in its `messages_*.properties` files.

### SAML Identity Providers (26.5.4)

When Keycloak brokers a SAML identity provider, it now validates `SubjectConfirmationData` in the response: `NotBefore` and `NotOnOrAfter` against its clock, with the provider's allowed clock skew, and `Recipient` against the broker endpoint.

Find SAML identity providers and their clock skew:

```sql
SELECT r.name AS realm, i.provider_alias, i.enabled,
       (SELECT value FROM identity_provider_config
         WHERE identity_provider_id = i.internal_id AND name = 'allowedClockSkew') AS clock_skew
  FROM identity_provider i JOIN realm r ON r.id = i.realm_id
 WHERE i.provider_id = 'saml';
```

For each one, record a login with a SAML tracer browser extension and check the `SubjectConfirmationData` element:

- `Recipient` equals `https://<keycloak_host>/realms/<realm>/broker/<alias>/endpoint`.
- `NotBefore`, if present, is not later than the response `IssueInstant`.

If the clock skew is `0`, consider a small value such as 30 seconds under **Identity providers** → the provider → **Allowed clock skew**.

Keycloak also limits SAML messages inflated from the redirect binding to 128 KB. Regular authentication requests are far smaller; the limit can be raised with the `max-inflating-size` option of the `saml` login protocol provider.

### Request Paths with Semicolons (26.5.2)

Keycloak now answers HTTP 400 to request paths that contain `;`. If a client or a reverse proxy sends such paths, enable debug logging for `org.keycloak.quarkus.runtime.services.RejectNonNormalizedPathFilter` to find them. The option `http-accept-non-normalized-paths=true` restores the old behavior, but it is deprecated.

### Other Changes

- **Fine-Grained Admin Permissions v1** is deprecated. If `KC_FEATURES` contains `admin-fine-grained-authz:v1`, it still works; plan a migration to v2.
- **New database indexes** are created on `OFFLINE_USER_SESSION`, `OFFLINE_CLIENT_SESSION` and `BROKER_LINK`. Above 300,000 rows Keycloak skips them and prints the SQL statement in the log to run manually.
- **`session_state` and `sid`** are random strings instead of UUIDs. This matters only to integrations that parse them as UUIDs.
- **Outgoing HTTP client** has a connection request timeout of 5,000 ms by default.
- **LDAP referrals** are limited to LDAP URLs (26.4.6).

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

5. Confirm the schema version:

   ```sql
   SELECT version, to_timestamp(update_time) FROM migration_model
    ORDER BY update_time DESC LIMIT 1;   -- 26.5.7
   ```

6. Enable ingress, scale up to the previous replica count, and test logins, including every SAML identity provider and token exchange client found above.

To roll back, follow [Restore From Backup](./index.md#restore-from-backup).
