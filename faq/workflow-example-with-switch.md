# Workflow example with switch?

enable_summarization_node: false

assistants:

- id: analyzer  
  assistant_id: 06847850-f8c0-4986-8b48-75f1974c2215  
  model: 'gpt-4o'
- id: documentation  
  assistant_id: 06847850-f8c0-4986-8b48-75f1974c2215  
  model: 'gpt-4o'

states:

- id: analyzer ID of state inside this configuration  
  assistant_id: analyzer  
  task: |  
   Analyze provided a code base for programming languages.  
  output_schema: |  
   {  
   "language": "Whether it's Java, Python or others"  
   }  
  next:  
   switch:  
   cases:
  - condition: "language == 'Java'"  
    state_id: documentation_java
  - condition: "language == 'Python'"  
    state_id: documentation_python  
    default: unknown_language
- id: documentation_java  
  assistant_id: documentation  
  task: |  
   Describe code in Java  
  next:  
   state_id: end
- id: documentation_python  
  assistant_id: documentation  
  task: |  
   Describe code in Python  
  next:  
   state_id: end
- id: unknown_language  
  assistant_id: documentation  
  task: |  
   Describe code provided  
  next:  
   state_id: end

## Sources

- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
- [State Transitions](https://docs.codemie.ai/user-guide/workflows/configuration/state-transitions)
