---
id: datasource-vs-tool
title: 2.12 What is the difference between a Data Source and an Assistant Tool in CodeMie?
sidebar_label: DataSource vs Tool
sidebar_position: 12
---

# 2.12 What is the difference between a Data Source and an Assistant Tool in CodeMie?

## Data Sources

- **Purpose**: Data Sources allow you to add and integrate various types of data into the CodeMie platform to provide the LLM with relevant context/knowledge that wasn't in its initial training data. This data can be used by assistants for generating more accurate responses, referencing documentation, or accessing project-specific information.

- **Types**: You can add different types of Data Sources such as Git repositories, Confluence pages, Text files (PDF, TXT, CSV), JSON files, and Google Docs.

- **Usage**: Data Sources are primarily used for indexing and searching specific data relevant to your project or documentation. For example, you might add a Git repository as a Data Source to help the assistant understand and reference code directly from the repository.

- **What data sources are**: Collections of information (documents, articles, code, etc.) that have been converted into vector embeddings using an embedding model.

- **How they work**: Text chunks are transformed into numerical vectors that capture semantic meaning, then stored in a vector database.

- **Data search / Retrieval process**: When a query comes in, it's also embedded, then similar vectors from the database are found through semantic search. Semantic search aims to improve search accuracy by understanding the contextual meaning of terms as they appear in the searchable data space. This type of search goes beyond keyword matching and considers the intent and contextual meaning of the query to provide more relevant results.

## Tools

- **Purpose**: Assistant Tools enhance the capabilities of your assistants by integrating them with external services or systems. This allows the assistant to perform various tasks beyond just answering questions.

- **Examples**: Tools for Jira, GitHub, GitLab, Confluence, and Research (Google Search, Wikipedia). These tools allow the assistant to create issues in Jira, make pull requests in GitHub, fetch the latest news, etc.

- **Usage**: Tools are integrated through the User menu, where you can specify credentials and set up the connection. These tools enable the assistant to perform actions within these systems or fetch data as needed.

- **What tools are**: External functions, APIs, or services that the LLM can call to perform specific tasks.

- **How they work**: The LLM generates structured function calls with appropriate parameters, which execute real-world actions.

- **Data search**: The information search is done using the full text search that involves searching for specific keywords within the text of documents to match specific terms or phrases within the provided data.

## Summary

- **Data Source**: Primarily for integrating and searching data relevant to your project.

- **Assistant Tool**: Enhances assistant capabilities by integrating with external systems and services to perform specific tasks.

- When choosing a tool for information search, it all depends on the user's needs and the most suitable approach to data retrieval.
