---
id: working-with-code-repositories
title: 2.4 Working With Code Repositories
sidebar_label: Code Repositories
sidebar_position: 4
---

# 2.4 Working With Code Repositories

AI/RunTM CodeMie assistants can work with Git repositories. Apart from integrating the Git tool for such purposes, assistants must also know what repository to deal with. To connect assistant with the repository, it is required to provide the repository link or upload the codebase and specify the target branch to work with.

Integrating Version Control Systems allows assistants to navigate to the code repositories and perform various actions on your behalf, whether it is simple code analysis or creating pull requests with code that solves the problem indicated in a JIRA task. It is worth mentioning that this integration is required when adding a code repository.

## Integrating Version Control Systems

To integrate Version Control System tool in AI/RunTM CodeMie, follow the steps below:

1. Generate access token for GitLab or GitHub account with the following rights:

   **GitHub**:
   - repo
     1. repo: status
     2. repo_deployment
     3. public repo
     4. repo: invite
     5. security_events
   - project
     - read: project

   **GitLab**:
   - api
   - read_api
   - read_repository
   - write_repository

   **Bitbucket**:
   - repository: read
   - repository: write
   - repo: status
   - project: read
   - project: write
   - api: read

   :::note
   Saving the token value in your secure notes place is preferable. GitHub/GitLab shows you the token value just once after generating.
   :::

2. In the AI/RunTM CodeMie main menu, click the **Integrations** button:

   ![Integrations button in main menu](../images/image39.png)

3. Select **User Integration** or **Project Integration** (only for applications-admin, for that create request in support) and click **+ Create**:

   ![Integration type selection](../images/image209.png)

4. Select the tool, specify the credentials and click **Create**:

   ![Integration credentials form](../images/image122.png)

   :::note
   Specify this token's correct project and URL (URL ex: "https://github.com"). The project name for setting must be the same as for the indexed repository.
   :::

That's it. Now you can add code repositories to your AI/RunTM CodeMie account. Proceed onto the next paragraph to learn more.

## Managing Integrations

As you work with AI/RunTM CodeMie, the number of integrations will increase. To simplify navigation between integrations, use the filters. You can filter integrations by:

- NAME
- TYPE
- GLOBAL
