# EPMCDME-14234 Marketplace Approval Gate: Open Documentation Questions

Open questions for the Marketplace approval gate documentation. Resolve them before or after merging the related documentation pull request.

## Affected Pages

- `docs/user-guide/assistants/marketplace-publishing.md`
- `docs/admin/configuration/codemie/marketplace-management.mdx`

## Open Questions

1. **Polish Gates.** Confirm how Polish Gates affect publishing and the VERIFIED badge. The **Configuration** section in `marketplace-management.mdx` only says they are used by the polish check.
2. **Admin Marketplace management page.** The **Overview** and **Cleanup queue** sections in `marketplace-management.mdx` are TODO placeholders. Screenshots are already stored in `docs/admin/configuration/codemie/images/marketplace-management/`.
3. **Tooltips and descriptions for Overview and Cleanup queue metrics.** Collect the tooltip text or confirmed descriptions, so they can be documented accurately:
   - **Overview**: Qualified, Community, and Flagged for removal buckets (including the "% of all marketplace usage" values), Total Marketplace Assistants, Pending review, Failing a critical check, Failing a minor check, the flagged reasons (Fails quality checks, Unused, Duplicate), and the Failed quality checks table (Check, Importance).
   - **Cleanup queue**: the Tier (Hot, Warm, Cold, Dead), Bucket, and Decision (Keep, Cleanup) columns and their info icons, and the Reason and MCP filters.
   - **Config**: the meaning of the "Default from config" label.
