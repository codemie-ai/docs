# How do I deploy AI/Run CodeMie without Elasticsearch?

AI/Run CodeMie supports a standalone deployment mode that runs as a single self-contained Docker/Podman container with PostgreSQL only, with no Elasticsearch, Kubernetes cluster, or cloud infrastructure required. This is set by configuring `RETRIEVAL_BACKEND=none` in the environment, which disables Elasticsearch-dependent capabilities across the platform (Data Sources, Knowledge Bases, code indexing) while the rest of the platform continues to function normally.

The standalone image is built with a provided PowerShell script from sibling checkouts of the `codemie` and `codemie-ui` repositories, then started with a Docker Compose file that provisions PostgreSQL alongside the application container.

## Sources

- [Standalone Deployment](https://docs.codemie.ai/admin/deployment/standalone/overview)
- [API Configuration](https://docs.codemie.ai/admin/configuration/codemie/api-configuration)
