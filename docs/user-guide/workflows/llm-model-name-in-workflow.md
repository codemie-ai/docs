---
id: llm-model-name-in-workflow
title: LLM Model Name in Workflow
sidebar_label: LLM Model Name
pagination_prev: user-guide/workflows/workflow-version-history
pagination_next: user-guide/workflows/workflow-templates
sidebar_position: 3
description: How to identify which LLM model is being used in a workflow
---

# LLM Model Name in Workflow

Use browser Developer Tools to identify the LLM model being used in your workflow execution.

## Steps to Find Model Name

1. **Open AI/Run CodeMie** in your browser.

2. **Open Developer Tools**:
   - Press **F12**, or
   - Right-click on the page and select **Inspect**

3. **Navigate to Network Tab**:

   The Network tab displays all HTTP requests made by the application.

4. **Refresh the Page**:

   Press **F5** to capture network activity, including LLM model requests.

5. **Locate the LLM Models Request**:

   Search or filter for `llm_models` in the Name column:

   ![Network tab showing llm_models request](../images/image110.png)

6. **View Response Data**:

   Click on the request, then select the **Response** tab to see the JSON response.

7. **Find the Model Name**:

   Locate the `base_name` field in the JSON response - this indicates the LLM model name used in the workflow.

## Example Response Structure

```json
{
  "base_name": "gpt-4.1",
  "deployment_name": "codemie-gpt-4.1-2025-04-14",
  "label": "GPT-4.1 2025-04-14",
  "provider": "azure_openai",
  "default": true
}
```

The response is a list with one object like this for every model available in your environment; other fields such as `multimodal`, `cost` and `features` are omitted here.

The `base_name` field contains the model identifier (e.g., `gpt-4.1`, `claude-sonnet-5-5`, etc.).
