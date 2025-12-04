---
id: indexing-duration
title: 5.2 Indexing Duration
sidebar_label: Indexing Duration
sidebar_position: 2
---

# 5.2 Indexing Duration

When indexing the data sources, keep in mind the following:

- Indexing can be time-consuming, depending on the size and complexity of the repository.

- Duration can range from a few minutes to up to 30-60 minutes. Click the "Data Sources" tab:
  ![Data Sources tab interface](../images/image219.png)

- To expedite the process, specify relevant file extensions, ensuring only necessary files are indexed.

- For existing repository indexes, it is possible to perform incremental re-index (exclusively for Jira/Confluence datasources) or full re-index (re-create the index from scratch with the same settings) in "Actions" dialog by clicking respective icon buttons with tooltips:
  ![Re-index action buttons interface](../images/image113.png)

## Typical Tasks

A few examples of typical tasks that the system can perform:

- Create README.md for this repo with specified structure `<structure>`.

- Delete class/function/endpoint/module `<entity name>` from `<location (optional)>`.

- Generate new class/function/endpoint/module `<entity name>` with `<entity details>`.

- Refactor code for `<entity name>` in `<location (optional)>` regarding to `<details>`.

:::note

- Give preference to small requests to the system rather than large complex tasks, this will increase the chance of its successful execution without additional edits.

- If the system responds that it does not have the necessary permissions, try reinstalling the GitHub App you previously added.
  :::
