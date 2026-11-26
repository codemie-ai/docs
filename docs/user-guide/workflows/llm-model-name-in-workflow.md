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

Use browser Developer Tools to see which LLM models are available in your environment.

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

   Type `llm_models` in the filter field of the Network tab. Several requests match the filter. Pick the one whose name is exactly `llm_models`.

6. **View Response Data**:

   Click on the request, then select the **Response** tab to see the JSON response.

7. **Find the Model Names**:

   The `base_name` field of each entry in the response is the name of an available model. The model that a workflow uses is set in its YAML configuration or in the assistant that the step uses.

## Example Response Structure

The response is a JSON list with one object for every model available in your environment. This is a shortened example with two entries:

```json
[
  {
    "base_name": "gpt-4.1",
    "deployment_name": "codemie-gpt-4.1-2025-04-14",
    "label": "GPT-4.1 2025-04-14",
    "multimodal": true,
    "enabled": true,
    "provider": "azure_openai",
    "default": true,
    "max_output_tokens": 32768,
    "status": "enabled"
  },
  {
    "base_name": "claude-4-5-haiku",
    "deployment_name": "us.anthropic.claude-haiku-4-5-20251001-v1:0",
    "label": "Bedrock Claude 4.5 Haiku",
    "multimodal": true,
    "enabled": true,
    "provider": "aws_bedrock",
    "default": false,
    "max_output_tokens": 64000,
    "status": "enabled"
  }
]
```

Other fields such as `cost`, `features`, `supports_image_generation` and `default_for_categories` are omitted here.

The `base_name` field contains the model name (for example, `gpt-4.1` or `claude-4-5-haiku`).
