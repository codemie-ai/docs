# Workflow example with iterative task processing?

assistants:

- id: researcher  
  assistant_id: 4506fe67-e6b8-4154-b187-27fead1432e5  
  model: 'gpt-4o'
- id: image-vision  
  assistant_id: 97b48860-5cf2-4a6b-a8b9-2210a484f756  
  model: 'gpt-4o'
- id: gpt-summ  
   assistant_id: b6bf2a41-d7c7-438d-9a85-9c64df937741  
   model: 'gpt-4o'  
  states:
- id: image-describer  
  assistant_id: image-vision  
  task: |  
   Describe the given image and provide only the major entities to search for information about them.  
   I need a list of the main entities to search for later.  
  output_schema: | Format of results for iteration with the next node  
   {  
   "entities": "List of main entity names"  
   }  
  next:  
   state_id: researcher ID of the next state to transition to  
   iter_key: entities Key for results iteration, must be same as in schema
- id: researcher  
  assistant_id: researcher  
  task: |  
   You must find relevant documentation with 2-3 links to learn about each component from the previous step.  
   Make sure that you return a valid JSON object. You do not need to process the image, just search for documentation for the given item.  
  output_schema: |  
   {  
   "success": "True | False. If link is returned - True, otherwise False",  
   "comment_body": "Return documentation for the given object"  
   }  
  next:  
   state_id: summarizer
- id: summarizer  
  assistant_id: gpt-summ  
  task: |  
   Generate a single article with documentation from the given doc parts.  
  output_schema: |  
   {  
   "documentation": "Return single documentation"  
   }  
  next:  
   state_id: end

## Sources

- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
- [Advanced Features](https://docs.codemie.ai/user-guide/workflows/configuration/advanced-features)
