# How do I change customer configuration without a redeploy? Which settings can be edited from the Administration page?

Some customer configuration components can be overridden at runtime from **Settings → Administration → Customer Configuration**. The page is available to platform administrators and maintainers; project administrators do not have access.

The page lists only the components declared as dynamic: the chat disclaimer (`chatDisclaimer`), the top banner (`banner`), web search (`features:webSearch`), and the number of recent releases on the Release Notes page (`releaseNotesRecentCount`). All other components are still configured only through `customer-config.yaml`.

Each setting shows whether it is **Overridden** or **Default from config**. **Save** stores an override that takes precedence over `customer-config.yaml`; **Reset to default** removes it, so the value follows the deployment configuration again. A change applies to backend and frontend behavior within the cache interval (60 seconds by default) with no restart or redeploy.

## Sources

- [Dynamic Customer Configuration](https://docs.codemie.ai/admin/configuration/codemie/dynamic-customer-configuration)
