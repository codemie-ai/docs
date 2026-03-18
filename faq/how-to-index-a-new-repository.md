# How to index a new repository? How to add a new repository? How to add code into AI/Run CodeMie?

Note: before adding a new Git Repository, make sure that Git credentials are populated in the “integration” tab for a particular Git domain (check: How do I use a temporary access token for private repositories?)  
Navigate to the 'Add new Git repository' action on the sidebar.  
To add your codebase to the AI/Run CodeMie platform, follow these steps:

1. Select your desired indexing mode. The options are:
   - Whole codebase: Directly splits and indexes the raw code.
   - Summarization per file: Generates summaries for code files and indexes them.
   - Summarization per chunks: Recommended. Generates summaries for code chunks and indexes both summaries and raw code. Indexing may take 30-60 minutes. (LEGACY approach).
2. Provide your desired Repository Name, ensuring it is all lowercase and avoids starting with \_ or -, and does not include spaces or restricted characters (:, ", \*, +, /, , |, ?, , >, \<).
3. Provide the repository link or upload your codebase. For private GIT repositories, use a temporary access token in the User integrations section.
4. Specify the target branch you wish to work with.
5. Specify relevant file extensions in File Types to index. You can list multiple extensions or exact file names. Leaving this field empty will index all files, which might lower the quality due to non-relevant files. E.g. ".java", ".yaml", ".js" - or you can specify multiple file extensions as comma-separated ".java,.yaml,.js" (without quotes). Also you can mention exact file names like "README.md,build.gradle,.groovy". Note: if you leave this field as empty, it will index all existing files, thus the quality may be worse, because of some rubbish files, e.g. css, images, etc. Please don’t index images at all.
   Filter behavior:
   - **Empty filter**: Include all files
   - **Patterns** (e.g., `*.py`): Include ONLY matching files (whitelist)
   - **!Patterns** (e.g., `!*.nupkg`): EXCLUDE matching files (blacklist)
   - **Combined** (e.g., `*.py,!test_*.py`): Include .py files except test\_\*.py files
     Examples:
   - Python projects: `*.py` - Only Python files
   - JavaScript/TypeScript: `*.js,*.ts,*.tsx,*.jsx` - Only JS/TS files
   - Exclude binaries: `!*.nupkg,!*.dll,!*.exe` - Exclude package and binary files
   - Java source only: `src/**/*.java` - Only Java files in src directory
   - Python without tests: `*.py,!test_*.py,!*_test.py` - Python files excluding tests
   - Documentation only: `*.md,*.rst,*.txt` - Only documentation files
6. (Optional) Set the Project-space visible setting to control who can see the indexed repository.
7. (Optional) Specify prompts for generating documentation.
8. (Optional) Select to generate and upload documentation for the indexed data in markdown format.
9. Click the “Create” button and wait for the process to finish.

## Sources

- [Add Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources)
- [Indexing Data Sources](https://docs.codemie.ai/user-guide/data-source/data-source-overview/indexing-data-sources)
