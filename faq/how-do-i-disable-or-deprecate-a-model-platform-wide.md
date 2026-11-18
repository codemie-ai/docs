# How do I disable or deprecate a model platform-wide?

Go to **Settings → Administration → Model management**. You need the global `admin` role to access this page.

To change a single model's status, use the status selector in the **Status** column of the model table. To update several models at once, select them using the checkboxes and choose the target status from the **Bulk actions** menu.

After making changes, click **Apply changes** to save. Changes are batched — nothing is saved until that button is clicked.

**Choosing between deprecated and disabled:**

- **Deprecated** — Existing assistants and workflows continue to use the model without interruption. The model cannot be selected for new work or set as the global default. Use this status when migrating users gradually.
- **Disabled** — The model is taken offline immediately. Existing work is redirected to an available replacement; requests fail if no replacement is reachable. Use this status only when the model must be removed immediately and a replacement is confirmed.

## Sources

- [Global Model Management](https://codemie-ai.github.io/docs/admin/configuration/codemie/global-model-management)
