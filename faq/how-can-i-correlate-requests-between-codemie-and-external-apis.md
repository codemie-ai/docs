# How can I correlate requests between CodeMie and external APIs? What is the metadata field used for in Assistants API requests? How do I pass a callback ID from CodeMie to external services?

## Using Metadata and Callback Headers in Assistants API

What is the metadata field in Assistants API requests?  
The metadata field in Assistants API requests allows you to include additional information that can be used for various purposes, including request correlation. One important use case is providing a `callback_id` that gets forwarded to downstream services.

How to use the callback_id for request correlation  
When you need to correlate requests between systems, you can include a `callback_id` in the metadata object of your Assistants API request. This ID will be forwarded as a `callback-id` HTTP header when the OpenAPI tool makes outgoing requests.

Example Request to POST /assistants:

```json
{
  "conversationId": "463b5a69-d8b8-4dd6-9dc9-18d901dfb93a",
  "text": "Make a request to this endpoint: https://example.com/api/data",
  "stream": false,
  "metadata": {
    "callback_id": "request-12345"
  }
}

## Sources

- [API Overview](https://docs.codemie.ai/user-guide/api/)
```
