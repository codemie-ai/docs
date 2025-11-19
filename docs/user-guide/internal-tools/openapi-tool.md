---
id: openapi-tool
title: OpenAPI Tool
sidebar_label: OpenAPI Tool
---

# OpenAPI Tool

Invoke external APIs using OpenAPI specifications.

In AI/Run CodeMie, admins have extended functionality to send requests by OpenAPI. This integration allows assistants to interact with external APIs using OpenAPI specifications.

## 1. Create OpenAPI Integration

### 1.1 Navigate to Integrations

Click on **Integrations** and select the project name.

### 1.2 Configure Integration

Fill in the following parameters:

- **Credential type**: Choose "OpenAPI" from the drop-down list.
- **Alias**: Enter the name of the integration.
- **OpenAPI Spec**: (optional) Provide the OpenAPI specification URL or content.
- **Radio button**: If a username and password are required, you can provide them here.
- **API Key**: Select this option if authorization via API key is needed.

![OpenAPI Integration Form](./images/openapi-integration-form.png)

## 2. Configure Assistant

### 2.1 Enable OpenAPI Tool

Open assistant or create a new one and choose in tool **Open API -> Invoke external API, Get Open API spec**:

![OpenAPI Assistant Configuration](./images/openapi-assistant-config.png)

## 3. Using OpenAPI Tool

### 3.1 Example of Request and Answer

Once configured, your assistant can invoke external APIs based on the OpenAPI specification:

![OpenAPI Example](./images/openapi-example.png)

## Available Operations

The OpenAPI tool provides two main operations:

### Invoke external API

Call external API endpoints defined in the OpenAPI specification. The assistant can automatically understand the API structure and make appropriate requests.

### Get Open API spec

Retrieve and analyze OpenAPI specifications to understand available endpoints, parameters, and response formats.

:::tip
The OpenAPI tool can automatically parse OpenAPI specifications and generate appropriate API calls based on natural language requests to the assistant.
:::
