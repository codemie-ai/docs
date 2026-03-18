# Workflow example without condition?

assistants:

- id: business_analyst Unique identifier for the assistant in this configuration  
  assistant_id: 196ede41-e7f0-4658-ae99-1dc0d83c8347 CodeMie assistant ID  
  model: 'gpt-4o' Optional model override
- id: onboarder  
  assistant_id: d09ec675-16db-4aba-901d-1fff17d84692  
  model: 'gpt-4o' Optional model override

states:

- id: onboarder Unique identifier for the state in this configuration  
  assistant_id: onboarder  
  task: |  
   Find all relevant information about workflow implementation and describe it as a requirements description for a business analyst.  
  next:  
   state_id: business_analyst Unique identifier for the next state
- id: business_analyst Unique identifier for the state in this configuration  
  assistant_id: business_analyst  
  task: |  
   You must analyze all provided requirements about workflows functionality and put a comprehensive description for QA  
   engineers, support team, and users on how to use this functionality with key points into a comment for Jira ticket EPMCDME-1350.  
  output_schema: |  
   {  
   "success": "Boolean true | false. If you created the Jira comment successfully return true, otherwise false",  
   "comment_body": "Return the comment body which you left in Jira"  
   }  
  next:  
   state_id: end

## Sources

- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
