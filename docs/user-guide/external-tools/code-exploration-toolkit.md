---
id: code-exploration-toolkit
title: Codebase Tools
sidebar_label: Codebase Tools
---

# Codebase Tools

Navigate and search code repositories with AI-powered tools.

Codebase Tools are specialized utilities designed to help users navigate and search data within code repositories. Similar to Linux tree commands but enhanced with AI-powered search capabilities, these tools make it easy to explore project structures and find specific code patterns.

## Prerequisites

:::note Required Data Source
Codebase Tools require a [Git data source](../../data-source/datasources-types/add-git-datasource) to function. Ensure you have added at least one Git repository as a data source before using these tools.
:::

Before using Codebase Tools, ensure you have:

- At least one Git data source configured in AI/Run CodeMie
- An assistant with Codebase Tools enabled
- Understanding of your repository structure
- Basic knowledge of code search patterns

## Overview

![Codebase Tools Introduction](./code-exploration-toolkit/codebase-tools-intro.png)

Codebase Tools work like a combination of the Linux `tree` command and an AI-powered search engine, enabling efficient navigation and intelligent code discovery within your repositories.

### Key Features

**Four main tool components:**

- **Get Repo Tree with filtering** - Builds hierarchical file trees for data sources
- **Search Code with filtering** - AI-powered search for patterns, keywords, and logical queries
- **Read Files Content** - Direct access to specific file content
- **Read Files Content With Summary** - Handles large files with automatic intelligent summarization

**Advanced capabilities:**

- Full content reading for files within token limits
- Automatic summarization for larger files while preserving key information
- Summary focus on main functionality, purpose, and key components
- Maintains original file source information throughout

## Tool Components

### 1. Get Repo Tree with Filtering

This tool allows assistants to build a file tree structure for a data source, providing a sorted file diagram of the repository.

**What it does:**
- Generates hierarchical view of repository files and directories
- Supports filtering to focus on specific file types or patterns
- Creates navigable structure similar to Linux `tree` command
- Works exclusively with Git data source types

**Use cases:**
- Understanding project structure
- Finding configuration files
- Locating specific directories
- Getting overview of repository organization

**Example queries:**
- "Show me the file structure of the repository"
- "List all directories in the project"
- "Display the repository tree for Python files only"
- "What's the folder structure of the src directory?"

### 2. Search Code with Filtering

A powerful AI-enhanced search tool that goes beyond simple text matching to understand logical patterns and queries.

**What it does:**
- Searches for files, text, and logical patterns
- Identifies keywords, function calls, imports, and declarations
- Understands contextual queries (e.g., "files that import numpy")
- Filters results based on complex criteria

**Advanced search capabilities:**
- Find files by content patterns
- Locate specific function definitions
- Search for import statements
- Identify class declarations
- Filter by multiple conditions simultaneously

**Example queries:**
- "Find files that import mathematical libraries"
- "Show code containing more than five class declarations"
- "Search for functions that handle authentication"
- "Locate files with database connection logic"

### 3. Read Files Content

Provides direct access to read the content of specific files within the code repository.

**What it does:**
- Reads complete file content when path is known
- Returns full text for files within token limits
- Useful for detailed file examination
- Efficient for pinpointing specific files

**When to use:**
- You know the exact file path
- Need detailed information about a particular file
- Want to review specific file content
- Require complete file text

**Usage:**
Simply provide the file path of the file you wish to read. The tool returns the complete content of the specified file or files.

**Example queries:**
- "Read the content of src/main.py"
- "Show me the README.md file"
- "Display the contents of config/settings.json"
- "Read package.json"

### 4. Read Files Content With Summary

Enhanced version of file reading that automatically handles large files through intelligent summarization.

**What it does:**
- Reads full content for files within token limits
- Automatically summarizes larger files exceeding limits
- Preserves key information while reducing size
- Maintains original file source information

**Key features:**
- Smart detection of file size
- Automatic decision to summarize or return full content
- Focus on main functionality and purpose
- Preservation of key components and structure
- Clear indication when summary is provided

**Benefits:**
- Handle large codebases efficiently
- Stay within system token limits
- Get relevant information quickly
- Understand file purpose without reading everything

**Usage:**
Provide the file path you wish to read. The tool automatically determines whether to return complete content or an intelligent summary.

**Example queries:**
- "Summarize the large utils.py file"
- "Give me an overview of the main application file"
- "Read the big configuration file and summarize it"
- "Show key information from the lengthy documentation"

## Setting Up Codebase Tools

No integration setup is required for Codebase Tools. They only need a Git data source to function.

### Step 1: Ensure Git Data Source Exists

Before enabling Codebase Tools, verify you have at least one Git data source:

1. Navigate to **Data Sources** section
2. Check for existing Git repositories
3. If needed, [add a Git data source](../../data-source/datasources-types/add-git-datasource)

### Step 2: Enable Codebase Tools

To use Codebase Tools, enable them in your assistant's available tools list:

![Enable Codebase Tools](./code-exploration-toolkit/enable-tools.png)

#### How to Enable

1. Open or create an assistant
2. Navigate to **Available Tools** section
3. Find **Codebase Tools** category
4. Enable the following tools:
   - Get Repo Tree with filtering
   - Search Code with filtering
   - Read Files Content
   - Read Files Content With Summary
5. Save the assistant configuration

### Step 3: Select Data Source

When using Codebase Tools, the assistant needs to know which repository to search:

![Select Data Source](./code-exploration-toolkit/select-data-source.png)

**Data source selection:**
- Assistants can access all Git data sources in the project
- Tools automatically detect available repositories
- You can specify which repository to search in your query
- Default repository can be configured in assistant settings

## Using Codebase Tools

### Getting Repository Structure

The **Get Repo Tree with filtering** tool activates when asking questions about repository structure.

#### Example 1: Basic Structure Query

![Example Query 1](./code-exploration-toolkit/example-query-1.png)

**Query**: "Show me the file structure of this repository"

![Example Response 1](./code-exploration-toolkit/example-response-1.png)

**Response**: The assistant generates a hierarchical tree structure showing:
- Directory organization
- File names and paths
- Nested folder structure
- File types and extensions

**Tree structure visualization:**

![Tree Structure](./code-exploration-toolkit/tree-structure.png)

The output resembles Linux `tree` command with clear hierarchy:
```
project/
├── src/
│   ├── components/
│   │   ├── Header.tsx
│   │   └── Footer.tsx
│   ├── utils/
│   │   └── helpers.ts
│   └── main.ts
├── tests/
│   └── unit/
├── package.json
└── README.md
```

### Searching Code Content

#### Example 2: Pattern Search

![Example Query 2](./code-exploration-toolkit/example-query-2.png)

**Query**: "Find files that import React libraries"

![Example Response 2](./code-exploration-toolkit/example-response-2.png)

**Response**: The assistant:
- Searches through all files in the repository
- Identifies files with React import statements
- Lists matching files with their paths
- May show relevant code snippets

**What the search finds:**
- Direct imports: `import React from 'react'`
- Named imports: `import { useState, useEffect } from 'react'`
- Related libraries: `import { Component } from 'react-router'`

### Advanced Code Search

#### Example 3: Complex Query

![Example Query 3](./code-exploration-toolkit/example-query-3.png)

**Query**: "Show me functions that handle database connections"

![Example Response 3](./code-exploration-toolkit/example-response-3.png)

**Response**: The assistant:
- Identifies files with database-related code
- Locates specific function definitions
- Understands context (database connections)
- Returns relevant code sections

**AI-powered understanding:**
- Recognizes database-related keywords
- Finds connection functions regardless of naming
- Understands context and purpose
- Filters out unrelated code

### Reading File Content

#### Example 4: Direct File Access

![Example Query 4](./code-exploration-toolkit/example-query-4.png)

**Query**: "Read the package.json file"

![Example Response 4](./code-exploration-toolkit/example-response-4.png)

**Response**: The assistant:
- Locates the specified file
- Returns complete file content (or summary if large)
- Maintains formatting and structure
- Indicates if content was summarized

## Best Practices

### Effective Query Formulation

**Be specific with paths:**
- Good: "Show files in the src/components directory"
- Better: "List all TypeScript files in src/components"

**Use descriptive patterns:**
- Good: "Find authentication code"
- Better: "Search for functions handling user authentication and token validation"

**Combine tools strategically:**
- First: Get repository tree to understand structure
- Then: Search for specific patterns or files
- Finally: Read detailed file content

### Optimal Tool Selection

**Use Get Repo Tree when:**
- Starting to explore a new repository
- Need to understand project structure
- Looking for specific directories
- Want overview before detailed search

**Use Search Code when:**
- Know what you're looking for conceptually
- Need to find patterns across multiple files
- Want AI to understand context
- Searching for logical patterns

**Use Read Files Content when:**
- Know exact file path
- Need complete file content
- File is small to medium size
- Want detailed examination

**Use Read Files Content With Summary when:**
- Dealing with large files
- Need key information quickly
- Want overview before details
- File exceeds token limits

### Repository Organization

**For better search results:**
- Maintain consistent naming conventions
- Use descriptive file and function names
- Organize code logically in directories
- Keep related code together
- Add comments for complex logic

**File structure tips:**
- Group similar files in directories
- Use clear directory names
- Separate tests from source code
- Keep configuration files at root level
- Document project structure in README

## Common Use Cases

### Understanding New Codebases

**Scenario**: Joining a new project and need to understand the codebase

**Approach**:
1. "Show me the overall file structure"
2. "Where are the main application files located?"
3. "Find all configuration files"
4. "Show me the entry point of the application"
5. Read key files with summaries

### Locating Specific Functionality

**Scenario**: Need to find where specific features are implemented

**Approach**:
1. "Search for authentication-related code"
2. "Find files that handle user permissions"
3. "Locate database query functions"
4. Read relevant files for details

### Code Review and Analysis

**Scenario**: Reviewing code quality or preparing for refactoring

**Approach**:
1. "Find files with more than 300 lines"
2. "Search for duplicate code patterns"
3. "Locate unused imports or dependencies"
4. "Show me all utility functions"

### Documentation and Onboarding

**Scenario**: Creating documentation or onboarding new team members

**Approach**:
1. Generate repository tree for structure diagram
2. Find all README files in subdirectories
3. Locate example code and usage patterns
4. Extract configuration examples

### Dependency Analysis

**Scenario**: Understanding project dependencies and imports

**Approach**:
1. "Find all files importing lodash"
2. "Show me external library usage"
3. "Locate all API endpoint definitions"
4. "Find database model dependencies"

## Troubleshooting

### Tool Not Finding Files

**Common causes:**
- Repository not properly indexed
- File path incorrect
- Search query too specific
- Data source not selected

**Solutions:**
1. Verify Git data source is properly configured
2. Check repository was successfully indexed
3. Use broader search terms initially
4. Ensure assistant has access to correct data source
5. Try alternative phrasing for queries

### Search Returns Too Many Results

**Common causes:**
- Query too broad
- Common keywords used
- No filtering applied

**Solutions:**
1. Add more specific keywords to query
2. Include file type or directory filters
3. Use more descriptive search patterns
4. Narrow down with multiple criteria
5. Example: Instead of "functions", try "authentication functions in src/auth"

### File Content Not Displaying

**Common causes:**
- File path incorrect
- File not in Git data source
- File too large and summary not working
- Permission issues

**Solutions:**
1. Verify exact file path with tree structure first
2. Check file exists in the indexed repository
3. Use "Read Files Content With Summary" for large files
4. Ensure data source has read permissions
5. Try reading a different file to test tool functionality

### Summary Losing Important Details

**Common causes:**
- File extremely large
- Complex code structure
- Key information spread throughout file

**Solutions:**
1. Request specific sections: "Show me the imports and main function"
2. Break request into smaller parts
3. Ask for specific components: "Summarize just the class definitions"
4. Use direct read for critical files if possible
5. Follow up with targeted questions about specific parts

## Integration with Workflows

### Combining with Other Tools

Codebase Tools work well with other AI/Run CodeMie features:

**With Data Sources:**
- Index multiple repositories for comprehensive search
- Combine with documentation sources
- Link code with related documentation

**With Assistants:**
- Create specialized code review assistants
- Build onboarding assistants with repository knowledge
- Develop debugging assistants that understand codebase

**With Other Tools:**
- Use with Research Tools for comprehensive analysis
- Combine with file writing for code generation
- Integrate with testing tools for test discovery

### Workflow Examples

**Code Review Workflow:**
1. Use Get Repo Tree to understand structure
2. Search for files changed in specific feature
3. Read file content for detailed review
4. Provide feedback based on code analysis

**Debugging Workflow:**
1. Search for error-related code patterns
2. Read relevant files with summaries
3. Understand code flow and dependencies
4. Identify potential issue locations

**Documentation Workflow:**
1. Generate repository structure tree
2. Search for main components and features
3. Read key files for functionality understanding
4. Create documentation based on code analysis

## Advanced Tips

### Filtering Techniques

**File type filtering:**
- "Show only Python files in the repository"
- "List all JSON configuration files"
- "Find TypeScript files in src directory"

**Directory filtering:**
- "Search only in the tests directory"
- "Show files under src/components"
- "List contents of config folder"

**Content filtering:**
- "Find files with TODO comments"
- "Search for files longer than 500 lines"
- "Locate files with specific class names"

### Query Optimization

**Start broad, then narrow:**
1. Begin with general structure query
2. Identify areas of interest
3. Perform targeted searches
4. Read specific files for details

**Use iterative refinement:**
1. Initial query: "Find database code"
2. Refine: "Find database connection functions"
3. Specify: "Show PostgreSQL connection setup in database module"
4. Read: "Read the specific connection file"

**Combine multiple criteria:**
- "Find Python files in src/models that import SQLAlchemy"
- "Show TypeScript React components with useState hook"
- "Locate JavaScript files in utils with export statements"

## Performance Considerations

### Efficient Searches

**For large repositories:**
- Specify directories to limit search scope
- Use file type filters to reduce results
- Be specific with search terms
- Start with tree structure to understand layout

**For multiple repositories:**
- Specify which data source to search
- Search one repository at a time for clarity
- Use consistent naming across repos for easier searching

### Optimizing Results

**To get faster responses:**
- Cache common queries (assistant learns patterns)
- Use precise file paths when known
- Filter by directory for targeted searches
- Limit scope to relevant sections

**To improve accuracy:**
- Use descriptive and specific terms
- Provide context in queries
- Ask follow-up questions for clarification
- Verify results with direct file reading

## Next Steps

After enabling and understanding Codebase Tools:

- [Configure assistants](../../assistants/) to leverage code exploration capabilities
- [Add Git data sources](../../data-source/datasources-types/add-git-datasource) for additional repositories
- [Explore assistant configuration](../../assistants/assistant-configuration) for optimal tool usage
- Combine with other tools for comprehensive code analysis workflows

:::tip Pro Tip
Start every code exploration session by requesting the repository tree structure. This gives you context for more targeted searches and helps you understand where to look for specific functionality.
:::

Now your assistants are equipped with powerful Codebase Tools to navigate, search, and understand code repositories efficiently with AI-powered intelligence.
