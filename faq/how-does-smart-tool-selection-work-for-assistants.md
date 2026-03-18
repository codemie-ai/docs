# How does Smart Tool Selection work for assistants? What is the Smart Tool Selection toggle and how do I use it? Can assistants automatically select tools based on conversation context?

Smart Tool Selection is an intelligent feature that automatically selects relevant tools for your assistant based on semantic similarity, configured credentials, and permissions.

1. Navigate to your assistant's **Create** or **Edit** page
2. Locate the **Smart Tool Selection** toggle
3. Enable or disable based on your needs:
   - **Disabled**: Uses the traditional manual tool selection approach
   - **Enabled**: Activates intelligent, automatic tool selection

When No Tools Are Pre-selected

- The system performs semantic analysis across all registered tools
- Tools are automatically selected based on:
  - **Semantic relevance** to your assistant's purpose and conversations
  - **Available credentials** and proper authentication
  - **User permissions** and access rights
- This ensures your assistant has access to the most relevant tools without manual configuration

When Tools Are Already Selected

- Smart selection is **limited to your pre-selected tools only**
- Prevents context overload by maintaining a focused tool set
- Provides intelligent selection within your curated tool collection

Workflow Operations

- **Workflows always use the legacy/traditional approach**
- The Smart Tool Selection toggle **does not affect workflow behavior**
- This ensures workflow consistency and predictable execution

Context Management

- Smart selection prevents LLM context overload
- Maintains optimal performance by limiting tool scope
- Balances capability with efficiency

When to Use Smart Tool Selection

**Enable Smart Tool Selection when:**

- You want automatic, intelligent tool discovery
- Your assistant needs dynamic tool access based on conversation context
- You prefer minimal manual tool configuration

**Keep it Disabled when:**

- You need precise control over tool availability
- You're working with sensitive tools requiring explicit selection
- You prefer the traditional manual approach

## Error Handling

If credential or permission issues occur during smart selection:

- The system provides clear error messages
- Alternative tools may be suggested when available
- Manual tool selection remains available as a fallback

## Sources

- [Overview](https://docs.codemie.ai/user-guide/tools_integrations/tools/overview)
- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
