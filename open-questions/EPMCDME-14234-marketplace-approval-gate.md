# EPMCDME-14234 Marketplace Approval Gate: Open Documentation Questions

Open questions for the Marketplace approval gate documentation. Resolve them before or after merging the related documentation pull request.

## Affected Pages

- `docs/user-guide/assistants/marketplace-publishing.md`
- `docs/admin/configuration/codemie/marketplace-management.mdx`

## Open Questions

1. **Validation check details.** The **Validation Checks** section in `marketplace-publishing.md` lists the checked areas (name, description, system instructions, categories, similarity) without exact limits. Decide whether to document default thresholds (for example, from the **Config** tab: Core Gates, Polish Gates, Similarity) and how CRITICAL and OPTIONAL findings map to them.
2. **YAML key to disable Marketplace management.** Marketplace management is enabled by default and can be disabled only in the backend YAML configuration. The exact configuration key and file are not documented yet (TODO in `marketplace-management.mdx`, section "Enabling Marketplace Management").
3. **Publish Anyway at publish time.** Confirm that **Publish Anyway** in the **Assistant Quality Validation Failed** dialog is shown only to administrators and maintainers, and whether it also requires a justification (like **Confirm Force-Publish** in the edit flow). Also confirm which buttons regular users see in this dialog.
4. **Admin Marketplace management page.** The **Overview**, **Review queue**, **Cleanup queue**, and **Config** sections in `marketplace-management.mdx` are TODO placeholders. Screenshots are already stored in `docs/admin/configuration/codemie/images/marketplace-management/`.
5. **Configure & Test panel in chats (EPMCDME-15254).** The ticket is in Ready for Review. Confirm the documented behavior after release and the open ticket questions: whether the panel closes after a successful save and where the user lands after a validation failure.
6. **Tooltips and descriptions for Marketplace management metrics and settings.** Collect the tooltip text or confirmed descriptions for each metric and setting on the admin page, so they can be documented accurately:
   - **Overview**: Qualified, Community, and Flagged for removal buckets (including the "% of all marketplace usage" values), Total Marketplace Assistants, Pending review, Failing a critical check, Failing a minor check, the flagged reasons (Fails quality checks, Unused, Duplicate), and the Failed quality checks table (Check, Importance).
   - **Cleanup queue**: the Tier (Hot, Warm, Cold, Dead), Bucket, and Decision (Keep, Cleanup) columns and their info icons, and the Reason and MCP filters.
   - **Config**: Marketplace Thresholds (Hot, Warm, and Cold tier min. users, Cold and Dead grace period), Core Gates (Description min. length, System prompt min. length, Substance-prompt alt min. length), Polish Gates (Description min. length, Categories min. count, Require icon, Conversation starters min. count), and Similarity (Critical, Optional, and Report thresholds, Shortlist size), plus the meaning of the "Default from config" label.
