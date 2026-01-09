---
id: specialized-nodes
title: Specialized Node Types
sidebar_label: Specialized Nodes
pagination_prev: user-guide/workflows/configuration/advanced-features
pagination_next: user-guide/workflows/configuration/integration-capabilities
sidebar_position: 8
---

# Specialized Node Types

## 8. Specialized Node Types

### 8.1 State Processor Node

Process and aggregate outputs from multiple states.

```yaml
custom_nodes:
  - id: summarizer
    custom_node_id: state_processor_node
    model: gpt-4.1-mini
    config:
      state_id: branch-processor  # Filter by state ID
      states_status_filter:
        - SUCCEEDED
        - FAILED
      output_template: |
        # Processing Results
        {% for item in items %}
        ## {{ item.file_name }}
        Status: {{ item.status }}
        Result: {{ item.result }}
        {% endfor %}
```

#### Use Cases:

- Aggregate results from parallel branches
- Generate summary reports
- Filter and format outputs

### 8.2 Bedrock Flow Node

Integrate AWS Bedrock Flows for specialized AI workflows.

```yaml
custom_nodes:
  - id: bedrock-processor
    custom_node_id: bedrock_flow_node
    config:
      flow_id: arn:aws:bedrock:region:account:flow/id
      flow_alias_id: alias-id
      enable_trace: false
```

#### Features:

- AWS Bedrock integration
- Flow execution and tracing
- Input/output transformation

### 8.3 Document Tree Generator

Generate structured document representations.

```yaml
custom_nodes:
  - id: doc-tree
    custom_node_id: generate_documents_tree
    config:
      datasource_ids:
        - datasource-1
      documents_filtering_pattern: "**/*.md"
      documents_filter:
        - id1
        - id2
```

#### Configuration Options:

- **datasource_ids**: Data sources to process
- **documents_filtering_pattern**: Glob pattern for filtering
- **documents_filter**: Specific document IDs
- **max_depth**: Tree depth limit
- **include_metadata**: Include document metadata

### 8.4 Transform Node

Transform and map data without LLM calls. Ideal for processing webhooks, extracting fields from complex JSON, and applying transformations.

```yaml
custom_nodes:
  - id: transform_pr
    custom_node_id: transform_node
    name: Transform GitHub PR Event
    config:
      input_source: "context_store"
      input_key: "github_event"

      mappings:
        # Extract label names from array
        - output_field: "label_names"
          type: "array_map"
          source_path: "pull_request.labels"
          item_field: "name"

        # Check if WS label exists (references label_names from above)
        - output_field: "has_ws_label"
          type: "condition"
          condition: "'WS' in label_names"
          then_value: true
          else_value: false

        # Extract PR number
        - output_field: "pr_number"
          type: "extract"
          source_path: "number"

      # Optional: validate output structure
      output_schema:
        type: "object"
        properties:
          label_names:
            type: "array"
          has_ws_label:
            type: "boolean"
          pr_number:
            type: "integer"
        required: ["has_ws_label"]

      on_error: "fail"
```

#### Configuration Parameters

| Parameter        | Type   | Required | Default         | Description                                                                     |
| ---------------- | ------ | -------- | --------------- | ------------------------------------------------------------------------------- |
| `input_source`   | string | No       | `context_store` | Source of input data: `context_store`, `messages`, `user_input`, `state_schema` |
| `input_key`      | string | No       | -               | Specific key to extract from input source                                       |
| `mappings`       | array  | Yes      | -               | List of transformation mappings                                                 |
| `output_schema`  | object | No       | -               | JSON Schema for output validation                                               |
| `on_error`       | string | No       | `fail`          | Error strategy: `fail`, `skip`, `default`, `partial`                            |
| `default_output` | object | No       | `{}`            | Default output when `on_error: default`                                         |

#### Mapping Types

Transform Node supports six mapping types:

##### 1. Extract - Field Extraction

Extract fields using dot notation for nested objects.

```yaml
- output_field: "user_name"
  type: "extract"
  source_path: "pull_request.user.login"
  default: "unknown"  # Optional
```

##### 2. Array Map - Array Processing

Extract fields from arrays of objects, with optional filtering.

```yaml
# Extract all label names
- output_field: "label_names"
  type: "array_map"
  source_path: "pull_request.labels"
  item_field: "name"

# Extract only labels starting with "target-"
- output_field: "target_labels"
  type: "array_map"
  source_path: "pull_request.labels"
  item_field: "name"
  filter_condition: "item.get('name', '').startswith('target-')"
```

##### 3. Condition - Conditional Logic

Apply boolean logic to determine output values.

```yaml
- output_field: "is_actionable"
  type: "condition"
  condition: "action in ['opened', 'updated', 'reopened']"
  then_value: true
  else_value: false
```

##### 4. Template - Jinja2 Rendering

Use Jinja2 templates for complex string formatting.

```yaml
- output_field: "summary"
  type: "template"
  template: "PR #{{ number }}: {{ title }} by @{{ author }}"
```

##### 5. Constant - Static Values

Assign static values.

```yaml
- output_field: "source"
  type: "constant"
  value: "github_webhook"
```

##### 6. Script - Python Expressions

Execute Python expressions with restricted namespace.

```yaml
- output_field: "priority_score"
  type: "script"
  script: "urgency * 2 + importance"
```

#### Sequential Processing

**Important:** Mappings are processed sequentially. Later mappings can reference fields created by earlier mappings.

```yaml
mappings:
  # Step 1: Extract array
  - output_field: "tags"
    type: "array_map"
    source_path: "items"
    item_field: "tag"

  # Step 2: Count tags (uses 'tags' from Step 1)
  - output_field: "tag_count"
    type: "script"
    script: "len(tags)"

  # Step 3: Check count (uses 'tag_count' from Step 2)
  - output_field: "has_many_tags"
    type: "condition"
    condition: "tag_count > 5"
    then_value: true
    else_value: false
```

#### Complete Example: GitHub PR Label Router

```yaml
execution_config:
  custom_nodes:
    - id: check_pr_labels
      custom_node_id: transform_node
      name: Extract and Check PR Labels
      config:
        input_source: "context_store"
        input_key: "github_event"

        mappings:
          # Extract all label names
          - output_field: "label_names"
            type: "array_map"
            source_path: "pull_request.labels"
            item_field: "name"

          # Extract only target labels
          - output_field: "target_labels"
            type: "array_map"
            source_path: "pull_request.labels"
            item_field: "name"
            filter_condition: "item.get('name', '').startswith('target-')"

          # Check for WS label
          - output_field: "has_ws"
            type: "condition"
            condition: "'WS' in label_names"
            then_value: true
            else_value: false

          # Check for any target label
          - output_field: "has_target"
            type: "condition"
            condition: "len(target_labels) > 0"
            then_value: true
            else_value: false

          # Extract PR info
          - output_field: "pr_number"
            type: "extract"
            source_path: "number"

          - output_field: "pr_title"
            type: "extract"
            source_path: "pull_request.title"

          # Create summary
          - output_field: "summary"
            type: "template"
            template: "PR #{{ pr_number }}: {{ pr_title }} - Labels: {{ label_names | join(', ') }}"

        on_error: "fail"

  states:
    - id: extract_labels
      custom_node_id: check_pr_labels
      task: "Extract and process PR labels"
      next:
        state_id: route_by_labels
        output_key: "pr_info"
        store_in_context: true

    - id: route_by_labels
      assistant_id: processor
      task: "Route based on labels"
      next:
        switch:
          cases:
            - condition: "has_ws == True"
              state_id: ws_workflow
            - condition: "has_target == True"
              state_id: target_workflow
          default: default_workflow
```

#### Use Cases

- **Webhook Processing**: Transform GitHub, GitLab, Jira webhooks
- **Array Operations**: Extract fields from collections (labels, assignees, tags)
- **Data Validation**: Enforce structure with JSON schema
- **Conditional Routing**: Route workflows based on transformed data
- **API Response Mapping**: Transform external API responses
- **Data Aggregation**: Combine data from multiple sources

#### Benefits

- **Fast**: No LLM calls - pure data transformation
- **Deterministic**: Same input always produces same output
- **Type-Safe**: Built-in validation and type coercion
- **Sequential**: Reference previous mapping results
- **Secure**: Restricted Python namespace prevents dangerous operations
- **Flexible**: Six transformation types cover most use cases

#### Error Handling

Transform Node supports four error strategies:

```yaml
# Fail on any error (default)
on_error: "fail"

# Skip transformation and return empty dict
on_error: "skip"

# Return configured default output
on_error: "default"
default_output:
  status: "error"
  message: "Transformation failed"

# Return partial results (skip failed mappings)
on_error: "partial"
```

---
