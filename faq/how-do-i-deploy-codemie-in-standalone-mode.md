# How do I deploy CodeMie in standalone mode?

CodeMie Standalone packages the frontend, backend, and nginx into a single Docker image, paired
with a separate PostgreSQL container via Docker Compose. It is intended for proof-of-concept
work, demos, and local development — not production, which should use the AWS, Azure, or GCP
Kubernetes or On VM deployment guides.

The general flow:

1. Obtain the version-matched standalone deployment files from the CodeMie release. The image is
   published on Docker Hub as `codemie/codemie-oss-standalone`.
2. Set `CODEMIE_IMAGE` to the matching image tag, for example
   `codemie/codemie-oss-standalone:<tag>`.
3. Copy `standalone/.env.standalone.example` to `standalone/.env.standalone` and fill in an LLM
   provider (Azure OpenAI or AWS Bedrock).
4. Start the stack with `docker compose -f standalone/docker-compose.standalone.yml up -d`.

Contributors can alternatively build the image from local `codemie` and `codemie-ui` checkouts
using `standalone/build-image.sh`; see the step-by-step deployment guide for both workflows.

CodeMie Standalone authenticates with the platform's built-in local provider by default — there
is no Keycloak container in the stack. By default it also runs without Elasticsearch
(`RETRIEVAL_BACKEND=none`), so Knowledge Bases, Data Sources, and code indexing are unavailable.
An optional `standalone-analytics` Compose profile adds ClickHouse and an OpenTelemetry Collector
for CLI Analytics.

## Sources

- [CodeMie Standalone Deployment Guide](https://docs.codemie.ai/user-guide/standalone/)
- [CodeMie Standalone Deployment Guide — Step by Step](https://docs.codemie.ai/user-guide/standalone/deployment-guide)
