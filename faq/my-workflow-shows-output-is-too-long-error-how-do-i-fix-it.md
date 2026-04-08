# My workflow shows an "output is too long" error. How do I fix it?

The error looks like this:

```
github output is too long: 13512 tokens. Ratio limit/used_tokens: 0.74 for output tokens 10000
```

It means a tool returned more tokens than the assistant's `limit_tool_output_tokens` allows
(default: 10000). The output was truncated, which may cause incomplete or incorrect results.

## Fix 1: Raise the limit

Add `limit_tool_output_tokens` to the assistant in your workflow YAML:

```yaml
assistants:
  - id: my-assistant
    model: gpt-4.1
    limit_tool_output_tokens: 25000
    tools:
      - name: github_list_issues
        integration_alias: github-integration
```

## Fix 2: Extract only the data you need

Use `tool_result_json_pointer` to pull out just the relevant field from a large response,
reducing the token count before it reaches the limit:

```yaml
tools:
  - id: fetch-issues
    tool: github_list_issues
    tool_args:
      repo: "org/repo"
    tool_result_json_pointer: /items  # extract only the issues array
```

## Fix 3: Paginate or filter at the source

Pass filtering arguments to the tool so it returns fewer results:

```yaml
tools:
  - id: fetch-recent-issues
    tool: github_list_issues
    tool_args:
      repo: "org/repo"
      state: open
      per_page: 20
      page: 1
```

## Sources

- [Troubleshooting — Tool Output Token Limit Exceeded](https://codemie-ai.github.io/docs/user-guide/workflows/configuration/troubleshooting#tool-output-token-limit-exceeded)
- [Configuration Reference — Assistant Properties](https://codemie-ai.github.io/docs/user-guide/workflows/configuration/configuration-reference)
