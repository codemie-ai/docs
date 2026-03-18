# Workflow example for sequential workflow with retries?

assistants:

- id: python-developer  
  assistant_id: 312fcd3b-e4be-44a4-af5d-70467d2ab4af  
  model: gpt-4
- id: business-analytic  
  assistant_id: ac58d2da-ddfa-4963-987c-d8d64f97ec66  
  model: gpt-4
- id: git-expert  
  assistant_id: 0d39c3c9-08e3-4a97-b25b-26a01efea32b  
  model: gpt-4
- id: code-reviewer  
  assistant_id: a9793973-4afa-4c29-8f0e-31ac22ef85c4  
  model: gpt-4

retry_policy:  
 initial_interval_seconds: 5.0 Amount of time that must elapse before the first retry occurs. In seconds  
 backoff_factor: 5.0 Multiplier by which the interval increases after each retry  
 max_interval_seconds: 50.0 Maximum amount of time that may elapse between retries. In seconds.  
 max_attempts: 5 Maximum number of attempts to make before giving up, including the first

states:

- id: task-retriever  
  assistant_id: business-analytic  
  task: |  
   Get description of jira ticket provided by user.  
   Return only description of the ticket  
  output_schema: |  
   {  
   "success": "True | False.  
   If description of jira ticket is empty return False, otherwise True",  
   "task": "Return the feedback on code changes if any"  
   }  
  next:  
   state_id: python-developer
- id: python-developer  
  assistant_id: python-developer  
  task: |  
   Implement task according to description  
  next:  
   state_id: codereview  
  retry_policy:  
   initial_interval_seconds: 1.0 Amount of time that must elapse before the first retry occurs. In seconds  
   backoff_factor: 1.0 Multiplier by which the interval increases after each retry  
   max_interval_seconds: 10.0 Maximum amount of time that may elapse between retries. In seconds.  
   max_attempts: 1 Maximum number of attempts to make before giving up, including the first
- id: codereview  
  assistant_id: code-reviewer  
  task: |  
   Provide feedback on updated code  
  output_schema: |  
   {  
   "success": "True | False.  
   If you haven't found any issues in review True, otherwise False",  
   "feedback": "Return the feedback on code changes if any"  
   }  
  next:  
   condition:  
   expression: "success==True"  
   then: end  
   otherwise: python-developer

## Sources

- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
