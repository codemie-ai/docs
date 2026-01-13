---
id: best-practices
title: Best Practices
sidebar_label: Best Practices
pagination_prev: user-guide/workflows/configuration/integration-capabilities
pagination_next: user-guide/workflows/configuration/examples
sidebar_position: 10
---

# Best Practices

## 10. Best Practices

### 10.1 Workflow Design Principles

#### Keep States Focused and Single-Purpose

Each state should perform one clear, well-defined task. This makes workflows easier to understand, test, and maintain.

**Good Example:**

```yaml
states:
  - id: fetch-data
    task: "Fetch user data from database"

  - id: validate-data
    task: "Validate data completeness and format"

  - id: process-data
    task: "Transform data into required format"

  - id: store-results
    task: "Store processed data"
```

**Bad Example:**

```yaml
states:
  - id: do-everything
    task: "Fetch data, validate it, process it, and store results"
    # Too many responsibilities in one state
```

**Benefits:**

- Easier to debug issues
- Better reusability of states
- Clearer workflow visualization
- Simpler error handling

#### Use Descriptive IDs and Names

IDs and names should clearly indicate what each component does. Avoid generic names and abbreviations.

**Good Examples:**

```yaml
# States
- id: analyze-security-vulnerabilities
- id: generate-documentation
- id: validate-user-permissions

# Assistants
- id: code-security-reviewer
- id: technical-documentation-writer
- id: permission-validator
```

**Bad Examples:**

```yaml
# Avoid
- id: state1
- id: proc
- id: helper
- id: temp-agent
```

**Naming Conventions:**

- Use kebab-case for IDs: `analyze-code-quality`
- Use action verbs: `fetch`, `validate`, `process`, `generate`
- Be specific: `validate-json-schema` not just `validate`

#### Provide Clear Task Instructions

Task descriptions should be explicit and detailed. Remember that the AI assistant only sees the task description and system prompt.

**Good Task Description:**

```yaml
task: |
  Analyze the provided code file for security vulnerabilities.

  Focus on:
  1. SQL injection risks
  2. XSS vulnerabilities
  3. Authentication bypass potential
  4. Insecure data storage

  For each issue found, provide:
  - Severity level (Critical/High/Medium/Low)
  - Line number and code snippet
  - Explanation of the risk
  - Recommended fix

  Output format: JSON with structure {"issues": [...]}
```

**Bad Task Description:**

```yaml
task: "Check the code"
# Too vague - what to check? How to report?
```

**Tips:**

- Specify the expected input and output format
- Include examples if helpful
- Break complex instructions into numbered steps
- Reference context variables explicitly: `Analyze {{file_path}}`

#### Handle Error Cases Explicitly

Design workflows to handle failures gracefully using conditional transitions and retry policies.

**Pattern: Conditional Error Handling**

```yaml
states:
  - id: attempt-operation
    assistant_id: processor
    task: "Perform operation and return status"
    retry_policy:
      max_attempts: 3
    next:
      condition:
        expression: "status == 'success'"
        then: continue-workflow
        otherwise: handle-error

  - id: handle-error
    assistant_id: error-handler
    task: "Log error and create fallback solution"
    next:
      state_id: end
```

**Pattern: Validation Before Processing**

```yaml
states:
  - id: validate-input
    task: "Validate input data meets requirements"
    next:
      condition:
        expression: "validation_passed == true"
        then: process-data
        otherwise: report-validation-error
```

#### Design for Maintainability

**1. Use Comments to Document Intent**

```yaml
# Phase 1: Data Collection
states:
  - id: fetch-from-api
    # Fetches raw data from external API
    # Depends on: api_endpoint in context
    task: "Fetch data from {{api_endpoint}}"

  - id: fetch-from-database
    # Fetches supplementary data from internal DB
    # Parallel execution with fetch-from-api
    task: "Fetch reference data"
```

**2. Group Related States Logically**

```yaml
# Data Ingestion Phase
- id: fetch-data
- id: validate-data

# Processing Phase
- id: transform-data
- id: enrich-data

# Output Phase
- id: format-results
- id: store-results
```

**3. Avoid Hard-Coding Values**

```yaml
# Good: Use context variables
task: "Process file {{file_path}} with format {{format_type}}"

# Bad: Hard-coded values
task: "Process file /tmp/data.json with format JSON"
```

**4. Keep Workflows Modular**
Break large workflows into smaller, reusable sub-workflows when possible.

### 10.2 Context Management Best Practices

#### Minimize Context Store Size

Large context stores impact performance and token usage. Store only what's necessary.

**Good:**

```yaml
states:
  - id: process-large-dataset
    task: "Process dataset and return summary statistics"
    # Output: {"count": 1000, "average": 42.5}
    next:
      store_in_context: true
      # Only stores summary, not full dataset
```

**Bad:**

```yaml
states:
  - id: process-large-dataset
    task: "Process dataset and return all 10,000 records"
    # Output: {"records": [{...}, {...}, ...]}  # Huge!
    next:
      store_in_context: true  # Bloats context
```

#### Clear Unnecessary Data

Actively clean up context data that's no longer needed.

**Pattern: Phase-Based Cleanup**

```yaml
states:
  - id: complete-phase-1
    task: "Finalize phase 1"
    next:
      state_id: start-phase-2
      reset_keys_in_context_store:
        - temp_file_path
        - intermediate_cache
        - iteration_counters
      # Keep only essential data for phase 2
```

**Pattern: Iteration Cleanup**

```yaml
states:
  - id: process-batch
    task: "Process batch of items"
    next:
      state_id: next-batch
      reset_keys_in_context_store:
        - current_batch_data
        - batch_index
      # Clean up between iterations
```

#### Use Specific Keys for Important Data

Use meaningful, specific names for context keys to avoid accidental overwrites.

**Good:**

```yaml
# Specific, descriptive keys
{{user_profile_data}}
{{api_authentication_token}}
{{validation_errors_list}}
{{file_processing_status}}
```

**Bad:**

```yaml
# Generic keys prone to conflicts
{{data}}
{{result}}
{{status}}
{{temp}}
```

#### Document Context Dependencies

Make it clear what context variables each state requires and produces.

**Pattern: Inline Documentation**

```yaml
states:
  - id: generate-report
    # Requires: analysis_results, user_email, report_format
    # Produces: report_content, report_url
    assistant_id: report-generator
    task: |
      Generate {{report_format}} report from {{analysis_results}}
      Send to {{user_email}}
```

#### Avoid Circular Data Flows

Don't create situations where states overwrite each other's critical data.

**Bad Pattern:**

```yaml
states:
  - id: state-a
    task: "Process data"
    # Output: {"result": "A"}
    next:
      state_id: state-b

  - id: state-b
    task: "Process data differently"
    # Output: {"result": "B"}  # Overwrites state-a's result!
    next:
      state_id: state-c

  - id: state-c
    task: "Use result from state-a"
    # BUG: {{result}} is now "B", not "A"
```

**Good Pattern:**

```yaml
states:
  - id: state-a
    task: "Process data"
    # Output: {"result_a": "A"}
    next:
      state_id: state-b

  - id: state-b
    task: "Process data differently"
    # Output: {"result_b": "B"}
    next:
      state_id: state-c

  - id: state-c
    task: "Use both results: {{result_a}} and {{result_b}}"
```

### 10.3 Performance Optimization

#### Limit Parallel Fan-Out

While parallel processing is powerful, too much parallelization can overwhelm resources.

**Guidelines:**

- **Small datasets (`<10 items`)**: Parallel processing is ideal
- **Medium datasets (`10-50 items`)**: Use with `max_concurrency` limit
- **Large datasets (`>50 items`)**: Consider batching or sequential processing

**Example: Controlled Parallelization**

```yaml
# Workflow-level concurrency limit
max_concurrency: 5

states:
  - id: split-work
    task: "Split into 100 items"
    next:
      state_id: process-item
      iter_key: items
      # Only 5 items processed simultaneously

  - id: process-item
    task: "Process {{item}}"
    next:
      state_id: aggregate
```

#### Use Appropriate Memory Limits

Configure memory management settings based on workflow complexity.

**For Short Workflows (< 10 states):**

```yaml
messages_limit_before_summarization: 50
tokens_limit_before_summarization: 100000
enable_summarization_node: false
```

**For Long Workflows (> 20 states):**

```yaml
messages_limit_before_summarization: 20
tokens_limit_before_summarization: 40000
enable_summarization_node: true
```

**For Iterative Workflows:**

```yaml
messages_limit_before_summarization: 15
tokens_limit_before_summarization: 30000
enable_summarization_node: true
# Aggressive summarization to handle repetition
```

#### Optimize Tool Output Size

Configure tools to return only necessary data.

**Pattern: Limit Tool Output Tokens**

```yaml
assistants:
  - id: analyzer
    limit_tool_output_tokens: 5000
    # Prevents tools from returning huge outputs
```

**Pattern: Extract Specific Results**

```yaml
tools:
  - id: api-call
    tool: call_api
    tool_result_json_pointer: /data/summary
    # Extract only summary, not full API response
```

#### Enable Result Summarization

For long-running workflows, enable automatic summarization.

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 25
tokens_limit_before_summarization: 50000

# When limits are exceeded, conversation history is automatically
# summarized to maintain context while reducing token usage
```

#### Configure Appropriate Timeouts

**Workflow-Level Recursion Limit:**

```yaml
recursion_limit: 50  # Maximum execution steps
# Default: 50
# Increase for complex workflows with many iterations
# Decrease for simple workflows to fail fast
```

**State-Level Retry Policies:**

```yaml
states:
  - id: external-api-call
    retry_policy:
      max_attempts: 3
      initial_interval: 1.0
      backoff_factor: 2.0
      max_interval: 10.0
    # Retries with exponential backoff for transient failures
```

### 10.4 Error Handling

#### Configure Retry Policies Appropriately

**Default Retry Policy (Workflow-Level):**

```yaml
retry_policy:
  max_attempts: 3
  initial_interval: 1.0
  backoff_factor: 2.0
  max_interval: 60.0
```

**Per-State Retry Override:**

```yaml
states:
  - id: critical-external-call
    retry_policy:
      max_attempts: 5      # More retries for critical operations
      initial_interval: 2.0
      backoff_factor: 3.0
      max_interval: 120.0

  - id: non-critical-step
    retry_policy:
      max_attempts: 1      # No retries for non-critical operations
```

**What Gets Retried Automatically:**

- Network errors (5xx HTTP status codes)
- Timeout errors
- Rate limiting errors (429)

**What Does NOT Get Retried:**

- Authentication errors (401, 403, 404)
- Validation errors
- Malformed requests

#### Use Conditional Transitions for Error Paths

Implement explicit error handling paths using conditionals.

**Pattern: Status-Based Routing**

```yaml
states:
  - id: attempt-operation
    task: "Attempt operation, return {status, error_message}"
    next:
      condition:
        expression: "status == 'success'"
        then: continue-workflow
        otherwise: log-and-retry

  - id: log-and-retry
    task: "Log error: {{error_message}}"
    next:
      state_id: attempt-operation
```

**Pattern: Switch for Multiple Error Types**

```yaml
next:
  switch:
    cases:
      - condition: "error_type == 'validation'"
        state_id: fix-validation-error
      - condition: "error_type == 'permission'"
        state_id: request-permission
      - condition: "error_type == 'timeout'"
        state_id: retry-with-backoff
    default: unknown-error-handler
```

#### Validate Data Between States

Add validation states between critical operations.

**Pattern: Explicit Validation**

```yaml
states:
  - id: fetch-data
    task: "Fetch data from API"
    next:
      state_id: validate-data

  - id: validate-data
    task: |
      Validate the fetched data:
      - Check required fields are present
      - Verify data types
      - Ensure values are within expected ranges
      Return: {valid: true/false, errors: [...]}
    next:
      condition:
        expression: "valid == true"
        then: process-data
        otherwise: handle-invalid-data
```

#### Provide Meaningful Error Messages

When handling errors, include context about what went wrong and why.

**Good Error Handling:**

```yaml
task: |
  If operation fails, return detailed error:
  {
    "status": "error",
    "error_type": "validation_failed",
    "message": "Missing required field 'email'",
    "context": {
      "state": "user-registration",
      "input_received": "{{input}}",
      "expected_format": {"name": "string", "email": "string"}
    }
  }
```

#### Log Critical Decision Points

Use states to log important decisions and state transitions.

**Pattern: Logging State**

```yaml
states:
  - id: make-critical-decision
    task: "Analyze data and make decision"
    next:
      state_id: log-decision

  - id: log-decision
    task: |
      Log decision made:
      - Decision: {{decision_made}}
      - Reason: {{decision_reason}}
      - Confidence: {{confidence_score}}
      - Timestamp: {{timestamp}}
    next:
      state_id: execute-decision
      include_in_llm_history: false  # Logged but not needed for LLM
```

### 10.5 Security Considerations

#### Avoid Hardcoding Credentials

Never include sensitive information directly in workflow configurations.

**Bad:**

```yaml
tools:
  - id: api-call
    tool_args:
      api_key: "sk-****************"  # NEVER DO THIS
      password: "mypassword"          # NEVER DO THIS
```

**Good:**

```yaml
tools:
  - id: api-call
    integration_alias: production-api
    # Credentials are managed securely via CodeMie Integrations
```

#### Use Integration Alias for Credential Management

Reference CodeMie Integrations for secure credential and environment variable management.

```yaml
assistants:
  - id: cloud-operator
    tools:
      - name: aws_operations
        integration_alias: aws-production
        # Credentials pulled from integration

tools:
  - id: database-query
    tool: query_database
    integration_alias: postgres-prod
    # Connection string and credentials from integration

mcp_servers:
  - name: filesystem
    integration_alias: secure-storage
    # Authentication handled by integration
```

#### Validate User Inputs

Always validate user-provided data before processing.

**Pattern: Input Validation State**

```yaml
states:
  - id: validate-user-input
    task: |
      Validate user input:
      - Check for SQL injection patterns
      - Validate email format
      - Ensure file paths are within allowed directories
      - Verify data types and ranges
      Return: {valid: true/false, sanitized_input: {...}}
    next:
      condition:
        expression: "valid == true"
        then: process-input
        otherwise: reject-input
```

#### Sanitize Tool Outputs

Clean and validate outputs from external tools before using them.

**Pattern: Sanitization State**

```yaml
states:
  - id: call-external-api
    tool_id: external-api
    next:
      state_id: sanitize-response

  - id: sanitize-response
    task: |
      Sanitize API response:
      - Remove any embedded scripts
      - Validate data structure
      - Filter sensitive fields
      - Escape special characters
    next:
      state_id: use-sanitized-data
```

#### Limit Data Source Access

Grant minimum necessary permissions to assistants and tools.

```yaml
assistants:
  - id: public-facing-assistant
    datasource_ids:
      - public-documentation
      # Only public data, no internal repositories

  - id: internal-analyst
    datasource_ids:
      - public-documentation
      - internal-codebase
      - team-confluence
      # More access for internal use
```

**Principle of Least Privilege:**

- Only grant tools/data sources that are actually needed
- Use separate assistants for different security contexts
- Review and audit data source access regularly

---
