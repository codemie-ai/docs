# How do I connect LiteLLM to CodeMie? How to generate a LiteLLM Virtual Key? How to configure LiteLLM integration in AI/Run CodeMie? How to monitor LiteLLM key usage and spend? How to customize the support URL in budget limit notification? What happens when the LiteLLM budget is exceeded? LiteLLM is a proxy that allows AI/Run CodeMie to connect to various LLM providers (AWS Bedrock, GCP Vertex AI, Azure OpenAI, etc.) through a unified API. This guide walks you through generating a LiteLLM Virtual Key and configuring the integration in AI/Run CodeMie.

## 1. Generate LiteLLM Virtual Key

1.1. Open your LiteLLM Dashboard and navigate to **Virtual Keys** in the sidebar. Click **+ Create New Key**.  
1.2. Fill in the key parameters and click **Create Key**:

- **Owned By**: Service Account
- **Team**: Select your team (e.g., "codemie")
- **Service Account ID**: Specify a service account ID (e.g., "codemie-demo")
- **Models**: Select models the key should have access to (e.g., "All Team Models")
- **Key Type**: Default  
  Optionally, in the **Optional Settings** section, you can configure budget controls:
- **Max Budget (USD)**: Set a maximum spending limit for the key.
- **Reset Budget**: Choose a reset period (e.g., daily, weekly, monthly) to automatically renew the budget.  
  You can adjust these values at any time to increase or decrease the budget as needed.  
  1.3. Copy the generated Virtual Key from the dialog and store it securely.
  > **Warning:** You will not be able to view this key again. Make sure to copy and save it before closing the dialog.

## 2. Configure Integration in AI/Run CodeMie

2.1. In the AI/Run CodeMie main menu, click **Integrations**, select **User** or **Project** tab, and click **+ Create**.

2.2. Specify the integration parameters and click **Save**:

- **Project**: Select your AI/Run CodeMie project name.
- **Global Integration**: Toggle on to use across multiple projects. If disabled, the integration will only be available within the selected project, and assistants and workflows attached to other projects will not be able to use it.
- **Credential Type**: LiteLLM
- **Alias**: Enter integration name (e.g., "codemie-demo").
- **API Key**: Paste the Virtual Key copied in the previous step.
  > **Note:** If you create this integration under the **Project** tab, the key will be available to the entire project by default, meaning all project members can use it.

## 3. Budget Limit Notification

If the budget configured for your Virtual Key or team has been exceeded, AI/Run CodeMie will display a notification indicating that the budget limit has been reached.

> **Tip:** If your organization or team has its own support channel, the contact link in the notification can be customized. Administrators can override the default support URL in the [API Configuration — Support & Help](https://docs.codemie.ai/admin/configuration/codemie/api-configuration) settings.

## 4. Verify Usage

After using the integration, you can open the LiteLLM Dashboard to verify that requests have been made and monitor usage, including spend and rate limits.

## Sources

- [Litellm](https://docs.codemie.ai/user-guide/tools_integrations/tools/litellm)
