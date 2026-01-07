---
id: configuration-reference
title: Configuration Reference
sidebar_label: Configuration Reference
sidebar_position: 3
---

# Configuration Reference

## 3. Workflow Configuration Reference

### 3.1 Assistants Configuration

```yaml
assistants:
  - id: assistant-1
    name: Optional Display Name
    assistant_id: existing-assistant-id  # OR define inline
    model: gpt-4.1-mini
    temperature: 0.7
    system_prompt: |
      Your custom instructions here
    tools:
      - name: tool-name
        integration_alias: optional-alias
    datasource_ids:
      - datasource-id-1
      - datasource-id-2
    mcp_servers:
      - {...}  # See Section 3.6 for MCP Server configuration
```

#### Assistant Types:

- **Reference existing assistant**: Use `assistant_id`
- **Inline definition**: Specify all properties directly

#### Assistant Properties:

- **id**: Unique identifier within workflow
- **assistant_id**: Reference to existing assistant (optional)
- **name**: Display name (optional)
- **model**: LLM model to use
- **temperature**: Response randomness (0.0-2.0)
- **system_prompt**: Custom instructions and context
- **tools**: List of tools the assistant can use
- **datasource_ids**: Data sources for knowledge base integration
- **limit_tool_output_tokens**: Maximum tokens from tool outputs (default: 10000)
- **exclude_extra_context_tools**: Disable automatic context tools
- **mcp_servers**: List of MCP server configurations (see Section 3.6)

#### Tool Configuration:

- **name**: Tool identifier
- **integration_alias**: Alias of a CodeMie Integration used to define credentials and/or environment variables for tool invocation

#### Advanced Assistant Examples:

**Example 1: Using `limit_tool_output_tokens`**

Limit tool output size to prevent context overflow when tools return large responses:

```yaml
assistants:
  - id: code-analyzer
    model: gpt-4.1
    system_prompt: |
      You are a code analysis assistant. Use filesystem tools to read and analyze code files.
    limit_tool_output_tokens: 5000  # Limit tool outputs to 5000 tokens
    mcp_servers:
      - name: mcp-server-filesystem
        description: Filesystem operations
        config:
          command: mcp-server-filesystem
          args:
            - "/workspace"

# Without limit_tool_output_tokens: Reading a 50KB file might consume 12,000+ tokens
# With limit_tool_output_tokens: 5000: Tool output is truncated to 5000 tokens max
# Use case: When processing large files where full content isn't needed
```

**Example 2: Using `exclude_extra_context_tools`**

Disable automatic context tools when you want precise control over available tools:

```yaml
assistants:
  - id: focused-assistant
    model: gpt-4.1-mini
    system_prompt: |
      You are a focused assistant with only specific tools available.
    exclude_extra_context_tools: true  # Disable automatic context/knowledge base tools
    tools:
      - name: specific-tool-1
      - name: specific-tool-2
    # Only the explicitly listed tools are available
    # No automatic knowledge base or context search tools

  - id: full-assistant
    model: gpt-4.1
    system_prompt: |
      You have access to all tools plus automatic context tools.
    exclude_extra_context_tools: false  # Default: enables automatic tools
    tools:
      - name: specific-tool-1
    datasource_ids:
      - datasource-1
    # Assistant gets: specific-tool-1 + automatic knowledge base search + context tools
```

**Use cases for `exclude_extra_context_tools: true`:**

- Performance-critical assistants where tool selection overhead matters
- Assistants that should NOT access knowledge bases
- Debugging scenarios where you need deterministic tool availability
- Workflows with token budget constraints

**Example 3: Complete Assistant with Integration Alias**

```yaml
assistants:
  - id: aws-deployment-assistant
    model: gpt-4.1
    temperature: 0.3
    system_prompt: |
      You are an AWS deployment specialist. Use AWS tools to manage infrastructure.
    tools:
      - name: aws_ec2_describe_instances
        integration_alias: aws-prod-account  # Credentials from integration
      - name: aws_s3_list_buckets
        integration_alias: aws-prod-account
    limit_tool_output_tokens: 8000  # Large AWS responses
    datasource_ids:
      - aws-documentation
      - deployment-runbooks

states:
  - id: check-infrastructure
    assistant_id: aws-deployment-assistant
    task: |
      List all EC2 instances in us-east-1 region and check their status.
      Identify any instances that need attention.
    next:
      state_id: end
```

### 3.2 Workflow-Level Settings

Configuration options that apply to the entire workflow execution:

```yaml
messages_limit_before_summarization: 25
tokens_limit_before_summarization: 50000
enable_summarization_node: true
recursion_limit: 50
max_concurrency: 10
```

#### Settings:

- **messages_limit_before_summarization**: Maximum messages before auto-summarization (default: 25)
- **tokens_limit_before_summarization**: Maximum tokens before auto-summarization (default: 50000)
- **enable_summarization_node**: Enable automatic result summarization (default: true)
- **recursion_limit**: Maximum workflow execution steps (default: 50)
- **max_concurrency**: Maximum concurrent parallel state executions

#### Workflow-Level Settings Examples:

**Example 1: High-Concurrency Batch Processing**

```yaml
# Optimized for processing many items in parallel
enable_summarization_node: false  # Disable for better performance
recursion_limit: 200              # Allow deep iteration chains
max_concurrency: 50               # Process up to 50 items simultaneously
messages_limit_before_summarization: 100  # Not used (summarization disabled)

assistants:
  - id: batch-processor
    model: gpt-4.1-mini  # Fast, cost-effective model
    system_prompt: Process items quickly

states:
  - id: split-batch
    assistant_id: batch-processor
    task: "Return list of 100 items to process"
    # Output: ["item1", "item2", ..., "item100"]
    next:
      state_id: process-item
      iter_key: .

  - id: process-item
    assistant_id: batch-processor
    task: "Process {{task}}"
    # 50 items execute concurrently at a time
    # Next batch of 50 starts as previous items complete
    next:
      state_id: end
```

**Example 2: Long Conversation Workflow with Summarization**

```yaml
# Optimized for multi-step workflows with conversation history
enable_summarization_node: true
messages_limit_before_summarization: 20   # Summarize after 20 messages
tokens_limit_before_summarization: 30000  # Or when reaching 30K tokens
recursion_limit: 100
max_concurrency: 5

assistants:
  - id: research-assistant
    model: gpt-4.1
    system_prompt: Research and analyze topics deeply

states:
  - id: gather-info
    assistant_id: research-assistant
    task: "Gather information about {{topic}}"
    # Messages: 1-20
    next:
      state_id: analyze-step-1

  - id: analyze-step-1
    assistant_id: research-assistant
    task: "Analyze gathered information"
    # Messages: 21 → triggers summarization
    # Previous 20 messages are summarized into 1-2 messages
    # Context preserved, tokens reduced
    next:
      state_id: analyze-step-2

  # Workflow continues with summarized history
```

**Example 3: Resource-Constrained Workflow**

```yaml
# Minimal resource usage for simple workflows
enable_summarization_node: false  # Not needed for short workflows
recursion_limit: 10               # Prevent runaway execution
max_concurrency: 1                # Sequential processing only
messages_limit_before_summarization: 25  # Default (not used)

assistants:
  - id: simple-assistant
    model: gpt-4.1-mini
    system_prompt: Handle simple tasks

states:
  - id: step-1
    assistant_id: simple-assistant
    task: "Task 1"
    next:
      state_id: step-2

  - id: step-2
    assistant_id: simple-assistant
    task: "Task 2"
    next:
      state_id: end
```

**Example 4: Balanced Production Workflow**

```yaml
# Recommended settings for most production workflows
enable_summarization_node: true
messages_limit_before_summarization: 25
tokens_limit_before_summarization: 50000
recursion_limit: 50
max_concurrency: 10

# Use case: General-purpose workflows with moderate complexity
# - Automatic summarization prevents context overflow
# - Reasonable concurrency for parallel processing
# - Recursion limit catches infinite loops
```

**Choosing the Right Settings:**

| Setting           | Low Value   | High Value | Use Case                                             |
| ----------------- | ----------- | ---------- | ---------------------------------------------------- |
| `max_concurrency` | 1-5         | 20-100     | Low: Sequential logic; High: Batch processing        |
| `recursion_limit` | 10-20       | 100-500    | Low: Simple workflows; High: Deep iterations         |
| `messages_limit`  | 10-15       | 50-100     | Low: Aggressive summarization; High: Preserve detail |
| `tokens_limit`    | 20000-30000 | 100000+    | Low: Cost optimization; High: Maximum context        |

### 3.3 Tools Configuration

```yaml
tools:
  - id: tool-1
    tool: tool-method-name
    tool_args:
      param1: value1
      param2: "{{dynamic_value}}"
    integration_alias: optional-alias
    tool_result_json_pointer: /path/to/result
    trace: false
    resolve_dynamic_values_in_response: false
    mcp_server: {...}  # See Section 3.6 for MCP Server configuration
```

#### Tool Properties:

- **id**: Unique identifier for the tool
- **tool**: Tool method name from toolkit
- **tool_args**: Arguments to pass to the tool
- **integration_alias**: Alias of a CodeMie Integration used to define credentials and/or environment variables for tool invocation
- **tool_result_json_pointer**: Extract specific result node using JSON Pointer
- **trace**: Enable detailed logging
- **resolve_dynamic_values_in_response**: Process template variables in tool output
- **mcp_server**: MCP server configuration for MCP tools (see Section 3.6)

#### Advanced Tools Examples:

**Example 1: Using `tool_result_json_pointer`**

Extract specific data from nested tool responses:

```yaml
tools:
  - id: fetch-api-data
    tool: http_request
    tool_args:
      url: "https://api.example.com/users"
      method: GET
    tool_result_json_pointer: /data/users
    # API returns: {"status": "success", "data": {"users": [...], "count": 10}, "timestamp": "..."}
    # JSON Pointer extracts: /data/users → only the users array
    # Context stores: users array directly (not the full response)

states:
  - id: get-users
    tool_id: fetch-api-data
    # Result is now just the users array: [{"id": 1, "name": "Alice"}, ...]
    next:
      state_id: process-users
      iter_key: .  # Iterate over the extracted users array
```

**Example 2: Using `trace` for Debugging**

Enable detailed tool execution logging:

```yaml
tools:
  - id: database-query
    tool: postgres_query
    tool_args:
      query: "SELECT * FROM users WHERE status = $1"
      params: ["active"]
    integration_alias: postgres-prod
    trace: true  # Enables detailed execution logs
    # Logs include:
    # - Tool execution start time
    # - Input arguments
    # - Raw tool output
    # - Execution duration
    # - Any errors or warnings

states:
  - id: debug-query
    tool_id: database-query
    # Check logs for detailed tool execution information
    next:
      state_id: process-results
```

**Example 3: Using `resolve_dynamic_values_in_response`**

Process template variables in tool outputs:

```yaml
tools:
  - id: generate-template
    tool: template_generator
    tool_args:
      template_name: "welcome_email"
    resolve_dynamic_values_in_response: true
    # Tool returns: "Welcome {{user_name}}! Your account {{account_id}} is ready."
    # With resolve=true: Template variables are processed using context store
    # If context has user_name="Alice", account_id="12345":
    # Final result: "Welcome Alice! Your account 12345 is ready."

states:
  - id: create-email
    tool_id: generate-template
    # Context populated from previous state with user_name and account_id
    next:
      state_id: send-email
```

**Example 4: Complete Tool with MCP Server**

```yaml
tools:
  - id: read-code-file
    tool: read_file
    tool_args:
      path: "{{file_path}}"  # Dynamic path from context
    tool_result_json_pointer: /content  # Extract only file content
    trace: false  # Disable for performance
    resolve_dynamic_values_in_response: false
    mcp_server:
      name: mcp-server-filesystem
      description: Filesystem access
      config:
        command: npx
        args:
          - "-y"
          - "@modelcontextprotocol/server-filesystem"
          - "/workspace"

states:
  - id: analyze-file
    tool_id: read-code-file
    tool_args:
      path: "/workspace/src/main.py"  # Override default path
    # Tool reads file, extracts content using JSON Pointer
    # Result stored in context for next state
    next:
      state_id: process-content
```

**Example 5: Tool with Integration Alias**

```yaml
tools:
  - id: deploy-to-aws
    tool: aws_ecs_deploy_service
    tool_args:
      cluster: "production-cluster"
      service: "{{service_name}}"
      task_definition: "{{task_def_arn}}"
    integration_alias: aws-prod-account  # Injects AWS credentials
    trace: true  # Log deployment details
    tool_result_json_pointer: /deployment/status

# Integration 'aws-prod-account' provides:
# - AWS_ACCESS_KEY_ID
# - AWS_SECRET_ACCESS_KEY
# - AWS_REGION
# Tool automatically uses these credentials

states:
  - id: deploy-service
    tool_id: deploy-to-aws
    # Credentials injected automatically from integration
    next:
      state_id: verify-deployment
```

**Example 6: Combining Multiple Advanced Features**

```yaml
tools:
  - id: complex-api-call
    tool: http_request
    tool_args:
      url: "https://api.example.com/data"
      method: POST
      headers:
        Authorization: "Bearer {{api_token}}"
      body:
        query: "{{search_query}}"
    integration_alias: api-credentials  # Provides api_token
    tool_result_json_pointer: /results/items  # Extract specific data
    trace: true  # Enable debugging
    resolve_dynamic_values_in_response: true  # Process templates in response
    # Complete tool with all advanced features:
    # 1. Dynamic args from context (search_query)
    # 2. Credentials from integration (api_token)
    # 3. JSON Pointer extraction
    # 4. Detailed logging
    # 5. Template resolution in response

states:
  - id: call-api
    tool_id: complex-api-call
    next:
      state_id: process-results
```

### 3.4 States Configuration

The `states` section defines the workflow steps and their execution order.

```yaml
states:
  - id: state-1
    assistant_id: assistant-1  # OR tool_id OR custom_node_id
    task: Task instructions
    next:
      state_id: state-2
```

(See Section 4 for detailed state configuration)

### 3.5 Custom Nodes Configuration

```yaml
custom_nodes:
  - id: node-1
    custom_node_id: state_processor_node
    name: Optional Display Name
    model: gpt-4.1-mini
    system_prompt: |
      Custom instructions
    config:
      state_id: optional-filter
      output_template: |
        Jinja2 template
```

#### Custom Node Types:

- **state_processor_node**: Process and aggregate state outputs
- **bedrock_flow_node**: AWS Bedrock Flows integration
- **generate_documents_tree**: Generate document tree structure
- Additional custom implementations

#### Common Properties:

- **id**: Unique identifier
- **custom_node_id**: Node type identifier
- **name**: Display name
- **model**: LLM model for processing
- **system_prompt**: Custom instructions
- **config**: Node-specific configuration

### 3.6 MCP Server Configuration

MCP (Model Context Protocol) servers provide tools and capabilities to assistants. They can be configured in two ways: using the `config` object for command-based servers, or using top-level fields for backward compatibility.

#### Configuration Method 1: Using `config` Object (Recommended)

```yaml
mcp_servers:
  - name: filesystem
    description: Filesystem operations server
    config:
      command: npx
      args:
        - -y
        - "@modelcontextprotocol/server-filesystem"
        - /allowed/directory
      env:
        VAR_NAME: value
      # type is not needed when using stdio transport
      single_usage: false
    tools_tokens_size_limit: 10000
    integration_alias: optional-alias
    resolve_dynamic_values_in_arguments: false
```

#### Configuration Method 2: HTTP/URL-Based Server

```yaml
mcp_servers:
  - name: remote-server
    description: Remote HTTP MCP server
    config:
      url: https://mcp-server.example.com
      headers:
        Authorization: "Bearer {{auth_token}}"
        X-Custom-Header: value
      type: streamable-http # for legacy SSE transport simply skip type
      single_usage: false
    mcp_connect_url: https://mcp-connect.example.com
```

#### MCP Server Properties:

**Top-Level Fields:**

- **name**: Server identifier (required)
- **description**: Human-readable description (optional)
- **config**: Server configuration object (recommended, see below)
- **tools_tokens_size_limit**: Maximum tokens for tool outputs (optional)
- **integration_alias**: Alias of a CodeMie Integration used to define credentials and/or environment variables for server invocation (optional)
- **resolve_dynamic_values_in_arguments**: Enable variable substitution in arguments (default: false)

**Config Object Properties:**

- **command**: Command to invoke the server (e.g., "npx", "uvx", "python")
- **url**: HTTP URL for remote server (mutually exclusive with `command`)
- **args**: List of arguments for the command
- **headers**: HTTP headers for URL-based servers (supports `{{variable}}` substitution)
- **env**: Environment variables for the server process
- **type**: Transport type ("streamable-http" for `HTTP`, not needed for `sse` and `stdio`)
- **auth_token**: Authentication token for MCP-Connect server
- **single_usage**: If true, server is started fresh for each request; if false, server is cached/persistent (default: false)

#### Variable Substitution:

Template variables in `command`, `url`, `headers`, `args`, and `env` can reference:

- Environment variables from the `env` field
- Credentials and environment variables from CodeMie Integration (when `integration_alias` is set)
- Context store variables using `{{variable_name}}` syntax

#### Transport Types:

1. **stdio (default)**: Command-based server using standard input/output
2. **streamable-http**: Remote server accessed via HTTP with streaming support
3. **sse**: Server-Sent Events transport (automatically detected)

#### Examples:

**Filesystem Server:**

```yaml
- name: filesystem
  enabled: true
  config:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "{{project_workspace}}"]
```

**Database Server with Environment Variables:**

```yaml
- name: database
  enabled: true
  config:
    command: uvx
    args: ["mcp-server-postgres"]
    env:
      DATABASE_URL: "{{db_connection_string}}"
      POOL_SIZE: "10"
  integration_alias: postgres-prod
  resolve_dynamic_values_in_arguments: true
```

**Remote HTTP Server:**

```yaml
- name: api-server
  enabled: true
  config:
    url: https://api.example.com/mcp
    headers:
      Authorization: "Bearer {{api_token}}"
    type: streamable-http
```

---
