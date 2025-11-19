---
id: 412-troubleshooting
title: Troubleshooting
sidebar_label: Troubleshooting
sidebar_position: 3
---

# Troubleshooting

## Common Issues

### Validation Errors

#### Undefined References

**Problem**: Workflow fails validation with "undefined reference" errors.

**Causes**:
- Referencing an assistant_id, tool_id, or state_id that doesn't exist
- Typo in ID names
- Missing assistant or tool definition

**Solutions**:
```yaml
# ✅ Correct: Define assistant before referencing
assistants:
  - id: my-assistant
    model: gpt-4.1

states:
  - id: state-1
    assistant_id: my-assistant  # Matches defined ID

# ❌ Wrong: Referencing non-existent assistant
states:
  - id: state-1
    assistant_id: my-assitant  # Typo: "assitant" vs "assistant"
```

#### Invalid YAML Syntax

**Problem**: "Invalid YAML format" error.

**Common Causes**:
- Incorrect indentation (mixing tabs and spaces)
- Missing colons after keys
- Unquoted special characters
- Unclosed strings

**Solutions**:
```yaml
# ✅ Correct indentation (2 spaces)
assistants:
  - id: my-assistant
    model: gpt-4.1

# ❌ Wrong: Inconsistent indentation
assistants:
 - id: my-assistant
   model: gpt-4.1

# ✅ Correct: Quote special characters
task: "Process file: {{file_name}}"

# ❌ Wrong: Unquoted special characters
task: Process file: {{file_name}}
```

#### Missing Required Fields

**Problem**: "Missing required field" errors.

**Solutions**:
```yaml
# Required fields for states:
states:
  - id: state-1           # ✅ Required
    assistant_id: my-assistant  # ✅ Required (or tool_id)
    task: "Do something"  # ✅ Required for agent states
    next:                 # ✅ Required
      state_id: state-2

# Required fields for assistants:
assistants:
  - id: my-assistant      # ✅ Required
    model: gpt-4.1        # ✅ Required (or assistant_id reference)
```

#### Schema Validation Failures

**Problem**: Output doesn't match defined output_schema.

**Solution**:
```yaml
# Define clear, accurate schemas
states:
  - id: extract-data
    task: "Extract name and age"
    output_schema: |
      {
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "age": {"type": "number"}
        },
        "required": ["name", "age"]
      }
```

---

### Execution Errors

#### State Not Found

**Problem**: "State with ID 'xyz' not found" during execution.

**Causes**:
- Typo in state_id reference
- Conditional transition referencing non-existent state
- Switch case with invalid state_id

**Solution**:
```yaml
# ✅ Correct: All referenced states exist
states:
  - id: state-1
    next:
      condition:
        expression: "status == 'success'"
        then: state-2      # State exists below
        otherwise: state-3 # State exists below

  - id: state-2
    task: "Handle success"

  - id: state-3
    task: "Handle failure"
```

#### Tool Execution Failures

**Problem**: Tool fails to execute or returns errors.

**Common Causes**:
1. **Missing credentials**: Integration alias not configured
2. **Invalid arguments**: Wrong parameter types or values
3. **Permission errors**: Tool lacks necessary permissions
4. **Network issues**: Unable to reach external services

**Solutions**:
```yaml
# ✅ Use integration aliases for credentials
tools:
  - id: aws-operation
    tool: aws_ec2_describe_instances
    integration_alias: aws-production  # Credentials managed centrally

# ✅ Validate tool arguments
tool_args:
  region: "us-east-1"        # Valid AWS region
  instance_ids: ["i-123"]    # Correct format
```

#### Context Access Errors

**Problem**: "Variable not found in context" or "KeyError".

**Causes**:
- Referencing variable before it's stored
- Typo in variable name
- Variable cleared or not stored

**Solution**:
```yaml
# ✅ Store before accessing
states:
  - id: state-1
    task: "Generate result"
    next:
      state_id: state-2
      output_key: my_result    # Store as "my_result"
      store_in_context: true   # Must be true

  - id: state-2
    task: "Use result: {{my_result}}"  # Now available
```

#### Timeout Issues

**Problem**: Workflow exceeds recursion limit or times out.

**Causes**:
- Too many states executed
- Infinite loop in conditional logic
- Large parallel fan-out

**Solutions**:
```yaml
# Increase recursion limit if needed
recursion_limit: 100  # Default is 50

# Avoid infinite loops
states:
  - id: check-status
    next:
      condition:
        expression: "attempt_count < 5"  # Add limit
        then: retry-operation
        otherwise: give-up  # Exit condition

# Limit parallel execution
max_concurrency: 10  # Prevent too many parallel states
```

---

### Memory Issues

#### Token Limit Exceeded

**Problem**: "Token limit exceeded" or "Context too large".

**Causes**:
- Message history grows too large
- Large tool outputs included in context
- Many iterations without summarization

**Solutions**:
```yaml
# Enable automatic summarization
enable_summarization_node: true
messages_limit_before_summarization: 20
tokens_limit_before_summarization: 40000

# Limit tool output size
assistants:
  - id: my-assistant
    limit_tool_output_tokens: 5000  # Truncate large outputs

# Use JSON pointer to extract only needed data
tools:
  - id: api-call
    tool: call_api
    tool_result_json_pointer: /data/summary  # Extract subset
```

#### Context Too Large

**Problem**: Context store grows too large, slowing execution.

**Solutions**:
```yaml
# Clear unnecessary data between phases
states:
  - id: complete-phase-1
    next:
      state_id: start-phase-2
      reset_keys_in_context_store:
        - temp_data
        - intermediate_results

# Don't store large outputs
states:
  - id: process-large-dataset
    task: "Return only summary statistics, not full dataset"
    next:
      store_in_context: true  # Only summary stored
```

#### History Accumulation

**Problem**: Message history grows indefinitely.

**Solutions**:
```yaml
# Exclude states from history when not needed
states:
  - id: logging-state
    task: "Log this action"
    next:
      state_id: next-state
      include_in_llm_history: false  # Not needed for AI context

# Clear history at checkpoints
states:
  - id: start-new-phase
    task: "Begin new phase"
    next:
      state_id: phase-2
      clear_prior_messages: true  # Fresh start
```

---

## Debugging Techniques

### Enable Verbose Logging

Check workflow execution logs for detailed information about:
- State transitions
- Variable values in context
- Tool executions and results
- Error messages and stack traces

### Use Workflow Visualization

View the workflow execution graph to:
- See the execution path taken
- Identify which states succeeded or failed
- Understand parallel execution flow
- Spot infinite loops or unexpected paths

### Check Execution State History

Review the state history to:
- See inputs and outputs for each state
- Verify data transformations
- Identify where errors occurred
- Understand context changes over time

### Monitor Context Store Changes

Track context store updates to:
- Verify variables are stored correctly
- Check variable values at each step
- Identify when variables are cleared or overwritten
- Debug dynamic value resolution issues

### Review Error Messages

Error messages typically include:
- Error type and description
- State where error occurred
- Relevant context information
- Stack trace for debugging

---

## Validation Process

Workflows undergo three-stage validation:

### Stage 1: YAML Format Validation

- Checks for valid YAML syntax
- Detects indentation errors
- Identifies malformed structures
- Validates string formatting

### Stage 2: Schema Validation

- Validates against JSON schema
- Ensures required fields are present
- Checks field types and formats
- Validates allowed values and enums

### Stage 3: Cross-Reference Validation

- Verifies all assistant_id references exist
- Checks all tool_id references are defined
- Validates state_id references in transitions
- Ensures no circular dependencies
- Confirms resource availability (assistants, tools, datasources)

---

## Common Error Messages

### "Invalid YAML format was provided"

**Fix**: Check YAML syntax:
- Use consistent indentation (2 spaces)
- Quote strings with special characters
- Close all brackets and quotes
- Validate YAML online before uploading

### "assistant_id references undefined assistant"

**Fix**: Ensure assistant is defined:
```yaml
assistants:
  - id: my-assistant  # Define first
    model: gpt-4.1

states:
  - id: state-1
    assistant_id: my-assistant  # Then reference
```

### "Workflow can't be created because resources don't exist"

**Fix**: Create required resources first:
- Create assistants before referencing them
- Index datasources before using datasource_ids
- Configure integrations before using integration_alias

### "State execution failed: KeyError 'variable_name'"

**Fix**: Store variable before accessing:
```yaml
states:
  - id: producer
    next:
      output_key: my_var
      store_in_context: true  # Store first

  - id: consumer
    task: "Use {{my_var}}"    # Access after storage
```

---

## Need More Help?

If you continue experiencing issues:

1. **Review the Documentation**:
   - [Introduction & Getting Started](./41-workflows-overview) for basic concepts
   - [Configuration Reference](./42-create-workflow) for detailed configuration options
   - [Complete Examples](./411-complete-examples) for working examples

2. **Check Workflow Logs**:
   - Execution state history
   - Error messages and stack traces
   - Tool execution results

3. **Validate Your YAML**:
   - Use online YAML validators
   - Check indentation and syntax
   - Verify all IDs are defined

4. **Simplify and Test**:
   - Start with a minimal workflow
   - Add complexity incrementally
   - Test each addition before proceeding

5. **Review Best Practices**:
   - [Best Practices](./48-llmmodel-name-in-workflow) for recommendations
   - Common patterns and anti-patterns
   - Performance optimization tips

---
