# How to work with workflows? Workflows? Examples of workflows? Workflow variables?

Workflow configuration documentation on kb: https://kb.epam.com/display/EPMCDME/Workflow+documentation

To create a workflow configuration with two assistants and two states, copy and paste the YAML example above into your configuration file. Customize the id, assistant_id, task, and other fields according to your requirements.The output_schema should be a valid JSON schema that describes the structure of the output.

- enable_summarization_node: boolean (Optional) Enable summary of workflow execution to provide summary/result of entire execution.
- tokens_limit_before_summarization: integer (Optional) Sets a maximum limit of tokens in the conversation before triggering automatic summarization. This helps manage long conversations and prevent context overflow.
- recursion_limit: integer (Optional) Specifies the maximum number of times a workflow can iterate over existing states. This prevents infinite loops and ensures workflows complete within reasonable bounds. Default value is 50
- max_concurrency: integer (Optional) Specifies the maximum number of parallel calls to make if iter_key is specified. This allows parallel execution of a given amount of nodes. Default value is 2

## YAML Specification for Workflow Configuration

1. Assistants Section:
   - id: string (Required) A unique identifier for the assistant within this configuration.
   - assistant_id: string (Optional) The unique identifier provided by an external source for the assistant. If not specified, a virtual assistant will be created
   - model: string (Optional) The model to be used by the assistant. If not specified, a default model will be used.
   - system_prompt: string (Optional) A system prompt for the assistant.
   - temperature: The temperature setting (0.0 to 2.0) that controls randomness in responses. Lower values (e.g., 0.1) produce more deterministic outputs, while higher values (e.g., 1.0) produce more creative responses.
   - limit_tool_output_tokens: integer (Optional) Limits the number of output tokens. The default is 10000.
   - tools: object (Optional) List of tools for the assistant
     - name: string (Required) Tool name used for assistant
     - integration_alias: string (Optional) integrations alias used for tool. If not specified, a first available will be used.
   - datasource_ids: list(Optional) List of datasource IDs used as additional context for assistant
   - exclude_extra_context_tools: boolean (Optional) Exclude extra context tools. By default the system adds 2 tools for interaction with context. Default is false
   - The default model will be used.

     2.States Section:

- id: string (Required) A unique identifier for the state.
- assistant_id: string (Optional) The identifier for the assistant associated with this state.
- custom_node_id: string (Optional) The identifier for the custom node, if any.
- tool_id: string (Optional) The identifier for the tool associated with this state.
- tool_args: object (Optional) Object containing arguments for tool invocation. Can use parameters with using jinja templates ({{argument1}})
- task: string (Optional) The task description for the state.
- next: object (Required) Defines the next state or condition to transition.
  - state_id: string (Optional) The identifier for the next state.
  - state_ids: list (Optional) List of identifiers for the next states
  - iter_key: string (Optional) Key to iterate over for repeated transitions.
  - output_key: string (Optional) Key to store current state results into state history.
  - keep_history: boolean (Optional) Indicates whether to keep history of transitions. Default is true.
  - condition: object (Optional) Conditional expression to determine the next state.
    - expression: string (Required) The conditional expression.
    - then: string (Required) The state identifier if the condition is true.
    - otherwise: string (Required) The state identifier if the condition is false.
  - switch: object (Optional) Switch case for transitioning states.
    - cases: list (Required) A list of conditions and corresponding state IDs.
      - condition: string (Required) The conditional expression.
      - state_id: string (Required) The identifier for the next state.
    - default: string (Required) The default state identifier if no cases match.
- output_schema: string (Optional) JSON schema for the output of this state.
- retry_policy: object (Optional) Retry policy for the state.
  - initial_interval: float (Required) Initial interval for retries.
  - backoff_factor: float (Required) Backoff factor for retries.
  - max_interval: float (Required) Maximum interval for retries.
  - max_attempts: integer (Required) Maximum number of retry attempts.
- interrupt_before: boolean (Optional) Pause the workflow before this state executes, requiring user confirmation to proceed. The default is false. Previously named `wait_for_user_confirmation`.

## 3. Tools section:

- id: string (Required) A unique identifier for the tool within this configuration.
- tool: string (Required) Tool name used for current tool node configuration
- tool_args: object (Optional) Object containing arguments for tool invocation. Can use parameters with using jinja templates ({{argument1}})
- integration_alias: string (Optional) integrations alias used for tool. If not specified, a first available will be used.
- trace: boolean (Optional) Indicates for tool to be traced in logs

## 4. Custom Nodes Section:

- custom_nodes: This is a list of custom node configurations.
- id: A unique identifier for the custom node within this configuration.
- config: Configuration settings specific to the custom node

## Validation of Workflow YAML Configuration

When creating a workflow with YAML configuration, the system performs validation to ensure all referenced components exist in your environment. This validation helps prevent errors and ensures smooth workflow execution.

## What Gets Validated

When you click the "Create" button to create a new workflow, the system validates:

1. **Assistant References**: All assistant_id values in your configuration must refer to existing assistants in your environment.

2. **Data Source References**: All datasource_ids specified in your configuration must refer to existing Data Sources.

3. **Tool References**: All tools referenced by name in your configuration must be available in your environment.

4. **YAML Schema Compliance**: The entire YAML configuration is validated against the workflow schema specification.

## Error Messages

If validation fails, you will receive an error message that lists all non-existent components:

```

Workflow can't be created because the following Data Sources/Tools do not exist:

## Data Sources:

## \<Data Source name 1> \<datasource_id 1>

## \<Data Source name 2> \<datasource_id 2>

...

## Tools:

## \<Tool name 1>

## \<Tool name 2>

...
## Sources

- [Workflows Overview](https://docs.codemie.ai/user-guide/workflows/workflows-overview)
- [Create Workflow](https://docs.codemie.ai/user-guide/workflows/create-workflow)
- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
- [Configuration Reference](https://docs.codemie.ai/user-guide/workflows/configuration/configuration-reference)
```
