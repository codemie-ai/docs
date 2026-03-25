# How do I attach tags to a workflow execution for Langfuse tracing?

Pass a `tags` array in the execution request. Tags are attached to the Langfuse trace for that run and have no effect on execution behavior.

**API:**

```http
POST /v1/workflows/{workflow_id}/executions
Content-Type: application/json
Authorization: Bearer <your-access-token>

{
  "user_input": "Run deployment check",
  "tags": ["experiment", "customer_X"]
}
```

**Python SDK:**

```python
result = client.workflows.run(
    workflow_id="<workflow-id>",
    user_input="Run deployment check",
    tags=["experiment", "customer_X"],
)
```

**Node.js SDK** (`tags` is the 7th positional argument):

```typescript
const result = await client.workflows.run(
  "<workflow-id>",
  "Run deployment check", // userInput
  undefined,              // fileName
  undefined,              // sessionId
  undefined,              // propagateHeaders
  undefined,              // headers
  ["experiment", "customer_X"], // tags
);
```

## Sources

- [Execute Workflow](https://codemie-ai.github.io/docs/user-guide/api/#execute-workflow)
