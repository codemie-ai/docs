# How do I troubleshoot CodeMie Standalone startup problems?

Run `docker compose -f standalone/docker-compose.standalone.yml logs codemie` and look for the
first error. The most common causes are a missing `ENV` value in `.env.standalone`, a volume not
writable by uid 1001, an unreachable PostgreSQL (`PG_URL`), or an incorrect `ELASTIC_URL`.

If the container runs but Chats, Assistants, and Workflows are missing, no complete LLM provider
is configured (`Core gating: missing settings` in the log). Changes to `.env.standalone` require
recreating the container with `up -d --force-recreate codemie`; `restart` does not re-read them.

## Sources

- [Troubleshooting CodeMie Standalone](https://docs.codemie.ai/user-guide/standalone/troubleshooting)
- [Running CodeMie Standalone](https://docs.codemie.ai/user-guide/standalone/run-guide)
