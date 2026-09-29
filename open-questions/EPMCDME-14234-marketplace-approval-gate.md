# EPMCDME-14234 Marketplace Approval Gate: Open Documentation Questions

Open questions for the Marketplace approval gate documentation. Resolve them before or after merging the related documentation pull request.

## Affected Pages

- `docs/user-guide/assistants/marketplace-publishing.md`
- `docs/admin/configuration/codemie/marketplace-management.mdx`

## Open Questions

1. **Recheck default thresholds.** The **Validation Checks** section in `marketplace-publishing.md` and the **Configuration** section in `marketplace-management.mdx` list default values (name 5–60 characters, description 100, system prompt 200, substance prompt 500, polish description 250, categories 2, conversation starters 2, similarity 0.70 / 0.55 / 0.40, shortlist 10, tier and grace period values). Defaults can change; recheck them against `MarketplaceManagementConfig` before creating the pull request. Also confirm how Polish Gates affect publishing and the VERIFIED badge.
2. **Admin Marketplace management page.** The **Overview** and **Cleanup queue** sections in `marketplace-management.mdx` are TODO placeholders. Screenshots are already stored in `docs/admin/configuration/codemie/images/marketplace-management/`. In the **Review queue** section, confirm what the **Sort** filter offers.
3. **Tooltips and descriptions for Overview and Cleanup queue metrics.** Collect the tooltip text or confirmed descriptions, so they can be documented accurately:
   - **Overview**: Qualified, Community, and Flagged for removal buckets (including the "% of all marketplace usage" values), Total Marketplace Assistants, Pending review, Failing a critical check, Failing a minor check, the flagged reasons (Fails quality checks, Unused, Duplicate), and the Failed quality checks table (Check, Importance).
   - **Cleanup queue**: the Tier (Hot, Warm, Cold, Dead), Bucket, and Decision (Keep, Cleanup) columns and their info icons, and the Reason and MCP filters.
   - **Config**: the meaning of the "Default from config" label.
