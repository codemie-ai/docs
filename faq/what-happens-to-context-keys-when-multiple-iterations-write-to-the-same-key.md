# What happens to context keys when multiple iterations write to the same key?

By default, when parallel `iter_key` iterations all write to the same context key, the
**last iteration's value wins** — earlier values are silently overwritten during the
fan-in merge.

To preserve every iteration's output, set `append_to_context: true` on the iterating
state. With this flag, each branch appends its output to a list instead of overwriting:

| Mode                | Config                     | Result after 3 iterations writing to `output`   |
| ------------------- | -------------------------- | ----------------------------------------------- |
| Overwrite (default) | `append_to_context: false` | `output = "result_3"` (only last)               |
| Accumulation        | `append_to_context: true`  | `output = ["result_1", "result_2", "result_3"]` |

Use `append_to_context: true` together with `output_key` to name the accumulation key.
The accumulated list is accessible via `{{output_key}}` in subsequent states.

## Sources

- [State Transitions — Context Isolation and Merging](https://docs.codemie.ai/user-guide/workflows/configuration/state-transitions)
- [Context Management — Context Control Flags](https://docs.codemie.ai/user-guide/workflows/configuration/context-management)
