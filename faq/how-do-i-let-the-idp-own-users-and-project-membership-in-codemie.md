# How do I let the identity provider own users, administrator rights, and project membership in AI/Run CodeMie?

Use **IdP-managed mode**, which is part of the Enterprise package. The steps are written and verified for Keycloak. In this mode the identity provider (IdP) is the single source
of truth for users, the administrator role, and project membership. A sync job run by the customer reads
the IdP and writes the state into the platform through the `/v1/idp-sync/` management API. The platform does
not ship the job or a scheduler.

1. Create a confidential IdP client with a service account for the sync job (client credentials grant).
2. Set the `preferred_username` of that service account (`service-account-<client-id>` in Keycloak) as
   `IDP_SYNC_SERVICE_ACCOUNT_USERNAME` in the `codemie-api` Helm values and restart the API.
3. Run the sync job in dry-run mode, review the log, and run the first live sync.
4. Set `IDP_MANAGED_ENABLED=true` and restart the API.

The mode must be switched on only after the first live sync, because changes made through the platform are
refused from that moment on. The platform does not start with `IDP_PROVIDER=local`.

## Sources

- [IdP-managed Mode Configuration](https://docs.codemie.ai/admin/configuration/access-control/idp-managed-mode-configuration)
