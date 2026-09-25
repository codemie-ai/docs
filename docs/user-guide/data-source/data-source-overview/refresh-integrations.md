---
id: refresh-integrations
title: Refreshing the Integration List
sidebar_label: Refreshing the Integration List
pagination_prev: user-guide/data-source/data-source-overview/data-source-overview
pagination_next: null
---

# Refreshing the Integration List

When creating a data source that requires an integration, the creation form includes an integration selector and a **Refresh** button. The Refresh button reloads the available integrations from the server without losing any data already entered in the form.

## Integration Selector States

The integration selector appears for all datasource types that require a user integration: Git, Confluence, Jira, X-ray, Google Docs, Azure DevOps, and others. It appears in one of two states depending on whether integrations are already configured.

### No integrations configured

When no integrations exist for the current datasource type, the selector shows:

- An **Add User Integration** button that opens the integration creation popup directly from the form
- A **Refresh** button to reload the list
- Helper text: _Create a user integration, or refresh the list after one is added._

### Integrations available

When at least one integration is configured, the selector shows:

- A dropdown to choose the integration for this data source
- A **Refresh** button to reload the list
- Helper text: _Choose an existing integration, or add a new one and refresh the list._

The **Add User Integration** option is also accessible from the footer of the open dropdown panel.

## Using the Refresh Button

Click **Refresh** to fetch the latest list of available integrations from the server. The button is useful when:

- An integration was created in another browser tab or window
- A team member added a new integration while the form was open
- The dropdown does not yet show a recently created integration

The **Refresh** button is temporarily disabled while the request is in progress. All other data already entered in the form is preserved.

:::warning Refresh error
If the refresh request fails, a notification appears: _Failed to refresh integrations. Please try again._

Check network connectivity and retry. If the problem persists, reload the page.
:::

## Adding a New Integration Without Losing Form Progress

The **Add User Integration** button opens the integration creation popup without navigating away from the data source creation form. After saving the new integration in the popup, click **Refresh** to add it to the dropdown.

For full details on integration types, scopes, and how to configure them, see [Integrations](../../tools_integrations/integrations/index.md).
