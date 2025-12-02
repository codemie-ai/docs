---
id: codemie-capabilities
title: CodeMie's capabilities
sidebar_label: Capabilities
sidebar_position: 2
---

# CodeMie's capabilities

AI/Run CodeMie efficiently addresses numerous tasks across varying difficulty levels. Below is an overview of AI/Run CodeMie's key capabilities:

## Core Features

### Comprehensive SDLC Smart Assistance and Assistants Library

AI/Run CodeMie offers robust smart assistance across all phases of the SDLC process by leveraging a variety of AI assistant roles, such as Business Analyst (BA), Developer, Quality Assurance (QA), Project Manager (PM), and more. These pre-built AI assistants enhance performance and productivity, and automate routine work, significantly reducing process costs and accelerating the software development cycle. The platform comes with a comprehensive library of pre-built AI assistants tailored to various roles within the SDLC to suit the diverse needs within a project.

### Assistants Constructor

Provides the flexibility to create personalized assistants equipped with specific tools and abilities tailored to your project's needs.

### Indexing and Data Management

AI/Run CodeMie provides options for data indexing, including the ability to:

- Monitor the current progress and status of the indexing process
- Perform incremental or full reindexing
- Manage indexed data sources effectively

Supported data sources include Jira, Confluence, various file formats (PDF, PPT, Excel, etc.), and Git.

### Support for Multi-Agent Workflows

AI/Run CodeMie supports multi-agent workflows, allowing multiple AI assistants to collaborate seamlessly on complex tasks and workflows. This capability covers use cases where different agents need to interact and share information to achieve a common goal, enhancing coordination and efficiency across various phases of the SDLC.

### Ease of Use for Beginners

Simple use cases for newcomers include:

- Code review
- Newcomer training
- User story creation

These require minimal setup, such as configuring your Git token for code-related tasks or your Jira token for project management tasks.

## Extensive Library of Tools

AI/Run CodeMie includes a wide array of tools to support various aspects of software development and project management:

### Version Control Systems (VCS)

Tools for managing and tracking changes in the codebase, such as Git.

### Codebase Tools

Tools for code review, static code analysis, and automated code formatting.

### Research Tools

Tools to assist in gathering and organizing research data and documentation.

### Cloud Tools

Integration with major cloud providers (AWS, GCP, Azure) for deployment, monitoring, and management of cloud resources.

### Project Management Tools

- **Jira**: For project management, task tracking, and issue tracking
- **Confluence**: For documentation, knowledge sharing, and collaboration

### Additional Tools

- **Open API**: Integration with various open APIs to extend functionality and connect with other services
- **Notification Tools**: Tools for sending notifications and alerts via email, chat, or other communication channels
- **Data Management Tools**: Tools for querying Elasticsearch indexes
- **Access Management**: Keycloak integration
- **Plugin System**: Extensible plugin architecture
- **File Management**: Tools for file operations
- **Quality Assurance**: Testing and QA tools

## Best Practices

### Data Source Usage

- There is no priority or sequential system in place. Everything depends on the given instructions
- You can instruct the model to use a specific data source for a particular use case
- Provide a description for the data source when it is created
- Data source descriptions are provided to the model so it can understand better use cases for it

### System Instructions

- System Instructions (System prompt) extends based on data source description
- If contradictions arise, the model will use its creative problem-solving abilities to address them
- The data source does not have rules, only description

### Context and Queries

- The model has a context window, but it is irrelevant to data source size
- The model answer will depend on query quality
- With queries that are specific and on point, there are no problems even with thousands of data sources
- If a poor query is provided (e.g., "tell me about something"), the answer would be vague

### Instructions Guidelines

- The smaller and clearer the instructions, the better
- Instructions must be uncontradictory, as this will reduce the risk of confusing LLM
- Other than the context window, there is no limit
