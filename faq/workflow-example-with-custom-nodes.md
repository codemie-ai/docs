# Workflow example with custom nodes?

type: code_comparator  
enable_summarization_node: false

custom_nodes:

- id: generate*repo_file_tree PREDEFINED node name that takes all files from provided datasource and filters by pattern  
  config:  
   datasource_id: e8355ab1-48b3-47d7-8290-7b87a8dc14e4 REQUIRED. ID of codemie datasource to get files from  
   file_filtering_pattern: .*.py Optional regexp format filter files from datasource, mutually exclusive with below documents*filter  
   documents_filter: | Optional gitignore format to filter files from datasource, exclusions starts with ! char, mutually exclusive with above file_filtering_pattern  
   *.py
- id: run_branch_comparator  
  config:  
   baseline_branch: main  
   custom_branch: custom  
   assistant_id: branch-comparator Link to assistant from assistants section. Used to compare branches
- id: run_report_generator Report is generated and stored in external storage either cloud or local FS. Depending on CodeMie configuration  
  config:  
   report_dir_name: branch-comparison-report

assistants:

- id: branch-comparator  
  assistant_id: fc83f97d-829b-4146-9bd5-63b97b2cb781  
  model: 'gpt-4o'  
  system_prompt: |  
   Find differences in functionality in {{baseline_branch}} using search. Use a search tool to find relevant context, you have this tool.  
   You'll be given a detailed explanation of code in simple words and you must identify whether this functionality is present in {{custom_branch}} branch.
  - Identify methods that exist in the provided summary and {{baseline_branch}} branch and compare their implementation.
  - Highlight methods that exist only in the provided summary.
  - Identify methods that exist only in the main branch (possibly removed in the summarized version).  
     Focus on the following:
    - Compare the method signatures.
    - Compare the logic within each method, detailing the differences and similarities (e.g., conditionals, loops, API calls, etc.).
      Resulting message should include:
  1. Main purpose of functionality
  2. What is different in the {{baseline_branch}} branch.  
      Pay attention to validation messages, codes, return values, variables, etc. You need to provide extensive  
      information so that person that will read your report could understand the difference and  
      assess complexity of changes that were made compared to {{baseline_branch}} branch branch.
     Structure the output clearly, with method names as headings and comparisons (if any) in bullet points under each heading.  
      File name: {{file}}.  
      Branch name: {{baseline_branch}}.  
      Summary of functionality: {{summary}}.

states:

- id: get_files_from_datasource  
  custom_node_id: generate_repo_file_tree  
  next:  
   state_id: compare_files
- id: compare_files  
  custom_node_id: run_branch_comparator  
  task: |  
   You need to search for similar functionality in the custom branch and report whether it is found or not by appending as many details as possible.  
  next:  
   state_id: generate_report_generator
- id: generate_report_generator  
  custom_node_id: run_report_generator  
  next:  
   state_id: end

## Sources

- [Specialized Nodes](https://docs.codemie.ai/user-guide/workflows/configuration/specialized-nodes)
- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
