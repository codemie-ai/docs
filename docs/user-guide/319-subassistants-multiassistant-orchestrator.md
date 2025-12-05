# 3.19 Sub-assistants, Multi-assistant (Orchestrator)

## Overview

The multi-assistant capability allows you to create an orchestrator assistant that can utilize other assistants as tools. This feature enables more effective agent-to-agent communications by allowing one assistant (the orchestrator) to delegate specific tasks to specialized sub-assistants.

## Key Concepts

- **Orchestrator Assistant**: An assistant configured to coordinate and delegate tasks to other assistants
- **Sub-assistants**: Specialized assistants that can be added as tools to the orchestrator
- **Hierarchical Task Processing**: Complex tasks can be broken down and distributed to specialized assistants

## How to Configure an Orchestrator Assistant

1. Go to the main page and click the **Assistants** button

2. In the **Project Assistants** menu, click **+ Create Assistant**

3. Fill in the basic assistant properties (Name, Description, System Instructions, etc.)

4. Scroll down to the **Tools** section

5. Look for the new **Sub-assistant** field with a dropdown menu

6. Use the search function to find the assistant(s) you want to add as sub-assistants:

   ![Sub-assistant Selection](./images/image185.png)

:::note

- Only assistants within the same project can be added
- You cannot select assistants that already have sub-assistants
- You cannot select the assistant itself as a sub-assistant
  :::

## Important Configuration Details

### 1. System Instructions

The orchestrator needs detailed instructions to understand which sub-assistants to use for specific tasks. Include descriptions of each sub-assistant's capabilities in the instructions.

### 2. Sub-assistant Descriptions

Make sure each sub-assistant has a clear description that explains its purpose and capabilities. This helps the orchestrator know when to use it.

### 3. Context Sharing

Sub-assistants can access the chat history context, allowing them to build upon information from previous interactions.

## Example Use Case

You can create an orchestrator assistant that helps with test documentation and regression planning by utilizing three specialized sub-assistants:

1. A sub-assistant to create checklists based on user stories
2. A sub-assistant to generate manual functional test cases
3. A sub-assistant to analyze code changes and provide recommendations for regression testing

The orchestrator will then determine which sub-assistant to use based on the specific request and coordinate their responses to provide a coherent answer.

## Viewing Sub-assistant Configuration

To see which sub-assistants are configured for an assistant:

1. Open the assistant details
2. Look for the list of sub-assistants in the configuration details

## Best Practices

1. Create specialized sub-assistants with focused capabilities
2. Provide clear system instructions that define when to use each sub-assistant
3. Ensure descriptions for each sub-assistant clearly explain their purpose and capabilities
4. Test the orchestrator with various scenarios to ensure proper delegation
