# How do I collect all results from parallel workflow iterations?

Use `append_to_context: true` together with `output_key` in the `next:` block of the
iterating state. This tells the workflow engine to accumulate each iteration's output into
a list rather than overwriting the previous value.

```yaml
states:
  - id: process-item
    assistant_id: processor
    task: "Analyze {{task}} and return a result object"
    next:
      state_id: aggregate
      iter_key: items
      output_key: all_results
      append_to_context: true

  - id: aggregate
    assistant_id: aggregator
    task: "Summarize all results: {{all_results}}"
    # {{all_results}} contains every iteration's output as a list
```

By default (`append_to_context: false`), when multiple parallel branches write to the
same context key, only the last branch's value is kept. Setting `append_to_context: true`
preserves all values in `context_store["all_results"]` as an ordered list.

## Sources

- [State Transitions — Iterative Transitions](https://docs.codemie.ai/user-guide/workflows/configuration/state-transitions)
- [Context Management — Context Control Flags](https://docs.codemie.ai/user-guide/workflows/configuration/context-management)
