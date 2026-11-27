# How do I filter or group analytics by custom run attributes?

Use the analytics API (Enterprise package). The `attributes` query parameter takes a JSON object and keeps only runs that carry all the given pairs. It is supported by `assistants-chats`, `assistants-requests`, `workflows`, `workflows-executions` and `attributes-usage` under `/v1/analytics`.

```bash
curl -G "https://codemie.example.com/code-assistant-api/v1/analytics/workflows-executions" \
  -H "Authorization: Bearer <your-access-token>" \
  --data-urlencode "time_period=last_30_days" \
  --data-urlencode 'attributes={"team":"alpha"}'
```

To group usage by the values of one attribute key, call `GET /v1/analytics/attributes-usage` with `attribute_key`. It returns one row per value with conversations, workflow executions, tokens, cost, unique users and the last usage time. `workflows-executions` and `assistants-requests` list individual runs and include an `attributes` column.

Runs started without attributes, including runs started before the feature was released, are not included in attribute-based results. Values are declared by callers and not verified.

## Sources

- [Run Attributes in Analytics](https://codemie-ai.github.io/docs/user-guide/analytics/run-attributes)
