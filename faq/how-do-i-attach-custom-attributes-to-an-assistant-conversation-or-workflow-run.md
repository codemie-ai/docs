# How do I attach custom attributes to an assistant conversation or workflow run for analytics?

Pass an `attributes` object of string keys and string values in the request that starts the conversation or the workflow execution. Attributes are fixed when the run starts and cannot be changed afterwards.

**Assistant conversation:**

```http
POST /v1/assistants/{assistant_id}/model
Content-Type: application/json
Authorization: Bearer <your-access-token>

{
  "text": "Summarize the open pull requests",
  "attributes": { "com.epam.gen_ai.service.work_item.id": "ABC-123" }
}
```

**Workflow execution:**

```http
POST /v1/workflows/{workflow_id}/executions
Content-Type: application/json
Authorization: Bearer <your-access-token>

{
  "user_input": "Run deployment check",
  "attributes": { "com.epam.gen_ai.service.work_item.id": "ABC-123" }
}
```

At most 4 attributes are allowed per run. A key is 2-64 characters of lowercase letters, digits, `.`, `_` or `-`, starts and ends with a letter or digit, and must not start with `codemie.` or `otel.`. A value is a string of 1-128 characters without control characters. Invalid attributes return `422` and the run does not start. Sub-workflows inherit the attributes of the parent execution.

Attributes are analytics labels only: they are never passed to the assistant or the workflow. With the Enterprise package, runs can be filtered and grouped by attributes through the analytics API. Values are visible to everyone who can see the run or its analytics, so they must not contain secrets or personal data.

## Sources

- [Run Attributes](https://codemie-ai.github.io/docs/user-guide/api/#run-attributes)
- [Run Attributes in Analytics](https://codemie-ai.github.io/docs/user-guide/analytics/run-attributes)
