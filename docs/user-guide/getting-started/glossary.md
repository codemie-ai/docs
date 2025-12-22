---
id: glossary
title: Glossary
sidebar_label: Glossary
sidebar_position: 20
pagination_next: null
---

# Glossary

This glossary provides definitions for key terms and concepts used throughout the CodeMie platform.

## A

### Alias

A descriptive name given to an integration in the CodeMie platform. The alias helps users identify and distinguish between different integrations of the same type (e.g., "ServiceNow Production", "GitHub Enterprise", "Jira Team Project"). It is a user-friendly label that makes it easier to manage and reference integrations when configuring assistants and tools.

### Applications

Deployable AI-powered solutions that extend or complement CodeMie capabilities. Applications combine AI assistants, tools, integrations, custom workflows, and user interfaces to create custom solutions for specific use cases. Types include conversational applications (chatbots), workflow applications (automated processes), and integration applications (connecting CodeMie with external systems).

### Assistant

An AI-powered agent in the CodeMie platform configured to perform specific tasks or roles. Assistants can be created from templates or customized with specific tools, data sources, and system instructions to help with various development and project management tasks.

### Template

A predefined configuration for creating assistants or workflows in the CodeMie platform:

- **Assistant Templates**: Pre-configured assistants tailored to specific roles such as Developer, QA, Project Manager, or Code Reviewer. Templates include pre-configured system instructions and integrated tools, helping users quickly set up assistants for common use cases.
- **Workflow Templates**: Pre-built workflows that serve as examples and ready-to-use solutions for various tasks such as Jira ticket management, Git branch comparison, unit test generation, code coverage analysis, and more. These templates can be customized to fit specific project needs.

---

## C

### Chat

A conversation interface for interacting with assistants. Users can communicate with AI assistants, ask questions, and receive responses. Chats can be organized into folders, shared with team members, and exported in various formats.

### Chat History

Browse previous conversations sorted by activity or grouped by assistant folders.

### Chat Folders

Organize chats by assistant, with ability to delete entire folders.

### Chat Sharing

Share conversations via read-only links with team members (no expiration, full edit/delete control retained).

### Chat Export

Export individual assistant messages or complete conversations to PPTX, DOCX, PDF, or JSON formats with preserved markdown formatting.

### Conversation Management

Manage your saved conversation history across workflows and assistants. Accessible through Profile Settings, allows bulk deletion of all conversations.

---

## D

### Data Indexing

The process of converting data from a data source into a searchable format, including the ability to monitor the current progress and status of the indexing process, perform incremental or full reindexing, and manage indexed Data Sources effectively. During indexing, text is chunked, converted into vector embeddings, and stored in a vector database. Assistants can only access data that has been indexed.

### Data Sources

A collection of information (documents, articles, code, etc.) integrated into CodeMie to provide assistants with relevant context and knowledge. Data sources are converted into vector embeddings for semantic search and must be indexed before assistants can access them. Supported types include Git repositories, Confluence, Jira, Files, and Google Docs. Data sources have lifecycle statuses: Indexing, Active/Ready, Failed, and Pending.

---

## E

### External Tools

Integration with external services and systems that extend assistant capabilities beyond built-in functionality. External tools enable assistants to interact with third-party services like Jira, GitHub, Confluence, and many others. There are two main approaches for integrating external tools:

- **[MCP (Model Context Protocol)](#mcp-model-context-protocol)**: Standardized protocol for tool integration.
- **[Providers](#providers)**: Third-party provider configurations for specialized tools and data sources.

---

## I

### IDE Plugin

Native IDE extensions that bring CodeMie capabilities directly into your development environment, allowing access to assistants, tools, and project resources without leaving your IDE.

**Supported IDEs:**

- **Visual Studio Code (VSCode)**
- **JetBrains IDEs** - IntelliJ IDEA, WebStorm, PyCharm, and others

### Integration

A configured connection between the CodeMie platform and an external service or system. Integrations provide the credentials and settings needed for assistants to use tools. There are three types:

- **User Integration**: Personal configuration available only to the individual user
- **User Global Integration**: Personal integration marked as global, available across all projects for the user
- **Project Integration**: Configuration available to all team members within a specific project (Admin-only)

---

## J

### JWT attributes

Required Claim parameters in JWT tokens assigned in Keycloak to control project access and permissions. There are two main attribute types:

- **applications**: Grants Standard User access to specified projects (comma-separated list of project names). Users can create, edit, delete, share, and publish their own assistants within these projects.
- **applications_admin**: Grants Project Administrator privileges for specified projects (comma-separated list). Users can manage all assistants and project integrations within these projects.

JWT attributes are only applicable to users with the `developer` role and determine which projects users can access and their permission level within those projects.

---

## L

### LLM (Large Language Model)

The underlying AI model that powers assistants in the CodeMie platform. LLMs process natural language inputs and generate responses, function calls, and other outputs based on their training and the provided context.

---

## M

### Marketplace

A collection of pre-built assistants created by the CodeMie team or shared by other users. Users can either clone assistants from the marketplace to customize and use in their own projects, or start a conversation directly with a ready-made assistant without any setup.

### MCP (Model Context Protocol)

An industry-standard protocol for integrating external tools with AI assistants. MCP servers allow assistants to leverage a wide variety of tools without requiring custom integrations for each tool type. Benefits include enhanced functionality, reduced development time, and integration with the growing MCP ecosystem.

---

## P

### Project

A workspace within the CodeMie platform that delineates and isolates working environments, ensuring that users' activities do not interfere with one another. Projects are typically created by team leaders or administrators and facilitate structured project management. All data sources, integrations, and assistants are associated with a specific project.

### Project Admin

A user with administrative privileges within the CodeMie platform. Project Admins have extended functionality including the ability configure Project Integrations (available to all team members), view all project assistants and workflows and manage project-level settings. Only Admin roles or user with attribute applications_admin have access to these administrative functions.

### Prompt Variables

Custom dynamic variables that can be defined and used within assistant system instructions. Prompt variables allow users to create reusable, parameterized instructions by inserting variables like `{{variable_name}}` into system prompts. Variables can be:

- **Regular Variables**: Standard variables with visible values
- **Sensitive Variables**: Encrypted variables marked with a shield icon for storing credentials, API keys, passwords, and other confidential information. Sensitive values are masked as `**********` in the UI and encrypted for security.

### Providers

Third-party provider configurations that enable integration of external data sources and specialized tools into CodeMie. Providers allow users to index external data beyond standard types, access provider-specific tools for code analysis, and perform advanced code understanding tasks. Provider tools can work with data sources or independently, depending on the configuration.

### Plugin

An extensible component that adds functionality to the CodeMie platform. Plugins can provide additional tools, integrations, or capabilities for assistants to use.

---

## S

### System Instructions (System Prompt)

Text instructions that define the assistant's behavior, role, personality, and guidelines. System instructions are provided to the LLM before each conversation and can be extended based on data source descriptions. Clear, uncontradictory system instructions improve the quality and consistency of assistant responses.

### Sub-assistant

An assistant that can be invoked by another assistant (orchestrator) to handle specific subtasks. Sub-assistants enable hierarchical task delegation and specialization, allowing complex tasks to be broken down and handled by specialized assistants.

---

## T

### Temperature

A parameter that controls the randomness of the LLM's predictions. A higher temperature (up to 2) results in more random and creative outputs, while a lower temperature (closer to 0) makes the outputs more deterministic and focused. For example, a temperature of 0.1 makes the model's predictions very focused on the most likely next word, while a temperature of 2 makes predictions more diverse and potentially more creative.

### Top P

Also known as nucleus sampling, Top P is a parameter used in natural language processing models that controls the randomness of predictions by setting a threshold for the probability distribution. The model only considers the smallest set of words whose cumulative probability exceeds the Top P value (range: 0 to 1). For instance, if Top P is set to 0.9, the model will only consider the top words that together have a 90% chance of being the next word.

### Tools

The process of connecting external services or systems to the CodeMie platform. Integrations allow users to expand assistants' capabilities by connecting various external tools and services. These integrations enable assistants to perform complex tasks such as creating pull requests in Git repositories, updating Jira issues, collecting information from external sources, and more. Integrations require specifying credentials (such as API tokens, URLs) and can be configured at User, User Global, or Project levels to control availability and sharing across team members.

---

## W

### Workflow

A multi-step automated process that can involve one or more assistants working together to complete complex tasks. Workflows can be created from templates or built from scratch, and can be shared with team members or exported for analysis.
