# How do I transfer integrations from one project to another?

Integrations can be transferred between projects using the `POST /v1/settings/transfer` API endpoint. This is an API-only operation available to **platform admins** and project **maintainers** only.

Two modes are supported:

- **move** — integrations are removed from the source project and reassigned to the target project. Entities in the source project that relied on those integrations will lose access after the transfer.
- **copy** — integrations are duplicated in the target project while remaining in the source project. Source project entities continue working without interruption.

**Request example:**

```json
POST /v1/settings/transfer

{
  "source_project_name": "project-a",
  "target_project_name": "project-b",
  "mode": "copy"
}
```

**Things to note:**

- In `copy` mode, **Webhook** and **Scheduler** integration types are skipped and not duplicated.
- If an integration with the same alias already exists in the target project, the transfer fails with a `409 Conflict` error listing all conflicting aliases. Rename or remove the conflicting integrations in the target project before retrying.
- When moving an assistant, data source, or workflow to a new project, use `copy` mode first to set up matching integrations in the target project, then move the entity.

## Sources

- [Integrations — Transferring Integrations Between Projects](https://docs.codemie.ai/user-guide/tools_integrations/integrations/#transferring-integrations-between-projects)
