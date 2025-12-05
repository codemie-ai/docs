---
id: context-management
title: Context Management
sidebar_label: Context Management
sidebar_position: 6
---

# Context Management

## 6. Context Management

Context management is central to CodeMie Workflows, enabling data to flow between states, persist across workflow execution, and provide AI assistants with necessary information.

### 6.1 Context Store

#### What is the Context Store?

The **context store** is a key-value storage system that persists throughout workflow execution. It acts as shared memory that all states can read from and write to. Think of it as a dictionary that travels with the workflow, accumulating and carrying data from state to state.

**Key Characteristics:**

- **Persistent**: Survives across all states in the workflow
- **Accessible**: Any state can read values stored by previous states
- **Mutable**: States can add, update, or remove keys
- **Dynamic**: Supports template variable substitution using `{{key}}` syntax

#### How Data Flows Between States

**Automatic Flow:**

1. **Workflow Initialization**: User input is parsed; if JSON, root keys populate the initial context store
2. **State Executes**: An AI assistant or tool generates output
3. **Output Captured**: The result is captured as a string or structured data
4. **Context Updated**: If `store_in_context: true`, the output is added to context store
5. **Next State Accesses**: Subsequent states can access stored values using `{{variable}}` syntax

**Context Lifecycle:**

- **Before first state**: Context contains variables from user input (if JSON)
- **After each state**: Context grows with new variables from state outputs
- **Throughout workflow**: All states share the same context store

**Example Flow:**

```yaml
# User input: {"user_id": "12345", "department": "engineering"}

states:
  - id: fetch-user-data
    assistant_id: data-fetcher
    task: 'Fetch user profile for user ID {{user_id}} from {{department}}'
    # {{user_id}} and {{department}} come from user input
    # Output: {"name": "Alice", "email": "alice@example.com", "role": "admin"}
    next:
      state_id: process-user
      store_in_context: true # Stores output in context

  - id: process-user
    assistant_id: processor
    task: |
      Process user profile:
      Name: {{name}}
      Email: {{email}}
      Role: {{role}}
      Department: {{department}}

      Generate a personalized welcome message.
    # {{name}}, {{email}}, {{role}} from state output
    # {{department}} from user input
    # All available in context store
    next:
      state_id: end
```

#### Automatic Context Storage

**Initial Context from User Input:**

When a workflow is executed, the initial user input/prompt is automatically parsed and used to populate the context store **before any states execute**. This allows you to pass structured data as input to workflows.

**How It Works:**

```yaml
# User executes workflow with JSON input:
User Input: { 'file_path': '/project/main.py', 'mode': 'analysis', 'threshold': 85 }

# Before first state executes, context store is populated:
# - file_path: "/project/main.py"
# - mode: "analysis"
# - threshold: 85

# First state can immediately access these values:
states:
  - id: first-state
    task: |
      Analyze file: {{file_path}}
      Mode: {{mode}}
      Quality threshold: {{threshold}}%
```

**Parsing Behavior:**

- **JSON input**: Parsed and all root keys added to context store
- **Plain text input**: Not added to context (only stored in message history)
- **Same parsing logic**: Uses the same intelligent parsing as state outputs (JSON, Python literals, etc.)

**Example Use Cases:**

**Configuration as Input:**

```yaml
# User input: {"config": {"max_items": 10, "format": "json"}, "source": "database"}
# Context: config, source

states:
  - id: fetch-data
    task: 'Fetch {{config.max_items}} items from {{source}} in {{config.format}} format'
```

**File Processing:**

```yaml
# User input: {"files": ["a.txt", "b.txt", "c.txt"]}
# Context: files

states:
  - id: process-files
    task: 'Process these files'
    next:
      state_id: process-file
      iter_key: files # Iterate over files from user input
```

**Default Behavior for State Outputs:**

When `store_in_context: true` (the default), state outputs are automatically processed and stored in the context store. The system attempts to parse outputs intelligently:

**Parsing Logic:**

1. **First attempt**: Try to parse as valid JSON using `json.loads()`
2. **Second attempt**: Try Python literal evaluation using `ast.literal_eval()` (supports dictionaries, lists, tuples, strings, numbers, booleans, and None)
3. **Pattern matching**: Search for JSON content wrapped in triple backticks (`json...`) or triple tildes (~~~json...~~~)
4. **Final fallback**: If all parsing fails, store the output as a plain string

**Output Type Handling:**

**Dictionary Output:**

```yaml
# State outputs a dictionary (most common case)
Output: { 'status': 'success', 'count': 42, 'items': ['a', 'b', 'c'] }

# Context store automatically contains all root-level keys:
# - status: "success"
# - count: 42
# - items: ["a", "b", "c"]

# Next state can access any key:
task: 'The operation returned {{count}} items with status: {{status}}'
```

**List of Dictionaries Output:**

```yaml
# State outputs a list containing dictionaries
Output: [{ 'file': 'a.txt', 'size': 100 }, { 'file': 'b.txt', 'size': 200 }]
# All dictionaries are merged into context store:
# - file: "b.txt"  (last value wins if keys conflict)
# - size: 200

# Note: If you need to preserve all items, output as a dictionary with a list:
# {"files": [{"file": "a.txt"}, {"file": "b.txt"}]}
```

**Simple List Output:**

```yaml
# State outputs a simple list (strings, numbers, etc.)
Output: ['file1.txt', 'file2.txt', 'file3.txt']
# The list is NOT added to context store as individual variables
# Use output_key to access the entire list, or output as a dict:
# {"files": ["file1.txt", "file2.txt", "file3.txt"]}
```

**Plain String Output:**

```yaml
# State outputs plain text (parsing fails)
Output: 'The analysis completed successfully with no structured data'
# The entire string is NOT added to context store as variables
# It remains in message history but not accessible via {{variable}}
# To make it accessible, use output_key or have the assistant output JSON
```

**Accessing Unparsed Output:**

If output cannot be parsed as structured data, you have two options:

**Option 1: Use output_key**

```yaml
states:
  - id: generate-text
    assistant_id: writer
    task: 'Write a paragraph'
    next:
      state_id: next-state
      output_key: paragraph_text

  - id: next-state
    task: 'Use the paragraph: {{paragraph_text}}'
```

**Option 2: Output as JSON**

```yaml
# Have the assistant output structured data
task: |
  Write a paragraph and return as JSON:
  {"paragraph": "your text here"}

# Now accessible as {{paragraph}}
```

**Key Takeaways:**

- ✅ **Dictionary outputs**: All root keys become accessible variables
- ✅ **List of dictionaries**: All dicts merged, keys become accessible (last wins on conflicts)
- ⚠️ **Simple lists**: Not added to context as variables (use output_key or wrap in dict)
- ⚠️ **Plain strings**: Not added to context as variables (use output_key or output as JSON)
- 💡 **Best practice**: Always output structured JSON from assistants for maximum flexibility

#### Accessing Context in Templates

**Template Variable Syntax:**

Use `{{variable_name}}` to reference context store values in:

- State task descriptions
- Tool arguments
- System prompts (when resolved dynamically)

**Basic Usage:**

```yaml
task: |
  Process the file: {{file_name}}
  Using configuration: {{config_settings}}
  For user: {{user_id}}
```

**Nested Access:**
If context contains nested structures, you can access nested values:

```yaml
# Context: {"user": {"profile": {"name": "Alice"}}}
task: 'Welcome {{user.profile.name}}'
```

**Default Values:**
If a variable doesn't exist, the template renders it as-is (the literal string `{{variable_name}}`). Best practice is to ensure variables exist before referencing them.

**Conditional Logic in Templates:**
While basic `{{variable}}` substitution is supported, complex logic should be handled via conditional transitions or custom nodes with Jinja2 templates.

### 6.2 Context Configuration Options

Context behavior can be fine-tuned per state transition using configuration flags. These flags control what data is stored, what is included in LLM history, and when to clear data.

```yaml
next:
  state_id: next-state
  # Context storage control
  store_in_context: true # Store output in context store
  include_in_llm_history: true # Include in message history

  # Context cleanup options
  clear_prior_messages: false # Clear message history
  clear_context_store: false # Clear entire context (false | true | "keep_current")
  reset_keys_in_context_store: # Remove specific keys
    - temp_data
    - intermediate_result
```

#### Context Control Flags

**store_in_context** (boolean, default: `true`)

Controls whether the current state's output is stored in the context store.

- `true`: Output is added to context store and accessible in future states
- `false`: Output is not stored; it won't be accessible via `{{variable}}` syntax

**When to use `false`:**

- The output is not needed by future states
- The output is very large and would bloat the context
- The state's output is only relevant for immediate message history

```yaml
states:
  - id: generate-large-report
    assistant_id: reporter
    task: 'Generate detailed 10-page report'
    next:
      state_id: summarize-report
      store_in_context: false # Don't store the large report
      include_in_llm_history: true # But do include in LLM history for next state
```

**include_in_llm_history** (boolean, default: `true`)

Controls whether the current state's output is included in the message history sent to AI assistants in subsequent states.

- `true`: Output appears in conversation history for LLMs
- `false`: Output is hidden from LLM context (but can still be in context store)

**When to use `false`:**

- The output contains intermediate data not relevant for LLM reasoning
- You want to reduce token usage for LLM calls
- The output is only needed for template variable substitution

```yaml
states:
  - id: fetch-database-ids
    tool_id: db-query
    task: 'Fetch all user IDs'
    # Output: {"ids": [1, 2, 3, 4, 5, ... 1000]}
    next:
      state_id: process-users
      store_in_context: true # Store IDs for iteration
      include_in_llm_history: false # Don't show raw IDs to LLM
```

**clear_prior_messages** (boolean, default: `false`)

Clears all prior messages from the message history, creating a "fresh start" for the LLM context.

- `true`: All previous messages are removed; LLM starts with clean slate
- `false`: Full conversation history is maintained

**When to use `true`:**

- Starting a new logical phase of the workflow
- Previous context is no longer relevant
- Reducing token usage by discarding old messages
- Avoiding context window limits

```yaml
states:
  - id: complete-phase-1
    assistant_id: assistant-1
    task: 'Complete phase 1 tasks'
    next:
      state_id: start-phase-2
      clear_prior_messages: true # Fresh start for phase 2

  - id: start-phase-2
    assistant_id: assistant-2
    task: 'Begin phase 2 with fresh context'
    # This assistant doesn't see phase 1's message history
    next:
      state_id: end
```

**clear_context_store** (boolean | string, default: `false`)

Controls context store clearing behavior after this state executes.

**Supported values:**

- `false` (default): Don't clear context store, merge new values with existing context
- `true`: Clear entire context store (all keys removed, including new values from this state)
- `"keep_current"`: Keep only new values from this state, discard all previous context

**When to use `true`:**

- Starting a completely new workflow phase
- Preventing data leakage between workflow sections
- Freeing memory in long-running workflows
- You don't need any context (including current state output) in subsequent states

**When to use `"keep_current"`:**

- You want a fresh context but still need the current state's output
- Starting a new phase but need to carry forward only the current results
- Preventing context bloat while preserving essential new data
- Useful when previous context is irrelevant but current output is needed

**Example: Complete Clear (`true`)**

```yaml
states:
  - id: cleanup-phase
    assistant_id: cleaner
    task: 'Finalize current phase'
    next:
      state_id: new-phase
      clear_context_store: true # Remove ALL context (including current output)

  - id: new-phase
    assistant_id: processor
    task: 'Start fresh with no prior context'
    # No variables available from previous states
    next:
      state_id: end
```

**Example: Keep Current (`"keep_current"`)**

```yaml
states:
  - id: summarize-phase
    assistant_id: summarizer
    task: 'Summarize all previous analysis'
    # Outputs: {"summary": "...", "key_findings": [...]}
    next:
      state_id: new-phase
      clear_context_store: 'keep_current' # Keep only summary and key_findings
      store_in_context: true

  - id: new-phase
    assistant_id: processor
    task: 'Work with {{summary}} and findings'
    # Has access to: summary, key_findings
    # Does NOT have access to: all previous context from earlier states
    next:
      state_id: end
```

**Comparison: `true` vs `"keep_current"`**

```yaml
# Scenario: State outputs {"result": "success", "data": [1,2,3]}
# Previous context: {"old_key": "old_value"}

# With clear_context_store: true
# → Context after state: {} (empty, everything cleared)

# With clear_context_store: "keep_current"
# → Context after state: {"result": "success", "data": [1,2,3]} (only new values)

# With clear_context_store: false (default)
# → Context after state: {"old_key": "old_value", "result": "success", "data": [1,2,3]} (merged)
```

**reset_keys_in_context_store** (list of strings, default: `null`)

Removes specific keys from the context store while preserving all other keys. Provides granular control over context cleanup.

- Specify keys to remove as a list
- Keys that don't exist are silently ignored
- More selective than `clear_context_store`

**When to use:**

- Removing temporary data no longer needed
- Cleaning up intermediate results
- Preventing specific variables from accumulating

```yaml
states:
  - id: process-with-temp-data
    assistant_id: processor
    task: 'Process data using temporary variables'
    # Uses: temp_file_path, temp_config, final_result
    next:
      state_id: finalize
      reset_keys_in_context_store:
        - temp_file_path # Remove temporary file path
        - temp_config # Remove temporary config
      # final_result is preserved
```

#### Configuration Combinations

**Pattern 1: Store but Don't Show to LLM**

```yaml
next:
  store_in_context: true
  include_in_llm_history: false
```

Use case: Store data for template substitution but don't clutter LLM context.

**Pattern 2: Show to LLM but Don't Store**

```yaml
next:
  store_in_context: false
  include_in_llm_history: true
```

Use case: LLM needs to see output for context, but you don't need it for variable substitution.

**Pattern 3: Complete Fresh Start**

```yaml
next:
  clear_prior_messages: true
  clear_context_store: true
```

Use case: Starting a completely new workflow phase with no carried context.

**Pattern 4: Selective Cleanup**

```yaml
next:
  store_in_context: true
  reset_keys_in_context_store:
    - iteration_counter
    - temp_result
```

Use case: Store current output but remove specific temporary variables.

**Pattern 5: Fresh Start with Current Output**

```yaml
next:
  store_in_context: true
  clear_context_store: 'keep_current'
  clear_prior_messages: true
```

Use case: Start a new workflow phase with a clean slate but preserve the current state's output for the next phase. Useful for multi-phase workflows where each phase needs only the summary from the previous phase.

**Pattern 6: Context Reset Between Iterations**

```yaml
next:
  state_id: process-item
  clear_context_store: 'keep_current'
  iter_key: items
```

Use case: When iterating over items, prevent context from accumulating across iterations. Each iteration gets only the current item, not data from previous iterations.

### 6.3 Dynamic Value Resolution

Dynamic value resolution enables you to use context store values throughout your workflow configuration using template syntax.

#### Basic Template Syntax

**Simple Variable Substitution:**

```yaml
task: |
  Process user {{user_id}} with email {{user_email}}
```

When the state executes, `{{user_id}}` and `{{user_email}}` are replaced with actual values from the context store.

**Example:**

```yaml
# Context store contains:
# - user_id: "12345"
# - user_email: "alice@example.com"

# Resolved task becomes:
task: |
  Process user 12345 with email alice@example.com
```

#### Using Dynamic Values in Different Locations

**1. State Task Descriptions**

```yaml
states:
  - id: process-data
    assistant_id: processor
    task: |
      Analyze file: {{file_path}}
      Using configuration: {{config_name}}
      Expected format: {{data_format}}
```

**2. Tool Arguments**

```yaml
states:
  - id: call-api
    tool_id: api-tool
    tool_args:
      endpoint: '{{api_endpoint}}'
      user_id: '{{user_id}}'
      auth_token: '{{auth_token}}'
```

**3. Conditional Expressions**
Variables in conditional expressions are accessed **without** `{{}}`:

```yaml
next:
  condition:
    expression: "user_role == 'admin'" # No {{}} here
    then: admin-path
    otherwise: user-path
```

**4. Iterative Transitions**

```yaml
# Context store contains: {"files": ["a.txt", "b.txt", "c.txt"]}

next:
  state_id: process-file
  iter_key: files # Extracts the list from context
```

#### Enable Dynamic Resolution

By default, dynamic value resolution is **enabled** for task descriptions. For additional control:

**resolve_dynamic_values_in_prompt** (state-level)

```yaml
states:
  - id: my-state
    assistant_id: my-assistant
    task: 'Process {{data}}'
    resolve_dynamic_values_in_prompt: true # Explicitly enable
```

**resolve_dynamic_values_in_response** (tool-level)

```yaml
tools:
  - id: my-tool
    tool: tool-method
    resolve_dynamic_values_in_response: true
    # Process variables in tool output before storing
```

**resolve_dynamic_values_in_arguments** (MCP server-level)

```yaml
mcp_servers:
  - name: my-server
    resolve_dynamic_values_in_arguments: true
    config:
      args:
        - '{{project_path}}'
        - '{{config_file}}'
```

#### Advanced: Accessing Nested Data

When a state outputs nested JSON structures, the **entire nested structure** is preserved in the context store under its root key. You can then access nested values using **Jinja2 dot notation**.

**How It Works:**

```yaml
# State outputs nested JSON:
Output:
  {
    'user':
      {
        'profile': { 'name': 'Alice', 'email': 'alice@example.com' },
        'preferences': { 'theme': 'dark' },
      },
  }

# Context store contains:
# - user: {"profile": {"name": "Alice", "email": "alice@example.com"}, "preferences": {"theme": "dark"}}
#   (entire nested structure stored under "user" key)

# Access nested values using Jinja2 dot notation:
task: |
  Welcome {{user.profile.name}}
  Your email: {{user.profile.email}}
  Theme: {{user.preferences.theme}}
```

:::note Important Notes

- **Root-level keys only**: Only top-level keys from JSON output become context store keys
- **Nested structures preserved**: The values can be complex nested objects/arrays
- **Jinja2 resolution**: Template rendering uses Jinja2, which supports dot notation for nested access
- **Alternative: Flatten at source**: For simpler access, have assistants output flat structures:
  ```yaml
  # Easier to work with:
  Output: { 'user_name': 'Alice', 'user_email': 'alice@example.com', 'user_theme': 'dark' }
  # Direct access: {{user_name}}, {{user_email}}, {{user_theme}}
  ```
  :::

**Working with Arrays:**

```yaml
# State outputs array in nested structure:
Output: {"files": [{"name": "a.txt", "size": 100}, {"name": "b.txt", "size": 200}]}

# Context store contains:
# - files: [{"name": "a.txt", "size": 100}, {"name": "b.txt", "size": 200}]

# Access array elements:
task: |
  First file: {{files[0].name}} ({{files[0].size}} bytes)
  Second file: {{files[1].name}} ({{files[1].size}} bytes)

# Or iterate in Jinja2 (when used in custom nodes with output_template):
{% for file in files %}
  - {{file.name}}: {{file.size}} bytes
{% endfor %}
```

**Best Practices:**

- ✅ **Use flat structures** when possible for simpler variable access
- ✅ **Use nested structures** when you need to group related data
- ✅ **Use descriptive root keys** like `user_data`, `analysis_results`, `config_settings`
- ⚠️ **Be careful with depth**: Deep nesting like `{{a.b.c.d.e}}` can fail if any intermediate key is missing

#### Best Practices for Context Management

**1. Use Meaningful Variable Names**

```yaml
# Good
{{user_email}}, {{file_path}}, {{analysis_result}}

# Avoid
{{x}}, {{data}}, {{result}}
```

**2. Document Context Dependencies**

```yaml
states:
  - id: process-user
    # Requires: user_id, user_email from previous state
    assistant_id: processor
    task: 'Process {{user_id}}'
```

**3. Clean Up Temporary Data**

```yaml
next:
  state_id: next-state
  reset_keys_in_context_store:
    - temp_file
    - iteration_index
```

**4. Avoid Context Bloat**

```yaml
# Don't store large outputs unnecessarily
next:
  store_in_context: false # If not needed later
```

**5. Use Conditional Cleanup**

```yaml
# Clear context between major workflow phases
next:
  clear_prior_messages: true # Start fresh
  reset_keys_in_context_store: [temp_data, cache]
```

---
