---
id: add-git-data-sources
title: Add and Index Git Data Sources
sidebar_label: Add and Index Git Data Sources
---

# Add and Index Git Data Sources

Connect and index Git repositories as data sources.

Git repositories are one of the most powerful data sources in AI/Run CodeMie, enabling assistants to analyze code, understand repository structure, and work with your codebase directly. This guide walks you through the process of adding and indexing Git repositories.

## Prerequisites

:::note Required Integration
This data source requires you to have at least one Git integration added to AI/Run CodeMie. For more details, please refer to the [Integrations Overview](../../integrations/) guidelines.
:::

Before adding a Git data source, ensure you have:

- Configured Git integration (GitHub, GitLab, or Bitbucket)
- Access to the repository you want to index
- Appropriate permissions to access repository content

## Adding a Git Data Source

To index a Git repository, fill in the following fields:

![Git Data Source Form](./add-git-data-sources/git-datasource-form.png)

### Configuration Fields

#### Project
Select the name of the project with which you want to associate that DataSource.

**Purpose**: Organizes data sources by project for better management and team collaboration.

#### Indexing Type
Choose the desired indexing mode.

**Available indexing types:**

1. **Whole codebase**: Direct indexing of raw code
   - Best for: Quick setup, simple code analysis
   - Use when: You want fast access to code without additional processing

2. **Summarization per file**: Generates summaries for each file
   - Best for: Documentation generation, code overview
   - Use when: You need high-level understanding of codebase

3. **Summarization per chunks**: Creates summaries for code chunks
   - Best for: Large codebases, detailed navigation
   - Use when: You need comprehensive code understanding
   - Note: Preferred mode, takes approximately 30-60 minutes

#### Repository Link
Provide the repository link.

**Format examples:**
- GitHub: `https://github.com/username/repository`
- GitLab: `https://gitlab.com/username/repository`
- Bitbucket: `https://bitbucket.org/username/repository`

**Tips:**
- Use HTTPS URLs for better compatibility
- Ensure the repository is accessible with your integration credentials
- Verify the URL is correct before proceeding

#### Branch
Specify the target branch to work with.

**Common branches:**
- `main` or `master`: Production code
- `develop`: Development branch
- `feature/*`: Feature branches
- Custom branch names

**Recommendations:**
- Use stable branches for production assistants
- Use development branches for testing and experimentation
- Update data source when switching branches

#### File Types
Specify relevant file extensions to index in the **File Types** field.

**Purpose**: Filters which files to include in indexing for better performance and relevance.

**Examples:**
- Code files: `.js, .py, .java, .ts, .go, .rb`
- Configuration: `.json, .yaml, .yml, .xml`
- Documentation: `.md, .txt, .rst`
- Web files: `.html, .css, .scss`

:::warning Important Note
If you leave this field empty, it will index all existing files, thus the quality may be worse because of some rubbish files (e.g., CSS, images, etc.). Please don't index images at all.
:::

**Best practices:**
- Specify only relevant file types for your use case
- Exclude binary files, images, and build artifacts
- Include documentation files for context
- Test with a subset of file types first

#### Model Used for Embeddings
Specify the assistant's LLM model.

**Purpose**: Determines which AI model processes the repository content for indexing.

**Common options:**
- Standard models for general purposes
- Specialized models for specific programming languages
- Follow your organization's model selection guidelines

### Creating the Data Source

Click the **+ Create** button and wait for the process to finish.

**What happens next:**
1. AI/Run CodeMie validates the configuration
2. Connection to repository is established
3. Indexing process begins automatically
4. Progress can be monitored in the data source list

## Error Handling for Git Data Sources

Errors can occur in the following cases:

- **Invalid repository link**: URL format is incorrect or repository doesn't exist
- **Invalid token**: Git integration credentials are expired or incorrect
- **Incorrect branch link**: Specified branch doesn't exist in the repository

For all these cases, after the data source is added and automatic reindex is created, a general error with exit code (128) will appear:

![Git Error Example](./add-git-data-sources/git-error-example.png)

![Git Error Code](./add-git-data-sources/git-error-code.png)

:::note
Pay attention while entering all the required data for this data source type.
:::

### Common Error Messages

#### Exit Code 128
**Cause**: General Git operation failure

**Common reasons:**
- Repository not found or inaccessible
- Authentication failed
- Network connectivity issues
- Invalid branch name

**Solutions:**
1. Verify repository URL is correct
2. Check Git integration credentials are valid
3. Ensure branch name exists in the repository
4. Test repository access manually
5. Review integration permissions

#### Connection Timeout
**Cause**: Cannot establish connection to Git server

**Solutions:**
- Check network connectivity
- Verify Git server is accessible
- Review firewall settings
- Try again after a few minutes

#### Permission Denied
**Cause**: Insufficient access to repository

**Solutions:**
- Verify integration has read access to repository
- Check repository visibility settings (public/private)
- Update integration credentials
- Request access from repository owner

## Best Practices

### Repository Selection

- **Size considerations**: Start with smaller repositories to test configuration
- **Active branches**: Index branches that are actively maintained
- **Monorepos**: Consider splitting into multiple data sources by module
- **Documentation**: Include README and docs for better context

### File Type Configuration

- **Be specific**: Only index file types your assistants need
- **Exclude generated code**: Skip build outputs, compiled files
- **Include tests**: Test files provide valuable context
- **Documentation files**: Always include .md, .txt for context

### Indexing Strategy

- **Initial setup**: Use "Whole codebase" for quick validation
- **Production use**: Upgrade to "Summarization per chunks" for best results
- **Large repositories**: Consider splitting by directory or module
- **Regular updates**: Schedule reindexing when code changes significantly

### Maintenance

- **Monitor indexing**: Check indexing status regularly
- **Update branches**: Reindex after major updates to main branch
- **Review file types**: Adjust file type filters based on assistant performance
- **Credentials**: Keep Git integration credentials up to date

## Use Cases

### Code Analysis
- Review code quality and patterns
- Identify technical debt
- Generate code documentation
- Analyze dependencies

### Development Support
- Answer questions about codebase
- Find specific functions or classes
- Understand code flow and architecture
- Locate similar code patterns

### Documentation Generation
- Create API documentation
- Generate README files
- Document code architecture
- Produce developer guides

### Code Review
- Review pull requests
- Identify potential issues
- Suggest improvements
- Check coding standards

## Next Steps

After adding your Git data source:

- [Monitor indexing progress](../data-source-overview/indexing-data-sources)
- [Configure assistants](../../assistants/) to use the indexed repository
- [Set up workflows](../../workflows/) that leverage code analysis
- Review [indexing duration](../data-source-overview/indexing-duration) estimates

:::tip Performance Tip
For large repositories, specifying relevant file extensions can reduce indexing time by up to 70% and significantly improve assistant response quality by focusing on relevant code.
:::

Now your Git repository is configured as a data source and ready to enhance your assistants with codebase knowledge.
