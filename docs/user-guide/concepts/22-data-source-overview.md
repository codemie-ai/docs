---
id: data-source-overview
title: 2.2 Data Source Overview
sidebar_label: Data Source Overview
sidebar_position: 2
---

# 2.2 Data Source Overview

The Data Source functionality in AI/Run CodeMie platform serves to incorporate various types of data into the platform, expanding the range of tasks the assistant can help with and enhancing its ability to provide relevant and accurate answers.

You can add various types of Data Sources to AI/Run CodeMie platform, such as:

- Code (git)
- Confluence
- Jira
- File (Max size: 50Mb. Formats: .yml, .yaml, .json, .pptx, .csv, .txt, .pdf, .docx, .xlsx, .xml)
- Google Docs

## Adding a Data Source

To add a data source, follow the steps below:

1. Navigate to the "Data Sources" section:

   ![Data Sources navigation menu](../images/image186.png)

2. Click the **+Create Datasource** button:

   ![Create data source button](../images/image107.png)

3. In the **Add new data source** window, fill in the required fields:
   - **Project**: Select the code name of your project.

   - **Data source name**: Specify the relevant and distinctive name associated with the data source.

     :::warning
     Be aware about the following naming restrictions:
     1. All letters must be lowercase.
     2. Only symbols '-', '\_' are allowed.
     3. It's not recommended to start Data Source Name with \_ (underscore) or - (hyphen).
     4. Data Source Name can't contain spaces, commas, or the following characters: `"`, `*`, `:`, `+`, `/`, `\`, `|`, `?`, `#`, `>`, or `<`.
     5. Character limitations: Data source name must be between 4 and 25 characters.
        :::

   - **Description**: Specify brief description that underlines data source features.

   - **Shared with Project Team**: Decide whether you want your project team members to use the data source or not.

   - **Data Source Type**: Specify data source type. It can be a Git repository, Confluence page, Jira space, pdf, .txt, .csv, .pptx, .xml, .json, .yaml File, or a Google document.

## Managing Data Sources

As you work with CodeMie, the number of data sources will increase. To simplify navigation between data sources, use the filters. You can filter datasources by:

- NAME
- TYPE
- PROJECT
- CREATED BY
- STATUS

![Data source filters interface](../images/image105.png)
