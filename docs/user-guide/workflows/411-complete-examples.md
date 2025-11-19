---
id: 411-complete-examples
title: Complete Examples
sidebar_label: Complete Examples
sidebar_position: 2
---

# Complete Examples

## Example: Code Review Workflow

This workflow demonstrates an automated code review process that fetches Git changes, analyzes each modified file in parallel, and generates a comprehensive review report.

### Complete YAML Configuration

```yaml
enable_summarization_node: true
recursion_limit: 100
max_concurrency: 5
messages_limit_before_summarization: 30
tokens_limit_before_summarization: 60000

assistants:
  - id: git-analyzer
    system_prompt: |
      You are a Git expert. Use Git MCP tools to analyze repository changes.
      Parse the diff output and return JSON with changed files information.
    model: gpt-4.1
    temperature: 0.2
    mcp_servers:
      - name: git
        description: Git repository operations
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-git"
            - "--repository"
            - "/workspace/{{repository_path}}"

  - id: code-reviewer
    system_prompt: |
      You are an expert code reviewer. Analyze code changes and provide detailed feedback.
      Review criteria: code quality, security, performance, best practices, test coverage.
    model: gpt-4.1
    temperature: 0.3
    mcp_servers:
      - name: mcp-server-filesystem
        config:
          command: mcp-server-filesystem
          args:
            - "/workspace"

  - id: review-aggregator
    system_prompt: |
      You are a senior engineer aggregating code review results.
      Create a comprehensive review summary.
    model: gpt-4.1-mini
    temperature: 0.5

states:
  - id: fetch-git-changes
    assistant_id: git-analyzer
    task: |
      Use Git MCP tools to analyze changes between {{base_branch}} and HEAD.
      Get the diff and list of changed files with their modification statistics.
      Return structured JSON with changed_files array.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "changed_files": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "path": {"type": "string"},
                "change_type": {"type": "string"},
                "additions": {"type": "number"},
                "deletions": {"type": "number"}
              }
            }
          }
        },
        "required": ["changed_files"]
      }
    next:
      state_id: review-file
      iter_key: changed_files
      store_in_context: true

  - id: review-file
    assistant_id: code-reviewer
    resolve_dynamic_values_in_prompt: true
    task: |
      Review the code changes in file: {{path}}

      Change type: {{change_type}}
      Lines added: {{additions}}
      Lines deleted: {{deletions}}

      Read the file, analyze the changes, and provide detailed review feedback.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "file_path": {"type": "string"},
          "severity": {"type": "string", "enum": ["high", "medium", "low"]},
          "issues": {"type": "array"},
          "approval_status": {"type": "string"},
          "summary": {"type": "string"}
        }
      }
    next:
      state_id: generate-final-report
      store_in_context: true

  - id: generate-final-report
    assistant_id: review-aggregator
    task: |
      Generate a comprehensive code review report based on all individual file reviews.

      Include:
      1. Executive summary
      2. Overall approval recommendation
      3. Critical issues requiring immediate attention
      4. Files with changes requested
      5. Approved files
      6. Recommendations for next steps
    next:
      state_id: end
```

### Key Features Demonstrated

**1. Parallel Processing with Map-Reduce**
- The workflow fetches changed files and processes each file in parallel
- Uses `iter_key: changed_files` to fan-out execution
- Results are automatically aggregated for the final report

**2. MCP Server Integration**
- Git MCP server for repository operations
- Filesystem MCP server for reading files
- Dynamic argument resolution with `{{repository_path}}`

**3. Structured Output with JSON Schema**
- Output schemas enforce data structure
- Enables reliable data flow between states
- Facilitates aggregation and processing

**4. Context Management**
- `store_in_context: true` preserves results
- Dynamic value resolution accesses stored data
- Memory limits prevent context overflow

### Usage Example

```json
{
  "repository_path": "/path/to/your/repo",
  "base_branch": "main"
}
```

---

## Example: Document Processing Pipeline

This workflow processes multiple documents concurrently, extracts information, and generates summaries.

### YAML Configuration

```yaml
enable_summarization_node: true
recursion_limit: 50
max_concurrency: 10

assistants:
  - id: document-extractor
    system_prompt: |
      You are a document analysis expert. Extract key information from documents.
    model: gpt-4.1-mini
    temperature: 0.2

  - id: summarizer
    system_prompt: |
      You are a professional summarizer. Create concise, accurate summaries.
    model: gpt-4.1-mini
    temperature: 0.5

states:
  - id: list-documents
    assistant_id: document-extractor
    task: |
      List all documents in the {{input_folder}} directory.
      Return JSON: {"documents": ["doc1.pdf", "doc2.pdf", ...]}
    next:
      state_id: process-document
      iter_key: documents
      store_in_context: true

  - id: process-document
    assistant_id: document-extractor
    task: |
      Extract key information from: {{document}}
      Return: title, date, key_points, entities
    next:
      state_id: generate-summary
      store_in_context: true

  - id: generate-summary
    assistant_id: summarizer
    task: |
      Create a comprehensive summary report from all processed documents.
    next:
      state_id: end
```

---

## Example: Multi-Step Research Workflow

Research workflow that gathers information from multiple sources and synthesizes findings.

### YAML Configuration

```yaml
assistants:
  - id: researcher
    model: gpt-4.1
    temperature: 0.3
    datasource_ids:
      - documentation-repo
      - confluence-kb
    tools:
      - name: search_knowledge_base

  - id: analyst
    model: gpt-4.1
    temperature: 0.5

states:
  - id: search-documentation
    assistant_id: researcher
    task: |
      Research topic: {{research_topic}}
      Search documentation datasource for relevant information.
    next:
      state_id: search-confluence

  - id: search-confluence
    assistant_id: researcher
    task: |
      Research topic: {{research_topic}}
      Search Confluence knowledge base for additional context.
    next:
      state_id: synthesize-findings

  - id: synthesize-findings
    assistant_id: analyst
    task: |
      Synthesize research findings from both sources:

      Documentation: {{task from search-documentation}}
      Confluence: {{task from search-confluence}}

      Create comprehensive analysis with:
      - Key findings
      - Patterns identified
      - Recommendations
      - References to sources
    next:
      state_id: end
```

---

## Best Practices from Examples

### 1. Use Appropriate Models

- **Analysis tasks**: `gpt-4.1` for accuracy
- **Summarization**: `gpt-4.1-mini` for efficiency
- **Extraction**: `gpt-4.1-mini` with low temperature

### 2. Structure Output with Schemas

```yaml
output_schema: |
  {
    "type": "object",
    "properties": {
      "field": {"type": "string"}
    },
    "required": ["field"]
  }
```

### 3. Manage Context Carefully

```yaml
next:
  store_in_context: true          # Store results
  include_in_llm_history: false   # Exclude from history
  output_key: specific_name       # Named storage
```

### 4. Configure Resource Limits

```yaml
enable_summarization_node: true
messages_limit_before_summarization: 25
tokens_limit_before_summarization: 50000
recursion_limit: 50
max_concurrency: 5
```

### 5. Use Parallel Processing Wisely

```yaml
# Good for independent tasks
next:
  state_id: process-item
  iter_key: items
  # Automatic parallelization

# With concurrency limit
max_concurrency: 5
```

---

For more examples and detailed explanations, refer to the other sections in this documentation.
