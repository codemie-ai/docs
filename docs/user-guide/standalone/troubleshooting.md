---
id: troubleshooting
title: Troubleshooting CodeMie Standalone
sidebar_label: Troubleshooting
sidebar_position: 3
pagination_prev: user-guide/standalone/index
pagination_next: null
---

# Troubleshooting CodeMie Standalone

Start with the container state and logs:

```bash
docker compose -f standalone/docker-compose.standalone.yml ps
docker compose -f standalone/docker-compose.standalone.yml logs codemie
```

| Symptom                                                                                                                      | Cause                                                                                                                       | Resolution                                                                                                                        |
| ---------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Container exits immediately with `ENV is not set`                                                                            | `ENV` missing from an older `.env.standalone`                                                                               | Copy `ENV`, `FRONTEND_URL`, and `RATE_LIMIT_LOGIN` from `.env.standalone.example`, then recreate the container                    |
| Container exits with `... is not writable by uid`                                                                            | The `codemie-storage` or `codemie-repos` volume is owned by another user, for example after migration from a root-run image | Change the volume ownership to `1001:1001`, see the Windows bind-mount note in the [Run Guide](./run-guide.md#managing-the-stack) |
| `uvicorn did not become healthy within 120s`                                                                                 | Backend failed to start, commonly because PostgreSQL is unreachable or `ELASTIC_URL` is wrong                               | Check `PG_URL` and database reachability, and the `ELASTIC_URL` value; read the traceback above the message                       |
| Chats, Assistants, and Workflows missing; log shows `Core gating: missing settings`                                          | No complete LLM provider block, or placeholder values left in `.env.standalone`                                             | Provide exactly one provider block with real values, then recreate the container                                                  |
| Knowledge Bases, Data Sources, and code indexing absent; log shows `Retrieval capability unavailable (ELASTIC_URL is empty)` | Expected without Elasticsearch                                                                                              | Set `ELASTIC_URL`, or leave the features off                                                                                      |
| `.env.standalone` change has no effect                                                                                       | `docker compose restart` does not re-read `env_file`                                                                        | Run `up -d --force-recreate codemie`                                                                                              |
| Edited `customer-config.yaml` ignored or components missing                                                                  | The external file replaces the bundled one with no merge                                                                    | Start from the version-matched full file; restart the container                                                                   |
| Budget Management shown but failing                                                                                          | LiteLLM is not part of standalone                                                                                           | Set `FEATURE_BUDGET_MANAGEMENT=false`                                                                                             |
| Login fails after the first start                                                                                            | New users must verify email when verification is enabled                                                                    | Set `EMAIL_VERIFICATION_ENABLED=false`, or use the seeded superadmin                                                              |

## Collecting Information for a Support Request

1. Image tag: `docker inspect codemie --format '{{.Config.Image}}'`
2. Application version: `curl -s http://localhost:8080/api/v1/info`
3. Logs from the first start of the container, with secrets removed.
4. Whether PostgreSQL is the Compose-managed container or an external server.

## See Also

- [Standalone Overview](./index.md)
- [Run Guide](./run-guide.md)
