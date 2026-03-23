# What happens if I select a tool that requires an integration I haven't set up?

When you save the assistant, the platform validates that all selected tools have the
required integrations configured. If any are missing, a **Missing Integrations** modal
appears listing each missing integration type and the tools that depend on it.

From the modal you can:

- Click **Add Integration** next to each missing type to create it, then return and save
  again using **Validate & Save**
- Click **Skip Validation & Save** to save immediately — tools without integrations will
  not work until you configure them later
- Click **Cancel** to go back to the assistant form and adjust the selected tools

## Sources

- [Integration Validation During Assistant Save](https://docs.codemie.ai/user-guide/tools_integrations/integrations/#integration-validation-during-assistant-save)
