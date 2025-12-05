---
id: state-transitions
title: State Transitions
sidebar_label: State Transitions
sidebar_position: 5
---

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
    expression: 'variable > 100'
    then: state-if-true
    otherwise: state-if-false
```

Conditional transitions allow branching based on the execution result from the previous state. The execution result is parsed (supports JSON), and variables from the result can be referenced directly in the expression.

#### How Conditional Expressions Work:

1. The previous state's output is parsed (JSON parsing is attempted automatically)
2. If the output is a dictionary, all keys become variables accessible in the expression
3. The expression is evaluated using Python's `eval()` with the parsed variables
4. Based on the boolean result, workflow transitions to `then` or `otherwise` state

#### Conditional Expression Syntax:

- **Comparison operators**: `>`, `<`, `>=`, `<=`, `==`, `!=`
- **Logical operators**: `and`, `or`, `not`
- **String methods**: `in` operator, `.startswith()`, `.endswith()`, `.contains()`
- **Variable references**: Use variable names directly (no `{{}}` needed in expressions)
- **Special variable**: `keys` - automatically available, contains all keys from the result dictionary

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
- If expression evaluation fails, workflow transitions to `otherwise` state
- String values are automatically converted; `'true'`/`'false'` strings become booleans

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
      - condition: 'score >= 90'
        state_id: excellent-handler
      - condition: 'score >= 70'
        state_id: good-handler
      - condition: 'score >= 50'
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
      - condition: 'error_count > 0 and error_count < 5'
        state_id: partial-success-state
      - condition: 'error_count >= 5'
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
  'chunks':
    [
      { 'data': 'chunk1', 'info': 'important info' },
      { 'data': 'chunk2', 'info': 'very important info' },
    ],
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
      { "id": 1, "name": "Alice" },
      { "id": 2, "name": "Bob" }
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
  { "id": 1, "task": "Process A" },
  { "id": 2, "task": "Process B" },
  { "id": 3, "task": "Process C" }
]
```

- `iter_key: .` → uses entire array (key ignored)
- Each item: `{"id": 1, "task": "Process A"}`, etc.

#### Iteration Properties:

**iter_key** (string):

- Expression evaluated against the state result to extract an iterable
- Two formats: dictionary key (`"items"`) or JSON Pointer (`"/data/items"`)
- The extracted value must be a list or will be wrapped as single-item list

#### Multi-Stage Iteration:

For multi-stage iteration (when you have multiple sequential states processing each item), the **same `iter_key` must be present in every state** included in the iteration chain.

```yaml
# Correct: Same iter_key in all states
states:
  - id: state-1
    next:
      state_id: state-2
      iter_key: items # First state starts iteration

  - id: state-2
    next:
      state_id: state-3
      iter_key: items # Same iter_key continues iteration

  - id: state-3
    next:
      state_id: state-4
      iter_key: items # Same iter_key throughout the chain
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
      iter_key: . # Evaluates entire list

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
      iter_key: errors # Extracts result['errors'] → ["err1", "err2"]

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
      iter_key: /data/users # JSON Pointer navigates to nested users array

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
      iter_key: /response/results # Extracts array of environment objects

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
      iter_key: . # Uses entire array (dot means use the list as-is)

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
      iter_key: chunks # Start iteration: splits into parallel executions

  - id: process-chunk
    assistant_id: processor
    task: |
      Process chunk with data: {{data}}
      Using metadata: {{metadata}}
    # Iteration 1: data="chunk1", metadata="info1" in context
    # Iteration 2: data="chunk2", metadata="info2" in context
    next:
      state_id: validate-chunk
      iter_key: chunks # Continue iteration: same iter_key required

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
- For duplicate keys across iterations, the **last value wins** (last iteration overwrites previous)
- The merged context is then passed to the next state after iteration

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

:::info Context Merging
- Iterations are isolated during execution but merged after completion
- Context keys set by multiple iterations will have only one final value (last wins)
- To preserve all iteration results, use unique keys (e.g., `result_1`, `result_2`) or aggregate into lists
- Message histories are fully preserved from all iterations
:::

:::note Important Notes
- **Multi-stage iteration requirement**: The same `iter_key` must be present in every state within the iteration chain except the last one in the chain
- The state result is automatically parsed as JSON if possible
- If `iter_key` evaluates to a non-list value, it's wrapped as a single-item list
- JSON Pointer expressions must start with `/` to be recognized
- Each item in the extracted list becomes a separate parallel execution
- All parallel executions must complete before transitioning to the next state
- Cannot combine `iter_key` with `state_ids` (parallel transitions) or `condition`/`switch`
- Each iteration branch has isolated context and message history during execution
- After all iterations complete, contexts and message histories are merged using LangGraph reducers
:::

---
