# What tools exist in codemie? List of codemie tools? Short summary about tools?

Assistant`s tools reviewed in the previous section are powerful enhancements that bring completely new capabilities. At the time being, the next tools provided in CodeMie:

1. Git - grants your assistant with abilities to operate your Git repositories. This tool offers the following capabilities:

- Set Active Branch
- Create File
- Update File
- Create Pull Request
- Create Branch
- Link Branches in Repo
- Get Changes of a Pull Request
- Create Pull Request Change Comment

2. GitHub Issues – provides you with assistance to work with GitHub Issues. Offers the following capabilities:

- Create GitHub Issue
- Update GitHub Issue content
- Open/Close GitHub Issue
- Comment on GitHub Issue
- Leave a Comment on GitHub Issue
- View all GitHub issues for given repository
- View a single GitHub Issue

3. VCS – Select this tool to integrate CodeMie with Version Control Systems, thus allowing for accessing Git repositories.
4. Data Management - provides integrations with Elasticsearch and SQL. For example, for analytical queries to data, as well as for accessing your data.
5. Research – this option integrates assistance with the web search engines that allow assistants to operate with the most fresh data. At the current moment, assistant supports the following tools:

- Google Search Tool JSON
- [Tavily](https://docs.tavily.com/docs/welcome#:~:text=Tavily%20Search%20API%20is%20a,developers%20and%20autonomous%20AI%20agents.) Search Results JSON
- Wikipedia
- [Web Scrapper](https://webscraper.io/documentation)

6. Cloud – allows for granting access for the assistant to the cloud resources, such a Kubernetes cluster, AWS. Other clouds are underway. With this integration, CodeMie assistants will be able to operate the corresponding resources. At the current moment, assistant supports the following tools:

- AWS
- Kubernetes
- GCP
- Azure

7. Access Management (Keycloak) – this tool allows users to leverage CodeMie for access management on the project.
8. Project Management – This tool became a replacement for obsolete Jira and Confluence tools. It contains the following sub tools:

- Generic Jira - grants your assistant with abilities to operate with Jira issues.
- Generic Confluence - this tool enforces assistants to work with Confluence, which in turn grants them ability to read, write and analyze the data stored within Confluence.

9. Plugin – any tool that can be enabled in order to integrate and manage a service through a plugin, for example, a file system. Please refer to our plugin [repo](https://gitbud.epam.com/epm-cdme/codemie-plugins) for more details. At the current moment, this tool is available solely for local usage.
10. Open API – This tool is designed to provide integrations with any third-party tools that support the [Open API](https://www.openapis.org/what-is-openapi) standard.
11. File System – for integrating the assistant with your computer's file system, allowing the assistant to manage files within the system. This option is only available when running CodeMie locally in a containerized environment.
12. MCP Servers – this tool allows you to integrate Model Context Protocol servers with your assistant, enabling access to a wide variety of external tools without requiring custom integrations. Using MCP servers, you can:
    - Configure server connections with name, description, command, and arguments

    - Access tools from MCP servers through your assistant

    - Invoke tools with appropriate parameters

    - Receive formatted responses from tools

    - Set up environment variables for secure access

    - Support both Form and JSON configuration formats

## Sources

- [Tools Overview](https://docs.codemie.ai/user-guide/tools_integrations/tools/overview)
