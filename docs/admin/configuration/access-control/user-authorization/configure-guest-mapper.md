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

Use this mapper when you need to classify a group of users (such as contractors or partners) as
external/guest without changing their role or project assignments.

:::info Relationship to `user_type`
The platform identifies external users through the `EXTERNAL_USER_TYPE` environment variable
(default: `"external"`). When the `guest` claim is present in the JWT, the platform sets the
user's `user_type` to the value configured in `EXTERNAL_USER_TYPE`. See
[External User Configuration](../../codemie/api-configuration.md#external-user-configuration)
for details.
:::

## Prerequisites

- Access to the Keycloak Admin Console for the `codemie-prod` realm.
- A client scope exists (or you are ready to create one) to assign to the intended users.
- The `developer` role is already assigned to the target users (see
  [Assign Roles](./assign-roles.md)).

## Step 1: Open or Create the Client Scope

1. In the Keycloak Admin Console, navigate to **Client scopes** from the left-hand menu.
2. Select an existing scope that is assigned to the CodeMie client, **or** click **Create
   client scope** to create a dedicated one (e.g., `guest-scope`).

:::tip Using a dedicated scope
Creating a separate `guest-scope` lets you assign the guest claim only to specific users by
adding the scope to their individual client scope assignments, without affecting all users of
the CodeMie client.
:::

## Step 2: Add the Protocol Mapper

1. Open the client scope and navigate to the **Mappers** tab.
2. Click **Add mapper** → **By configuration**.
3. Select **Hardcoded claim** from the mapper type list.

## Step 3: Configure the Mapper

Fill in the fields as follows, then click **Save**:

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
Set **Claim JSON type** to `boolean`, not `String`. Sending `"true"` (a string) instead of
`true` (a boolean) may prevent the platform from recognizing the user as external.
:::

## Step 4: Assign the Scope to the Target Users

If you created a dedicated `guest-scope`, assign it to each guest user:

1. Navigate to **Users** and open the user's detail page.
2. Go to the **Client scopes** tab.
3. Click **Add client scope** and select `guest-scope`.
4. Choose **Default** to ensure the scope is always included in the token.

If the scope is attached directly to the CodeMie client as a **default scope**, all users of
that client receive the `guest` claim automatically — use this approach only when the entire
user base should be treated as external.

## Step 5: Verify the Token

After assigning the scope, verify that the claim is present in the issued token:

1. In the Keycloak Admin Console, open the user's page and go to **Client scopes** →
   **Evaluate**.
2. Select the CodeMie client and click **Evaluate**.
3. In the **Generated access token** tab, confirm that `"guest": true` appears in the payload.

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
To remove guest restrictions from a user, remove the `guest-scope` from their **Client scopes**
assignment. The claim will no longer be included in their next token, and full platform access
will be restored on the next login.
:::
