---
id: workflow-states
title: Workflow States
sidebar_label: Workflow States
pagination_prev: user-guide/workflows/configuration/configuration-reference
pagination_next: user-guide/workflows/configuration/state-transitions
sidebar_position: 4
---

# Workflow States

## 4. Workflow States

### 4.1 State Types

- **Agent States**: Execute AI assistant with specific task
- **Tool States**: Execute tool directly without LLM
- **Custom Node States**: Specialized processing nodes

### 4.2 Agent State Configuration

```yaml
states:
  - id: state-1
    assistant_id: assistant-1
    task: |
      Detailed task description and instructions with {{dynamic_placeholders}}.
    next:
      state_id: state-2
    resolve_dynamic_values_in_prompt: true
```

#### Agent State Properties:

- **id**: Unique state identifier
- **assistant_id**: Reference to assistant configuration
- **task**: Instructions for the assistant
- **next**: State transition configuration
- **resolve_dynamic_values_in_prompt**: Enable template variable resolution
- **output_schema**: JSON schema for structured output (optional)
- **interrupt_before**: Pause workflow for user confirmation
- **retry_policy**: Custom retry configuration

#### Agent State Advanced Examples:

**Example 1: Using `output_schema` for Structured Output**

```yaml
assistants:
  - id: data-extractor
    model: gpt-4.1
    system_prompt: Extract structured information from text

states:
  - id: extract-user-info
    assistant_id: data-extractor
    task: |
      Extract user information from this text: {{user_text}}

      Return data in the specified JSON format.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "email": {"type": "string", "format": "email"},
          "age": {"type": "number", "minimum": 0},
          "interests": {
            "type": "array",
            "items": {"type": "string"}
          }
        },
        "required": ["name", "email"]
      }
    # The LLM output is validated against this schema
    # If validation fails, the LLM is re-prompted automatically
    # Output is guaranteed to match the schema structure
    next:
      state_id: process-user-data

# Example successful output:
# {
#   "name": "Alice Johnson",
#   "email": "alice@example.com",
#   "age": 28,
#   "interests": ["reading", "hiking", "photography"]
# }
```

**Example 2: Using `interrupt_before` for Human-in-the-Loop**

```yaml
assistants:
  - id: approver
    model: gpt-4.1
    system_prompt: Review and summarize proposed changes

states:
  - id: analyze-changes
    assistant_id: approver
    task: |
      Analyze the proposed changes and provide a summary:
      {{changes_description}}
    next:
      state_id: await-approval

  - id: await-approval
    assistant_id: approver
    interrupt_before: true  # Pause before executing this state
    task: |
      Apply the approved changes.

      Previous analysis: {{task}}
    # Workflow pauses here and waits for user to:
    # 1. Review the analysis from previous state
    # 2. Click "Continue" to proceed or "Cancel" to stop
    # User sees all previous conversation history
    next:
      state_id: apply-changes

  - id: apply-changes
    assistant_id: approver
    task: "Execute the approved changes"
    next:
      state_id: end
```

**Example 3: Using `retry_policy` at State Level**

```yaml
assistants:
  - id: api-caller
    model: gpt-4.1-mini
    system_prompt: Make API calls and handle responses
    tools:
      - name: http_request

states:
  - id: call-external-api
    assistant_id: api-caller
    task: |
      Call the external API at {{api_endpoint}} and retrieve data.
      Handle any rate limiting or temporary errors gracefully.
    retry_policy:
      max_attempts: 5         # Retry up to 5 times
      initial_interval: 2.0   # Wait 2 seconds before first retry
      backoff_factor: 2.0     # Double wait time each retry (2s, 4s, 8s, 16s)
      max_interval: 30.0      # Cap wait time at 30 seconds
    # Automatically retries on:
    # - Network errors (5xx status codes)
    # - Timeout errors
    # - Rate limiting errors (429)
    # Does NOT retry on: 401, 403, 404 errors
    next:
      state_id: process-api-response

# Retry timing example:
# Attempt 1: Immediate
# Attempt 2: After 2 seconds
# Attempt 3: After 4 seconds
# Attempt 4: After 8 seconds
# Attempt 5: After 16 seconds
# Total max time: 30 seconds of delays + execution time
```

**Example 4: Combining Multiple Advanced Properties**

```yaml
assistants:
  - id: critical-processor
    model: gpt-4.1
    system_prompt: Process critical business data
    tools:
      - name: database_query
        integration_alias: prod-db

states:
  - id: critical-data-processing
    assistant_id: critical-processor
    interrupt_before: true  # Require approval before running
    task: |
      Process critical financial data for quarter {{quarter}}.

      Extract:
      - Total revenue
      - Operating expenses
      - Net profit margin
      - Growth percentage
    output_schema: |
      {
        "type": "object",
        "properties": {
          "total_revenue": {"type": "number"},
          "operating_expenses": {"type": "number"},
          "net_profit_margin": {"type": "number"},
          "growth_percentage": {"type": "number"}
        },
        "required": ["total_revenue", "net_profit_margin"]
      }
    retry_policy:
      max_attempts: 3
      initial_interval: 1.0
      backoff_factor: 2.0
    resolve_dynamic_values_in_prompt: true
    # This state demonstrates:
    # 1. Requires user approval before execution
    # 2. Enforces structured output schema
    # 3. Has custom retry policy for reliability
    # 4. Uses dynamic value resolution for quarter variable
    next:
      state_id: generate-report
```

**Example 5: Using `resolve_dynamic_values_in_prompt`**

```yaml
states:
  - id: personalized-analysis
    assistant_id: analyzer
    resolve_dynamic_values_in_prompt: true  # Enable template resolution
    task: |
      Analyze data for user {{user_name}} (ID: {{user_id}}).

      Focus areas:
      - Department: {{department}}
      - Project: {{project_name}}
      - Time period: {{start_date}} to {{end_date}}

      Previous results: {{previous_results}}
    # All {{variables}} are replaced with values from context store
    # before sending task to the LLM
    next:
      state_id: next-step

# With context:
# {
#   "user_name": "Alice",
#   "user_id": "12345",
#   "department": "Engineering",
#   "project_name": "Platform Redesign",
#   "start_date": "2025-01-01",
#   "end_date": "2025-03-31",
#   "previous_results": "92% completion rate"
# }
#
# LLM receives:
# "Analyze data for user Alice (ID: 12345).
#  Focus areas:
#  - Department: Engineering
#  - Project: Platform Redesign
#  - Time period: 2025-01-01 to 2025-03-31
#  Previous results: 92% completion rate"
```

### 4.3 Tool State Configuration

```yaml
states:
  - id: state-1
    tool_id: tool-1
    tool_args:
      param1: value1
      param2: "{{context_value}}"
    next:
      state_id: state-2
```

#### Tool State Properties:

- **id**: Unique state identifier
- **tool_id**: Reference to tool configuration
- **tool_args**: Override tool arguments (optional)
- **next**: State transition configuration

### 4.4 Custom Node State Configuration

```yaml
states:
  - id: state-1
    custom_node_id: node-1
    task: Processing instructions
    next:
      state_id: state-2
```

#### Custom Node State Properties:

- **id**: Unique state identifier
- **custom_node_id**: Reference to custom node configuration
- **task**: Instructions for the node
- **next**: State transition configuration

---
