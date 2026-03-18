# Workflow example with custom tools and with variable passing?

assistants:

- assistant_id: b664fcd3-e797-45e8-aac4-660ccfed27d5  
  id: cpp-assistant  
  model: gpt-4o  
  system_prompt: "Assume that you are experienced C++ developer with huge experience\  
   \ in gtest and gmock. \nYou MUST show values of all input parameters\nAfter that\  
   \ you MUST analyze given `cpp_file` and return path and filename for given cpp\  
   \ file\nYou CANNOT call \_cpp_data_transfer_test_tool BECAUSE it is called by workflow\  
   \ in previous steps\nUse ONLY the newest message in provided history\n"

states:

- id: cpp_data_transfer_tool  
  next:  
   switch:  
   cases:
  - condition: next_step == "create_test"  
     state_id: cpp-assistant  
     default: end  
    tool_id: cpp_data_transfer_tool
- assistant_id: cpp-assistant  
  id: cpp-assistant  
  next:  
   state_id: cpp_data_transfer_tool  
  output_schema: "{ \n \"cpp_file\" : \"cpp_file , the full filename returned from\  
   \ the previous state in this workflow\",\n \"cpp_test\" : \"generated cpp_test\"\  
   ,\n \"vcxproj\" : \"vcxproj file containing cpp_test\",\n \"work_dir\"\  
   \ : \"working directory\" \n \n}\n"  
  task: 'Look ONLY on the latest json content which had latest iteration field value  
   in provided history'

tools:

- id: cpp_data_transfer_tool  
  tool: \_cpp_data_transfer_test_tool  
  tool_args:  
   cpp_file: '{{cpp_file}}'  
   cpp_test: '{{cpp_test}}'  
   vcxproj: '{{vcxproj}}'  
   work_dir: '{{work_dir}}'

## Sources

- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
