# How do I automatically generate YAML for workflows? What is the AutoYam Assistant in CodeMie? How to convert workflow requirements into YAML configurations?

AutoYaml Assistant: Generate Workflow YAML Configurations Automatically

The AutoYaml Assistant is a feature that helps you quickly generate YAML configurations for workflows in CodeMie. This tool significantly speeds up the workflow creation process by providing intelligent suggestions and pre-configured templates based on your requirements.

## How to Use the AutoYaml Assistant

## Generating a New Workflow Configuration

1. **Access the AutoYaml Assistant**
   - Navigate to the workflows section in CodeMie
   - Click on "Create New Workflow"
   - Select "Use AutoYaml Assistant" option

2. **Define Your Workflow Requirements**
   - The assistant will prompt you for necessary workflow information:
     - Number and types of assistants needed
     - States and transitions between them
     - Specific tasks for each state
     - Conditions for state transitions (if required)
   - Provide detailed responses to get the most accurate YAML configuration

3. **Review and Edit the Generated YAML**
   - The assistant will generate a complete YAML configuration based on your requirements
   - Review the generated configuration in the editor
   - Make adjustments as needed using the built-in YAML editor
   - The system will validate your configuration for syntax and logical errors

4. **Save and Apply Your Configuration**
   - Once satisfied with the configuration, click "Save" to apply it
   - The system will perform final validation to ensure all referenced components exist
   - Your workflow is now ready to use

## Editing an Existing Workflow Configuration

1. **Select an Existing Workflow**
   - Navigate to the workflows section
   - Select the workflow you want to modify

2. **Use AutoYaml Assistant for Editing**
   - Click "Edit with AutoYaml Assistant"
   - Paste or upload your current YAML configuration
   - Describe the changes you want to make

3. **Review and Apply Changes**
   - The assistant will update your configuration based on your requirements
   - Review the changes and make additional edits if needed
   - Save the updated configuration to apply changes to your workflow

## Examples and Use Cases

Example 1: Creating a Simple Two-State Workflow

```
 User input: "I need a workflow with two states. The first state searches for information, the second state summarizes it."

 Generated YAML:
assistants:
  - id: researcher
    assistant_id: [your_assistant_id]
    model: 'gpt-4o'
  - id: summarizer
    assistant_id: [your_assistant_id]
    model: 'gpt-4o'

states:
  - id: research_state
    assistant_id: researcher
    task: |
      Search for relevant information on the provided topic.
    output_schema: |
      {
        "research_results": "Research findings and information"
      }
    next:
      state_id: summary_state
  - id: summary_state
    assistant_id: summarizer
    task: |
      Summarize the research findings into a concise report.
    output_schema: |
      {
        "summary": "Concise summary of the research findings"
      }
    next:
      state_id: end
```

Example 2: Adding a Conditional Branch

```
 User input: "Add a condition to check if research found sufficient information, if not, repeat research."

 Assistant adds:
    output_schema: |
      {
        "research_results": "Research findings and information",
        "sufficient_info": "Boolean indicating if information is sufficient"
      }
    next:
      condition:
        expression: "sufficient_info == True"
        then: summary_state
        otherwise: research_state
```

## Tips for Effective Use

1. **Be Specific in Your Requirements**: The more detailed your requirements, the more accurate the generated configuration.

2. **Start Simple, Then Expand**: Begin with a simple workflow and use the assistant to add complexity as needed.

3. **Review the Documentation**: Refer to the [Workflow YAML Specification](link-to-existing-docs) to understand all available options.

4. **Validate Your Configuration**: Always use the validation feature to ensure your workflow meets all requirements.

## Sources

- [Create Workflow](https://docs.codemie.ai/user-guide/workflows/create-workflow)
- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
