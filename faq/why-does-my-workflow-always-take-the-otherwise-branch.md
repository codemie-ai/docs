# Why does my workflow condition always take the "otherwise" branch? Why does my switch always fall through to "default"?

Almost always because the variable in the expression is not visible to it.

A condition or switch expression is evaluated against the **parsed output of the state that
declares it** — and nothing else. The context store is not in scope, so a value written by an
earlier state is invisible here even though `{{placeholders}}` elsewhere can read it.

When a variable is undefined, the expression does not raise an error that stops the workflow.
It evaluates to `false`, the `otherwise` branch is taken (or the switch falls through to
`default`), and the execution finishes successfully. The routing is wrong but nothing looks
broken.

## What breaks it

```yaml
states:
  - id: fetch-user
    assistant_id: fetcher
    next:
      state_id: check-tier
      output_key: user_record # goes to the context store

  - id: check-tier
    assistant_id: classifier
    next:
      condition:
        # user_record belongs to fetch-user, not to check-tier — undefined here
        expression: "user_record.tier == 'premium'"
        then: premium-path
        otherwise: standard-path
```

## How to fix it

**Make the deciding state emit the value.** Add the field to that state's own output, then
reference it by its bare name:

```yaml
- id: check-tier
  assistant_id: classifier
  output_schema: |
    {
      "type": "object",
      "properties": { "tier": { "type": "string" } },
      "required": ["tier"]
    }
  next:
    condition:
      expression: "tier == 'premium'"
      then: premium-path
      otherwise: standard-path
```

**Or lift the context value with a Transform Node.** This costs no LLM call and is the usual
approach when the value is already in the context store:

```yaml
custom_nodes:
  - id: lift_tier
    custom_node_id: transform_node
    config:
      input_source: 'context_store'
      mappings:
        - output_field: 'tier'
          type: 'extract'
          source_path: 'user_record.tier'

states:
  - id: route-by-tier
    custom_node_id: lift_tier
    next:
      condition:
        expression: "tier == 'premium'"
        then: premium-path
        otherwise: standard-path
```

## Other causes of the same symptom

Every one of these evaluates to `false` rather than failing:

- A misspelled variable name
- Lowercase `true` / `false` instead of Python's `True` / `False`
- A method that does not exist, such as `.contains()` on a string
- A type mismatch, such as `count > 10` when `count` is the string `"ten"`
- List comprehensions and lambdas, which the expression evaluator rejects
- A state whose `output_schema` is a plain example rather than a real JSON Schema, so the field
  was never guaranteed to be present

Check the execution logs for `Condition expression blocked`,
`Condition expression has invalid syntax`, or `Error evaluating condition` to confirm which one
applies.

## Sources

- [State Transitions — Conditional Transitions](https://docs.codemie.ai/user-guide/workflows/configuration/state-transitions)
- [Workflow States — Two Modes of output_schema](https://docs.codemie.ai/user-guide/workflows/configuration/workflow-states)
- [Specialized Nodes — Transform Node](https://docs.codemie.ai/user-guide/workflows/configuration/specialized-nodes)
