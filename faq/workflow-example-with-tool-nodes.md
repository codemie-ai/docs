# Workflow example with tool nodes?

recursion_limit: 3

states:

- id: coder  
  assistant_id: coder  
  task: |  
   Generate code for a given programming language for base data class with base operations. If no programming language settled - use Python  
  output_schema: |  
   {  
   "success": "True | False. If code is provided - True, otherwise False",  
   "comment_body": "Return code for the given object"  
   }  
  next:  
   state_id: run_custom_tool
- id: run_custom_tool  
  next:  
   switch:  
   cases:
  - condition: "result == 'build_failed'"  
    state_id: echo
  - condition: "result == 'good_coverage'"  
     state_id: end  
     default: end  
    tool_args:  
     file_path: test  
    tool_id: test
- id: echo  
   next:  
   state_id: coder  
   tool_args:  
   command: "echo {{source_assembly_name}}"  
   tool_id: cli  
  tools:
- id: cli  
  integration_alias: 'local-plugin'  
  tool: \_run_command_line_tool  
  toolset: Plugin
- id: test  
  integration_alias: 'local-plugin'  
  tool: \_setup_test_project  
  toolset: Plugin

assistants:

- id: coder  
  model: 'gpt-4o-2024-11-20'

## Sources

- [Specialized Nodes](https://docs.codemie.ai/user-guide/workflows/configuration/specialized-nodes)
- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
