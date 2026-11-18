---
id: idp-managed-mode-configuration
sidebar_position: 4
title: IdP-managed Mode Configuration
sidebar_label: ✨ IdP-managed Mode
description: How to let the identity provider own users, administrator rights and project membership through the IdP-sync management API
pagination_prev: admin/configuration/access-control/access-control-overview
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# IdP-managed Mode Configuration

<EnterpriseFeature />

In **IdP-managed mode** (`IDP_MANAGED_ENABLED=true`), the identity provider (IdP) owns users, the platform
administrator role, and project membership. The platform exposes a management API under `/v1/idp-sync/`. An external
sync job, run by the customer, calls this API to bring the IdP state into the platform. Changes made
through the platform UI or API are refused, so the IdP stays the single source of truth.

The platform ships the API and the switch only. It does not ship the sync job, a scheduler, or a sync image.
The job and its scheduling live on the customer side.

IdP-managed mode builds on [Platform-managed mode](./platform-managed-mode-configuration.md): enabling it
turns `ENABLE_USER_MANAGEMENT` on.

## What the Mode Changes

- Requests that change users, administrator status, or project membership through the platform return `403`.
- Reads and user budgets keep working.
- The mode is exposed in the public configuration, so the UI hides the editing controls.
- The mode does not depend on a particular IdP: the management API reads only standard token claims, and the sync job writes users and project membership through it.

:::note
The maintainer and auditor flags can still be edited in the administrator UI while the mode is on. If the
sync job manages these roles, its next run overwrites a manual change.
:::

## Prerequisites

- Access to the Kubernetes cluster and the Helm values of AI/Run CodeMie Backend (`codemie-api`)
- An IdP that issues OAuth 2.0 access tokens with the client credentials grant
- Administrative access to the IdP realm or tenant that holds the users
- A sync job that calls the management API (see [Management API Contract](#management-api-contract))

## Step 1: Create the IdP Client for the Sync Job

1. In the IdP, create a client (an application registration) for the sync job.
2. Set client authentication to **On**, so the client is confidential.
3. Enable the client credentials grant (in Keycloak: **Service accounts roles**).
4. Make the access token of the service account carry the claims listed below. A service account has no
   `name` and no `user_type` by default, so both need hardcoded-claim mappers (in Keycloak) or an equivalent claim configuration.

   | Claim                | Value                                                                                                                                                                       |
   | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
   | `sub`                | The ID of the service account user in the IdP. The platform looks the user up by it.                                                                                        |
   | `preferred_username` | The user name of the service account, for example `service-account-<client-id>` in Keycloak. Must equal `IDP_SYNC_SERVICE_ACCOUNT_USERNAME`, the same on every environment. |
   | `name`               | A display name (hardcoded-claim mapper).                                                                                                                                    |
   | `realm_access.roles` | The roles of the service account (in Keycloak, the realm roles).                                                                                                            |
   | `user_type`          | The fixed value `service_account` (hardcoded-claim mapper).                                                                                                                 |

   The platform refuses the API to any token whose user name differs from
   `IDP_SYNC_SERVICE_ACCOUNT_USERNAME` or whose `user_type` is not `service_account`. Without the other
   claims, the call can fail with `401` or `403`.

5. Store the client ID and the client secret in the secret store of the system that runs the job.

:::warning
The same client credentials that read the IdP also authorize writes to the platform. Treat the client secret
as a credential with write access to users and project membership.
:::

## Step 2: Allow the Client in the Platform

1. Take the user name of the service account: `service-account-<client-id>`, the `preferred_username` claim
   of its token.
2. Set it as `IDP_SYNC_SERVICE_ACCOUNT_USERNAME` in the Helm values of `codemie-api`.
3. Restart the API.

Only this account may call `/v1/idp-sync/`, and it may call nothing else. An empty
`IDP_SYNC_SERVICE_ACCOUNT_USERNAME` closes the management API to everyone.

## Step 3: Verify How the Token Is Checked

The platform runs in one of two modes. The mode in use determines which checks are required before the first
run.

**`JWKS_VALIDATION_ENABLED=true`.** The platform verifies the signature of the `Authorization: Bearer` token
against the issuers in `JWKS_TRUSTED_ISSUERS` and only then reads the claims. The issuer of the sync
client must be listed there with the right audience. A token from any other issuer is rejected with `401`. An
empty or invalid `JWKS_TRUSTED_ISSUERS` also returns `401` for every request.

**`JWKS_VALIDATION_ENABLED=false` (default).** The platform does not verify the signature. It trusts the
`x-auth-request-access-token` header set by the authentication proxy in front of it, so the proxy is the only
control. If the backend can be reached around the proxy, anyone can forge the sync account. Before the first
run, check all of the following:

1. A request through the ingress or proxy with a valid token succeeds:

   ```bash
   curl -H "Authorization: Bearer $TOKEN" "$API_URL/v1/idp-sync/users?per_page=1"
   ```

   The response status is `200`.

2. The same request with a forged `x-auth-request-access-token` header and no valid token is rejected.
3. A direct call to the backend service that bypasses the proxy returns `401`.
4. The backend has no network path other than through the proxy.

If check 2 or 3 fails, do not enable the mode and do not run the job. Enabling `JWKS_VALIDATION_ENABLED`
removes the dependency on the proxy.

The sync job must call the API address reached through the ingress or authentication proxy.

## Step 4: Roll Out in the Right Order

1. Deploy the platform with the management API first, then the sync job.
2. Run the sync job in dry-run mode. It logs the changes it would make and writes nothing.
3. Review the log. Fix the IdP data or the job settings until the planned changes are correct.
4. Run the first live sync.
5. Check users, the administrator role, and project membership in the platform.
6. Set `IDP_MANAGED_ENABLED=true` and restart the API.

:::warning
The mode must not be switched on before the first live sync. Changes through the platform are refused from
that moment on, so the platform must already hold the IdP state.
:::

If a step fails:

- After step 2 or 3, nothing was written. Fix the settings and repeat.
- After step 4 or 5, suspend the job, correct the IdP data, and run the sync again. Step 6 is done only
  when steps 4 and 5 are clean.
- If step 6 was already done, follow [Disable and Roll Back](#disable-and-roll-back).

## Maintainer and Auditor Roles

Besides users, project membership, and the administrator flag, the API carries the maintainer and auditor
flags. Which IdP roles map to them (in Keycloak, realm roles) is a setting of the sync job, not of the platform. The
following rules apply to the flags:

- The auditor flag is independent of other roles.
- A maintainer is always an administrator. A request with `is_maintainer=true` and `is_admin=false` is refused
  with `422`.
- A user who ends up without the administrator flag also ends up without the maintainer role.
- Removing the last active maintainer or the last active administrator is refused with `409`.
- A field that is omitted from the request leaves the stored flag unchanged.

When a role is switched on in the job for the first time, the next run removes it from every user who does not
hold the corresponding role in the IdP. The roles must be handed out in the IdP first, then checked in a dry
run, and only then switched on.

An older job that does not send `is_maintainer` and `is_auditor` leaves the stored flags unchanged.

## Management API Contract

All routes are under `/v1/idp-sync/` and are available to the service account from
[Step 1](#step-1-create-the-idp-client-for-the-sync-job) only. Every write is idempotent.

| Method and path                                               | Purpose                                                                                                       |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `GET /v1/idp-sync/users`                                      | Paged list of all users, deactivated included, ordered by ID. Query: `page` (from 0), `per_page` (up to 100). |
| `GET /v1/idp-sync/users/{user_id}`                            | One user with project memberships, deactivated users included.                                                |
| `PUT /v1/idp-sync/users/{user_id}`                            | Creates or updates a user. The ID in the path and in the body must match.                                     |
| `PUT /v1/idp-sync/users/{user_id}/projects/{project_name}`    | Assigns the user to a project and creates the project when it does not exist. Query: `is_project_admin`.      |
| `DELETE /v1/idp-sync/users/{user_id}/projects/{project_name}` | Removes the user from a project. A user that is not a member is already done.                                 |
| `POST /v1/idp-sync/users/{user_id}/deactivate`                | Deactivates the user.                                                                                         |

The body of `PUT /v1/idp-sync/users/{user_id}`:

| Field           | Required | Description                                                                                          |
| --------------- | -------- | ---------------------------------------------------------------------------------------------------- |
| `id`            | Yes      | The IdP user ID (UUID, the token subject).                                                           |
| `email`         | Yes      | The user email.                                                                                      |
| `username`      | Yes      | The login name.                                                                                      |
| `name`          | Yes      | The display name.                                                                                    |
| `is_admin`      | Yes      | The platform administrator flag.                                                                     |
| `picture`       | No       | An avatar URL, up to 1024 characters. An omitted or empty value leaves the stored picture unchanged. |
| `is_maintainer` | No       | The maintainer flag. Requires `is_admin=true`.                                                       |
| `is_auditor`    | No       | The auditor flag.                                                                                    |

Notable refusals:

- Personal projects cannot be assigned or removed (`409`). The same applies to the project creator on removal.
- The last active administrator and the sync account itself cannot be deactivated.
- The last active administrator or maintainer cannot be demoted (`409`).
- A reactivated user keeps memberships and member budget allocations. Only the missing budget shares are
  added, so limits set by a project administrator survive.

Role changes are written to the audit log as `user.updated`, with the sync account as the actor.

:::info
The platform keeps the administrator rights of the user set in `ADMIN_USER_ID` on its own, independent of the
IdP data.
:::

## Disable and Roll Back

1. Suspend the sync job first. Stopping it stops all changes at once.
2. Set `IDP_MANAGED_ENABLED=false` and restart the API. Do this only after the job is suspended, otherwise
   the next run undoes the changes made in the platform.
3. Users that the sync created or changed stay as they are.
