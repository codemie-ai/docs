# How to set temperature for virtual assistants in workflow? Allow temperature setting for virtual assistants defined in workflow YAML?

temperature: The temperature setting (0.0 to 2.0) that controls randomness in responses. Lower values (e.g., 0.1) produce more deterministic outputs, while higher values (e.g., 1.0) produce more creative responses.

## Example Usage with Temperature Setting:

assistants:

- id: analyzer  
  model: 'gpt-4o'  
  system_prompt: |  
   You are a code analyzer. Review the provided code for potential issues.  
  temperature: 0.2 Lower temperature for more deterministic analysis  
  datasource_ids:
  - ac58d2da-ddfa-4963-987c-d8d64f97ec66 repository datasource  
    tools:
  - name: search_code_repo_v2

- id: creative_writer  
  model: 'gpt-4o'  
  system_prompt: |  
   You are a creative technical writer. Generate engaging documentation.  
  temperature: 0.8 Higher temperature for more creative outputs  
  datasource_ids:
  - 06847850-f8c0-4986-8b48-75f1974c2215 documentation datasource

## Sources

- [Configuration Reference](https://docs.codemie.ai/user-guide/workflows/configuration/configuration-reference)
- [Llm Model Name In Workflow](https://docs.codemie.ai/user-guide/workflows/llm-model-name-in-workflow)
