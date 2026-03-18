# What types of Data Source can I add to the CodeMie platform?

You can add the following Data Sources to the CodeMie platform:

| Data Source Type    | Automatic Scheduler Support |
| ------------------- | --------------------------- |
| Git Repositories    | ✅ Available                |
| Confluence          | ✅ Available                |
| Jira                | ✅ Available                |
| Google Docs         | ✅ Available                |
| AWS Knowledge Bases | ✅ Available                |
| X-ray               | ✅ Available                |
| File                | ❌ Not available            |
| Provider            | ❌ Not available            |

**Git Repositories**

- Connect and index code repositories
- Supports automatic scheduled synchronization

**Confluence**

- Integrate Confluence spaces and pages
- Supports automatic scheduled synchronization

**Jira**

- Connect Jira projects and issues using JQL queries
- Supports automatic scheduled synchronization
- Includes incremental indexing capability

**Google Docs**

- Import Google Docs documents
- Supports automatic scheduled synchronization

**AWS Knowledge Bases**

- Integrate AWS Bedrock Knowledge Bases
- Supports automatic scheduled synchronization
- Requires AWS integration configuration

**X-ray**

- Connect X-ray test management data
- Supports automatic scheduled synchronization

**File**

- Upload local files: PDF (including documents with images), TXT, CSV, JSON
- Manual reindexing only (no automatic scheduler)
- Max file size: 50MB
- JSON files require special format:

Choose the type that best fits the data you want to incorporate into your assistant.

**Note:** XML files are no longer supported as a Data Source format.

Naming restrictions for Data Source

- Only lowercase letters are allowed
- Names should not begin with an underscore (\_) or a hyphen (-)
- Spaces, commas, and special characters (:, ", \*, +, /, , |, ?, , >, \<) are prohibited
- Max size of file: 50Mb

**Important:** JSON files as a datasource require a special format to be indexed properly. It allows users to add custom data with efficient ability to search and process any data.  
The format should be the following:

```json
[
  {
    "content": "textual content",
    "metadata": {
      "source": "some data",
      "unit": "some data",
      ... any other keys/values
    }
  }
]
```

## Sources

- [Add Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources)
