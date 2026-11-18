# How do I change the global default chat model?

Go to **Settings → Administration → Model management** (requires the global `admin` role). The **Default models** section at the top of the page contains the global default selector.

Open the selector and choose a specific model from the list. Only enabled chat models that are not switchyard routers appear as options. Click **Apply changes** to save.

To revert to the deployment-level default (defined in the LiteLLM or native LLM configuration), select **Use configured default** from the same dropdown and click **Apply changes**.

The global default is used when an assistant or workflow has no explicit model selection — for example, when a new assistant is created without a model preference, or when the previously configured model is no longer available. If the saved default model is later disabled, the platform falls back automatically to the next available enabled model.

## Sources

- [Global Model Management](https://codemie-ai.github.io/docs/admin/configuration/codemie/global-model-management)
