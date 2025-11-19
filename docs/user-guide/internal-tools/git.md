---
id: git
title: Git
sidebar_label: Git
---

# Git

Git version control system integration for repository management.

The Git tool grants your assistant comprehensive abilities to operate Git repositories directly from the AI/Run CodeMie interface. This powerful integration enables automated version control operations, code management, and collaborative development workflows.

## Overview

The Git tool provides assistants with the capability to interact with Git repositories, enabling them to perform a wide range of version control operations. This integration streamlines development workflows by allowing assistants to:

- Manage branches and commits
- Create and update files in repositories
- Handle pull requests and code reviews
- Coordinate repository operations
- Automate routine Git tasks

## Available Operations

The Git tool offers the following comprehensive capabilities:

### Branch Management

#### Set Active Branch

Switch between branches to work on different features or versions:

- Change the current working branch
- Verify branch existence before switching
- Handle branch switching conflicts
- Support for local and remote branches

**Use Case**: "Switch to the development branch to work on the new feature"

#### Create Branch

Create new branches for feature development or bug fixes:

- Create branches from current HEAD
- Create branches from specific commits
- Set up tracking for remote branches
- Support for branch naming conventions

**Use Case**: "Create a new branch called 'feature/user-authentication' from main"

#### Link Branches in Repo

Establish relationships between branches:

- Set upstream tracking for branches
- Configure push/pull relationships
- Manage branch hierarchies
- Handle branch dependencies

### File Operations

#### Create File

Add new files to the repository:

- Create files with specified content
- Place files in appropriate directory structure
- Stage files automatically for commit
- Handle file encoding and line endings

**Use Case**: "Create a new configuration file at config/database.yml with the development settings"

#### Update File

Modify existing files in the repository:

- Edit file contents
- Preserve file permissions and attributes
- Stage changes automatically
- Handle merge conflicts

**Use Case**: "Update the README.md file to include installation instructions"

#### Update File Diff

Apply changes using diff format:

- Apply patch files
- Update specific sections of files
- Handle line-by-line changes
- Support for unified diff format

**Use Case**: "Apply the following diff to fix the bug in user controller"

### Pull Request Management

#### Create Pull Request

Initiate code review processes:

- Create pull requests with titles and descriptions
- Set reviewers and assignees
- Link to related issues
- Configure merge options

**Use Case**: "Create a pull request to merge feature/login into main with a description of the authentication improvements"

#### Get Changes of a Pull Request

Review pull request modifications:

- Retrieve file changes in a PR
- View diff statistics
- Check affected files
- Review commit history

**Use Case**: "Show me what files were changed in pull request #42"

#### Create Pull Request Change Comment

Provide feedback on specific changes:

- Comment on specific lines
- Suggest code improvements
- Request changes
- Approve modifications

**Use Case**: "Add a comment on line 15 of the authentication file suggesting to use bcrypt instead of plain text passwords"

## Setup

The Git tool requires integration with a VCS (Version Control System) platform:

### Prerequisites

1. **VCS Integration**: Configure integration with GitHub, GitLab, or Azure DevOps
2. **Repository Access**: Ensure the integration has appropriate permissions
3. **Authentication**: Valid API tokens or credentials for the VCS platform

### Configuration Steps

#### 1. Create VCS Integration

First, set up integration with your version control platform:

1. Navigate to **Integrations** in AI/Run CodeMie
2. Select **User** or **Project**
3. Click **+ Create**
4. Choose your VCS platform (GitHub, GitLab, Azure DevOps)
5. Provide required credentials and API tokens
6. Test the connection
7. Save the integration

For detailed instructions, see the respective VCS integration documentation:
- [GitHub Integration](./github.md)
- [GitLab Integration](./gitlab.md)
- [Azure DevOps Git](./git-azuredevops.md)

#### 2. Enable Git Tool in Assistant

1. Create or edit an assistant
2. Navigate to **Available Tools** section
3. Find and enable the **Git** tool
4. Select your configured VCS integration
5. Save the assistant configuration

## Using Git-Enabled Assistants

Once configured, your assistant can perform various Git operations through natural language commands:

### Common Workflows

#### Feature Development

```
"Create a new branch called 'feature/payment-integration' from main,
then create a file called payment_processor.py with a basic PaymentProcessor class"
```

#### Bug Fixes

```
"Switch to the bugfix/login-error branch,
update the authentication.js file to fix the token expiration issue,
then create a pull request to merge into main"
```

#### Code Review

```
"Show me the changes in pull request #123 and add a comment on the database query
suggesting to add an index for better performance"
```

#### Repository Maintenance

```
"Create a new branch for v2.0 development,
link it to track the remote v2.0 branch,
and update the version.txt file to 2.0.0-dev"
```

## Best Practices

### Branch Naming

- Use descriptive branch names: `feature/`, `bugfix/`, `hotfix/`
- Include ticket numbers: `feature/JIRA-123-user-auth`
- Keep names concise but meaningful
- Follow your team's naming conventions

### Commit Strategy

- Make atomic commits with single purposes
- Write clear, descriptive commit messages
- Reference related issues in commit messages
- Keep commits focused and reviewable

### Pull Request Management

- Provide detailed PR descriptions
- Include testing instructions
- Link related issues and tickets
- Request appropriate reviewers
- Respond to feedback promptly

### File Operations

- Review changes before committing
- Test modifications locally when possible
- Ensure proper file permissions
- Follow repository structure conventions

## Security Considerations

### Access Control

- **Token Security**: Store API tokens securely
- **Permission Scoping**: Grant minimal necessary permissions
- **Branch Protection**: Respect protected branch rules
- **Review Requirements**: Ensure proper code review processes

### Safe Operations

- **Backup Important Data**: Before major refactoring
- **Test Changes**: Validate modifications in safe environments
- **Review Diffs**: Always review changes before merging
- **Audit Logs**: Monitor Git operations performed by assistants

## Integration with Other Tools

The Git tool works seamlessly with other AI/Run CodeMie tools:

### Codebase Tools

- **Read Files**: Analyze code before making changes
- **Search Code**: Find relevant files to modify
- **Get Repo Tree**: Understand repository structure

### CI/CD Integration

- **Trigger Builds**: Pull requests automatically trigger CI pipelines
- **Deploy Changes**: Merged code can trigger deployment workflows
- **Run Tests**: Automated testing on branch updates

### Issue Tracking

- **Link Issues**: Connect commits and PRs to issue trackers
- **Update Status**: Automatically update issue status on merge
- **Reference Tickets**: Include ticket numbers in commit messages

## Limitations

- Operations are subject to VCS platform rate limits
- Protected branches may have additional restrictions
- Large file operations may have size constraints
- Some advanced Git features may require direct VCS platform access

## Troubleshooting

### Common Issues

**Branch Already Exists**:
- Use `Set Active Branch` to switch instead of creating
- Delete existing branch if recreation is needed
- Use unique, descriptive branch names

**Permission Denied**:
- Verify integration has necessary permissions
- Check repository access rights
- Ensure API token hasn't expired

**Merge Conflicts**:
- Pull latest changes before making modifications
- Resolve conflicts manually in VCS platform
- Use smaller, more frequent commits

**File Not Found**:
- Verify correct branch is active
- Check file path and spelling
- Ensure file exists in repository

## Additional Resources

- Git Documentation: [git-scm.com/doc](https://git-scm.com/doc)
- GitHub API: [docs.github.com/en/rest](https://docs.github.com/en/rest)
- GitLab API: [docs.gitlab.com/ee/api](https://docs.gitlab.com/ee/api)
- Best Practices: Refer to your organization's Git workflow documentation

:::tip
The Git tool is most effective when combined with Codebase Tools for comprehensive repository management and code analysis.
:::

Now your assistant can perform Git operations to manage repositories, create branches, handle files, and manage pull requests efficiently.
