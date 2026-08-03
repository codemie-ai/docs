---
id: settings-transfer
title: Transfer Integrations Between Projects
sidebar_label: Transfer Integrations
sidebar_position: 3
pagination_prev: user-guide/api/index
pagination_next: null
---

# Transfer Integrations Between Projects

Transfer integrations from one project to another using the settings transfer endpoint. Access is restricted to **platform admins** and project **maintainers**.

## Endpoint

**POST** `/v1/settings/transfer`

## Request Body

| Field                   | Type   | Required | Description                                       |
| ----------------------- | ------ | -------- | ------------------------------------------------- |
| **source_project_name** | String | Yes      | Name of the project to transfer integrations from |
| **target_project_name** | String | Yes      | Name of the project to transfer integrations to   |
| **mode**                | String | Yes      | Transfer mode: `move` or `copy`                   |

### Modes

| Mode   | Behavior                                                                                       |
| ------ | ---------------------------------------------------------------------------------------------- |
| `move` | Integrations are removed from the source project and reassigned to the target project.         |
| `copy` | Integrations are duplicated in the target project. The originals remain in the source project. |

### Example Request

```http
POST /v1/settings/transfer
Content-Type: application/json
Authorization: Bearer <your-access-token>

{
  "source_project_name": "project-a",
  "target_project_name": "project-b",
  "mode": "copy"
}
```

## Response

The response includes the count of transferred and skipped integrations and the full list of each.

```json
{
  "message": "Transferred 3 integration(s) from 'project-a' to 'project-b'.",
  "source_project_name": "project-a",
  "target_project_name": "project-b",
  "mode": "copy",
  "transferred_count": 3,
  "transferred": [
    { "id": "...", "alias": "my-jira", "credential_type": "JIRA" }
  ],
  "skipped_count": 0,
  "skipped": []
}
```

## Skipped Integration Types (Copy Mode Only)

When `copy` mode is used, the following integration types are skipped and not duplicated:

- **Webhook**
- **Scheduler**

In `move` mode, all eligible integrations are transferred regardless of type.

## Error Responses

| Status Code | Description                                                                                                      |
| ----------- | ---------------------------------------------------------------------------------------------------------------- |
| **403**     | Caller does not have platform admin or maintainer permissions                                                    |
| **404**     | Source or target project not found                                                                               |
| **409**     | One or more integration aliases already exist in the target project — the response lists all conflicting aliases |
| **422**     | Invalid request: same source and target project, blank project name, or unsupported mode value                   |

### Resolving Alias Conflicts

If a `409` is returned, remove or rename the conflicting integrations in the target project before retrying.

## Effect on Source Project Entities

| Mode   | Impact on source project                                                                                                                                                                                                                 |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `move` | Assistants, data sources, and workflows in the source project that relied on the moved integrations will no longer have access to them. Review and update those entities after the transfer, or move them to the target project as well. |
| `copy` | Source project entities continue using the original integrations without interruption.                                                                                                                                                   |

:::tip
When moving an assistant, data source, or workflow to a new project, use `copy` mode first to set up matching integrations in the target project. Then move the entity. This avoids a gap where the entity has no functional integrations.
:::
