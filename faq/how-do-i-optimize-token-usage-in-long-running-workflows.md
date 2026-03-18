# How do I optimize token usage in long-running workflows? What's the difference between Context Store and LLM message history? How can I use dynamic variables without including all previous messages? How do I configure workflow states to reduce token consumption?

The Context Store provides granular control over workflow state data, separating storage concerns from LLM communication for improved token efficiency and flexible state management.

## Configuration Flags

store_in_context  
Controls whether state outcomes are stored in the Context Store.

- **Default**: `true`
- **Usage**: Set to `false` to prevent storing state results

include_in_llm_history
Controls whether stored context is included in LLM message history.

- **Default**: `true`
- **Required**: `store_in_context` must be `true` when this is `true`

exclude_prior_messages  
Removes prior LLM messages for token efficiency while retaining Context Store data.

- **Default**: `false`
- **Benefit**: Reduces token usage while maintaining dynamic variable resolution

clear_context_store  
Resets accumulated outcomes in the Context Store.

- **Default**: `false`
- **Usage**: Use at workflow boundaries or state transitions

## Example Configuration

```yaml
states:
  - id: data_processor
    assistant_id: processor
    task: "Process the input data"
    store_in_context: true
    include_in_llm_history: false  # Save tokens
    next:
      state_id: analyzer

  - id: analyzer
    assistant_id: analyzer
    task: "Analyze using {{processed_data}}"  # Resolves from Context Store
    exclude_prior_messages: true  # Fresh LLM context
    next:
      state_id: end
```

Dynamic Variable Resolution  
Variables in `{{variable}}` format resolve primarily from the Context Store, ensuring reliable access to prior state outcomes even when LLM history is optimized.

Best Practices

- Use `include_in_llm_history: false` for intermediate processing states
- Apply `exclude_prior_messages: true` for token-intensive workflows
- Clear Context Store at logical workflow boundaries
- Validate flag combinations during configuration

## Sources

- [Context Management](https://docs.codemie.ai/user-guide/workflows/configuration/context-management)
- [Advanced Features](https://docs.codemie.ai/user-guide/workflows/configuration/advanced-features)
