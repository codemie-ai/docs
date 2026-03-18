# Workflow example with virtual assistant?

states:

- id: get_a_jira_ticket  
  next:  
   state_id: end  
  tool_args:  
   method: GET  
   relative_url: /rest/api/2/issue/EPMCDME-3226  
  tool_id: jira_tool  
  next:  
   state_id: analyzer
- id: analyzer  
  assistant_id: analyzer  
  task: |  
   Get context to resolve this Jira ticket. Return plan for implementation for given issue.  
  next:  
   state_id: end

tools:

- id: jira_tool  
  integration_alias: CodeMie Jira  
  tool: generic_jira_tool

Available tools: ['create_branch', 'set_active_branch', 'list_branches_in_repo', 'create_file', 'update_file', 'update_file_diff', 'delete_file',
'create_pull_request', 'get_pr_changes', 'create_pr_change_comment', 'github', 'gitlab', 'get_repository_file_tree_v2', 'search_code_repo_v2',
'read_files_content', 'read_files_content_summary', 'Sonar', 'google_search_tool_json', 'google_places', 'google_places_find_near', 'wikipedia',
'tavily_search_results_json', 'web_scrapper', 'Kubernetes','AWS', 'GCP', 'Azure', 'AzureDevops', 'keycloak', 'generic_jira_tool', 'generic_confluence_tool',
'open_api', 'open_api_spec', 'Email', 'Telegram', 'elastic', 'sql', 'read_file_from_file_system', 'write_file_to_file_system', 'list_directory_from_file_system',
'run_command_line_tool', 'diff_update_file_tool', 'str_replace_editor', 'ZephyrCloud', 'ZephyrSquadTool']

assistants:

- id: analyzer  
  model: 'gpt-4o-2024-11-20'  
  system_prompt: |  
   Search over codebase and give plan how to resolve given Jira ticket  
  datasource_ids:
  - ac58d2da-ddfa-4963-987c-d8d64f97ec66 codemie-backend
  - 06847850-f8c0-4986-8b48-75f1974c2215 codemie-frontend  
    tools:
  - search_code_repo_v2  
    exclude_extra_context_tools: true

## Sources

- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
