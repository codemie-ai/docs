---
id: configure-guest-mapper
sidebar_position: 4
title: Configure Guest Mapper
description: Set up a Keycloak client scope mapper to classify users as external/guest
pagination_prev: admin/configuration/access-control/user-authorization/assign-attributes
pagination_next: null
---

The **guest** mapper is a Hardcoded Claim protocol mapper added to a Keycloak client scope. It
automatically embeds a `guest` claim with the value `true` into the JWT token for every user
who receives that scope. The CodeMie platform reads this claim to determine the user's
`user_type`, restricting the UI to components marked `availableForExternal: true`.

This mapper should be used when a group of users (such as contractors or partners) needs to be
classified as external/guest without changing their role or project assignments.

:::info Relationship to `user_type`
External users are identified through the `EXTERNAL_USER_TYPE` environment variable
(default: `"external"`). When the `guest` claim is present in the JWT, the user's
`user_type` is set to the value configured in `EXTERNAL_USER_TYPE`. See
[External User Configuration](../../codemie/api-configuration.md#external-user-configuration)
for details.
:::

## Prerequisites

- Access to the Keycloak Admin Console for the `codemie-prod` realm.
- A client scope exists (or is ready to be created) for assignment to the intended users.
- The `developer` role is already assigned to the target users (see
  [Assign Roles](./assign-roles.md)).

## Step 1: Open or Create the Client Scope

1. In the Keycloak Admin Console, **Client scopes** should be opened from the left-hand menu.
2. An existing scope assigned to the CodeMie client should be selected, **or** **Create client
   scope** should be clicked so a dedicated scope can be created (e.g., `guest-scope`).

:::tip Using a dedicated scope
By creating a separate `guest-scope`, the guest claim can be assigned only to specific users by
adding the scope to their individual client scope assignments, without affecting all users of
the CodeMie client.
:::

## Step 2: Add the Protocol Mapper

1. The client scope should be opened, and the **Mappers** tab should be selected.
2. **Add mapper** → **By configuration** should be clicked.
3. **Hardcoded claim** should be selected from the mapper type list.

## Step 3: Configure the Mapper

The fields should be filled in as follows, then **Save** should be clicked:

| Field                   | Value     |
| ----------------------- | --------- |
| **Name**                | `guest`   |
| **Token Claim Name**    | `guest`   |
| **Claim value**         | `true`    |
| **Claim JSON type**     | `boolean` |
| **Add to ID token**     | `On`      |
| **Add to access token** | `On`      |
| **Add to userinfo**     | `On`      |

:::warning Claim JSON type
**Claim JSON type** should be set to `boolean`, not `String`. If `"true"` (a string) is sent
instead of `true` (a boolean), recognition of the user as external may be prevented.
:::

## Step 4: Assign the Scope to the Target Users

If a dedicated `guest-scope` was created, it should be assigned to each guest user:

1. The **Users** section should be opened, and the user's detail page should be selected.
2. The **Client scopes** tab should be opened.
3. **Add client scope** should be clicked, and `guest-scope` should be selected.
4. **Default** should be chosen to ensure the scope is always included in the token.

If the scope is attached directly to the CodeMie client as a **default scope**, all users of
that client receive the `guest` claim automatically; this approach should be used only when the
entire user base should be treated as external.

## Step 5: Verify the Token

After the scope is assigned, it should be verified that the claim is present in the issued token:

1. In the Keycloak Admin Console, the user's page should be opened, and **Client scopes** →
   **Evaluate** should be selected.
2. The CodeMie client should be selected, and **Evaluate** should be clicked.
3. In the **Generated access token** tab, it should be confirmed that `"guest": true` appears in the payload.

```json
{
  "sub": "...",
  "realm_access": { "roles": ["developer"] },
  "guest": true,
  ...
}
```

## Result

Users with the `guest` claim in their JWT token are recognized by the CodeMie platform as
external users. Their access is limited to projects listed in `EXTERNAL_USER_ALLOWED_PROJECTS`
and UI components that have `availableForExternal: true`.

:::note Reverting guest access
To remove guest restrictions from a user, the `guest-scope` should be removed from their
**Client scopes** assignment. The claim will no longer be included in their next token, and full
platform access will be restored on the next login.
:::
