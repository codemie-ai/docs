# What options does CodeMie have for integrating into Enterprise Identity and Auth providers such as Okta, PingIdentity, and CyberArk?

CodeMie uses **Keycloak as the identity broker layer**. All enterprise Identity Providers (Okta, PingIdentity, CyberArk, Entra ID, and any OIDC/SAML 2.0 provider) are integrated through Keycloak, which then connects to CodeMie. A generic OIDC option also exists for direct integration without Keycloak.

## Supported IDP Options

The `IDP_PROVIDER` configuration setting controls the identity provider:

| Value      | Use case                                                                           |
| ---------- | ---------------------------------------------------------------------------------- |
| `keycloak` | Recommended for production. Supports SSO federation with any OIDC or SAML 2.0 IdP. |
| `oidc`     | Generic OIDC for direct integration, bypassing Keycloak.                           |
| `local`    | Development only.                                                                  |

## Integration Path: Okta / PingIdentity / CyberArk → Keycloak → CodeMie

Since Keycloak natively federates any **OIDC or SAML 2.0** identity provider, Okta, PingIdentity, and CyberArk are all supported through the standard Keycloak Identity Provider configuration.

### Step 1 — Configure your IdP in Keycloak

1. In your `codemie-prod` Keycloak realm, navigate to **Identity Providers**
2. Select **OpenID Connect v1.0** (for Okta/PingIdentity/CyberArk with OIDC) or **SAML v2.0**
3. Fill in:
   - **Discovery endpoint** (OIDC metadata URL from your IdP)
   - **Client ID** and **Client Secret** from your IdP app registration
4. Copy the **Redirect URI** that Keycloak generates and register it in your IdP

### Step 2 — Configure Keycloak client for CodeMie

Create or use an existing Keycloak client (e.g., `admin-cli`) with:

- Client authentication: **enabled**
- Standard flow: **enabled**
- Direct access grants: **enabled**
- Service accounts roles: `view-users`, `query-users`, `manage-users`, `view-realm`, `view-identity-providers`, `impersonation`, `query-groups`

Copy the **Client Secret** from the Credentials tab.

### Step 3 — Create the Keycloak integration in CodeMie

1. Go to **Integrations → Create**
2. Set **Credential Type: Keycloak**
3. Fill in: Alias, Keycloak Base URL, Realm, Client ID, Client Secret
4. Click **Save**

### Step 4 — Add automation mappers (required)

Without mappers, new SSO users are created in Keycloak but cannot access the platform. Configure two mappers on the Identity Provider:

**Mapper 1 — Assign Default Role:**

- Mapper Type: `Hardcoded Role`
- Role: `developer`
- Sync Mode: `Import`

**Mapper 2 — Assign Default Project:**

- Mapper Type: `Attribute Importer`
- Claim: `email` (or `preferred_username` / `upn` depending on IdP)
- User Attribute Name: `applications`

## Microsoft Entra ID (fully documented)

Entra ID has a complete step-by-step guide covering Azure app registration, Keycloak federation via OpenID Connect v1.0, redirect URI configuration, mapper setup, and admin consent flow.

See: [Keycloak + Entra ID Setup](https://docs.codemie.ai/admin/configuration/access-control/user-provisioning/keycloak-entra-id)

## User Provisioning Options

Once SSO is configured, three user provisioning methods are available:

| Method             | Description                                                               |
| ------------------ | ------------------------------------------------------------------------- |
| Manual creation    | Admin creates users one by one in Keycloak                                |
| Keycloak Assistant | Bulk/programmatic user creation via the Keycloak tool in an assistant     |
| SSO with mappers   | Fully automatic — users and projects created on first login (recommended) |

## Sources

- [Access Control Overview](https://docs.codemie.ai/admin/configuration/access-control/) — HTTP 200
- [User Provisioning](https://docs.codemie.ai/admin/configuration/access-control/user-provisioning/) — HTTP 200
- [Keycloak + Entra ID Setup](https://docs.codemie.ai/admin/configuration/access-control/user-provisioning/keycloak-entra-id) — HTTP 200
- [Keycloak Assistant Provisioning](https://docs.codemie.ai/admin/configuration/access-control/user-provisioning/keycloak-assistant) — HTTP 200
- [Manual User Creation](https://docs.codemie.ai/admin/configuration/access-control/user-provisioning/manual-creation) — HTTP 200
- [User Authorization Overview](https://docs.codemie.ai/admin/configuration/access-control/user-authorization/) — HTTP 200
- [Assign Roles](https://docs.codemie.ai/admin/configuration/access-control/user-authorization/assign-roles) — HTTP 200
- [Assign Attributes](https://docs.codemie.ai/admin/configuration/access-control/user-authorization/assign-attributes) — HTTP 200
- [Keycloak Tool Integration](https://docs.codemie.ai/user-guide/tools_integrations/tools/keycloak) — HTTP 200
