---
id: add-google-data-source
title: Add and Index Google Data Source
sidebar_label: Add and Index Google Data Source
---

# Add and Index Google Data Source

Connect and index Google Documents as data sources.

Google Documents are a valuable knowledge source in AI/Run CodeMie, enabling assistants to access structured documentation and FAQs. This guide walks you through the process of adding and indexing Google Docs.

## Overview

Google Documents can be indexed by providing a link with read-only access to AI/Run CodeMie's Google account. The document must be formatted in a specific way, such as FAQs, to be compatible with the platform's parsing and LLM routing capabilities.

## Prerequisites

Before adding a Google Docs data source, ensure you have:

- A Google Document formatted according to AI/Run CodeMie requirements
- Permission to share the document with AI/Run CodeMie's service account
- Required document structure

:::danger Strict Format Required
Google Docs must follow the triple numeration format (1.1.1.) with Heading 3 style. Documents without this format will fail to parse correctly.
:::

## Required Document Format

Google documents should be created in a specific format to allow AI/Run CodeMie to parse it and use it for LLM routing efficiently instead of traditional semantic search.

### Format Structure

The document format should follow these guidelines:

**1. Titles with triple numeration**

- Use format: `1.1.1.` (numbered sections)
- Apply text style: **Heading 3**
- This creates a hierarchical structure for easy navigation

**2. Content text**

- Use text style: **Normal** for all content inside sections
- Keep content clear and concise
- Structure information logically

### Example Structure

```
1.1.1. What is AI/Run CodeMie?
AI/Run CodeMie is a platform for...

1.1.2. How do I get started?
To get started with AI/Run CodeMie...

1.2.1. Creating your first assistant
Follow these steps to create...
```

:::info Why This Format?
The triple numeration format enables AI/Run CodeMie to create a semantic hierarchy of your content, improving search accuracy and LLM routing efficiency.
:::

:::tip Example Document
For a complete example of the correct format, refer to [this example Google Document](https://docs.google.com/document/d/19EXgnFCgJontz0ToCAH6zMGwBTdhi5X97P9JIby4wHs/edit#heading=h.b01c2ig0adfg).
:::

## Sharing the Document

To allow AI/Run CodeMie to parse a Google Document, you must share the document with AI/Run CodeMie's service account.

### Service Account Email

Share your document with:

```
codemie-kb-crawler@or2-msq-epmd-edp-anthos-t1iylu.iam.gserviceaccount.com
```

:::warning Service Account Security
This service account only has read access and cannot modify your documents. Sharing with this account is safe and does not expose your data.
:::

### How to Share

1. Open your Google Document
2. Click the **Share** button in the top-right corner
3. Enter the service account email address
4. Set permissions to **Viewer** (read-only access)
5. Click **Send**

:::warning Important
Ensure you grant at least **Viewer** permissions. The service account only needs read access to index the document.
:::

## Adding a Google Data Source

Follow these detailed steps to add a Google Document as a data source:

![Google Data Source Form](./add-google-data-source/google-datasource-form.png)

Now you can select data source from the drop down list in Data Source Context section of your assistant.
