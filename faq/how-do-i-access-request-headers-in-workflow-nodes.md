# How do I access request headers in workflow nodes?

Set `"propagate_headers": true` in the workflow execution request body. Safe incoming HTTP
headers are then stored in the context store under the `propagated_headers` key before the
first state runs, and are accessible in any state via `{{propagated_headers.<header-name>}}`.

## Execution request

```http
POST /v1/workflows/{workflow_id}/executions
Content-Type: application/json
X-Tenant-ID: acme-corp
X-Correlation-ID: trace-abc-123

{
  "user_input": "...",
  "propagate_headers": true
}
```

## Accessing headers in workflow YAML

**In a task prompt:**

```yaml
states:
  - id: process-request
    assistant_id: processor
    task: |
      Process the request for tenant {{propagated_headers.X-Tenant-ID}}.
      Trace ID: {{propagated_headers.X-Correlation-ID}}.
    next:
      state_id: end
```

**In tool arguments:**

```yaml
states:
  - id: call-api
    tool_id: api-tool
    tool_args:
      tenant_id: "{{propagated_headers.X-Tenant-ID}}"
      trace_id: "{{propagated_headers.X-Correlation-ID}}"
    next:
      state_id: end
```

**In a conditional expression (no `{{}}` syntax):**

```yaml
next:
  condition:
    expression: "propagated_headers.get('X-Environment') == 'production'"
    then: production-path
    otherwise: staging-path
```

## Blocked headers

Sensitive headers are never stored. The following are always excluded:
`Authorization`, `Cookie`, `Set-Cookie`, `Proxy-Authorization`, `X-Api-Key`, `X-Auth-Token`.

## Sources

- [Context Management — Propagated Request Headers](https://docs.codemie.ai/user-guide/workflows/configuration/context-management#64-propagated-request-headers)
- [MCP Header Propagation in Workflows](https://docs.codemie.ai/user-guide/workflows/configuration/integration-capabilities#94-mcp-header-propagation-in-workflows)
