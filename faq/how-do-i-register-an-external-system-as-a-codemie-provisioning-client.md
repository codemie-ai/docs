# How do I register an external system as a CodeMie provisioning client?

An external system, such as a ServiceNow request portal, calls the CodeMie provisioning API (`/v1/provisioning`) with its own service account. An administrator registers that account in `provisioning-clients-config.yaml`:

1. Create a client credentials client in the identity provider and get the CodeMie user ID of its service account (the `sub` claim of its token, a UUID).
2. Add an entry with a `name`, the `user_id`, and the `permissions` the system needs: `provisioning:read-projects`, `provisioning:manage-budgets`, and `provisioning:manage-projects`.
3. Mount the file into the api, ds-pool, and proxy-pool workloads, set `PROVISIONING_API_ENABLED=true` and `ENABLE_USER_MANAGEMENT=true`, and restart all three workloads. The file is read only at startup.
4. Hand over the client credentials only after the restart. A registered account can call only the provisioning API.

## Sources

- [Provisioning Clients Configuration](https://docs.codemie.ai/admin/configuration/codemie/provisioning-clients)
