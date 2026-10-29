# What JSONPath syntax is supported for the GitHub JSON Path Filter in CodeMie?

The GitHub JSON Path Filter supports two expression forms:

- **Existence check (plain path)**: Tests whether a field is present in the payload, regardless
  of its value. Example: `$.pull_request.draft`
- **Value comparison (filter predicate)**: Tests whether a field equals a specific value.
  Example: `$[?(@.pull_request.draft==false)]`

**Important limitations:**

- **A nested predicate only matches on array fields.** For example,
  `$.pull_request.labels[?(@.name=='bug')]` matches correctly because `labels` is an array.
  Applying the same syntax to a non-array (object) field, such as
  `$.pull_request[?(@.draft==false)]`, never matches — use a root-level filter predicate
  instead: `$[?(@.pull_request.draft==false)]`.
- Multiple conditions can be combined in a single filter predicate with `&`, for example:
  `$[?(@.pull_request.draft==false & @.action=='opened')]`.
- Expressions containing regex operations, arithmetic, or other complex constructs are rejected
  at save time with a validation error.
- A configured GitHub Webhook Secret is required whenever a JSON Path Filter is set. Without
  it, saving returns a validation error.

## Sources

- [Webhook](https://docs.codemie.ai/user-guide/tools_integrations/tools/webhook)
