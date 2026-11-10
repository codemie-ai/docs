# How do I transfer integrations from one project to another?

Platform Admins and Maintainers can call `POST /v1/settings/transfer` with `source_project_name`, `target_project_name`, and a `mode`:

- `move` reassigns the integrations to the target project, so they are no longer available in the source project.
- `copy` duplicates them in the target project and leaves the originals in place. Webhook and scheduler integrations are not copied.

To limit the scope, add `type_of_integration` with the `user_integrations` and `project_integrations` flags, and optionally a `list` of integration aliases. Without them, all user and project integrations are transferred. The call fails with `409` if an alias already exists in the target project, and nothing is transferred.

After a `move`, assistants, workflows, and data sources in the source project that relied on the moved integrations lose access to them. Use `copy` first if assistants or workflows must keep working. Data sources reference integrations by ID, so a data source must be pointed at the copied integration after it is moved.

## Sources

- [Transfer Integrations Between Projects](https://docs.codemie.ai/user-guide/api/settings-transfer)
