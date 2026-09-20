---
id: state-transitions
title: State Transitions
sidebar_label: State Transitions
pagination_prev: user-guide/workflows/configuration/workflow-states
pagination_next: user-guide/workflows/configuration/context-management
sidebar_position: 5
---

<!-- cspell:words isinstance statuss -->

# State Transitions

## 5. State Transitions

### 5.1 Simple Transitions

```yaml
next:
  state_id: next-state-id
```

Direct transition to a single next state.

### 5.2 Parallel Transitions

```yaml
next:
  state_ids:
    - state-2
    - state-3
    - state-4
```

Execute multiple states in parallel (fan-out pattern).

### 5.3 Conditional Transitions

```yaml
next:
  condition:
    expression: "variable > 100"
    then: state-if-true
    otherwise: state-if-false
```

Conditional transitions allow branching based on the execution result from the previous state. The execution result is parsed (supports JSON), and variables from the result can be referenced directly in the expression.

#### How Conditional Expressions Work:

1. The previous state's output is parsed (JSON parsing is attempted automatically)
2. If the output is a dictionary, all keys become variables accessible in the expression
3. The expression is evaluated by a restricted expression evaluator using those variables
4. Based on the boolean result, workflow transitions to `then` or `otherwise` state

:::warning Expressions see only the deciding state's own output

The variables available to a condition come **exclusively from the output of the state that
declares the condition**. The context store is not in scope, so a value written by an earlier
state is not visible here unless the deciding state re-emits it in its own output.

```yaml
states:
  - id: fetch-user
    assistant_id: fetcher
    next:
      state_id: check-tier
      output_key: user_record # written to the context store

  - id: check-tier
    assistant_id: classifier
    next:
      condition:
        # ❌ tier came from fetch-user, not from check-tier — undefined here
        expression: "tier == 'premium'"
        then: premium-path
        otherwise: standard-path
```

To branch on an earlier value, have the deciding state emit it — a [Transform Node](./specialized-nodes.md#84-transform-node)
is the cheapest way to lift context-store keys into a state output without an LLM call.

:::

#### Conditional Expression Syntax:

- **Comparison operators**: `>`, `<`, `>=`, `<=`, `==`, `!=`, `is`, `is not`
- **Logical operators**: `and`, `or`, `not`
- **Membership and indexing**: `in`, subscript access (`payload["status"]`, `items[0]`)
- **String methods**: any public string method, such as `.lower()`, `.startswith()`, `.endswith()`
- **Built-in functions**: `len`, `min`, `max`, `sum`, `abs`, `round`, `sorted`, `any`, `all`, `str`, `int`, `float`, `bool`, `list`, `dict`, `set`, `tuple`, `isinstance`, `enumerate`, `zip`, `map`, `filter`, `reversed`
- **Variable references**: Use variable names directly (no `{{}}` needed in expressions)
- **Special variable**: `keys` - automatically available, contains all keys from the result dictionary

**Not supported**: list/dict comprehensions, lambdas, assignments, imports, and any attribute
beginning with an underscore. These are rejected by the evaluator rather than executed.

:::warning Dotted access into a nested value does not work

`payload.status` is rejected by the evaluator as an unsafe construct, which — like every other
evaluation failure — yields `False` and routes to `otherwise`. Only the top-level names from the
state's own output are variables; reach inside them with a subscript instead:

```yaml
expression: 'payload["status"] == "ok"' # ✅
expression: "payload.status == 'ok'" # ❌ blocked, silently takes otherwise
```

The execution log records `Condition expression blocked - unsafe construct` when this happens.

:::

#### Boolean Literals Must Be Python-Style

Expressions are Python, not YAML. Boolean literals are `True` and `False`, capitalized.
Lowercase `true`/`false` are normalized to Python booleans when the workflow is saved, but write
them capitalized so the expression reads the same everywhere it appears:

```yaml
expression: "is_approved == True" # ✅
expression: "is_approved == true" # ⚠️ normalized on save — prefer True
```

#### Examples:

```yaml
# Simple comparison
condition:
  expression: "count > 10"
  then: process-large-batch
  otherwise: process-small-batch

# String comparison
condition:
  expression: "status == 'success'"
  then: next-step
  otherwise: error-handler

# Complex logical expression
condition:
  expression: "count > 10 and status == 'active'"
  then: process-state
  otherwise: skip-state

# Check if key exists
condition:
  expression: "'result' in keys"
  then: has-result
  otherwise: no-result

# String contains check
condition:
  expression: "'error' in message.lower()"
  then: error-handler
  otherwise: success-state
```

**Important Notes**:

- Variables are referenced by name only (e.g., `status`, not `{{status}}`)
- The expression must evaluate to a boolean value
- String values are automatically converted; `'true'`/`'false'` strings become booleans

#### Every Failure Routes to `otherwise`

A condition that cannot be evaluated does not fail the workflow — it evaluates to `False` and the
workflow takes the `otherwise` branch. This applies to all of the following:

| What happened                      | Example                               |
| ---------------------------------- | ------------------------------------- |
| Variable not in the state's output | `tier == 'premium'` (see note above)  |
| Misspelled variable name           | `statuss == 'success'`                |
| Unsupported construct              | `[x for x in items if x.ok]`          |
| Method or attribute does not exist | `'error' in message.contains('x')`    |
| Type mismatch during comparison    | `count > 10` where `count` is `"ten"` |

Because the workflow still completes, a misspelling looks like a business-logic outcome rather
than a bug. When a branch always goes the same way, check the execution logs for
`Condition expression blocked`, `Condition expression has invalid syntax`, or
`Error evaluating condition` before assuming the data is at fault.

The same rule applies to switch cases: a case that fails to evaluate is treated as not matching,
and evaluation continues with the next case, falling through to `default`.

### 5.4 Switch/Case Transitions

```yaml
next:
  switch:
    cases:
      - condition: "status == 'success'"
        state_id: success-handler
      - condition: "status == 'warning'"
        state_id: warning-handler
      - condition: "status == 'error'"
        state_id: error-handler
    default: unknown-handler
```

Switch/case transitions provide multiple conditional branches evaluated sequentially until one matches. This is useful when you have more than two possible outcomes based on state execution results.

#### How Switch/Case Works:

1. The previous state's output is parsed (JSON parsing is attempted automatically)
2. If the output is a dictionary, all keys become variables accessible in expressions
3. Each case's condition is evaluated in order from top to bottom
4. The first condition that evaluates to `true` determines the next state
5. If no condition matches, workflow transitions to the `default` state
6. The same expression syntax as conditional transitions applies

#### Switch/Case Properties:

- **cases**: List of condition-state pairs evaluated sequentially
  - **condition**: Boolean expression to evaluate (same syntax as conditional transitions)
  - **state_id**: Target state if condition is true
- **default**: State to transition to if no case matches (required)

#### Examples:

**Status-based routing:**

```yaml
next:
  switch:
    cases:
      - condition: "status == 'completed'"
        state_id: success-state
      - condition: "status == 'pending'"
        state_id: wait-state
      - condition: "status == 'failed'"
        state_id: retry-state
    default: error-state
```

**Numeric range routing:**

```yaml
next:
  switch:
    cases:
      - condition: "score >= 90"
        state_id: excellent-handler
      - condition: "score >= 70"
        state_id: good-handler
      - condition: "score >= 50"
        state_id: average-handler
    default: poor-handler
```

**Complex conditions:**

```yaml
next:
  switch:
    cases:
      - condition: "error_count == 0 and status == 'complete'"
        state_id: success-state
      - condition: "error_count > 0 and error_count < 5"
        state_id: partial-success-state
      - condition: "error_count >= 5"
        state_id: failure-state
    default: unknown-state
```

**Type-based routing:**

```yaml
next:
  switch:
    cases:
      - condition: "'email' in type.lower()"
        state_id: email-processor
      - condition: "'sms' in type.lower()"
        state_id: sms-processor
      - condition: "'push' in type.lower()"
        state_id: push-processor
    default: unsupported-type-handler
```

**Important Notes**:

- Cases are evaluated in order - first match wins
- Order matters: place more specific conditions before general ones
- Variables are referenced by name only (e.g., `status`, not `{{status}}`)
- The `default` state is required and handles all unmatched cases
- If a case condition evaluation fails, it's treated as `false` and evaluation continues
- String values are automatically converted; `'true'`/`'false'` strings become booleans

### 5.5 Iterative Transitions (Map-Reduce)

```yaml
next:
  state_id: processing-state
  iter_key: items
```

Iterative transitions enable map-reduce patterns where a state's output is evaluated to extract a collection of items, each item is processed in parallel, and results are aggregated. This implements fan-out/fan-in parallelization.

#### How Iteration Works:

The `iter_key` is an **expression** that is evaluated against the current workflow state result to extract an iterable (like a list). The workflow engine evaluates this expression to get the collection of items to iterate over. Each item is then sent to the target state for parallel processing.

#### Task Input and Context Population:

Each item in the iteration becomes the **task input** for the iteration chain of states. The behavior depends on the item's type:

**When the item is a JSON object or dictionary:**

- Its root elements are automatically stored in the execution context
- These values can be referenced using `{{key}}` expressions in task templates

**Example:**

```yaml
# State output with iter_key: chunks
{
  "chunks": [
    {"data": "chunk1", "info": "important info"},
    {"data": "chunk2", "info": "very important info"}
  ]
}

# For iteration 1:
# - Task input: {"data": "chunk1", "info": "important info"}
# - Context variables: data=chunk1, info="important info"
# - Template usage: {{data}} resolves to "chunk1", {{info}} resolves to "important info"

# For iteration 2:
# - Task input: {"data": "chunk2", "info": "very important info"}
# - Context variables: data=chunk2, info="very important info"
# - Template usage: {{data}} resolves to "chunk2", {{info}} resolves to "very important info"
```

**When the item is a simple value (string, number, etc.):**

- The entire item becomes the task input
- It can be referenced using `{{task}}` in task templates

#### iter_key Expression Types:

The `iter_key` can be expressed in two ways:

**1. Dictionary Key Expression**

When the state result is a dictionary or object, use a simple key name:

- Expression: `"items"` or `"errors"` or `"users"`
- Evaluation logic:
  - If result is a **dictionary**: extracts `result['items']` (must be a list)
  - If result is a **list**: uses the entire list (key is ignored; `iter_key` must be simply a dot `.`)
  - If result is neither: wraps it as a single-item list `[result]`

**2. JSON Pointer Expression (RFC 6901)**

For nested structures or complex data, use JSON Pointer syntax (starts with `/`):

- Expression: `"/data/items"` or `"/response/users"` or `"/results/0/errors"`
- Navigates through nested structures using forward slashes
- Supports array indexing: `/items/0/name`
- Supports deeply nested paths: `/data/response/items/results`

#### State Result Formats:

The previous state can output various formats, and `iter_key` adapts accordingly:

**Simple List:**

```json
["item1", "item2", "item3"]
```

- `iter_key: .` → uses entire list (key ignored for direct arrays)
- Each item: `"item1"`, `"item2"`, `"item3"`

**Dictionary with List:**

```json
{
  "items": ["file1.txt", "file2.txt"],
  "count": 2
}
```

- `iter_key: items` → extracts `result['items']`
- Each item: `"file1.txt"`, `"file2.txt"`

**Nested Structure:**

```json
{
  "data": {
    "users": [
      {"id": 1, "name": "Alice"},
      {"id": 2, "name": "Bob"}
    ]
  }
}
```

- `iter_key: /data/users` → navigates to nested array
- Each item: `{"id": 1, "name": "Alice"}`, `{"id": 2, "name": "Bob"}`

**Complex Nested Array:**

```json
{
  "response": {
    "results": [
      {
        "errors": ["error1", "error2"],
        "status": "failed"
      },
      {
        "errors": ["error3"],
        "status": "failed"
      }
    ]
  }
}
```

- `iter_key: /response/results` → extracts array of result objects
- Each item: entire result object with errors and status

**Array of Objects:**

```json
[
  {"id": 1, "task": "Process A"},
  {"id": 2, "task": "Process B"},
  {"id": 3, "task": "Process C"}
]
```

- `iter_key: .` → uses entire array (key ignored)
- Each item: `{"id": 1, "task": "Process A"}`, etc.

#### Iteration Properties:

**iter_key** (string):

- Expression evaluated against the state result to extract an iterable
- Two formats: dictionary key (`"items"`) or JSON Pointer (`"/data/items"`)
- The extracted value must be a list or will be wrapped as single-item list

**append_to_context** (boolean, default: `false`):

- When `true`, each iteration's output is **appended** to a list in the context store instead of overwriting the previous value
- When `false` (default), standard overwrite semantics apply — the last iteration's value wins on duplicate keys
- Use together with `output_key` to control which context key accumulates the collected results
- When `append_to_context: true` is combined with `output_key`, the top-level state key is **not** set — values are only available via the accumulated list in the context store

```yaml
next:
  state_id: collect-results
  iter_key: items
  output_key: processed_items
  append_to_context: true  # Each iteration appends its output; context_store["processed_items"] becomes a list
```

**finish_iteration** (boolean, default: `false`) — _state-level, not inside `next`_:

- Marks a state as the **last step of the per-item chain**
- While `finish_iteration` is `false`, each state in the chain forwards the same item onward, keeping the branch alive
- Setting it to `true` ends the per-item branch, allowing the workflow to converge (fan-in)
- Set it on **every terminal state of the chain**. When the chain branches with a condition, each branch needs its own `finish_iteration: true` — the state that evaluates the condition does not get it
- Pair it with `append_to_context: true` so each branch's result is collected rather than overwritten

`iter_key` belongs on the state that **produces** the collection, not on the branching states.
The schema rejects `iter_key` in the same `next` block as a `condition` or `switch`.

```yaml
states:
  - id: list-candidates
    assistant_id: scorer
    task: List the candidates.
    next:
      state_id: score-item
      iter_key: candidates # the producer starts the fan-out

  - id: score-item
    assistant_id: scorer
    task: Score this candidate.
    next:
      condition: # the evaluator only routes
        expression: "score >= 7"
        then: keep-item
        otherwise: drop-item

  - id: keep-item
    assistant_id: writer
    finish_iteration: true # terminal branch
    next:
      state_id: summarize
      output_key: kept
      append_to_context: true

  - id: drop-item
    assistant_id: writer
    finish_iteration: true # the other terminal branch
    next:
      state_id: summarize
      output_key: dropped
      append_to_context: true

  - id: summarize
    assistant_id: writer
    next:
      state_id: end
```

**include_in_iterator_context** (array of strings, default: `["*"]`):

- Whitelist of context store keys copied into **each** parallel branch
- The default `["*"]` copies the entire context store into every branch — with N items, the store is duplicated N times inside the execution checkpoint
- Large values (fetched file contents, API responses, document batches) multiplied across many branches can push the checkpoint past the database row size limit and fail the execution
- Naming only the keys the per-item states actually read keeps branches small. The parent context store is untouched, so keys left out are still available after the fan-in

```yaml
next:
  state_id: review-item
  iter_key: review_batches
  include_in_iterator_context: ['current_goal', 'channel', 'jira_project_key']
  # review_batches itself stays in the parent store — branches get only the three small keys
```

**override_task** (boolean, default: `false`):

- Controls what the **next state in the per-item chain** receives as its item
- `false` (default): the next state receives the original item, unchanged — every state in the chain sees the same input
- `true`: the next state receives **this state's output** instead, so the item is progressively rewritten as it moves down the chain

Use `true` for refinement pipelines (draft → edit → polish, where each step consumes the previous
step's version) and leave it `false` when several states must each inspect the same original item.

#### Multi-Stage Iteration:

For multi-stage iteration (when you have multiple sequential states processing each item), the **same `iter_key` must be present in every state** included in the iteration chain.

```yaml
# Correct: Same iter_key in all states
states:
  - id: state-1
    next:
      state_id: state-2
      iter_key: items      # First state starts iteration

  - id: state-2
    next:
      state_id: state-3
      iter_key: items      # Same iter_key continues iteration

  - id: state-3
    next:
      state_id: state-4
      iter_key: items      # Same iter_key throughout the chain
```

This ensures that the iteration context is maintained across all processing stages for each parallel item.

#### Iteration Examples:

**Example 1: Simple List Iteration**

```yaml
states:
  - id: list-files
    assistant_id: file-lister
    task: List all files in the directory
    # Assistant outputs: ["file1.txt", "file2.txt", "file3.txt"]
    next:
      state_id: process-file
      iter_key: .  # Evaluates entire list

  - id: process-file
    assistant_id: processor
    task: Process file {{task}}
    # Each execution receives one filename in {{task}}
    next:
      state_id: generate-summary
```

**Example 2: Dictionary with List**

```yaml
states:
  - id: analyze-code
    assistant_id: analyzer
    task: Analyze code and find issues
    # Assistant outputs: {"errors": ["err1", "err2"], "warnings": ["warn1"], "count": 3}
    next:
      state_id: fix-error
      iter_key: errors  # Extracts result['errors'] → ["err1", "err2"]

  - id: fix-error
    assistant_id: fixer
    task: Fix error {{task}}
    # Each execution receives one error in {{task}}
    next:
      state_id: verify
```

**Example 3: Nested Structure with JSON Pointer**

```yaml
states:
  - id: fetch-api-data
    tool_id: api-call
    tool_args:
      endpoint: /api/users
    # Tool outputs: {"status": "success", "data": {"users": [{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]}}
    next:
      state_id: process-user
      iter_key: /data/users  # JSON Pointer navigates to nested users array

  - id: process-user
    assistant_id: user-processor
    task: Process user data {{task}}
    # Each execution receives one user object: {"id": 1, "name": "Alice"}
    next:
      state_id: end
```

**Example 4: Complex Nested Structure**

```yaml
states:
  - id: fetch-results
    assistant_id: fetcher
    task: Get test results from all environments
    # Outputs: {"response": {"results": [{"env": "dev", "tests": ["test1", "test2"]}, {"env": "prod", "tests": ["test3"]}]}}
    next:
      state_id: process-environment
      iter_key: /response/results  # Extracts array of environment objects

  - id: process-environment
    assistant_id: env-processor
    task: Process tests for environment {{task}}
    # Each execution receives: {"env": "dev", "tests": ["test1", "test2"]}
    next:
      state_id: aggregate
```

**Example 5: Array of JSON Objects with Context Population**

```yaml
states:
  - id: get-tasks
    tool_id: task-fetcher
    # Outputs: [{"id": 1, "title": "Task A", "priority": "high"}, {"id": 2, "title": "Task B", "priority": "low"}]
    next:
      state_id: execute-task
      iter_key: .  # Uses entire array (dot means use the list as-is)

  - id: execute-task
    assistant_id: executor
    task: |
      Execute task ID {{id}}: {{title}}
      Priority level: {{priority}}

      Please process this task according to its priority.
    # Iteration 1 receives: {"id": 1, "title": "Task A", "priority": "high"}
    # - Context: id=1, title="Task A", priority="high"
    # - Task template resolves to: "Execute task ID 1: Task A\nPriority level: high\n..."

    # Iteration 2 receives: {"id": 2, "title": "Task B", "priority": "low"}
    # - Context: id=2, title="Task B", priority="low"
    # - Task template resolves to: "Execute task ID 2: Task B\nPriority level: low\n..."
    next:
      state_id: end
```

**Example 6: Multi-Stage Iteration with Context Variables**

This example demonstrates multi-stage iteration where each item goes through multiple processing states. **Note that `iter_key: chunks` is specified in all three states** to maintain the iteration context.

```yaml
states:
  - id: split-work
    assistant_id: splitter
    task: Split work into chunks
    # Outputs: {"chunks": [{"data": "chunk1", "metadata": "info1"}, {"data": "chunk2", "metadata": "info2"}]}
    next:
      state_id: process-chunk
      iter_key: chunks          # Start iteration: splits into parallel executions

  - id: process-chunk
    assistant_id: processor
    task: |
      Process chunk with data: {{data}}
      Using metadata: {{metadata}}
    # Iteration 1: data="chunk1", metadata="info1" in context
    # Iteration 2: data="chunk2", metadata="info2" in context
    next:
      state_id: validate-chunk
      iter_key: chunks          # Continue iteration: same iter_key required

  - id: validate-chunk
    assistant_id: validator
    task: |
      Validate the processed chunk {{data}}
      Check metadata consistency: {{metadata}}
    # Context variables still available: data and metadata
    # Each iteration has isolated context during execution
    next:
      state_id: merge-results
      # This is the last state in the iteration chain so  iter_key in is not needed here

  - id: merge-results
    assistant_id: merger
    task: Combine all validated results
    # Receives merged context and message history from all iterations
```

**How it works:**

1. `split-work` outputs chunks with both data and metadata fields
2. Two parallel branches are created:
   - Branch 1: `data="chunk1"`, `metadata="info1"`
   - Branch 2: `data="chunk2"`, `metadata="info2"`
3. Each branch processes through `process-chunk` → `validate-chunk` with isolated context
4. After all branches complete, contexts and message histories are merged
5. Merged results flow to `merge-results`

**Example 7: Accumulating Results Across Iterations**

When all iteration results must be preserved, use `append_to_context: true` so each parallel branch contributes to a shared list rather than overwriting it.

```yaml
states:
  - id: get-tickets
    tool_id: jira-api
    tool_args:
      jql: "project = PROJ AND status = 'Open'"
    # Outputs: [{"id": "PROJ-1", "title": "Bug A"}, {"id": "PROJ-2", "title": "Bug B"}, {"id": "PROJ-3", "title": "Bug C"}]
    next:
      state_id: analyze-ticket
      iter_key: .  # Iterate over the entire list

  - id: analyze-ticket
    assistant_id: analyzer
    task: |
      Analyze ticket {{id}}: {{title}}
      Return a JSON object: {"ticket_id": "...", "severity": "low|medium|high", "summary": "..."}
    # Iteration 1 returns: {"ticket_id": "PROJ-1", "severity": "high", "summary": "..."}
    # Iteration 2 returns: {"ticket_id": "PROJ-2", "severity": "low", "summary": "..."}
    # Iteration 3 returns: {"ticket_id": "PROJ-3", "severity": "medium", "summary": "..."}
    next:
      state_id: create-report
      output_key: analyses
      append_to_context: true  # Accumulate all results; context_store["analyses"] = [{...}, {...}, {...}]

  - id: create-report
    assistant_id: reporter
    task: |
      Create a severity report based on all ticket analyses.
      Analyses: {{analyses}}
    # Receives the full list of all three analyses in {{analyses}}
    next:
      state_id: end
```

**How it works:**

1. Three parallel branches process one ticket each
2. Each branch writes its output with the `analyses` key via `append_to_context: true`
3. The reducer appends each result to the list — no overwriting occurs
4. `create-report` receives `analyses = [result_1, result_2, result_3]` in its context

:::tip
`append_to_context: true` is the recommended way to collect results from all parallel iterations into a single list. It replaces the workaround of using unique per-iteration keys (`result_1`, `result_2`, ...).
:::

---

#### Context Isolation and Merging:

Iterations have important context management characteristics that ensure proper isolation and aggregation:

**Context Isolation per Iteration:**

- Each parallel iteration has its **own isolated context store**
- Each parallel iteration has its **own isolated message history**
- This prevents cross-contamination between parallel executions
- Changes made in one iteration branch do not affect other branches during execution

**Context Store Cloning:**

- When the first iteration starts (fan-out), the context store is **cloned** for each parallel branch
- Each clone gets a copy of the parent context at the moment of iteration start
- Example: If parent context has `{user: "Alice", mode: "production"}`, each iteration starts with this same context

**Context Merging After Completion:**

- When all parallel iterations complete (fan-in), their context stores are **merged**
- The merge uses `add_or_replace_context_store` reducer
- **Default (overwrite)**: for duplicate keys across iterations, the **last value wins** (last iteration overwrites previous)
- **Accumulation mode**: when `append_to_context: true` is set on the iterating state, each iteration's output is **appended** to a list under the specified key — no values are lost
- The merged context is then passed to the next state after iteration

**Choosing between overwrite and accumulation:**

| Mode                | Config                     | Result for key `output` after 3 iterations      |
| ------------------- | -------------------------- | ----------------------------------------------- |
| Overwrite (default) | `append_to_context: false` | `output = "result_3"` (only last)               |
| Accumulation        | `append_to_context: true`  | `output = ["result_1", "result_2", "result_3"]` |

**Message History Merging:**

- Similarly, message histories from all iterations are also merged
- Messages from all parallel branches are combined into a single history
- This provides complete visibility of all parallel processing to subsequent states

**Example of Context Isolation:**

```yaml
states:
  - id: split-work
    assistant_id: splitter
    task: Split work into chunks
    # Outputs: {"chunks": [{"id": 1}, {"id": 2}]}
    next:
      state_id: process-chunk
      iter_key: chunks

  - id: process-chunk
    assistant_id: processor
    task: Process chunk {{id}} and generate result
    # Iteration 1: Sets result="processed-1" in its isolated context
    # Iteration 2: Sets result="processed-2" in its isolated context
    # These contexts are separate during execution
    next:
      state_id: merge-results

  - id: merge-results
    assistant_id: merger
    task: Merge all results
    # Receives merged context with values from all iterations
    # If both iterations set "result" key, only the last value is retained
```

**Important Context Merging Notes:**

- Iterations are isolated during execution but merged after completion
- By default, context keys set by multiple iterations will have only one final value (last wins)
- To preserve all iteration results, set `append_to_context: true` combined with `output_key` — the context key will accumulate all values as a list
- Message histories are fully preserved from all iterations regardless of the merge mode

#### Important Notes:

- **Multi-stage iteration requirement**: The same `iter_key` must be present in every state within the iteration chain except the last one in the chain
- The state result is automatically parsed as JSON if possible
- If `iter_key` evaluates to a non-list value, it's wrapped as a single-item list
- JSON Pointer expressions must start with `/` to be recognized
- Each item in the extracted list becomes a separate parallel execution
- All parallel executions must complete before transitioning to the next state
- Cannot combine `iter_key` with `state_ids` (parallel transitions) or `condition`/`switch`
- Each iteration branch has isolated context and message history during execution
- After all iterations complete, contexts and message histories are merged using LangGraph reducers
- Use `append_to_context: true` to accumulate all iteration outputs into a list; without it, only the last iteration's value is retained for duplicate keys
- `append_to_context: true` has no effect when `store_in_context: false`

---
