---
id: troubleshooting
title: Troubleshooting
sidebar_label: Troubleshooting
pagination_prev: user-guide/workflows/configuration/examples
pagination_next: null
sidebar_position: 12
---

# Troubleshooting

## 12.1 Common Issues

### Validation Errors

- **Undefined references**: Ensure all IDs are defined before use
- **Invalid YAML syntax**: Check indentation and special characters
- **Missing required fields**: Review configuration requirements
- **Schema validation failures**: Verify structure matches schema

### Execution Errors

- **State not found**: Check state ID references
- **Tool execution failures**: Verify tool arguments and permissions
- **Context access errors**: Ensure variables exist in context store
- **Timeout issues**: Adjust recursion limits and retry policies

### Memory Issues

- **Token limit exceeded**: Enable summarization or reduce context
- **Context too large**: Clear unnecessary data between states
- **History accumulation**: Configure memory limits appropriately

---

## 12.4 Tool Output Token Limit Exceeded {#tool-output-token-limit-exceeded}

### Error pattern

When a tool returns a response that exceeds `limit_tool_output_tokens`, the following error is
logged and the output is truncated:

```
<tool-name> output is too long: <N> tokens. Ratio limit/used_tokens: <ratio> for output tokens <limit>
```

Example from production logs:

```
github output is too long: 13512 tokens.
Ratio limit/used_tokens: 0.74 for output tokens 10000
```

This means the GitHub tool returned 13512 tokens but the assistant's limit is 10000. The output
was cut off at the limit, which may cause the assistant to work with incomplete data.

:::note

The error is always logged, but the workflow may continue with truncated output rather than
stopping. If the assistant produces incorrect or incomplete results, check the logs for this
error first.

:::

### How to fix it

**Strategy 1: Raise `limit_tool_output_tokens`**

The simplest fix. Set a higher limit for the specific assistant that triggers the error:

```yaml
assistants:
  - id: github-assistant
    model: gpt-4.1
    limit_tool_output_tokens: 25000  # raised from default 10000
    tools:
      - name: github_list_issues
        integration_alias: github-integration
```

Choose a value based on the typical output size of the tools your assistant uses. See the
[Configuration Reference](./configuration-reference.md#31-assistants-configuration) for guidance.

**Strategy 2: Extract only the data you need with `tool_result_json_pointer`**

If the tool returns a large JSON object but you only need part of it, use `tool_result_json_pointer`
to extract the relevant field before it reaches the token limit check:

```yaml
tools:
  - id: fetch-github-issues
    tool: github_list_issues
    tool_args:
      repo: "org/repo"
    tool_result_json_pointer: /items  # extract only the issues array, not metadata
```

This reduces the token count of the result before it is counted against `limit_tool_output_tokens`.

**Strategy 3: Paginate or filter at the tool level**

Use tool arguments to reduce the result set at the source:

```yaml
tools:
  - id: fetch-recent-issues
    tool: github_list_issues
    tool_args:
      repo: "org/repo"
      state: open
      per_page: 20   # fetch only 20 items instead of all
      page: 1
```

Fetch additional pages in subsequent workflow states using iteration (`iter_key`) if you need to
process more records.

**Strategy 4: Enable workflow summarization**

For multi-step workflows where accumulated context grows over time, enable automatic summarization
to keep total token usage under control:

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 20
tokens_limit_before_summarization: 30000
```

This does not reduce individual tool output size, but prevents the overall context from
growing unbounded across workflow steps.

### Which strategy to choose

| Scenario                                       | Recommended strategy        |
| ---------------------------------------------- | --------------------------- |
| Tool returns more tokens than expected         | Strategy 1: raise the limit |
| Tool returns large JSON but you need one field | Strategy 2: JSON Pointer    |
| Tool returns too many records                  | Strategy 3: paginate/filter |
| Context grows over many workflow steps         | Strategy 4: summarization   |

## 12.2 Debugging Techniques

- Enable verbose logging
- Use workflow visualization
- Check execution state history
- Monitor context store changes
- Review error messages and stack traces

## 12.3 Validation Process

- YAML format validation
- Schema validation against JSON Schema
- Cross-reference validation (IDs exist)
- Resource availability validation (assistants, tools, datasources)
- Circular dependency detection

---

## Need More Help?

- Review the [Introduction](./introduction.md) for basic concepts
- Check [Configuration Reference](./configuration-reference.md) for detailed configuration options
- See [Complete Examples](./examples.md) for working examples
- Consult [Best Practices](./best-practices.md) for recommendations

---

**Version**: 1.0
**Last Updated**: 2025-01-20
