---
id: add-provider-datasource
title: Add and Index Provider Data Source
sidebar_label: Add and Index Provider Data Source
pagination_prev: user-guide/data-source/datasources-types/add-azure-devops-wiki-data-source
pagination_next: null
---

# Add and Index Provider Data Source

Index external data sources through third-party providers.

## Overview

Provider data sources enable indexing external data through registered third-party provider configurations. Once indexed, assistants can use provider-specific tools to work with this data. Additionally, some provider tools can be used independently without requiring a data source.

:::warning Access Required
This functionality is only available to users with the [isAdmin](/user-guide/getting-started/glossary.md#jwt-attributes) role.
:::

## Provider Capabilities

Provider capabilities depend on their configuration. External providers might enable:

- Analyze code structure and patterns
- Explore repository contents
- Extract insights from indexed data
- Perform advanced code understanding tasks

## How It Works

### 1. Manage Provider Configurations

Administrators register and manage third-party providers in **Settings → Administration → Providers management**.

#### Provider List

The Providers management page displays a table of all registered providers with their **ID**, **Name**, and a row-level actions menu.

![Providers Management](./add-provider-datasource/add-provider-datasource-management-admin.png)

#### Add a Provider

1. Click **+ Add Provider**.
2. Enter the provider configuration as a JSON object in the editor.
3. Click **Save**.

A confirmation message appears when the provider is created successfully.

![Add Provider Configuration](./add-provider-datasource/add-provider-datasource-provider-configuration.png)

:::note
The provider configuration is entered as raw JSON. The required fields and structure depend on the specific provider type being registered.
:::

#### View Provider Details

Open the actions menu on a provider row (the **⋮** icon) and select **View Details** to open a read-only view of all provider properties.

#### Edit a Provider

1. Open the actions menu on a provider row and select **Edit**.
2. Update the JSON configuration in the editor.
3. Click **Save**.

A confirmation message appears when the provider is updated successfully.

#### Copy Provider ID

Open the actions menu on a provider row and select **Copy ID** to copy the provider's identifier to the clipboard. The ID is used when creating a Provider data source.

#### Delete a Provider

1. Open the actions menu on a provider row and select **Delete**.
2. In the confirmation dialog, review the provider name and click **Delete** to confirm.

:::warning
This action cannot be undone. The provider will be permanently removed.
:::

### 2. Creating Provider Data Source

#### Step 1: Navigate to Data Sources

Click **Data Sources** in the left navigation bar.

#### Step 2: Create New Data Source

Click **+ Create Datasource** button.

#### Step 3: Fill Required Fields

![Create Provider Data Source Form](./add-provider-datasource/add-provider-datasource-create-form.png)

**Select project**: Choose the project from the dropdown.

**Shared with project**: Toggle to share the data source with project team members.

**Name**: Provide a descriptive name for the data source.

**Description**: Explain the data source purpose and what it will be used for.

**Choose Datasource Type**: Select the registered provider from the dropdown.

**Provider-Specific Configuration**: Depending on the selected provider, fill in additional fields:

- **Graph Database Password**: Password for graph database connection (if required by provider)
- **Graph Database Username**: Username for graph database (if required by provider)
- **Graph Database URL**: Connection URL for graph database (if required by provider)
- **Code Analysis Datasources**: Select existing datasources to analyze with provider tools (optional)

### 3. Index Provider Data Source

Select **Provider** as the data source type and index the data:

![Provider Data Sources List](./add-provider-datasource/add-provider-datasource-list.png)

### 4. Use Provider Tools with Assistants

When configuring assistants, provider-specific tools become available in the External Tools section:

![Provider External Tools](./add-provider-datasource/add-provider-datasource-external-tools.png)

Provider tools can be used:

- **With data source context**: Tools work with indexed provider data
- **Independently**: Some tools don't require a data source and work standalone

## Workflow

```
1. Administrator registers provider configuration
   ↓
2. User selects Provider as data source type
   ↓
3. User indexes data through provider
   ↓
4. User creates assistant with provider tools enabled
   ↓
5. Assistant uses provider tools with or without data source context
```

## Using Provider Data Source in Assistants

After successfully creating and indexing a Provider data source, it can be connected to any assistant to provide access to external analysis capabilities.

### Adding Data Source to Assistant

1. Navigate to the **Assistants** section.
2. Click **+ Create Assistant** or edit an existing assistant.
3. In the **Data Source Context** section, click the dropdown menu.
4. Select the Provider data source from the list.
5. In the **Available tools** section, enable the provider-specific tools.
6. Save the assistant configuration.

The assistant can now access and analyze code through the provider's external tooling, enabling it to:

- Perform advanced code analysis with specialized tools
- Leverage external analysis engines and capabilities
- Access provider-specific insights and metrics
- Combine indexed data with real-time analysis
- Utilize both data source context and independent tool operations
