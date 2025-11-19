---
id: elastic
title: Elastic
sidebar_label: Elastic
---

# Elastic

Elasticsearch integration for search and analytics.

Elastic is a robust platform for search and data analysis, allowing seamless integration with various tools. AI/Run CodeMie assistants can connect to an Elastic endpoint to retrieve data efficiently. To set up this integration, follow these steps:

## 1. Obtain Credentials

There are two ways to obtain Elastic credentials:

- Using terminal
- Using Elastic UI

### Option A: Using Terminal

#### 1.1 Use curl Command

Use command for curl below:

```bash
curl -X POST "https://<elasticsearch_url>:9200/_security/api_key" \
-H "Content-Type: application/json" \
-H "Authorization: Basic <base64-encoded-username-password>" \
-d '{
  "name": "my-api-key",
  "role_descriptors": {
    "my-role": {
      "cluster": ["all"],
      "index": [
        {
          "names": ["*"],
          "privileges": ["read"]
        }
      ]
    }
  }
}'
```

#### 1.2 Copy Command Output

Copy the command's output. Below is an example of such an output:

```json
{
  "id": "id-of-the-api-key",
  "name": "my-api-key",
  "api_key": "your-api-key-value"
}
```

#### 1.3 Save Credentials

Ensure to save the `id` and `api_key` fields as they are necessary for integration with AI/Run CodeMie.

### Option B: Using Elastic UI

#### 2.1 Navigate to Stack Management

Navigate **Elastic UI -> Management -> Stack Management**:

![Elastic Stack Management](./images/elastic-stack-management.png)

#### 2.2 Select API Keys

On the **Stack Management** page, navigate to **Security** and select **API keys**:

![Elastic API Keys](./images/elastic-api-keys.png)

## 2. Create Integration in AI/Run CodeMie

### 2.1 Navigate to Integrations

In the AI/Run™ CodeMie main menu, click the **Integrations** button.

Depending on your needs, select **User or Project** and click **Create**.

### 2.2 Fill in Required Fields

Fill in the required fields and click **Create**:

- **Project Name**: Specify project name.
- **Credential Type**: Elastic
- **Alias**: Specify the integration name.
- **Endpoint URL**: Specify an endpoint of your Elastic instance. Ensure to append the port 9200 to it.
- **API Key ID**: Paste the "id" parameter of the JSON-formatted API key.
- **API Key**: Paste the "api_key" parameter of the JSON-formatted API key.

![Elastic Integration Form](./images/elastic-integration-form.png)

## 3. Configure Assistant

### 3.1 Enable Elastic Integration

Modify an assistant by enabling **Elastic** integration or create a new assistant with this tool:

![Elastic Assistant Configuration](./images/elastic-assistant-config.png)

## 4. Verify Elastic Integration

Verify **Elastic** integration by asking assistant a relevant question:

![Elastic Verification](./images/elastic-verification.png)

Now your assistant can connect to Elasticsearch to retrieve and analyze data efficiently.
