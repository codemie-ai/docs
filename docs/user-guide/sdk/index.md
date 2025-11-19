---
id: sdk
title: SDK
sidebar_label: SDK
sidebar_position: 1
---

# SDK (Software Development Kit)

The AI/Run CodeMie SDK (Software Development Kit) provides programmatic access to the CodeMie platform, enabling developers to integrate CodeMie capabilities into their own applications, tools, and workflows.

## What is the CodeMie SDK?

The CodeMie SDK is a set of tools, libraries, and APIs that allow developers to:

- **Integrate AI Capabilities**: Embed CodeMie assistants into custom applications
- **Automate Workflows**: Programmatically execute tasks and processes
- **Build Custom Solutions**: Create tailored tools using CodeMie's infrastructure
- **Extend Functionality**: Develop plugins and integrations
- **Access Platform Features**: Interact with assistants, data sources, and tools via API

## SDK Components

### REST API

The primary interface for interacting with CodeMie programmatically:

- **Assistant API**: Create, configure, and interact with assistants
- **Chat API**: Send messages and receive responses
- **Project API**: Manage projects and resources
- **Data Source API**: Configure and manage data sources
- **Tool API**: Access and configure assistant tools
- **User API**: Manage user accounts and permissions

### Client Libraries

Official client libraries for popular programming languages:

- **Python SDK**: Python bindings for CodeMie API
- **JavaScript/TypeScript SDK**: Node.js and browser-compatible libraries
- **Java SDK**: Java client for enterprise applications
- **Other Languages**: Community-maintained libraries for additional languages

### CLI Tools

Command-line interfaces for automation and scripting:

- **CodeMie CLI**: Main command-line tool for platform interaction
- **Plugin CLI**: Development environment plugin (`codemie-plugin`)
- **Deployment Tools**: Infrastructure and component deployment scripts

## Getting Started with the SDK

### Prerequisites

- **CodeMie Account**: Active account with appropriate permissions
- **API Credentials**: API key or authentication token
- **Development Environment**: Supported programming language runtime

### Basic Setup

1. **Obtain API Credentials**
   - Log in to CodeMie
   - Navigate to Settings > API Keys
   - Generate a new API key
   - Store the key securely

2. **Install SDK Library**

   For Python:
   ```bash
   pip install codemie-sdk
   ```

   For Node.js:
   ```bash
   npm install @codemie/sdk
   ```

3. **Configure Authentication**

   ```python
   from codemie import CodeMieClient

   client = CodeMieClient(api_key='your-api-key')
   ```

4. **Make Your First API Call**

   ```python
   # List available projects
   projects = client.projects.list()

   # Create a chat session
   chat = client.chats.create(
       assistant_id='assistant-123',
       message='Hello, CodeMie!'
   )
   ```

## Common Use Cases

### Custom Application Integration

Integrate CodeMie into your applications:

```python
# Example: Customer support chatbot integration
def handle_customer_query(query):
    response = client.chats.send_message(
        assistant_id='support-assistant',
        message=query
    )
    return response.content
```

### Automated Workflows

Build automated processes:

```python
# Example: Automated code review workflow
def review_pull_request(pr_url):
    # Get code changes
    code_diff = get_pr_diff(pr_url)

    # Send to review assistant
    review = client.chats.create(
        assistant_id='code-reviewer',
        message=f'Please review this code:\n{code_diff}'
    )

    return review.content
```

### Batch Processing

Process multiple items programmatically:

```python
# Example: Batch document processing
def process_documents(documents):
    results = []
    for doc in documents:
        analysis = client.chats.create(
            assistant_id='document-analyzer',
            message=f'Analyze this document:\n{doc}'
        )
        results.append(analysis)
    return results
```

### Custom Dashboards

Build monitoring and analytics tools:

```python
# Example: Usage analytics dashboard
def get_usage_stats():
    stats = {
        'total_chats': client.analytics.chat_count(),
        'active_assistants': client.assistants.count(status='active'),
        'token_usage': client.analytics.token_usage()
    }
    return stats
```

## SDK Features

### Assistant Management

- Create and configure assistants programmatically
- Update system instructions and settings
- Enable/disable tools and integrations
- Manage assistant lifecycle

### Conversation Handling

- Start new chat sessions
- Send messages and receive responses
- Stream responses for real-time interaction
- Manage conversation context and history

### Data Source Integration

- Configure data sources via API
- Trigger indexing operations
- Monitor indexing status
- Query indexed content

### Tool Configuration

- Enable tools for assistants
- Configure tool parameters
- Add custom tool integrations
- Manage tool credentials

### Workflow Automation

- Create and execute workflows
- Chain multiple assistants
- Handle complex multi-step processes
- Monitor workflow execution

## API Authentication

### API Key Authentication

Basic authentication using API keys:

```python
client = CodeMieClient(api_key='your-api-key')
```

### OAuth 2.0

For user-facing applications:

```python
from codemie.auth import OAuth2Client

auth_client = OAuth2Client(
    client_id='your-client-id',
    client_secret='your-client-secret'
)

# Get authorization URL
auth_url = auth_client.get_authorization_url()

# Exchange code for token
token = auth_client.exchange_code(authorization_code)
```

### Service Accounts

For server-to-server communication:

```python
from codemie.auth import ServiceAccountClient

client = ServiceAccountClient(
    credentials_file='service-account.json'
)
```

## Best Practices

### Security

- **Secure Credentials**: Never hardcode API keys in source code
- **Use Environment Variables**: Store credentials in environment variables
- **Rotate Keys Regularly**: Implement key rotation policies
- **Limit Scope**: Use minimum required permissions
- **Monitor Usage**: Track API usage and detect anomalies

### Performance

- **Connection Pooling**: Reuse HTTP connections for better performance
- **Caching**: Cache responses when appropriate
- **Batch Operations**: Combine multiple operations when possible
- **Async Requests**: Use async/await for concurrent operations
- **Rate Limiting**: Respect API rate limits

### Error Handling

- **Handle Errors Gracefully**: Implement proper error handling
- **Retry Logic**: Add retry mechanisms for transient failures
- **Logging**: Log API calls and errors for debugging
- **Validation**: Validate inputs before making API calls
- **Timeouts**: Set appropriate timeouts for requests

### Code Organization

- **Separate Concerns**: Keep API logic separate from business logic
- **Use Abstractions**: Create service layers for API interactions
- **Configuration Management**: Centralize configuration
- **Testing**: Write tests for API integrations
- **Documentation**: Document API usage in your code

## API Rate Limits

CodeMie API implements rate limiting to ensure fair usage:

- **Standard Tier**: 100 requests per minute
- **Premium Tier**: 1000 requests per minute
- **Enterprise Tier**: Custom limits

Handle rate limits in your code:

```python
from codemie.exceptions import RateLimitError
import time

def make_api_call_with_retry(func, max_retries=3):
    for attempt in range(max_retries):
        try:
            return func()
        except RateLimitError as e:
            if attempt < max_retries - 1:
                time.sleep(e.retry_after)
            else:
                raise
```

## SDK Examples

### Example 1: Chat Integration

```python
from codemie import CodeMieClient

client = CodeMieClient(api_key='your-api-key')

# Start a conversation
chat = client.chats.create(
    project_id='project-123',
    assistant_id='assistant-456'
)

# Send a message
response = chat.send_message('What is CodeMie?')
print(response.content)

# Continue the conversation
response = chat.send_message('How do I create an assistant?')
print(response.content)
```

### Example 2: Assistant Creation

```python
# Create a new assistant
assistant = client.assistants.create(
    name='Code Review Assistant',
    description='Assists with code reviews',
    system_instructions='You are a helpful code reviewer...',
    model='claude-sonnet-4-5',
    tools=['codebase-search', 'git']
)

print(f'Created assistant: {assistant.id}')
```

### Example 3: Workflow Automation

```python
# Automated document processing workflow
def process_document_workflow(document_content):
    # Step 1: Analyze document
    analysis = client.chats.create(
        assistant_id='analyzer',
        message=f'Analyze: {document_content}'
    )

    # Step 2: Generate summary
    summary = client.chats.create(
        assistant_id='summarizer',
        message=f'Summarize: {analysis.content}'
    )

    # Step 3: Extract key points
    key_points = client.chats.create(
        assistant_id='extractor',
        message=f'Extract key points: {summary.content}'
    )

    return {
        'analysis': analysis.content,
        'summary': summary.content,
        'key_points': key_points.content
    }
```

## Troubleshooting

### Common Issues

**Authentication Errors**
- Verify API key is correct
- Check key hasn't expired
- Ensure proper permissions

**Connection Errors**
- Check network connectivity
- Verify API endpoint URL
- Check firewall settings

**Rate Limit Errors**
- Implement exponential backoff
- Reduce request frequency
- Consider upgrading tier

**Timeout Errors**
- Increase timeout settings
- Check assistant response time
- Verify network stability

## API Documentation

For detailed API reference documentation:

- **API Reference**: Full endpoint documentation with request/response examples
- **SDK Documentation**: Language-specific SDK guides and API references
- **OpenAPI Specification**: Machine-readable API specification
- **Postman Collection**: Pre-configured API requests for testing

## Support and Resources

### Documentation

- API Reference Guide
- SDK Tutorials and Examples
- Integration Guides
- Best Practices Documentation

### Community

- Developer Forum
- GitHub Repository
- Stack Overflow Tag
- Discord Channel

### Support Channels

- Technical Support: For SDK-related issues
- FAQ Assistant: Quick answers to common questions
- Documentation: Comprehensive guides and references

## Advanced Topics

### Webhooks

Set up webhooks for event-driven architecture:
- Chat completion events
- Assistant status changes
- Workflow completion notifications
- Error and warning alerts

### Custom Integrations

Build custom integrations:
- Custom tool development
- Plugin creation
- MCP server implementation
- Third-party service connectors

### Enterprise Features

Enterprise-specific SDK capabilities:
- Single Sign-On (SSO) integration
- Advanced security controls
- Audit logging
- Custom deployment options

## Getting Help

For SDK assistance:
- Review the API documentation and examples
- Check the SDK GitHub repository for issues and discussions
- Use the FAQ Assistant for quick questions
- Contact technical support for integration assistance
- Join the developer community for peer support
