---
id: settings-transfer
title: Transfer Integrations Between Projects
sidebar_label: Transfer Integrations
pagination_prev: user-guide/api/index
pagination_next: null
sidebar_position: 3
---

# Transfer Integrations Between Projects

Move or copy integrations from one project to another with a single API call, optionally limited to user or project integrations, or to a list of specific integrations. Without this endpoint, an integration would have to be recreated manually in every project that needs it.

Access is restricted to users with the platform **Admin** or **Maintainer** role.

## Endpoint

**POST** `/v1/settings/transfer`

The path is relative to the API base URL, for example `https://codemie.example.com/code-assistant-api`.

## Request Body

| Field                   | Type      | Required | Description                                                                                                                |
| ----------------------- | --------- | -------- | -------------------------------------------------------------------------------------------------------------------------- |
| **source_project_name** | String    | Yes      | Name of the project to transfer integrations from                                                                          |
| **target_project_name** | String    | Yes      | Name of the project to transfer integrations to. Must differ from the source project                                       |
| **mode**                | String    | Yes      | Transfer mode: `move` or `copy`                                                                                            |
| **type_of_integration** | Object    | No       | Selects which integration types are transferred. When omitted, both user and project integrations are transferred          |
| **list**                | String\[] | No       | Aliases of the integrations to transfer. When omitted, every integration that matches `type_of_integration` is transferred |

### Modes

| Mode   | Behavior                                                                                       |
| ------ | ---------------------------------------------------------------------------------------------- |
| `move` | Integrations are removed from the source project and reassigned to the target project.         |
| `copy` | Integrations are duplicated in the target project. The originals remain in the source project. |

### Integration Type Filter

The `type_of_integration` object contains two Boolean flags:

| Field                    | Description                                                                   |
| ------------------------ | ----------------------------------------------------------------------------- |
| **user_integrations**    | Include integrations created at the user level (owned by individual users)    |
| **project_integrations** | Include integrations created at the project level (shared across the project) |

| `user_integrations` | `project_integrations` | Transferred integrations      |
| ------------------- | ---------------------- | ----------------------------- |
| `true`              | `true`                 | User and project integrations |
| `true`              | `false`                | User integrations only        |
| `false`             | `true`                 | Project integrations only     |
| `false`             | `false`                | Rejected with `422`           |

:::warning Omitted flags default to false
When `type_of_integration` is omitted entirely, both types are transferred. When the object is present, a flag that is not specified defaults to `false`. For example, `{"user_integrations": true}` transfers user integrations only.
:::

User integrations are scoped per user, so several users in the same project can each own an integration with the same alias. When such an alias is listed in `list` and `user_integrations` is `true`, all of them are transferred.

### Integration List

The `list` field contains integration aliases, as displayed in the **Integrations** list. The list is validated before anything is transferred, and the request is rejected with `422` if it:

- is empty (omit the field instead to transfer everything that matches the type filter)
- contains an alias that does not exist in the source project
- contains an alias that exists in the source project but is excluded by `type_of_integration`
- contains an alias of an integration managed internally by the platform
- contains a webhook or scheduler integration while `mode` is `copy`

### Example Requests

Move all user and project integrations:

```http
POST /v1/settings/transfer
Content-Type: application/json
Authorization: Bearer <access-token>

{
  "source_project_name": "project-a",
  "target_project_name": "project-b",
  "mode": "move"
}
```

Copy only project integrations, limited to two aliases:

```http
POST /v1/settings/transfer
Content-Type: application/json
Authorization: Bearer <access-token>

{
  "source_project_name": "project-a",
  "target_project_name": "project-b",
  "mode": "copy",
  "type_of_integration": {
    "user_integrations": false,
    "project_integrations": true
  },
  "list": ["git-integration", "kb-integration"]
}
```

## Response

The response reports the number and the full list of transferred and skipped integrations.

```json
{
  "message": "Transferred 3 integration(s) from 'project-a' to 'project-b'.",
  "source_project_name": "project-a",
  "target_project_name": "project-b",
  "mode": "copy",
  "transferred_count": 3,
  "transferred": [{ "id": "...", "alias": "my-jira", "credential_type": "JIRA" }],
  "skipped_count": 0,
  "skipped": []
}
```

When no integration matches the request, the call succeeds with `transferred_count` set to `0` and a message stating that no transferable integrations were found.

The transfer is atomic. Either every selected integration is transferred, or none is and an error is returned, so there is no partial result to reconcile.

## Skipped Integration Types (Copy Mode Only)

When `copy` mode is used without a `list`, the following integration types are not duplicated and are returned in `skipped`:

- **Webhook**
- **Scheduler**

In `move` mode, these types are transferred like any other integration. Integrations created and managed internally by the platform are never transferred in either mode.

## Error Responses

| Status Code | Description                                                                                                                                                                             |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **403**     | The caller is not a platform Admin or Maintainer                                                                                                                                        |
| **404**     | Source or target project not found                                                                                                                                                      |
| **409**     | One or more aliases already exist in the target project (the response lists all conflicting aliases), or an integration was changed by a concurrent request during the transfer         |
| **422**     | Invalid request: same source and target project, empty project name, unsupported `mode`, no integration type selected, or an invalid `list` (see [Integration List](#integration-list)) |

### Resolving Alias Conflicts

If a `409` is returned for an alias conflict, remove or rename the conflicting integrations in the target project, or rename them in the source project, then retry. A conflicting integration can be project-scoped or owned by another user. If the conflict was caused by a concurrent change, retry the request.

## Effect on Source Project Entities

| Mode   | Impact on source project                                                                                                                                                                                                                                                                                                                                |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `move` | Integration IDs do not change. Assistants, workflows, and skills in the source project that reference a moved integration by alias lose access to it. Data sources left in the source project have their integration link cleared, so they stop using credentials that now belong to another project. Update or move those entities after the transfer. |
| `copy` | Source project entities continue using the original integrations without interruption.                                                                                                                                                                                                                                                                  |

:::tip
When moving an assistant or workflow to a new project, use `copy` mode first so integrations with the same aliases exist in the target project. Then move the entity. Data sources reference integrations by ID rather than alias, so after moving a data source, select the copied integration in the data source settings. Alternatively, move the data source first and then `move` its integrations: the data source keeps its link.
:::
