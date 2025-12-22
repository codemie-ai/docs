---
id: advanced-features
title: Advanced Features
sidebar_label: Advanced Features
sidebar_position: 7
---

# Advanced Features

## 7. Advanced Features

### 7.1 Map-Reduce Patterns

Map-reduce patterns enable processing arrays of items in parallel, with automatic fan-out and fan-in orchestration. This pattern is essential for scalable workflows.

**Key Capabilities:**

- **Processing arrays of items**: Automatically split collections into individual items
- **Parallel execution across items**: Each item is processed concurrently
- **Aggregating results**: Results from parallel branches are merged after completion
- **Iteration counters and tracking**: Built-in tracking of iteration progress

**Example: Process Multiple Files Workflow**

This workflow demonstrates the map-reduce pattern for processing multiple files concurrently:

**States:**

1. **split-files**: Initial state where a splitter assistant parses a file list and outputs a structured array of file paths. The output uses JSON Pointer format with files at `/files` path.

2. **process-file**: Processing state that executes in parallel for each file. Uses the `iter_key: /files` configuration to extract the array and fan out. Each parallel instance receives one file as input and processes it independently.

3. **aggregate-results**: Aggregation state that combines all processed results. This state executes only after all parallel processing completes, receiving merged context and message history from all parallel branches.

**Execution Pattern:**

- State 1 outputs N files
- N parallel instances of state 2 execute simultaneously
- State 3 waits for all N instances to complete
- Final aggregated result is produced

---

**Complete YAML Configuration:**

```yaml
enable_summarization_node: false
recursion_limit: 100
max_concurrency: 10

assistants:
  - id: file-splitter
    model: gpt-4.1
    temperature: 0.3
    system_prompt: |
      You are a file organization assistant. Parse file lists and output structured JSON.
      Always return JSON in this format:
      {
        "files": ["file1.txt", "file2.txt", ...]
      }
    mcp_servers:
      - name: mcp-server-filesystem
        description: Filesystem operations for reading directory listings
        config:
          command: npx
          args:
            - '-y'
            - '@modelcontextprotocol/server-filesystem'
            - '/workspace'

  - id: file-processor
    model: gpt-4.1
    temperature: 0.3
    system_prompt: |
      You are a file analysis assistant. Analyze files and extract key information.
      Return JSON with this structure:
      {
        "file_name": "filename",
        "lines_of_code": 123,
        "complexity": "Medium",
        "issues_found": 5,
        "summary": "brief description"
      }
    mcp_servers:
      - name: mcp-server-filesystem
        description: Filesystem operations for reading files
        config:
          command: npx
          args:
            - '-y'
            - '@modelcontextprotocol/server-filesystem'
            - '/workspace'

  - id: results-aggregator
    model: gpt-4.1-mini
    temperature: 0.5
    system_prompt: |
      You are a results aggregator. Combine analysis results from multiple files into a comprehensive summary.

      Provide:
      - Total files processed
      - Aggregate statistics (total lines, average complexity)
      - Top issues across all files
      - Overall recommendations

states:
  - id: split-files
    assistant_id: file-splitter
    task: |
      List all files in the directory: {{directory_path}}

      Return a JSON object with "files" array containing all file paths found.
    next:
      state_id: process-file
      iter_key: files
      store_in_context: true

  - id: process-file
    assistant_id: file-processor
    task: |
      Analyze the file: {{task}}

      Examine:
      1. Lines of code
      2. Code complexity
      3. Potential issues or improvements
      4. Brief summary of purpose

      Return structured JSON with analysis results.
    next:
      state_id: aggregate-results
      store_in_context: true
      include_in_llm_history: true

  - id: aggregate-results
    assistant_id: results-aggregator
    task: |
      Review all file analysis results and create a comprehensive summary report.

      Include:
      - Total files analyzed
      - Aggregate metrics (total LOC, average complexity)
      - Most common issues found
      - Files requiring immediate attention
      - Overall codebase health assessment
    next:
      state_id: end
```

**Usage:**

```json
{
  "directory_path": "/workspace/src"
}
```

**Key Features Demonstrated:**

- **Map-reduce pattern** with `iter_key: files` for automatic fan-out
- **Parallel processing** of multiple files (controlled by `max_concurrency: 10`)
- **Context isolation** during iteration (each file processed independently)
- **Automatic aggregation** when all parallel branches complete
- **MCP filesystem integration** for file operations
- **Structured JSON output** for reliable parsing and context population

---

### 7.2 Memory Management

Memory management ensures workflows can handle long conversations and complex multi-step processes without exceeding context limits. CodeMie Workflows provides automatic summarization and manual cleanup strategies.

#### How Automatic Summarization Works

When message count or token count exceeds configured limits, the workflow automatically:

1. **Detects limit breach**: Monitors `messages_limit_before_summarization` and `tokens_limit_before_summarization`
2. **Pauses execution**: Workflow pauses before executing the next state
3. **Triggers summarization**: A specialized summarization assistant analyzes the conversation history
4. **Condenses history**: The full message history is condensed into a concise summary (typically 1-3 messages)
5. **Replaces history**: Original messages are replaced with the summary
6. **Resumes execution**: Workflow continues with reduced context size

**Configuration** (from Section 3.2):

```yaml
enable_summarization_node: true # Enable automatic summarization
messages_limit_before_summarization: 25 # Trigger after 25 messages
tokens_limit_before_summarization: 50000 # Or after 50K tokens (whichever comes first)
```

#### Memory Management Examples

**Example 1: Long Research Workflow with Automatic Summarization**

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 15 # Aggressive summarization
tokens_limit_before_summarization: 25000
recursion_limit: 100

assistants:
  - id: researcher
    model: gpt-4.1
    system_prompt: |
      You are a research assistant. Conduct thorough investigations and maintain context across multiple steps.

states:
  - id: gather-sources
    assistant_id: researcher
    task: 'Gather sources about {{topic}}'
    # Messages: 1-2 (user input + response)
    next:
      state_id: analyze-source-1

  - id: analyze-source-1
    assistant_id: researcher
    task: 'Analyze the first source in detail'
    # Messages: 3-4
    next:
      state_id: analyze-source-2

  - id: analyze-source-2
    assistant_id: researcher
    task: 'Analyze the second source'
    # Messages: 5-6
    next:
      state_id: analyze-source-3

  # ... continues for multiple sources ...

  - id: analyze-source-7
    assistant_id: researcher
    task: 'Analyze the seventh source'
    # Messages: 15-16 → SUMMARIZATION TRIGGERED
    # Before this state executes:
    # 1. Workflow pauses
    # 2. Previous 15 messages are summarized into 2-3 messages
    # 3. Summary captures: key findings, important facts, analysis patterns
    # 4. Workflow resumes with condensed history
    next:
      state_id: synthesize-findings

  - id: synthesize-findings
    assistant_id: researcher
    task: 'Synthesize all findings into a comprehensive report'
    # Works with summarized history
    # Still has access to all important information
    # But with ~80% fewer tokens
    next:
      state_id: end
```

**Example Summarization Output:**

```
Original messages (15 total, ~20,000 tokens):
- User: "Research quantum computing applications"
- Assistant: [500-word analysis of Source 1]
- Assistant: [600-word analysis of Source 2]
- Assistant: [700-word analysis of Source 3]
... (12 more messages)

After summarization (2-3 messages, ~4,000 tokens):
- Summary: "Research topic: Quantum computing applications
  Key findings:
  - Source 1-3: Focus on cryptography, optimization, simulation
  - Identified 7 primary application areas
  - Notable companies: IBM, Google, Microsoft
  - Technical challenges: error correction, qubit stability
  - Commercial timeline: 3-5 years for specific applications"
```

**Example 2: Disabling Summarization for Short Workflows**

```yaml
enable_summarization_node: false # Disable summarization
recursion_limit: 20
max_concurrency: 5

assistants:
  - id: simple-processor
    model: gpt-4.1-mini
    system_prompt: Process tasks quickly

states:
  - id: step-1
    assistant_id: simple-processor
    task: 'Task 1'
    next:
      state_id: step-2

  - id: step-2
    assistant_id: simple-processor
    task: 'Task 2'
    next:
      state_id: step-3

  # Only 5-6 total messages, summarization not needed
  # Saves processing time and maintains full message history
# Use when:
# - Total workflow has < 10-15 messages
# - Full conversation history is important
# - Performance is critical
```

**Example 3: Manual Memory Cleanup with Context Control**

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 30
tokens_limit_before_summarization: 60000

assistants:
  - id: processor
    model: gpt-4.1
    system_prompt: Process data in phases

states:
  # Phase 1: Data Collection (messages 1-10)
  - id: collect-data-source-1
    assistant_id: processor
    task: 'Collect data from source 1'
    next:
      state_id: collect-data-source-2

  - id: collect-data-source-2
    assistant_id: processor
    task: 'Collect data from source 2'
    next:
      state_id: summarize-collection
      store_in_context: true

  - id: summarize-collection
    assistant_id: processor
    task: 'Summarize all collected data into key metrics'
    next:
      state_id: start-analysis
      clear_prior_messages: true # Manual cleanup: clear Phase 1 messages
      # Phase 1 messages are removed from history
      # But summarize-collection output is in context store
      # Phase 2 starts fresh with only essential data

  # Phase 2: Analysis (starts with clean slate)
  - id: start-analysis
    assistant_id: processor
    task: 'Analyze the data summary: {{task}}'
    # LLM sees:
    # - Only data summary (from context)
    # - No Phase 1 conversation history
    # - Reduced token usage
    next:
      state_id: end
```

**Example 4: Balancing Automatic and Manual Cleanup**

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 20
tokens_limit_before_summarization: 40000

assistants:
  - id: multi-phase-processor
    model: gpt-4.1
    system_prompt: Process complex multi-phase workflows

states:
  # Phase 1: Data Gathering (heavy conversation)
  - id: gather-phase
    assistant_id: multi-phase-processor
    task: 'Gather all required data'
    next:
      state_id: process-phase

  # ... 15 states of data gathering ...

  # Phase 2: Processing
  - id: process-phase
    assistant_id: multi-phase-processor
    task: 'Process the gathered data'
    # Automatic summarization may have triggered during Phase 1
    # If messages > 20 or tokens > 40K
    next:
      state_id: transition-to-reporting
      reset_keys_in_context_store:
        - temp_data
        - intermediate_results
        - debug_info
      # Remove temporary context keys
      # Keep only essential data for reporting

  # Phase 3: Reporting (clean start)
  - id: transition-to-reporting
    assistant_id: multi-phase-processor
    task: 'Prepare for reporting phase'
    next:
      state_id: generate-report
      clear_prior_messages: true # Manual cleanup
      # Fresh start for reporting with only essential context

  - id: generate-report
    assistant_id: multi-phase-processor
    task: 'Generate final report using {{essential_data}}'
    # Minimal context: only report-relevant data
    # Optimal token usage
    next:
      state_id: end
```

#### Memory Management Strategies

**Strategy 1: Aggressive Summarization (Token Optimization)**

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 10
tokens_limit_before_summarization: 20000
# Use for: Cost-sensitive workflows, simple task chains
# Trade-off: May lose some conversation nuance
```

**Strategy 2: Conservative Summarization (Context Preservation)**

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 50
tokens_limit_before_summarization: 100000
# Use for: Complex reasoning tasks, research workflows
# Trade-off: Higher token costs
```

**Strategy 3: Phase-Based Manual Cleanup**

```yaml
enable_summarization_node: false
# Use clear_prior_messages: true between major workflow phases
# Use reset_keys_in_context_store to remove temporary data
# Use for: Workflows with distinct phases, maximum control
```

**Strategy 4: Hybrid Approach**

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 25
tokens_limit_before_summarization: 50000
# + Manual cleanup at phase transitions
# + Selective context key removal
# Use for: Production workflows, balanced approach
```

#### Best Practices for Memory Management

1. **Enable summarization for workflows with > 20 states**
2. **Use manual cleanup (`clear_prior_messages`) between distinct workflow phases**
3. **Remove temporary context keys with `reset_keys_in_context_store`**
4. **Monitor token usage in logs to optimize limits**
5. **Test summarization behavior with representative workflows**
6. **Store only essential data in context between phases**

### 7.3 Retry Policies

```yaml
retry_policy:
  max_attempts: 3
  initial_interval: 1.0
  backoff_factor: 2.0
  max_interval: 60.0
```

#### Retry Configuration:

- **max_attempts**: Maximum retry attempts
- **initial_interval**: Initial wait time in seconds
- **backoff_factor**: Exponential backoff multiplier
- **max_interval**: Maximum wait time between retries

#### Automatic Retry Conditions:

- Network errors (5xx status codes)
- Timeout errors
- Rate limiting errors
- Excludes: Authentication errors (401, 403, 404)

#### Per-State Retry Override:

```yaml
states:
  - id: critical-state
    assistant_id: assistant-1
    task: Critical operation
    retry_policy:
      max_attempts: 5
    next:
      state_id: next-state
```

### 7.4 Workflow Interruption

Workflow interruption enables human-in-the-loop workflows by pausing execution before critical states, allowing users to review progress, approve changes, or provide additional input before the workflow continues.

#### How Workflow Interruption Works

When `interrupt_before: true` is set on a state:

1. **Workflow pauses**: Execution stops BEFORE the state runs
2. **User notification**: User is notified that approval is needed
3. **Review interface**: User can review all previous conversation history and context
4. **User decision**: User can:
   - **Continue**: Resume workflow and execute the interrupted state
   - **Cancel**: Stop workflow execution
   - **Modify (if supported)**: Provide additional input
5. **Resume execution**: Workflow continues from the interrupted state

#### Workflow Interruption Examples

**Example 1: Approval Gate for Critical Operations**

```yaml
enable_summarization_node: false
recursion_limit: 20

assistants:
  - id: deployment-planner
    model: gpt-4.1
    system_prompt: |
      You are a deployment specialist. Plan and execute deployments safely.
    tools:
      - name: aws_ecs_deploy
        integration_alias: aws-prod

states:
  - id: analyze-deployment
    assistant_id: deployment-planner
    task: |
      Analyze the proposed deployment for service {{service_name}}.

      Review:
      - Container image: {{image_tag}}
      - Environment: production
      - Current version: {{current_version}}
      - Rollback plan availability

      Provide a deployment plan with risk assessment.
    next:
      state_id: await-approval

  - id: await-approval
    assistant_id: deployment-planner
    interrupt_before: true # PAUSE HERE - await user approval
    task: |
      Execute the deployment plan.

      Proceeding with deployment to production:
      - Service: {{service_name}}
      - Image: {{image_tag}}
      - Strategy: Rolling update

      This will affect live production traffic.
    # Workflow pauses here
    # User reviews:
    # - Full deployment plan from previous state
    # - Risk assessment
    # - All context and parameters
    # User must click "Continue" to proceed
    next:
      state_id: execute-deployment

  - id: execute-deployment
    assistant_id: deployment-planner
    task: |
      Deploy the service to production.
      Monitor the deployment and report status.
    next:
      state_id: verify-deployment

  - id: verify-deployment
    assistant_id: deployment-planner
    task: 'Verify deployment health and report results'
    next:
      state_id: end
```

**Example 2: Multi-Stage Approval Workflow**

```yaml
assistants:
  - id: data-processor
    model: gpt-4.1
    system_prompt: Process sensitive data with multiple checkpoints

states:
  - id: analyze-data
    assistant_id: data-processor
    task: 'Analyze the data quality: {{data_source}}'
    next:
      state_id: checkpoint-1

  - id: checkpoint-1
    assistant_id: data-processor
    interrupt_before: true # First approval gate
    task: 'Proceed with data transformation based on analysis?'
    # User reviews analysis results
    next:
      state_id: transform-data

  - id: transform-data
    assistant_id: data-processor
    task: 'Transform the data according to requirements'
    next:
      state_id: checkpoint-2

  - id: checkpoint-2
    assistant_id: data-processor
    interrupt_before: true # Second approval gate
    task: 'Apply transformed data to production database?'
    # User reviews transformation results
    next:
      state_id: apply-to-production

  - id: apply-to-production
    assistant_id: data-processor
    task: 'Apply data to production'
    next:
      state_id: end
```

**Example 3: Conditional Interruption Pattern**

```yaml
assistants:
  - id: change-analyzer
    model: gpt-4.1
    system_prompt: |
      Analyze changes and determine if they require approval.
      Output JSON with "requires_approval" boolean.

states:
  - id: analyze-changes
    assistant_id: change-analyzer
    task: |
      Analyze the proposed changes: {{changes}}

      Determine if changes are:
      - Low risk (auto-approve): Config changes, documentation
      - High risk (require approval): Database schemas, API contracts

      Return: {"requires_approval": true/false, "risk_level": "low/high", "reason": "..."}
    output_schema: |
      {
        "type": "object",
        "properties": {
          "requires_approval": {"type": "boolean"},
          "risk_level": {"type": "string"},
          "reason": {"type": "string"}
        },
        "required": ["requires_approval", "risk_level"]
      }
    next:
      condition:
        expression: 'requires_approval == true'
        then: manual-approval
        otherwise: auto-apply

  - id: manual-approval
    assistant_id: change-analyzer
    interrupt_before: true # Only interrupts for high-risk changes
    task: |
      Apply high-risk changes:
      {{changes}}

      Risk level: {{risk_level}}
      Reason: {{reason}}
    next:
      state_id: apply-changes

  - id: auto-apply
    assistant_id: change-analyzer
    task: 'Automatically apply low-risk changes: {{changes}}'
    next:
      state_id: end

  - id: apply-changes
    assistant_id: change-analyzer
    task: 'Apply approved high-risk changes'
    next:
      state_id: end
```

**Example 4: Approval with Context Review**

```yaml
assistants:
  - id: report-generator
    model: gpt-4.1
    system_prompt: Generate comprehensive reports

states:
  - id: gather-metrics
    assistant_id: report-generator
    task: 'Gather all metrics for Q{{quarter}} report'
    # Output: {"revenue": 1000000, "expenses": 750000, "profit": 250000}
    next:
      state_id: analyze-trends

  - id: analyze-trends
    assistant_id: report-generator
    task: |
      Analyze trends based on metrics:
      - Revenue: ${{revenue}}
      - Expenses: ${{expenses}}
      - Profit: ${{profit}}

      Identify key insights and recommendations.
    next:
      state_id: review-before-sending

  - id: review-before-sending
    assistant_id: report-generator
    interrupt_before: true
    task: |
      Send the quarterly report to stakeholders:

      ## Financial Summary Q{{quarter}}
      - Revenue: ${{revenue}}
      - Expenses: ${{expenses}}
      - Net Profit: ${{profit}}

      ## Analysis
      {{task}}

      Recipients: CEO, CFO, Board Members

      Confirm to send this report.
    # User sees:
    # - All gathered metrics
    # - Complete analysis
    # - Full context from previous states
    # - Can verify accuracy before sending
    next:
      state_id: send-report

  - id: send-report
    assistant_id: report-generator
    task: 'Send the approved report via email'
    next:
      state_id: end
```

**Example 5: Interruption with User Input Integration**

```yaml
assistants:
  - id: interactive-planner
    model: gpt-4.1
    system_prompt: Create plans with user feedback integration

states:
  - id: create-initial-plan
    assistant_id: interactive-planner
    task: 'Create an initial project plan for {{project_name}}'
    next:
      state_id: review-plan

  - id: review-plan
    assistant_id: interactive-planner
    interrupt_before: true
    task: |
      The initial plan has been created.

      When you continue, you can optionally provide feedback or modifications.
      The plan will be refined based on your input.
    # User can:
    # 1. Simply continue (no changes)
    # 2. Provide feedback in the UI
    # Feedback becomes part of conversation history
    next:
      state_id: refine-plan

  - id: refine-plan
    assistant_id: interactive-planner
    task: |
      Refine the project plan based on any feedback provided.

      Original plan: {{task}}
      User feedback (if any): Available in conversation history

      Generate final plan incorporating feedback.
    next:
      state_id: end
```

#### Best Practices for Workflow Interruption

1. **Use for high-risk operations**: Deployments, data modifications, external communications
2. **Provide context in task description**: Clearly explain what will happen after approval
3. **Place interruption after analysis, before action**: Let AI analyze, human approve, AI execute
4. **Combine with conditional logic**: Only interrupt when necessary (high-risk changes)
5. **Keep interruption count reasonable**: Too many approvals slow down workflows
6. **Document what user should review**: Clear instructions in the task description

#### When to Use Workflow Interruption

**Use interruption for:**

- Production deployments
- Database migrations
- Sending external communications (emails, notifications)
- Financial transactions
- Permanent data modifications
- API changes affecting customers
- Security-sensitive operations

**Do NOT use interruption for:**

- Read-only operations
- Development/testing workflows
- Automated monitoring workflows
- Low-risk data analysis
- Frequent batch processing

### 7.5 Structured Output

```yaml
states:
  - id: extract-data
    assistant_id: extractor
    task: Extract structured information
    output_schema: |
      {
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "age": {"type": "number"},
          "email": {"type": "string", "format": "email"}
        },
        "required": ["name", "email"]
      }
    next:
      state_id: process-data
```

Enforce JSON schema validation on assistant output.

### 7.6 Performance Tuning

Performance tuning optimizes workflow execution speed, resource usage, and reliability. Proper tuning ensures workflows run efficiently without exceeding system limits or causing timeouts.

#### Key Performance Settings

From Section 3.2, two main settings control performance:

- **recursion_limit**: Maximum workflow execution steps (default: 50)
- **max_concurrency**: Maximum concurrent parallel state executions

#### Performance Tuning Examples

**Example 1: High-Performance Batch Processing**

```yaml
# Optimized for maximum throughput
enable_summarization_node: false # Skip summarization overhead
recursion_limit: 500 # Allow deep iteration
max_concurrency: 100 # Maximum parallelism
messages_limit_before_summarization: 1000 # Not used

assistants:
  - id: fast-processor
    model: gpt-4.1-mini # Fast, cheap model
    temperature: 0.3 # Lower temp = faster inference
    limit_tool_output_tokens: 3000 # Limit tool outputs
    exclude_extra_context_tools: true # Reduce tool selection overhead
    system_prompt: Process items quickly and concisely

states:
  - id: generate-batch
    assistant_id: fast-processor
    task: 'Return 1000 items to process'
    next:
      state_id: process-item
      iter_key: .
      include_in_llm_history: false # Don't bloat history

  - id: process-item
    assistant_id: fast-processor
    task: 'Process {{task}}'
    # 100 items execute concurrently
    # Each iteration uses minimal tokens
    # Fast turnaround
    next:
      state_id: end
      store_in_context: false # Don't store individual results
      include_in_llm_history: false # Skip history

# Performance characteristics:
# - 1000 items processed in ~10 batches of 100
# - Minimal token usage per item
# - No summarization overhead
# - Fast model for quick responses
# - Total time: ~5-10 minutes for 1000 items
```

**Example 2: Balanced Production Workflow**

```yaml
# Production-ready balanced settings
enable_summarization_node: true
recursion_limit: 75
max_concurrency: 15
messages_limit_before_summarization: 25
tokens_limit_before_summarization: 50000

assistants:
  - id: balanced-processor
    model: gpt-4.1
    temperature: 0.7
    limit_tool_output_tokens: 10000

states:
  - id: analyze-input
    assistant_id: balanced-processor
    task: 'Analyze {{input}}'
    next:
      state_id: process-parallel
      iter_key: items

  - id: process-parallel
    assistant_id: balanced-processor
    task: 'Process {{task}}'
    # Up to 15 items processed concurrently
    # Good balance of speed and resource usage
    next:
      state_id: aggregate

  - id: aggregate
    assistant_id: balanced-processor
    task: 'Aggregate all results'
    next:
      state_id: end
# Performance characteristics:
# - Moderate concurrency (15)
# - Automatic summarization prevents context overflow
# - Balanced token usage
# - Suitable for most production workflows
```

**Example 3: Resource-Constrained Environment**

```yaml
# Optimized for minimal resource usage
enable_summarization_node: true
recursion_limit: 20 # Conservative limit
max_concurrency: 3 # Low concurrency
messages_limit_before_summarization: 15 # Aggressive summarization
tokens_limit_before_summarization: 25000

assistants:
  - id: conservative-processor
    model: gpt-4.1-mini # Efficient model
    temperature: 0.5
    limit_tool_output_tokens: 5000 # Strict limits
    exclude_extra_context_tools: false

states:
  - id: process-items
    assistant_id: conservative-processor
    task: 'Process {{items}}'
    next:
      state_id: end
      clear_prior_messages: true # Clean up aggressively

# Use when:
# - Limited compute resources
# - Cost optimization is priority
# - Workflows have sequential dependencies
# - Lower throughput is acceptable
```

**Example 4: Deep Iteration Workflow**

```yaml
# Optimized for workflows with many sequential steps
enable_summarization_node: true
recursion_limit: 200 # High limit for deep chains
max_concurrency: 5 # Lower concurrency
messages_limit_before_summarization: 30
tokens_limit_before_summarization: 60000

assistants:
  - id: chain-processor
    model: gpt-4.1
    temperature: 0.7

states:
  - id: step-1
    assistant_id: chain-processor
    task: 'Step 1'
    next:
      state_id: step-2

  # ... many sequential steps ...

  - id: step-50
    assistant_id: chain-processor
    task: 'Step 50'
    # Automatic summarization keeps token count manageable
    # High recursion_limit allows completion
    next:
      state_id: end
# Performance characteristics:
# - Supports long sequential chains (up to 200 steps)
# - Summarization prevents context overflow
# - Lower concurrency reduces resource spikes
# - Each step builds on previous context
```

#### Performance Optimization Strategies

**Strategy 1: Optimize Model Selection**

```yaml
# Use fast models for simple tasks
assistants:
  - id: quick-classifier
    model: gpt-4.1-mini # 5-10x faster than gpt-4.1
    temperature: 0.3
    # For: Classification, simple extraction, batch processing

  - id: complex-analyzer
    model: gpt-4.1 # Use only when necessary
    temperature: 0.7
    # For: Complex reasoning, detailed analysis, code generation
```

**Strategy 2: Minimize Token Usage**

```yaml
states:
  - id: fetch-large-data
    tool_id: database-query
    next:
      state_id: process-data
      store_in_context: false # Don't store large data
      include_in_llm_history: false # Don't send to LLM

  - id: process-data
    assistant_id: processor
    task: 'Process the data (available via tool)'
    # LLM uses tools to access data, not from history
```

**Strategy 3: Control Concurrency Based on Resources**

```yaml
# Calculate appropriate max_concurrency:

# Available CPU cores: 16
# Memory per task: 512MB
# Total memory: 8GB

# Safe max_concurrency = min(
#   CPU cores * 2 = 32,
#   Total memory / Memory per task = 16
# ) = 16

max_concurrency: 16 # Optimal for this system
```

**Strategy 4: Use Selective History**

```yaml
states:
  - id: preprocessing
    assistant_id: processor
    task: 'Preprocess data'
    next:
      state_id: main-processing
      clear_prior_messages: true # Remove preprocessing from history
      # Main processing doesn't need preprocessing details

  - id: main-processing
    assistant_id: processor
    task: 'Process using {{preprocessed_data}}'
    # Faster: smaller context window
```

#### Performance Tuning Guidelines

**Choosing `recursion_limit`:**

| Workflow Type           | Recommended Limit | Rationale                       |
| ----------------------- | ----------------- | ------------------------------- |
| Simple (< 10 states)    | 20-30             | Catch infinite loops early      |
| Moderate (10-30 states) | 50-75             | Default, handles most workflows |
| Complex (30-100 states) | 100-200           | Deep sequential processing      |
| Iterative (map-reduce)  | 200-500           | Depends on item count           |

**Choosing `max_concurrency`:**

| Use Case                  | Recommended Value | Rationale               |
| ------------------------- | ----------------- | ----------------------- |
| Sequential workflow       | 1-3               | No parallelism needed   |
| Light parallel tasks      | 5-10              | Moderate resource usage |
| Standard batch processing | 10-20             | Balanced throughput     |
| High-volume processing    | 50-100            | Maximum throughput      |
| Resource-constrained      | 2-5               | Respect system limits   |

#### Monitoring and Optimization

**Key Metrics to Monitor:**

1. **Execution Time**: Total workflow duration
2. **Token Usage**: Track costs and context limits
3. **Concurrency Utilization**: Are all slots being used?
4. **Summarization Frequency**: Too often = aggressive limits
5. **Error Rate**: Timeouts, rate limits, failures

**Performance Testing Checklist:**

1. Test with representative data volumes
2. Monitor resource usage (CPU, memory)
3. Check for timeout errors
4. Verify summarization behavior
5. Measure end-to-end execution time
6. Test at peak concurrency
7. Review token usage and costs

**Common Performance Issues:**

| Issue                    | Symptom                      | Solution                                      |
| ------------------------ | ---------------------------- | --------------------------------------------- |
| Recursion limit exceeded | Workflow fails after N steps | Increase `recursion_limit` or reduce states   |
| Context overflow         | Out of memory errors         | Enable summarization, reduce `messages_limit` |
| Slow execution           | Workflow takes too long      | Increase `max_concurrency`, use faster models |
| High costs               | Excessive token usage        | Use gpt-4.1-mini, enable summarization        |
| Rate limiting            | 429 errors                   | Reduce `max_concurrency`, add retry policies  |

---
