---
id: clone-mcp-server
title: Clone an MCP Server Configuration
sidebar_label: Clone MCP Server
pagination_prev: user-guide/tools_integrations/tools/mcp/mcp-integration-credentials
pagination_next: null
sidebar_position: 3
description: Create a new MCP catalog entry from an existing one, reviewing and editing values before saving.
---

# Clone an MCP Server Configuration

Cloning lets you start a new entry in the MCP server catalog from an existing one, instead of
re-entering every field by hand. The clone opens as an editable, pre-filled form so you can
review and adjust values before saving — not a one-click copy.

:::warning Access Required
Cloning an MCP server configuration is available only to **Platform Administrators** and
**Maintainers**. See [Roles and Access Control](../../../../admin/security/roles-rbac.md) for
details on these roles.
:::

This manages the same admin-controlled catalog referenced in
[Adding an MCP Server](./adding-an-mcp-server.md) (the servers available under **Browse Catalog**,
and the only servers selectable when `mcpCustomServersDisabled` restricts users to catalog-only
configuration).

## Open MCP Catalog Management

1. Click the **Profile** icon in the bottom-left corner → **Settings** → **Administration** →
   **MCPs management**.
2. The **MCPs catalog management** page lists every server in the catalog, with its name,
   categories, description, visibility, and status.

![MCPs catalog management list, with the row actions menu open showing View Details, Edit, Clone, Copy ID, and Delete](../images/mcp-catalog-management-list.png)

Each row's actions menu offers **View Details**, **Edit**, **Clone**, **Copy ID**, and **Delete**.

## Clone an Existing Server

1. Open the actions menu (**⋮**) for the server you want to copy and select **Clone**.
2. The **Clone MCP Server** dialog opens immediately, pre-filled from the source server —
   **except Name, which opens empty.** Type a name before you can save; it is not pre-filled or
   suggested from the source name.
3. Review and edit any of the pre-filled values:
   - **Basic Information**: **Name** (required, starts empty), **Icon URL**, **Category** (choose
     up to three from the predefined list), **Description** (required).
   - **Documentation or Source Link**: **Link to MCP documentation** (required). **Link to Source
     code** isn't marked required in the dialog, but the form currently blocks saving if it's left
     empty — fill in a URL here even though it has no required indicator.
   - **Server Configuration**: the server's **Configuration JSON** (command/arguments or
     connection URL, depending on server type), with **Prettify** and copy helpers.
   - **Environment Variables**: the source's required environment variable definitions (name,
     description, required flag), editable and extendable with **Add Variable**.
4. Click **Clone Server** to save the new catalog entry, or **Cancel** to discard the draft.

:::info Secret values
If the source server's auth settings include a confidential OAuth2 client secret, the
Configuration JSON never shows the real value — the secret field is replaced with a
`has_client_secret` flag instead. Leave that part of the configuration as-is to carry the
original secret over to the clone unchanged, or add a `client_secret` value to set a different
secret for the clone. This applies specifically to OAuth2 client secrets in `auth_config`; other
values such as environment variables are not masked this way.
:::

## After Cloning

- The clone is saved as a **new, independent** catalog entry. Subsequent edits to the clone do not
  change the original, and edits to the original do not affect the clone.
- Visibility and system-provided status are always copied from the source and cannot be changed in
  the clone form.
- The clone starts with its own usage count of zero and is active immediately. The catalog list is
  sorted by usage count (most-used first) and then by name, so a freshly cloned entry appears
  wherever that sort places it — not necessarily at the top — once any existing servers in the
  catalog have been used.

## Validation and Errors

- **Name** and **Description** are required, as are **Link to MCP documentation** and the
  **Configuration JSON**.
- Configuration JSON must be valid JSON; an invalid server configuration is rejected on save.
- The name must be unique among the configurations you created — reusing a name you already used
  for another of your catalog entries is rejected with "Name already exists". A name used by a
  different admin or maintainer's entry does not conflict.
- If the source server is deleted before you finish cloning it, saving fails with
  "MCP configuration not found" — verify the configuration still exists and retry.
- On the rare case of an internal ID conflict, saving fails and can be retried — a new identifier
  is generated on every clone attempt.
