# How do I enable enhanced structured output validation in my workflows? What happens if my workflow output doesn't match the provided JSON schema? Will my existing workflows still work after the LangChain structured output update? What models support the new structured output feature? How is the new structured output different from the previous implementation?

## Enhanced Structured Output Validation

Overview  
When you provide a valid JSON schema in the `output_schema` field, CodeMie workflows automatically enforce structured output using LangChain's native `with_structured_output()` method. This provides enhanced reliability, better error handling, and improved schema validation compared to the previous implementation.

How It Works

- **Automatic Activation**: The enhanced structured output validation activates automatically when a valid JSON schema is provided in the `output_schema` field
- **Framework Integration**: Uses LangChain's `with_structured_output()` method instead of custom prompt engineering
- **Model Compatibility**: Supports both tool calling and JSON mode based on your model's capabilities
- **Error Handling**: Includes built-in handling for structured output generation refusal and malformed outputs

## Example Configuration

```yaml
assistants:
  - id: business_analyst
    system_prompt: |
      You are a skilled business analyst that can analyze requirements and build tasks for CodeMie AI projects
    model: 'gpt-4o-2024-11-20'

states:
  - id: business_analysis
    assistant_id: business_analyst
    task: |
      Provide requirements for the provided task and indicate if it is an AI project.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "requirements": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "is_ai_project": {
            "type": "boolean"
          }
        },
        "required": ["requirements", "is_ai_project"],
        "additionalProperties": false
      }
    next:
      condition:
        expression: "is_ai_project == True"
        then: ai_development_plan
        otherwise: development_plan
```

Benefits

- **Enhanced Reliability**: Framework-native structured output handling reduces parsing errors
- **Better Validation**: Automatic schema validation ensures outputs match expected structure
- **Improved Error Handling**: Built-in error handling for malformed or refused outputs
- **Backward Compatibility**: Existing workflows continue to work without modification
- **Reduced Complexity**: Less manual prompt engineering required for structured outputs

Important Notes

- The enhanced structured output feature requires a **valid JSON schema** in the `output_schema` field
- Invalid or missing schemas will fall back to the previous implementation
- The feature works with all supported LLM models but behavior may vary based on model capabilities
- Error handling includes automatic retries and fallback mechanisms for refused outputs

## Sources

- [Advanced Features](https://docs.codemie.ai/user-guide/workflows/configuration/advanced-features)
- [Configuration Reference](https://docs.codemie.ai/user-guide/workflows/configuration/configuration-reference)
