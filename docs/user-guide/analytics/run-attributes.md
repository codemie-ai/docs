---
id: run-attributes
title: Run Attributes in Analytics
sidebar_label: Run Attributes
sidebar_position: 5
pagination_prev: user-guide/analytics/analytics-overview
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Run Attributes in Analytics

<EnterpriseFeature />

Run attributes are custom string labels attached to a single assistant conversation or a single workflow execution when the run starts. In analytics, the labels make individual runs identifiable and easy to group. For example, usage can be reported per work item, per team, or per customer engagement, using the values supplied by the caller.

This page describes how run attributes appear in analytics and how to filter and group by them. For how to supply attributes, including the validation rules, see [Run Attributes](../api/index.md#run-attributes) in the API guide.

:::info Where run attributes are available
Run attributes are returned by the analytics API and SDKs. The Analytics Dashboard UI does not display them.
:::

## Prerequisites

- Run attributes were supplied when the conversation or workflow execution started. Runs started without attributes, including all runs started before the feature was released, carry no attributes.
- Insights analytics is enabled for the deployment. This requires [LiteLLM Proxy](../../admin/deployment/extensions/litellm-proxy/index.md). When it is not enabled, the analytics endpoints return `403`.
- The caller can use analytics. Visibility follows the [Analytics Dashboard access rules](./index.md#access-permissions-and-data-visibility): super admins see all runs, project admins see runs of the projects they administer, and other users see their own runs.

## What Is Stored

| Item                        | Description                                                                                                                                                                        |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Usage records**           | Every usage record of a run with attributes carries the attributes. This includes tool-call resume turns, resumed workflow executions, and sub-workflows (the parent's attributes) |
| **Immutability**            | Attributes are fixed when the run starts. All usage records of the run carry the same values                                                                                       |
| **Runs without attributes** | Records are unchanged and appear in analytics as before                                                                                                                            |
| **Not recorded**            | Chats started with `save_history` set to `false` and virtual assistants write no usage records, so they never appear in attribute-based analytics                                  |

## Analytics Endpoints

All endpoints are under `/v1/analytics` and return the standard tabular analytics response. They share the common query parameters `time_period`, `start_date`, `end_date`, `users`, `projects`, `page`, and `per_page`, and the optional `client_source` filter.

| Endpoint                    | Result                                                                                                      |
| --------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `GET /assistants-chats`     | Assistant chat usage. Accepts the `attributes` filter                                                       |
| `GET /assistants-requests`  | One row per assistant request. Has an `attributes` column and accepts the `attributes` filter               |
| `GET /workflows`            | Workflow usage. Accepts the `attributes` filter                                                             |
| `GET /workflows-executions` | One row per workflow execution. Has an `attributes` column and accepts the `attributes` filter              |
| `GET /attributes-usage`     | Usage grouped by the values of one attribute key. Requires `attribute_key`, accepts the `attributes` filter |

The `/summaries` endpoint does not support the `attributes` filter.

## Filtering by Attributes

The `attributes` query parameter takes a JSON object of string keys and string values. Only runs that carry all the given pairs are counted.

```bash
curl -G "https://codemie.example.com/code-assistant-api/v1/analytics/workflows-executions" \
  -H "Authorization: Bearer <your-access-token>" \
  --data-urlencode "time_period=last_30_days" \
  --data-urlencode 'attributes={"com.epam.gen_ai.service.work_item.id":"ABC-123"}'
```

- **Matching:** Every pair in the filter must match exactly. A run with additional attributes still matches.
- **Validation:** Filter keys and values follow the same rules as run attributes. A filter that is not a JSON object, contains non-string values, or has an invalid key or value returns `422`.
- **Echo:** The applied filter is returned as `attributes` in `metadata.filters_applied` of the response.
- **Cost under a filter:** When the `attributes` filter is set, cost figures reflect only the matching runs.

## Usage by Attribute Value

`GET /v1/analytics/attributes-usage` breaks usage down by the values of one attribute key, with one row per value.

```bash
curl -G "https://codemie.example.com/code-assistant-api/v1/analytics/attributes-usage" \
  -H "Authorization: Bearer <your-access-token>" \
  --data-urlencode "attribute_key=team" \
  --data-urlencode "time_period=last_30_days"
```

| Column                  | Description                                                |
| ----------------------- | ---------------------------------------------------------- |
| **value**               | Value of the attribute key                                 |
| **conversations**       | Number of distinct assistant conversations with this value |
| **workflow_executions** | Number of distinct workflow executions with this value     |
| **total_tokens**        | Input plus output tokens                                   |
| **total_cost**          | Cost of the runs carrying this value                       |
| **unique_users**        | Number of distinct users who started those runs            |
| **last_used**           | Timestamp of the newest usage record                       |

- **Required key:** `attribute_key` must follow the attribute key rules. A missing or invalid key returns `422`.
- **Narrowing:** The `attributes` filter limits the rows to runs that also carry the given pairs.
- **Unknown keys:** A key that no run carries returns an empty table. The keys in use are not listed by any endpoint.
- **Not covered:** Runs without attributes are absent.

## Per-Execution Workflow Analytics

`GET /v1/analytics/workflows-executions` returns one row per workflow execution, most recent activity first. It is the workflow counterpart of `assistants-requests`.

| Column                                                | Description                                                                      |
| ----------------------------------------------------- | -------------------------------------------------------------------------------- |
| **execution_id**                                      | Workflow execution identifier                                                    |
| **last_activity**                                     | Timestamp of the newest usage record of the execution                            |
| **workflow_name**, **status**                         | Taken from the newest usage record, so `status` is the latest reported status    |
| **user_id**, **user_name**, **user_email**            | User who started the execution                                                   |
| **project**                                           | Project of the execution                                                         |
| **usage_records**                                     | Number of usage records grouped into the row                                     |
| **input_tokens**, **output_tokens**, **total_tokens** | Summed tokens. `total_tokens` is input plus output and excludes cached tokens    |
| **money_spent**                                       | Cost of the whole execution                                                      |
| **execution_time**                                    | Largest execution time reported, in seconds                                      |
| **attributes**                                        | Run attributes as a `{key: value}` object, or `null` when the execution has none |

- An execution appears once it has written a usage record. Executions removed after completion (`delete_on_completion`) are still listed.
- `totals` cover every execution in the filtered range, not only the requested page.
- At most the first 10,000 executions of a filtered range can be paged. Narrow the date range or add filters to reach older executions. Above 3,000 executions, `total_count` is approximate.
- When Elasticsearch is not configured or a search is incomplete, the endpoint returns `503` instead of partial data.

## Per-Request Assistant Analytics

`GET /v1/analytics/assistants-requests` lists one row per assistant request. Each row has an `attributes` column with the attributes of the request's conversation, or `null` when the conversation has none. The `attributes` filter keeps the requests of conversations that carry all the given pairs, so every request of a matching conversation is listed.

## Cost Figures

Cost of runs with attributes is priced per run from the LiteLLM spend ledger, by `execution_id` for workflow executions and by `request_id` for chat requests.

- Runs first seen before the ledger's coverage start, and deployments without the ledger, use the cost stored in the usage records.
- A cost that the ledger has not recorded yet is returned as `null` with `spend_unavailable: true`. A sum that is missing unsettled costs is flagged `spend_partial: true`.
- `money_spent` in `workflows-executions` is the cost of the whole execution. In `workflows`, cost is attributed per LLM call to the period in which the call started, so the two cost totals do not reconcile in general. Token totals do reconcile for the same filters and date range.

## Limitations and Trust

- **Declared, not verified.** Values are supplied by the callers who start the runs. Totals grouped or filtered by attributes are only as reliable as the callers' labelling.
- **No secrets or personal data.** Anyone who can see a run or its usage analytics can read its attributes, and values are also written to usage metrics and application logs.
- **No retroactive labelling.** Attributes cannot be added to runs that already started.
- **Analytics only.** Attributes are never passed to the assistant, its tools, or the workflow. See [Attributes Versus Prompt Context and Tags](../api/index.md#attributes-versus-prompt-context-and-tags).

## SDK Support

Both SDKs expose the endpoints and accept `attributes` as an object. The SDKs encode the filter as the JSON string the API expects.

| Endpoint               | Python SDK                 | Node.js SDK              |
| ---------------------- | -------------------------- | ------------------------ |
| `assistants-requests`  | `get_assistants_requests`  | `getAssistantsRequests`  |
| `workflows-executions` | `get_workflows_executions` | `getWorkflowsExecutions` |
| `attributes-usage`     | `get_attributes_usage`     | `getAttributesUsage`     |

```python
from codemie_sdk.models.analytics import AttributesUsageQueryParams

usage = client.analytics.get_attributes_usage(
    AttributesUsageQueryParams(
        attribute_key="team",
        attributes={"env": "prod"},
    )
)
```

```typescript
const usage = await client.analytics.getAttributesUsage({
  attribute_key: "team",
  attributes: { env: "prod" },
});
```
