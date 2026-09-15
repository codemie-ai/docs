# Can CodeMie automatically close conversations after a period of time?

No. CodeMie does not run a built-in job that finishes conversations after N hours. Close-after-N-hours (or any other staleness rule) belongs in an external scheduler that calls the platform APIs.

A typical pattern is to list unfinished conversations with `GET /v1/admin/conversations?isFinished=false` (optionally filtered by `startedAt` and `project`), then finish the returned IDs with `POST /v1/admin/conversations/finish-bulk`.

Finishing blocks new messages; it does not delete history and is not a configurable retention or purge policy.

## Sources

- [Finish Conversations](https://docs.codemie.ai/user-guide/api/finish-conversations)
