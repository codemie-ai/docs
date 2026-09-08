# Plan: Document Jira Attachment Transfer for Bug Creation

## Requirements

Document the new capability in the Generic Jira tool that automatically transfers attachments
(and extracts text from image attachments) when creating a bug from a Jira support request ticket.

Source: EPMCDME-11264

## Clarification assumptions

- No new assistant configuration is required beyond the existing Generic Jira setup.
- The feature is triggered via natural language — the assistant detects it should copy attachments
  when the user asks to create a bug from a support request.
- Image text extraction happens automatically server-side; no extra parameters needed.

---

## Tasks

### Task 1 — Add "Create Bug from Support Request" section to jira.mdx

Add a new numbered section (§5) to `docs/user-guide/tools_integrations/tools/jira.mdx`
covering the attachment-transfer feature:

- What it does (auto-copy attachments; extract text from images into bug description)
- Example natural language prompt
- What the user sees in the resulting bug ticket
- Edge case: support request with no attachments → bug created normally

Test-first: no — documentation-only task, no code under test.

### Task 2 — Update Use Cases section in jira.mdx

Extend the existing "Issue Tracking" use case (or add a new "Support Request Triage" use case)
to mention the attachment-transfer capability and link back to §5.

Test-first: no — documentation-only task.

### Task 3 — Build validation

Run `npm run build` to verify no broken links or MDX errors.

Test-first: no — build is the validation.
