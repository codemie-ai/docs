# Does CodeMie use customer data to train AI models?

No. CodeMie does not use customer data to train AI models.

Prompts, chat messages, indexed data sources (Git repositories, Jira, Confluence, files), and AI-generated outputs are used exclusively to deliver the requested assistant functionality within your deployment. No data is used for model training or improvement.

**LLM provider guarantees**

When CodeMie forwards a prompt to an external LLM provider (e.g., Azure OpenAI, AWS Bedrock, Google Vertex AI, Anthropic), the enterprise agreements with these providers guarantee:

- Prompts and completions are not available to other customers
- Data is not used to improve LLM models or any third-party products
- Models are stateless unless explicitly fine-tuned with customer data
- Any fine-tuned models remain exclusively available to the client

**Integration credentials are never sent to LLM models**

API keys, passwords, and datasource credentials are encrypted (KMS/Vault) and exist as plaintext only in memory for the duration of a single API call. They are never included in prompts or persisted to disk.

## Sources

- [Security & Data Processing](https://docs.codemie.ai/admin/security)
