# How to Use Structured Outputs with Assistants API and SDK? How to get structured JSON responses from Assistants API? Using Pydantic models with CodeMie SDK structured outputs? AssistantChatRequest output_schema parameter examples? Streaming structured outputs with Assistants API JSON schema validation in CodeMie API responses?

## Structured Outputs with Assistants API and SDK

Overview  
The Assistants API and CodeMie SDK now support structured outputs, allowing you to enforce specific response formats using Pydantic models or JSON schemas. This feature enables developers to seamlessly integrate LLM structured outputs into their applications, leveraging structured data for complex operations and improved data management.

Prerequisites  
Before using structured outputs, ensure you have:

- CodeMie SDK installed and configured
- Valid API credentials (see: [How to work with CodeMie API])
- Assistant ID for your target assistant

SDK Installation Quick Start

```bash
pip install codemie-sdk
```

For detailed setup instructions, see: [How to Create a Client in Keycloak for SDK?]

## Using Pydantic Models (Python SDK)

```python
from pydantic import BaseModel
from codemie_sdk import AssistantChatRequest, CodeMieClient

class OutputSchema(BaseModel):
    requirements: list[str]
    priority: str
    estimated_hours: int
    complexity_score: float

Initialize client:
client = CodeMieClient(
    api_domain="https://codemie.lab.epam.com/code-assistant-api",
    username="your-username",
    password="your-password",
    auth_client_id="codemie-sdk"
)

Using Pydantic model for structured output:
chat_request = AssistantChatRequest(
    text="Analyze this project requirements and provide structured analysis",
    stream=False,
    output_schema=OutputSchema
)

response = client.assistants.chat("assistant_id", chat_request)
response.generated is a Pydantic object with type safety
print(f"Requirements: {response.generated.requirements}")
print(f"Priority: {response.generated.priority}")
print(f"Estimated Hours: {response.generated.estimated_hours}")
```

## Common Use Cases

1. Project Analysis

```python
class ProjectAnalysis(BaseModel):
    tasks: list[str]
    risks: list[str]
    timeline_weeks: int
    tech_stack: list[str]

Get structured project analysis
request = AssistantChatRequest(
    text="Analyze this project proposal for feasibility",
    output_schema=ProjectAnalysis
)
```

2. Code Review Results

```python
class CodeReviewResult(BaseModel):
    issues_found: list[str]
    suggestions: list[str]
    quality_score: int
    approved: bool
```

3. Data Processing Results

```python
class DataSummary(BaseModel):
    total_records: int
    categories: dict[str, int]
    anomalies: list[str]
```

## Troubleshooting

**Common Issues:**

1. **Schema Validation Errors**
   - Ensure your Pydantic model matches expected output structure
   - Check that all required fields are specified
   - Verify data types match your schema

2. **SDK Connection Issues**
   - Verify API credentials are correctly configured
   - Check network connectivity to CodeMie API
   - Ensure proper authentication setup

3. **Structured Output Not Returned**
   - Confirm backend structured outputs are enabled for your assistant
   - Verify the LLM model supports structured outputs
   - Check that `output_schema` parameter is properly set

## Advanced Configuration

Custom Validation:

```python
from pydantic import BaseModel, validator

class CustomOutput(BaseModel):
    priority: str
    score: int

    @validator('priority')
    def priority_must_be_valid(cls, v):
        if v not in ['low', 'medium', 'high', 'critical']:
            raise ValueError('Priority must be: low, medium, high, or critical')
        return v

    @validator('score')
    def score_range(cls, v):
        if not 1 \<= v \<= 10:
            raise ValueError('Score must be between 1 and 10')
        return v
```

Related Documentation

- [How to Create a Client in Keycloak for SDK?] - SDK setup and authentication
- [How to work with CodeMie API?] - API credentials and authentication
- [Enhanced Structured Output Validation] - Workflow-specific structured outputs

Benefits

- **Type Safety**: Direct integrations with Pydantic models provides compile-time type checking
- **Consistency**: Guaranteed response format structure across all assistant calls
- **Integration**: Seamless integrations into existing applications and workflows
- **Validation**: Automatic schema validation and error handling
- **Flexibility**: Support for both streaming and non-streaming modes
- **Developer Experience**: Improved SDK usability for complex operations

Important Notes

- Structured outputs require backend support (already implemented)
- Compatible with all supported LLM models
- Response parsing is handled automatically by the SDK
- Works with both streaming and non-streaming requests
- Supports complex nested schemas and custom validation

Related Features

- For API authentication, see: [How to work with CodeMie API](<[https://gitbud.epam.com/epm-cdme/codemie-sdk/-/blob/main/sdk/codemie-python/README.md?ref_type=heads#:~:text=Utilize%20structured%20outputs%20with%20Assistant](https://gitbud.epam.com/epm-cdme/codemie-sdk/-/blob/main/sdk/codemie-python/README.md?ref_type=heads#:~:text=Utilize%20structured%20outputs%20with%20Assistant)>)

## Sources

- [Client Secret Access](https://docs.codemie.ai/user-guide/api/client-secret-access)
