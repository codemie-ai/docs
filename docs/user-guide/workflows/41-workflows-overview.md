---
id: 41-workflows-overview
title: Introduction & Getting Started
sidebar_label: Introduction & Getting Started
sidebar_position: 1
---

# Introduction

## 1. Introduction

### 1.1 What are CodeMie Workflows?

**CodeMie Workflows** is a powerful orchestration system that enables you to create complex, multi-step AI-powered processes by coordinating multiple assistants, tools, and custom processing nodes. Built on top of LangGraph (a framework for building stateful, multi-agent applications), workflows transform simple linear AI interactions into sophisticated, automated processes that can handle complex tasks requiring multiple steps, parallel processing, and intelligent decision-making.

#### Overview and Purpose

A workflow is essentially a directed graph where each node represents a specific action (like running an AI assistant, executing a tool, or processing data), and edges define how execution flows from one node to another. This architecture allows you to:

- **Decompose complex tasks** into manageable steps
- **Coordinate multiple AI assistants** with different specializations
- **Integrate tools and external systems** seamlessly
- **Implement advanced patterns** like parallel processing, conditional branching, and map-reduce operations
- **Maintain context** across all steps of execution
- **Handle errors gracefully** with retry policies and fallback strategies

Unlike single AI assistants that handle tasks in a single interaction, workflows enable you to orchestrate a sequence (or parallel execution) of multiple operations, each optimized for a specific subtask.

#### Key Benefits

**1. Task Decomposition & Specialization**
- Break down complex problems into focused, manageable steps
- Assign specialized assistants to different parts of the task
- Each assistant can have its own model, temperature, system prompt, and tools

**2. Advanced Control Flow**
- Execute steps sequentially or in parallel
- Branch execution based on conditions (if-then-else logic)
- Iterate over collections with map-reduce patterns
- Aggregate results from parallel operations

**3. Scalability & Reliability**
- Process multiple items concurrently with automatic parallelization
- Built-in retry mechanisms for handling transient failures
- Memory management with automatic conversation summarization
- Configurable recursion limits and concurrency controls

**4. Context Preservation & Sharing**
- Shared context store accessible across all workflow steps
- Message history maintained throughout execution
- Dynamic value resolution with template variables
- Granular control over what data is stored and shared

**5. Integration Flexibility**
- Connect to data sources (code repositories, Confluence, Jira, etc.)
- Use built-in tools for cloud platforms (AWS, Azure, GCP, Kubernetes)
- Integrate MCP (Model Context Protocol) servers for extended capabilities
- Custom nodes for specialized processing

#### Use Cases

**Code Analysis & Transformation**
- Analyze codebase → Identify issues → Generate fixes → Validate changes
- Multi-file processing with parallel analysis and aggregation

**Document Processing Pipelines**
- Extract data → Analyze content → Generate summaries → Store results
- Process multiple documents concurrently

**Research & Analysis**
- Gather information → Analyze data → Compare alternatives → Generate reports
- Parallel research across multiple sources with result aggregation

**Development Workflows**
- Generate code → Run tests → Fix errors → Create documentation
- Conditional branching based on test results

**Data Processing**
- Fetch data → Transform → Validate → Store
- Map-reduce patterns for processing large datasets

#### When to Use Workflows vs. Single Assistants

**Use a Workflow when:**
- The task requires multiple distinct steps that can be logically separated
- You need to process multiple items in parallel (e.g., analyzing multiple files)
- Different steps require different AI assistant configurations or tools
- You need conditional logic or branching based on intermediate results
- The task involves both AI reasoning and tool execution
- You need to aggregate results from multiple parallel operations
- Context needs to be preserved and shared across multiple steps

**Use a Single Assistant when:**
- The task can be completed in one interaction
- No parallelization or complex branching is needed
- The conversation is exploratory and doesn't follow a predetermined structure
- You want maximum flexibility for the AI to determine its own approach

### 1.2 Core Architecture Components

CodeMie Workflows is built on a graph-based architecture with several key components that work together to execute complex AI-powered processes.

#### Workflow States (Nodes)

States (also called nodes) are the fundamental building blocks of a workflow. Each state represents a single unit of work. There are three types of states:

**1. Agent States**
- Execute an AI assistant with a specific task
- The assistant processes input, uses tools, and generates output
- Configured with system prompts, models, temperature, and available tools
- Can reference existing assistants or define inline configurations

**2. Tool States**
- Execute a tool directly without LLM involvement
- Useful for deterministic operations (API calls, data transformations)
- Faster and more cost-effective than agent states for simple operations
- Results can be extracted using JSON Pointer expressions

**3. Custom Node States**
- Specialized processing nodes for advanced operations
- Examples: State processors (aggregate results), Bedrock flows, document tree generators
- Implement custom logic beyond standard agent/tool capabilities
- Can use LLMs for processing with custom system prompts

Each state has:
- **Unique ID**: Identifies the state within the workflow
- **Task/Instructions**: What the state should accomplish
- **Next Transition**: Where execution should go after completion
- **Configuration**: State-specific settings (retry policies, output schemas, etc.)

#### Assistants and Agents

Assistants are AI agents configured with specific capabilities, personalities, and tool access. In workflows, assistants can be:

**Referenced by ID**
```yaml
assistants:
  - id: code-analyzer
    assistant_id: existing-assistant-123  # Reference existing assistant
```

**Defined Inline**
```yaml
assistants:
  - id: code-analyzer
    model: gpt-4.1
    temperature: 0.3
    system_prompt: |
      You are an expert code analyzer...
    tools:
      - name: read_file
      - name: git_diff
    datasource_ids:
      - repo-1
```

Each assistant can have:
- **Model configuration**: Choose the LLM model and temperature
- **System prompt**: Define behavior, personality, and instructions
- **Tools**: Grant access to specific tools (code analysis, cloud operations, etc.)
- **Data sources**: Connect to knowledge bases (code repos, documentation)
- **MCP servers**: Integrate external capabilities via Model Context Protocol
- **Token limits**: Control maximum tokens from tool outputs

#### Tools and Integrations

Tools extend workflow capabilities beyond AI reasoning:

**Built-in Tool Categories:**
- **Code Tools**: Read files, search code, analyze syntax, generate documentation
- **Cloud Platform Tools**: AWS, Azure, GCP, Kubernetes operations
- **Git Tools**: Repository operations, diff analysis, branch management
- **Knowledge Base Tools**: Search and retrieve from indexed data sources
- **Plugin Tools**: NATS-based integration with external systems
- **MCP Tools**: Model Context Protocol servers for extended capabilities

**Tool Configuration:**
```yaml
tools:
  - id: my-tool
    tool: tool_method_name
    tool_args:
      param1: value1
      param2: "{{dynamic_value}}"
    integration_alias: credentials-alias
    tool_result_json_pointer: /path/to/result
```

Tools can:
- Accept dynamic arguments resolved from context
- Extract specific results using JSON Pointer
- Use integration credentials for secure access
- Be called directly in tool states or by AI agents

#### State Transitions and Routing

Transitions define how execution flows through the workflow. CodeMie Workflows supports multiple transition types:

**1. Simple Transitions**
- Direct transition to the next state
- `next: { state_id: next-state }`

**2. Parallel Transitions (Fan-Out)**
- Execute multiple states concurrently
- `next: { state_ids: [state-1, state-2, state-3] }`

**3. Conditional Transitions (If-Then-Else)**
- Branch based on previous state's output
- `next: { condition: { expression: "status == 'success'", then: success-state, otherwise: error-state } }`

**4. Switch/Case Transitions**
- Multiple conditional branches evaluated sequentially
- `next: { switch: { cases: [...], default: default-state } }`

**5. Iterative Transitions (Map-Reduce)**
- Process collections in parallel with automatic fan-out/fan-in
- `next: { state_id: process-item, iter_key: items }`

Each transition can be configured with:
- **Context storage control**: What data to store for future steps
- **Message history control**: What to include in LLM context
- **Context cleanup**: Clear or reset specific data
- **Output extraction**: Pull specific values from results

#### Context Management and Memory

The context system preserves and shares data across workflow execution:

**Context Store**
- Key-value storage accessible throughout the workflow
- Automatically populated with state outputs
- Supports dynamic value resolution with `{{variable_name}}` syntax
- Can be explicitly cleared or partially reset

**Message History**
- Contains all messages exchanged during workflow execution
- Automatically sent to AI assistants for context
- Can be included or excluded per state
- Supports summarization when history grows too large

**Memory Management**
- **Automatic Summarization**: When message count or token limit is exceeded, the system automatically summarizes conversation history
- **Token Limits**: Configurable thresholds for triggering summarization
- **Context Isolation**: Parallel iterations maintain separate contexts during execution
- **Context Merging**: Results from parallel branches are merged when they complete

**Configuration Options:**
- `store_in_context`: Control whether state output is stored
- `include_in_llm_history`: Control whether output appears in message history
- `clear_prior_messages`: Start fresh with empty message history
- `clear_context_store`: Reset all stored context
- `reset_keys_in_context_store`: Remove specific keys

#### Workflow Lifecycle

A typical workflow execution follows this lifecycle:

1. **Initialization**: Workflow graph is constructed from YAML configuration
2. **Validation**: Configuration is validated for correctness and resource availability
3. **Entry Point**: Execution starts at the designated entry state
4. **State Execution**: Each state executes its assigned task (agent, tool, or custom node)
5. **Transition**: Based on transition rules, execution moves to next state(s)
6. **Parallelization**: If iterating or fanning out, multiple branches execute concurrently
7. **Aggregation**: Parallel branches complete and results are merged
8. **Summarization**: If enabled and limits exceeded, conversation is summarized
9. **Completion**: Workflow reaches end state or result finalizer node
10. **Cleanup**: Resources are released and execution status is recorded

#### Key Terminology

- **Workflow**: The complete orchestration graph defining the entire process
- **State/Node**: A single step in the workflow (agent, tool, or custom node)
- **Transition/Edge**: Connection between states defining execution flow
- **Context Store**: Key-value storage for sharing data across states
- **Message History**: Conversation history sent to AI assistants
- **Agent/Assistant**: AI model with specific configuration and tools
- **Tool**: Executable function for specific operations
- **Custom Node**: Specialized processing component
- **Iteration/Map-Reduce**: Pattern for processing collections in parallel
- **Fan-Out**: Splitting execution into multiple parallel branches
- **Fan-In**: Merging results from parallel branches
- **MCP Server**: Model Context Protocol server providing extended capabilities
- **Retry Policy**: Configuration for automatic retry on failures
- **Interrupt**: Pausing execution for user confirmation

---

## 2. Getting Started

### 2.1 Your First Workflow

This section walks you through creating your first simple workflow to help you understand the basic concepts and structure.

#### Creating a Simple Two-Step Workflow

A basic two-step workflow demonstrates the fundamental pattern of chaining AI assistants together. This type of workflow is ideal for learning the core concepts.

**Example: Article Summarization Workflow**

This simple workflow takes a long article and creates a summary in two steps: first extracting key points, then formatting them into a professional summary. This demonstrates the fundamental workflow pattern.

**Assistants Defined:**
1. **Content Analyst**: Configured with gpt-4.1-mini model to read the article and extract key points. Uses a low temperature (0.3) for factual accuracy.

2. **Writer**: Configured with gpt-4.1-mini model to format the key points into a polished summary. Uses slightly higher temperature (0.5) for better writing style.

**Workflow States:**
1. **extract-key-points**: The first state where the content analyst reads the article and identifies the most important points. Returns a simple list of key points.

2. **format-summary**: The second state where the writer takes the key points and formats them into a professional executive summary.

**Execution Flow:**
- User provides an article as input
- Content analyst extracts key points from the article
- Key points automatically flow to the writer through context
- Writer creates the final formatted summary
- Workflow completes at the `end` state

---
**Complete YAML Configuration:**

```yaml
assistants:
  - id: content-analyst
    model: gpt-4.1-mini
    temperature: 0.3
    system_prompt: |
      You are a content analyst. Read articles carefully and extract the most important points.
      Focus on facts, key findings, and main conclusions.

  - id: writer
    model: gpt-4.1-mini
    temperature: 0.5
    system_prompt: |
      You are a professional writer. Create clear, well-structured summaries.
      Use professional language and organize information logically.

states:
  - id: extract-key-points
    assistant_id: content-analyst
    task: |
      Read this article and extract the key points:

      {{article}}

      List 3-5 most important points from the article.
      Focus on main ideas, key findings, and conclusions.
    next:
      state_id: format-summary
      output_key: key_points  # Store output as "key_points" variable
      store_in_context: true

  - id: format-summary
    assistant_id: writer
    task: |
      Create a professional executive summary based on these key points:

      {{key_points}}

      Format as:
      - Opening sentence (what the article is about)
      - 2-3 paragraphs covering the key points
      - Closing sentence (main takeaway)
    next:
      state_id: end
```

**Usage:**
```json
{
  "article": "Your article text here. This can be several paragraphs long. The workflow will process it and create a concise summary..."
}
```

---

For more detailed information about workflow configuration, states, transitions, and advanced features, please explore the other sections in this documentation.
