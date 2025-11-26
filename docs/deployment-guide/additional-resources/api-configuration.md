---
id: api-configuration
title: CodeMie API Configuration Reference
sidebar_label: API Configuration
sidebar_position: 100
---

# CodeMie API Configuration Reference

This document provides a comprehensive reference for all configuration parameters available in the CodeMie API.

These parameters control application behavior, AI provider integrations, tools configuration, storage, security, and more. Configure them through environment variables or `.env` files.

## Core Application Settings

These settings control fundamental application behavior, deployment environment, and runtime characteristics.

### Application Metadata

| Parameter       | Type    | Default    | Description                                                                            |
| --------------- | ------- | ---------- | -------------------------------------------------------------------------------------- |
| `APP_VERSION`   | string  | `"0.16.0"` | Application version displayed in UI and logs for tracking deployments                  |
| `ENV`           | string  | `"local"`  | Deployment environment identifier affecting logging format and feature flags           |
| `MODELS_ENV`    | string  | `"dial"`   | LLM configuration profile to load (points to `llm-{value}-config.yaml`)                |
| `LOG_LEVEL`     | string  | `"INFO"`   | Minimum log severity to output; use `DEBUG` for troubleshooting, `INFO` for production |
| `TIMEZONE`      | string  | `"UTC"`    | System timezone for timestamp normalization across distributed components              |
| `API_ROOT_PATH` | string  | `""`       | URL prefix for API endpoints when behind reverse proxy (e.g., `/api/v1`)               |
| `WORKERS`       | integer | `1`        | Uvicorn worker processes; increase for production to handle concurrent requests        |

### Callback Configuration

| Parameter               | Type   | Default                              | Description                                                        |
| ----------------------- | ------ | ------------------------------------ | ------------------------------------------------------------------ |
| `CALLBACK_API_BASE_URL` | string | `"http://host.docker.internal:8080"` | Base URL for asynchronous webhook callbacks from external services |

### Mermaid Diagram Rendering

Converts Mermaid diagram syntax to images for documentation and visualizations.

| Parameter                 | Type    | Default                   | Description                                                                                         |
| ------------------------- | ------- | ------------------------- | --------------------------------------------------------------------------------------------------- |
| `MERMAID_SERVER_URL`      | string  | `"http://localhost:8082"` | Local Mermaid rendering service URL for diagram generation                                          |
| `MERMAID_SERVER_TIMEOUT`  | integer | `50`                      | Max seconds to wait for diagram rendering before timeout                                            |
| `MERMAID_USE_MERMAID_INC` | boolean | `false`                   | Use public Mermaid Inc. service (requires outbound internet connection) or locally installed server |

### Agent-to-Agent (A2A) Communication

Enable CodeMie agents to communicate with external AI agents and services.

| Parameter                      | Type  | Default | Description                                               |
| ------------------------------ | ----- | ------- | --------------------------------------------------------- |
| `A2A_AGENT_CARD_FETCH_TIMEOUT` | float | `30.0`  | Max seconds to fetch agent capability cards for discovery |
| `A2A_AGENT_REQUEST_TIMEOUT`    | float | `30.0`  | Max seconds to wait for responses from external agents    |

### Platform & Marketplace

Configure marketplace integration for sharing and discovering assistants.

| Parameter                              | Type    | Default                    | Description                                        |
| -------------------------------------- | ------- | -------------------------- | -------------------------------------------------- |
| `PLATFORM_MARKETPLACE_DATASOURCE_NAME` | string  | `"marketplace_assistants"` | Datasource name for marketplace assistant catalog  |
| `PLATFORM_DATASOURCES_SYNC_ENABLED`    | boolean | `false`                    | Automatically sync platform datasources on startup |

### State Management & Import/Export

Configure data migration, backup, and state import/export capabilities.

| Parameter                 | Type    | Default            | Description                                      |
| ------------------------- | ------- | ------------------ | ------------------------------------------------ |
| `STATE_IMPORT_DIR`        | string  | `"./state_import"` | Directory containing state files for bulk import |
| `STATE_IMPORT_ENABLED`    | boolean | `false`            | Enable state import on startup (for migrations)  |
| `CODEMIE_EXPORT_ROOT`     | string  | `"/app"`           | Root path for exported data and backups          |
| `THREAD_POOL_MAX_WORKERS` | integer | `5`                | Worker threads for parallel background tasks     |

### Feature Flags & Experimental Features

Enable or disable experimental features and beta functionality.

| Parameter                         | Type    | Default | Description                                                  |
| --------------------------------- | ------- | ------- | ------------------------------------------------------------ |
| `AMNA_AIRN_PRECREATE_WORKFLOWS`   | boolean | `false` | Pre-create AMNA-AIRN workflows on deployment (beta feature)  |
| `LLM_REQUEST_ADD_MARKDOWN_PROMPT` | boolean | `true`  | Add markdown formatting hint to improve LLM output structure |

### Support & Help

| Parameter         | Type   | Default                            | Description                                   |
| ----------------- | ------ | ---------------------------------- | --------------------------------------------- |
| `CODEMIE_SUPPORT` | string | `"https://epa.ms/codemie-support"` | URL for user support and documentation portal |

### Configuration File Paths

These parameters define paths to configuration files and directories. Typically auto-detected and rarely need manual configuration.

| Parameter                         | Type | Default                          | Description                                              |
| --------------------------------- | ---- | -------------------------------- | -------------------------------------------------------- |
| `PROJECT_ROOT`                    | Path | Auto-detected                    | Project root directory (auto-detected from installation) |
| `LLM_TEMPLATES_ROOT`              | Path | `config/llms`                    | Directory containing LLM model configuration YAML files  |
| `DATASOURCES_CONFIG_DIR`          | Path | `config/datasources`             | Datasource connector definitions and schemas             |
| `ASSISTANT_TEMPLATES_DIR`         | Path | `config/templates/assistant`     | Pre-built assistant templates for quick setup            |
| `WORKFLOW_TEMPLATES_DIR`          | Path | `config/templates/workflow`      | Workflow templates for common automation patterns        |
| `CUSTOMER_CONFIG_DIR`             | Path | `config/customer`                | Customer-specific customizations and branding            |
| `ASSISTANT_CATEGORIES_CONFIG_DIR` | Path | `config/categories`              | Assistant categorization and organization                |
| `AUTHORIZED_APPS_CONFIG_DIR`      | Path | `config/authorized_applications` | External application access control definitions          |
| `INDEX_DUMPS_DIR`                 | Path | `config/index-dumps`             | Pre-built index snapshots for faster deployment          |
| `ALEMBIC_MIGRATIONS_DIR`          | Path | `external/alembic`               | Database schema migration scripts                        |
| `ALEMBIC_INI_PATH`                | Path | `external/alembic/alembic.ini`   | Alembic database migration configuration                 |

---

## AI Providers Configuration

Configure connections to AI model providers. At least one provider must be configured for CodeMie to function.

### OpenAI / Azure OpenAI

For LLMs and embedding models via Azure OpenAI Service.

| Parameter                  | Type    | Default                | Description                                                                    |
| -------------------------- | ------- | ---------------------- | ------------------------------------------------------------------------------ |
| `OPENAI_API_TYPE`          | string  | `"azure"`              | Provider type: `azure` for Azure OpenAI, `openai` for direct OpenAI API        |
| `OPENAI_API_VERSION`       | string  | `"2024-12-01-preview"` | Azure OpenAI API version; update to access new features or model capabilities  |
| `AZURE_OPENAI_API_KEY`     | string  | `""`                   | Authentication key from Azure OpenAI resource (required for Azure deployments) |
| `AZURE_OPENAI_URL`         | string  | `""`                   | Azure OpenAI endpoint URL from resource overview page                          |
| `AZURE_OPENAI_MAX_RETRIES` | integer | `5`                    | Retry attempts for failed requests due to rate limits or transient errors      |

### Anthropic (Claude)

For Claude (Sonnet and Haiku models) via Anthropic's native API.

| Parameter               | Type    | Default | Description                                                            |
| ----------------------- | ------- | ------- | ---------------------------------------------------------------------- |
| `ANTHROPIC_API_KEY`     | string  | `""`    | API key from Anthropic Console (required for direct Anthropic access)  |
| `ANTHROPIC_MAX_RETRIES` | integer | `2`     | Retry attempts; lower default due to Anthropic's robust infrastructure |

### AWS Bedrock

For Claude, Llama, Titan, and other models via AWS Bedrock managed service.

| Parameter                  | Type    | Default | Description                                                            |
| -------------------------- | ------- | ------- | ---------------------------------------------------------------------- |
| `AWS_BEDROCK_MAX_RETRIES`  | integer | `5`     | Retry attempts for throttled or failed Bedrock API calls               |
| `AWS_BEDROCK_READ_TIMEOUT` | integer | `60000` | Request timeout in milliseconds; increase for long-running generations |
| `AWS_BEDROCK_REGION`       | string  | `""`    | AWS region hosting Bedrock service (e.g., `us-east-1`, `us-west-2`)    |

### Google Vertex AI

For Gemini, and Claude via Google Cloud's Vertex AI platform.

| Parameter                       | Type    | Default | Description                                                           |
| ------------------------------- | ------- | ------- | --------------------------------------------------------------------- |
| `GOOGLE_VERTEXAI_REGION`        | string  | `""`    | Region for Vertex AI models (e.g., `us-central1`, `europe-west4`)     |
| `GOOGLE_CLAUDE_VERTEXAI_REGION` | string  | `""`    | Separate region for Claude on Vertex AI if different from main region |
| `GOOGLE_VERTEXAI_MAX_RETRIES`   | integer | `5`     | Retry attempts for rate-limited or failed Vertex AI requests          |
| `GOOGLE_PROJECT_ID`             | string  | `""`    | GCP project ID where Vertex AI is enabled                             |
| `GOOGLE_REGION`                 | string  | `""`    | Default GCP region for all Google services                            |
| `GCP_API_KEY`                   | string  | `""`    | Base64-encoded service account JSON key for GCP authentication        |

---

## Additional AI Service Integrations

Additional AI services for multimodal capabilities beyond text generation.

### DALL-E Image Generation

Enables AI-generated images for visual content creation within assistants.

| Parameter       | Type   | Default | Description                                  |
| --------------- | ------ | ------- | -------------------------------------------- |
| `DALLE_API_URL` | string | `""`    | Endpoint URL for DALL-E image generation API |
| `DALLE_API_KEY` | string | `""`    | Authentication key for DALL-E service access |

### Speech-to-Text (STT)

Converts voice input to text for conversational interfaces and voice commands.

| Parameter                 | Type   | Default | Description                                                |
| ------------------------- | ------ | ------- | ---------------------------------------------------------- |
| `STT_API_URL`             | string | `""`    | Whisper or compatible STT service endpoint                 |
| `STT_API_KEY`             | string | `""`    | Authentication key for STT service                         |
| `STT_API_DEPLOYMENT_NAME` | string | `""`    | Azure-specific deployment identifier if using Azure Speech |
| `STT_MODEL_NAME`          | string | `""`    | Model variant (e.g., `whisper-1`) to use for transcription |

### Azure Speech Services

Microsoft's speech-to-text and text-to-speech services for Azure deployments.

| Parameter                  | Type   | Default | Description                                                     |
| -------------------------- | ------ | ------- | --------------------------------------------------------------- |
| `AZURE_SPEECH_REGION`      | string | `""`    | Azure region for Speech resource (e.g., `eastus`, `westeurope`) |
| `AZURE_SPEECH_SERVICE_KEY` | string | `""`    | Subscription key from Azure Speech resource                     |

---

## Database Configuration

Configure persistent data storage for conversations, users, workflows, and application state.

### PostgreSQL

Primary relational database for structured data and transactional operations.

| Parameter           | Type    | Default       | Description                                                     |
| ------------------- | ------- | ------------- | --------------------------------------------------------------- |
| `POSTGRES_HOST`     | string  | `"localhost"` | PostgreSQL server hostname or IP address                        |
| `POSTGRES_PORT`     | integer | `5432`        | PostgreSQL server port                                          |
| `POSTGRES_DB`       | string  | `"postgres"`  | Database name for CodeMie tables and data                       |
| `POSTGRES_USER`     | string  | `"postgres"`  | Database username with read/write permissions                   |
| `POSTGRES_PASSWORD` | string  | `"password"`  | Database password (use secrets manager in production)           |
| `PG_URL`            | string  | `""`          | Complete connection string (overrides individual params if set) |
| `PG_POOL_SIZE`      | integer | `10`          | Connection pool size; increase for high concurrency workloads   |
| `DEFAULT_DB_SCHEMA` | string  | `"codemie"`   | PostgreSQL schema for organizing CodeMie tables                 |

### Elasticsearch

Document store for full-text search, analytics, and unstructured data.

| Parameter          | Type   | Default                   | Description                                        |
| ------------------ | ------ | ------------------------- | -------------------------------------------------- |
| `ELASTIC_URL`      | string | `"http://localhost:9200"` | Elasticsearch cluster endpoint URL                 |
| `ELASTIC_PASSWORD` | string | `""`                      | Password for `elastic` user or configured username |
| `ELASTIC_USERNAME` | string | `""`                      | Username for Elasticsearch authentication          |

#### Elasticsearch Indexes

Index names for different data types. Customize to avoid collisions in shared clusters.

| Parameter                                 | Type         | Default                                | Description                                              |
| ----------------------------------------- | ------------ | -------------------------------------- | -------------------------------------------------------- |
| `ELASTIC_APPLICATION_INDEX`               | string       | `"applications"`                       | Indexed applications and their metadata                  |
| `ELASTIC_GIT_REPO_INDEX`                  | string       | `"repositories"`                       | Code repository metadata and indexing status             |
| `ELASTIC_LOGS_INDEX`                      | string       | `"codemie_infra_logs*"`                | Infrastructure logs pattern for monitoring and debugging |
| `FEEDBACK_INDEX_NAME`                     | string       | `"ca_feedback"`                        | User feedback and ratings on AI responses                |
| `BACKGROUND_TASKS_INDEX`                  | string       | `"background_tasks"`                   | Async task queue and execution status                    |
| `USER_CONVERSATION_INDEX`                 | string       | `"codemie_raw_user_conversations"`     | Complete conversation history and messages               |
| `USER_CONVERSATION_FOLDER_INDEX`          | string       | `"codemie_conversation_folder"`        | Folder organization for conversation management          |
| `CONVERSATIONS_METRICS_INDEX`             | string       | `"codemie_conversation_metrics"`       | Analytics data on conversation usage and performance     |
| `SHARED_CONVERSATION_INDEX`               | string       | `"codemie_shared_conversations"`       | Conversations shared across users or teams               |
| `KZ_USERS_INDEX`                          | string       | `"codemie_kz_users_data"`              | User profiles and searchable user data                   |
| `ASSISTANTS_INDEX`                        | string       | `"codemie_assistants"`                 | Assistant definitions, configurations, and templates     |
| `WORKFLOWS_INDEX`                         | string       | `"workflows"`                          | Workflow definitions and templates                       |
| `SETTINGS_INDEX`                          | string       | `"codemie_user_settings"`              | User preferences and personalization data                |
| `USER_DATA_INDEX`                         | string       | `"codemie_user_data"`                  | Additional user-related data and metadata                |
| `INDEX_STATUS_INDEX`                      | string       | `"index_status"`                       | Status tracking for repository and datasource indexing   |
| `PROVIDERS_INDEX`                         | string       | `"providers"`                          | AI provider configurations and availability              |
| `WORKFLOW_EXECUTION_INDEX`                | string       | `"workflows_execution_history"`        | Historical workflow runs and outcomes                    |
| `WORKFLOW_EXECUTION_STATE_INDEX`          | string       | `"workflows_execution_states"`         | Current state of running workflows                       |
| `WORKFLOW_EXECUTION_STATE_THOUGHTS_INDEX` | string       | `"workflows_execution_state_thoughts"` | Workflow reasoning and decision logs                     |
| `TOOLS_INDEX_NAME`                        | string       | `"codemie_tools"`                      | Semantic index for intelligent tool selection            |
| `INDEXES_PERMITTED_FOR_SEARCH`            | list[string] | `["codemie_kz_users_data"]`            | Indexes accessible via general search API                |

---

## File Storage Configuration

Configure where and how CodeMie stores uploaded files, attachments, and generated content.

### General Storage Settings

| Parameter                       | Type    | Default               | Description                                                                              |
| ------------------------------- | ------- | --------------------- | ---------------------------------------------------------------------------------------- |
| `FILES_STORAGE_TYPE`            | string  | `"filesystem"`        | Storage backend: `filesystem` (local on pod), `aws` (S3), `azure` (blob), `gcp` (bucket) |
| `FILES_STORAGE_DIR`             | string  | `"./codemie-storage"` | Local directory path when using `filesystem` storage type                                |
| `FILES_STORAGE_MAX_UPLOAD_SIZE` | integer | `104857600`           | Maximum file size in bytes (100 MB default); increase for large document processing      |
| `REPOS_LOCAL_DIR`               | string  | `"./codemie-repos"`   | Directory for cloned Git repositories during code indexing                               |

### Cloud Storage - AWS S3

Configuration for Amazon S3 storage backend (requires `FILES_STORAGE_TYPE=aws`).

| Parameter                     | Type   | Default                    | Description                                                 |
| ----------------------------- | ------ | -------------------------- | ----------------------------------------------------------- |
| `AWS_S3_REGION`               | string | `""`                       | S3 bucket region (e.g., `us-east-1`) for low-latency access |
| `AWS_S3_BUCKET_NAME`          | string | `""`                       | S3 bucket name for user files and attachments               |
| `CODEMIE_STORAGE_BUCKET_NAME` | string | `"codemie-global-storage"` | Bucket for system-level shared assets and resources         |

### Cloud Storage - Azure Blob

Configuration for Azure Blob Storage backend (requires `FILES_STORAGE_TYPE=azure`).

| Parameter                         | Type   | Default | Description                                                 |
| --------------------------------- | ------ | ------- | ----------------------------------------------------------- |
| `AZURE_STORAGE_CONNECTION_STRING` | string | `""`    | Complete connection string from Azure Storage account       |
| `AZURE_STORAGE_ACCOUNT_NAME`      | string | `""`    | Storage account name for alternative authentication methods |

### Cloud Storage - GCP

Configuration for Google Cloud Storage backend (requires `FILES_STORAGE_TYPE=gcp`).

| Parameter                  | Type   | Default | Description                                      |
| -------------------------- | ------ | ------- | ------------------------------------------------ |
| `FILES_STORAGE_GCP_REGION` | string | `"US"`  | Multi-region or region for Cloud Storage buckets |

---

## Security & Encryption

Protect sensitive data at rest using cloud key management services or HashiCorp Vault.

### Encryption Configuration

| Parameter         | Type   | Default   | Description                                                                                                                           |
| ----------------- | ------ | --------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `ENCRYPTION_TYPE` | string | `"plain"` | Encryption method: `plain` (none), `aws` (KMS), `azure` (Key Vault), `gcp` (Cloud KMS), `vault` (HashiCorp Vault with Transit Engine) |

### AWS KMS

Encrypt secrets and sensitive data using AWS Key Management Service.

| Parameter        | Type   | Default | Description                                            |
| ---------------- | ------ | ------- | ------------------------------------------------------ |
| `AWS_KMS_KEY_ID` | string | `""`    | KMS key ID or ARN for encryption/decryption operations |
| `AWS_KMS_REGION` | string | `""`    | AWS region where KMS key is located                    |

### Azure Key Vault

Encrypt data using Azure Key Vault's encryption keys and secrets management.

| Parameter               | Type   | Default | Description                                                 |
| ----------------------- | ------ | ------- | ----------------------------------------------------------- |
| `AZURE_KEY_VAULT_URL`   | string | `""`    | Key Vault URL (e.g., `https://mykeyvault.vault.azure.net/`) |
| `AZURE_KEY_NAME`        | string | `""`    | Name of encryption key within Key Vault                     |
| `AZURE_SUBSCRIPTION_ID` | string | `""`    | Azure subscription ID for service principal authentication  |
| `AZURE_TENANT_ID`       | string | `""`    | Azure AD tenant ID for authentication                       |
| `AZURE_CLIENT_ID`       | string | `""`    | Service principal application (client) ID                   |
| `AZURE_CLIENT_SECRET`   | string | `""`    | Service principal secret for authentication                 |

### GCP KMS

Encrypt data using Google Cloud Key Management Service.

| Parameter               | Type   | Default                  | Description                                   |
| ----------------------- | ------ | ------------------------ | --------------------------------------------- |
| `GOOGLE_KMS_PROJECT_ID` | string | Uses `GOOGLE_PROJECT_ID` | GCP project containing KMS resources          |
| `GOOGLE_KMS_KEY_RING`   | string | `"codemie"`              | Key ring grouping encryption keys             |
| `GOOGLE_KMS_CRYPTO_KEY` | string | `"codemie"`              | Specific crypto key for encryption operations |
| `GOOGLE_KMS_REGION`     | string | Uses `GOOGLE_REGION`     | Region where KMS key ring is located          |

### HashiCorp Vault

Encrypt data using Vault's Transit secrets engine for centralized key management.

| Parameter                   | Type   | Default     | Description                                               |
| --------------------------- | ------ | ----------- | --------------------------------------------------------- |
| `VAULT_URL`                 | string | `""`        | Vault server URL (e.g., `https://vault.company.com:8200`) |
| `VAULT_TOKEN`               | string | `""`        | Authentication token with transit engine permissions      |
| `VAULT_NAMESPACE`           | string | `""`        | Vault namespace for multi-tenant deployments              |
| `VAULT_TRANSIT_KEY_NAME`    | string | `"codemie"` | Transit engine key name for encryption                    |
| `VAULT_TRANSIT_MOUNT_POINT` | string | `"transit"` | Mount path for Transit secrets engine                     |

---

## Identity & Access Management

Configure authentication providers and access control for users and administrators.

### IDP Configuration

| Parameter             | Type   | Default   | Description                                                                                                             |
| --------------------- | ------ | --------- | ----------------------------------------------------------------------------------------------------------------------- |
| `IDP_PROVIDER`        | string | `"local"` | Identity provider: `keycloak` (recommended), `local` (for development), `oidc` (generic OIDC for specific client needs) |
| `KEYCLOAK_LOGOUT_URL` | string | `""`      | Keycloak logout endpoint for proper session termination                                                                 |
| `ADMIN_USER_ID`       | string | `""`      | User ID to automatically grant admin privileges on startup                                                              |
| `ADMIN_ROLE_NAME`     | string | `"admin"` | Role name identifying administrators in the system                                                                      |

### External User Configuration

Control access for external users (e.g., contractors, partners) with limited permissions.

| Parameter                        | Type         | Default       | Description                                             |
| -------------------------------- | ------------ | ------------- | ------------------------------------------------------- |
| `EXTERNAL_USER_TYPE`             | string       | `"external"`  | User type identifier for external user classification   |
| `EXTERNAL_USER_ALLOWED_PROJECTS` | list[string] | `["codemie"]` | Projects accessible to external users for collaboration |

---

## Integration Services

Connect CodeMie to external services for enhanced tools capabilities.

### Search Services

Enable web search capabilities for assistants to access current information.

| Parameter               | Type   | Default | Description                                                                                                                          |
| ----------------------- | ------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `GOOGLE_SEARCH_API_KEY` | string | `""`    | API key for Google Custom Search integration. Can be registered in your GCP account                                                  |
| `GOOGLE_SEARCH_CSE_ID`  | string | `""`    | Custom Search Engine ID for scoped web searches. Can be registered here https://programmablesearchengine.google.com/controlpanel/all |
| `TAVILY_API_KEY`        | string | `""`    | Tavily API key for AI-optimized web search and extraction                                                                            |

### Kubernetes Integration

Enable deployment, monitoring, and management of Kubernetes resources via assistants.

| Parameter              | Type   | Default | Description                                                           |
| ---------------------- | ------ | ------- | --------------------------------------------------------------------- |
| `KUBERNETES_API_URL`   | string | `""`    | Kubernetes API server URL (typically in-cluster or external endpoint) |
| `KUBERNETES_API_TOKEN` | string | `""`    | Service account token with appropriate RBAC permissions               |

### Version Control Systems

Configure Git provider detection for repository indexing and code analysis.

| Parameter                        | Type         | Default             | Description                                        |
| -------------------------------- | ------------ | ------------------- | -------------------------------------------------- |
| `GITHUB_IDENTIFIERS`             | list[string] | `["github"]`        | URL patterns identifying GitHub repositories       |
| `GITLAB_IDENTIFIERS`             | list[string] | `["gitlab"]`        | URL patterns identifying GitLab repositories       |
| `BITBUCKET_IDENTIFIERS`          | list[string] | `["bitbucket"]`     | URL patterns identifying Bitbucket repositories    |
| `AZURE_DEVOPS_REPOS_IDENTIFIERS` | list[string] | `["dev.azure.com"]` | URL patterns identifying Azure DevOps repositories |

---

## NATS Message Broker Configuration

Configure NATS for plugin communication, event streaming, and distributed messaging.

### Connection Settings

| Parameter                 | Type    | Default              | Description                                                        |
| ------------------------- | ------- | -------------------- | ------------------------------------------------------------------ |
| `NATS_SERVERS_URI`        | string  | `"nats://nats:4222"` | NATS server cluster URI; supports multiple comma-separated servers |
| `NATS_CLIENT_CONNECT_URI` | string  | `""`                 | Alternative client connection URI if different from server URI     |
| `NATS_USER`               | string  | `"codemie"`          | Username for NATS authentication                                   |
| `NATS_PASSWORD`           | string  | `"codemie"`          | Password for NATS authentication (use secrets in production)       |
| `NATS_SKIP_TLS_VERIFY`    | boolean | `false`              | Skip TLS certificate validation (only for development/testing)     |
| `NATS_CONNECT_TIMEOUT`    | integer | `5`                  | Connection establishment timeout in seconds                        |

### Connection Behavior

| Parameter                     | Type    | Default | Description                                                       |
| ----------------------------- | ------- | ------- | ----------------------------------------------------------------- |
| `NATS_MAX_RECONNECT_ATTEMPTS` | integer | `-1`    | Max reconnection attempts (-1 for unlimited retries with backoff) |
| `NATS_RECONNECT_TIME_WAIT`    | integer | `10`    | Seconds to wait between reconnection attempts                     |
| `NATS_MAX_OUTSTANDING_PINGS`  | integer | `5`     | Max unanswered pings before connection considered dead            |
| `NATS_PING_INTERVAL`          | integer | `120`   | Seconds between keepalive pings to detect connection issues       |
| `NATS_VERBOSE`                | boolean | `false` | Enable detailed NATS protocol logging for debugging               |

### Connection Pool

Optimize NATS performance with connection pooling for high-throughput scenarios.

| Parameter                              | Type    | Default | Description                                            |
| -------------------------------------- | ------- | ------- | ------------------------------------------------------ |
| `NATS_CONNECTION_POOL_SIZE`            | integer | `20`    | Number of NATS connections to maintain in pool         |
| `NATS_CONNECTION_POOL_MAX_AGE`         | integer | `300`   | Max connection age in seconds before recycling         |
| `NATS_CONNECTION_POOL_ACQUIRE_TIMEOUT` | float   | `10.0`  | Max seconds to wait for available connection from pool |

### Plugin Configuration

Configure NATS-based plugin system for extending CodeMie capabilities.

| Parameter                             | Type    | Default | Description                                                   |
| ------------------------------------- | ------- | ------- | ------------------------------------------------------------- |
| `NATS_PLUGIN_KEY_CHECK_ENABLED`       | boolean | `false` | Validate plugin authentication keys before allowing execution |
| `NATS_PLUGIN_PING_TIMEOUT_SECONDS`    | integer | `1`     | Max seconds to wait for plugin health check response          |
| `NATS_PLUGIN_UPDATE_INTERVAL`         | integer | `60`    | Seconds between plugin availability refresh checks            |
| `NATS_PLUGIN_LIST_TIMEOUT_SECONDS`    | integer | `15`    | Max seconds to wait for plugin discovery responses            |
| `NATS_PLUGIN_MAX_VALIDATION_ATTEMPTS` | integer | `3`     | Max attempts to validate plugin before marking unavailable    |
| `NATS_PLUGIN_V2_ENABLED`              | boolean | `true`  | Enable enhanced plugin protocol v2 with improved features     |
| `NATS_PLUGIN_TOOL_TIMEOUT`            | integer | `302`   | Max seconds for plugin tool execution (5 min + buffer)        |
| `NATS_PLUGIN_EXECUTE_TIMEOUT`         | integer | `302`   | Max seconds for plugin command execution                      |

---

## MCP (Model Context Protocol) Configuration

Configure Model Context Protocol for enhanced AI context management and tool integration.

### MCP Connect

| Parameter                    | Type    | Default                   | Description                                                 |
| ---------------------------- | ------- | ------------------------- | ----------------------------------------------------------- |
| `MCP_CONNECT_ENABLED`        | boolean | `true`                    | Enable MCP functionality for advanced context handling      |
| `MCP_CONNECT_URL`            | string  | `"http://localhost:3000"` | MCP server endpoint for context coordination                |
| `MCP_CONNECT_BUCKETS_COUNT`  | integer | `10`                      | Number of context buckets for partitioning and isolation    |
| `MCP_TOOL_TOKENS_SIZE_LIMIT` | integer | `30000`                   | Max tokens for tool definitions to prevent context overflow |

### MCP Client Configuration

| Parameter            | Type  | Default | Description                                                     |
| -------------------- | ----- | ------- | --------------------------------------------------------------- |
| `MCP_CLIENT_TIMEOUT` | float | `300.0` | Max seconds for MCP operations (5 minutes for complex contexts) |

### MCP Caching

Improve MCP performance by caching toolkit instances and reducing initialization overhead.

| Parameter                        | Type    | Default | Description                                      |
| -------------------------------- | ------- | ------- | ------------------------------------------------ |
| `MCP_TOOLKIT_SERVICE_CACHE_SIZE` | integer | `100`   | Max cached toolkit instances to retain in memory |
| `MCP_TOOLKIT_SERVICE_CACHE_TTL`  | integer | `3600`  | Toolkit cache lifetime in seconds (1 hour)       |
| `MCP_TOOLKIT_FACTORY_CACHE_SIZE` | integer | `50`    | Max cached toolkit factories to retain           |
| `MCP_TOOLKIT_FACTORY_CACHE_TTL`  | integer | `600`   | Factory cache lifetime in seconds (10 minutes)   |

### MCP Header Propagation

Control which HTTP headers are forwarded to MCP servers for security and privacy.

| Parameter             | Type   | Default                      | Description                                                             |
| --------------------- | ------ | ---------------------------- | ----------------------------------------------------------------------- |
| `MCP_BLOCKED_HEADERS` | string | `"authorization,cookie,..."` | Comma-separated headers to block from MCP server propagation (security) |

---

## LLM Proxy & LiteLLM Configuration

Configure LiteLLM proxy for unified LLM access, budget management, and usage tracking.

### Proxy Mode

| Parameter                        | Type    | Default      | Description                                                                    |
| -------------------------------- | ------- | ------------ | ------------------------------------------------------------------------------ |
| `LLM_PROXY_MODE`                 | string  | `"internal"` | Proxy mode: `internal` (built-in routing), `lite_llm` (external LiteLLM proxy) |
| `LLM_PROXY_ENABLED`              | boolean | `false`      | Enable LLM proxy for centralized model access control                          |
| `LLM_PROXY_BUDGET_CHECK_ENABLED` | boolean | `true`       | Enforce budget limits before allowing LLM requests                             |
| `LLM_PROXY_TIMEOUT`              | integer | `60`         | Max seconds to wait for proxy responses                                        |

### LiteLLM Connection

Connect to external LiteLLM proxy for advanced features like load balancing and fallbacks.

| Parameter             | Type   | Default | Description                                            |
| --------------------- | ------ | ------- | ------------------------------------------------------ |
| `LITE_LLM_URL`        | string | `""`    | LiteLLM proxy server URL (e.g., `http://litellm:4000`) |
| `LITE_LLM_APP_KEY`    | string | `""`    | Application-specific key for LiteLLM authentication    |
| `LITE_LLM_MASTER_KEY` | string | `""`    | Master key for LiteLLM administrative operations       |

### LiteLLM Model Tagging

Tag LLM requests for cost tracking and usage analytics.

| Parameter                        | Type   | Default     | Description                                                  |
| -------------------------------- | ------ | ----------- | ------------------------------------------------------------ |
| `LITE_LLM_PROJECTS_TO_TAGS_LIST` | string | `""`        | Comma-separated project names to include as request tags     |
| `LITE_LLM_TAGS_HEADER_VALUE`     | string | `"default"` | Default tag value when project doesn't match configured list |

### LiteLLM Budget Configuration

Set spending limits per user or team to control LLM usage costs.

| Parameter                   | Type   | Default     | Description                                                    |
| --------------------------- | ------ | ----------- | -------------------------------------------------------------- |
| `DEFAULT_SOFT_BUDGET_LIMIT` | float  | `200`       | Soft limit in USD triggering warnings before hard cutoff       |
| `DEFAULT_HARD_BUDGET_LIMIT` | float  | `500`       | Hard limit in USD completely blocking requests when exceeded   |
| `DEFAULT_BUDGET_DURATION`   | string | `"30d"`     | Budget reset period (e.g., `30d` for monthly, `7d` for weekly) |
| `DEFAULT_BUDGET_ID`         | string | `"default"` | Identifier for default budget configuration                    |

### LiteLLM Cache & Optimization

Reduce latency and API costs by caching metadata and responses.

| Parameter                    | Type    | Default | Description                                                 |
| ---------------------------- | ------- | ------- | ----------------------------------------------------------- |
| `LiteLLM_CUSTOMER_CACHE_TTL` | integer | `300`   | Customer info cache duration in seconds (5 minutes)         |
| `LiteLLM_MODELS_CACHE_TTL`   | integer | `1800`  | Available models list cache duration (30 minutes)           |
| `LiteLLM_REQUEST_TIMEOUT`    | float   | `5.0`   | Timeout for metadata requests to LiteLLM proxy              |
| `LiteLLM_FAIL_OPEN_ON_503`   | boolean | `true`  | Allow requests when LiteLLM proxy unavailable (bypass mode) |

---

## Agent & Workflow Configuration

Control AI agent behavior, workflow execution limits, and parallel processing.

### AI Agent Settings

| Parameter                               | Type         | Default                 | Description                                               |
| --------------------------------------- | ------------ | ----------------------- | --------------------------------------------------------- |
| `AI_AGENT_RECURSION_LIMIT`              | integer      | `150`                   | Max agent reasoning steps to prevent infinite loops       |
| `ENABLE_LANGGRAPH_AITOOLS_AGENT`        | boolean      | `true`                  | Use LangGraph-based agent for advanced tool orchestration |
| `DISABLE_PARALLEL_TOOLS_CALLING_MODELS` | list[string] | `["gpt-4o", "gpt-4.1"]` | Models incompatible with parallel tool execution          |

### Workflow Configuration

| Parameter                      | Type    | Default | Description                                                    |
| ------------------------------ | ------- | ------- | -------------------------------------------------------------- |
| `WORKFLOW_MAX_CONCURRENCY`     | integer | `5`     | Max simultaneous workflow executions to control resource usage |
| `WORKFLOW_DEFAULT_CONCURRENCY` | integer | `2`     | Default concurrency when not specified by workflow             |

### Trigger Engine

Enable time-based or event-driven workflow automation.

| Parameter                     | Type    | Default | Description                                     |
| ----------------------------- | ------- | ------- | ----------------------------------------------- |
| `TRIGGER_ENGINE_ENABLED`      | boolean | `false` | Enable scheduled workflows and event triggers   |
| `SCHEDULER_PROMPT_SIZE_LIMIT` | integer | `4000`  | Max prompt tokens for scheduled workflow inputs |

---

## CodeMie Tools Configuration

Configure AI tool selection, code analysis integrations, tool execution limits, and tool-specific environment variables for individual CodeMie tool behaviors. These parameters control execution environments, security policies, and feature access for built-in tools.

### Code Analysis Tools

| Parameter                    | Type    | Default | Description                                                             |
| ---------------------------- | ------- | ------- | ----------------------------------------------------------------------- |
| `MAX_CODE_TOOLS_OUTPUT_SIZE` | integer | `50000` | Max characters in code analysis tool output to prevent context overflow |

### Smart Tool Selection

Automatically select relevant tools based on user queries to improve response quality.

| Parameter                  | Type    | Default | Description                                                    |
| -------------------------- | ------- | ------- | -------------------------------------------------------------- |
| `TOOL_SELECTION_ENABLED`   | boolean | `false` | Enable AI-powered tool selection from available toolkits       |
| `TOOL_SELECTION_THRESHOLD` | integer | `3`     | Min tools before triggering smart selection (use all if below) |
| `TOOL_SELECTION_LIMIT`     | integer | `3`     | Max tools to select per query to optimize token usage          |

### Code Analysis Services

Integration with advanced code analysis platforms (e.g., AICE).

| Parameter                                | Type   | Default                            | Description                                      |
| ---------------------------------------- | ------ | ---------------------------------- | ------------------------------------------------ |
| `CODE_ANALYSIS_SERVICE_PROVIDER_NAME`    | string | `"CodeAnalysisServiceProvider"`    | Provider name for code analysis tool integration |
| `CODE_EXPLORATION_SERVICE_PROVIDER_NAME` | string | `"CodeExplorationServiceProvider"` | Provider name for code exploration capabilities  |

### Code Executor & Python Sandbox

Configure secure Python code execution in isolated Kubernetes pods for running user-generated code safely.

| Parameter                              | Type    | Default                               | Description                                                                                                                                                 |
| -------------------------------------- | ------- | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CODE_EXECUTOR_EXECUTION_MODE`         | string  | `"local"`                             | Execution mode: `sandbox` (isolated K8s pod, recommended for production), `local` (embedded kernel, less secure)                                            |
| `CODE_EXECUTOR_KUBECONFIG_PATH`        | string  | `""`                                  | Path to kubeconfig for Kubernetes authentication (optional, uses in-cluster config if empty). Set if you want to move code execution to a dedicated cluster |
| `CODE_EXECUTOR_WORKDIR_BASE`           | string  | `"/home/codemie"`                     | Base working directory for code execution inside containers                                                                                                 |
| `CODE_EXECUTOR_NAMESPACE`              | string  | `"codemie-runtime"`                   | Kubernetes namespace for executor pods                                                                                                                      |
| `CODE_EXECUTOR_DOCKER_IMAGE`           | string  | `"epamairun/codemie-python:2.2.13-1"` | Docker image with Python environment and dependencies for code execution                                                                                    |
| `CODE_EXECUTOR_EXECUTION_TIMEOUT`      | float   | `30.0`                                | Max seconds for code execution before timeout (prevents infinite loops)                                                                                     |
| `CODE_EXECUTOR_SESSION_TIMEOUT`        | float   | `300.0`                               | Max session lifetime in seconds before automatic cleanup                                                                                                    |
| `CODE_EXECUTOR_DEFAULT_TIMEOUT`        | float   | `30.0`                                | Default timeout for operations in seconds                                                                                                                   |
| `CODE_EXECUTOR_MEMORY_LIMIT`           | string  | `"256Mi"`                             | Kubernetes memory limit for executor pods                                                                                                                   |
| `CODE_EXECUTOR_MEMORY_REQUEST`         | string  | `"256Mi"`                             | Kubernetes memory request for executor pods                                                                                                                 |
| `CODE_EXECUTOR_CPU_LIMIT`              | string  | `"1"`                                 | Kubernetes CPU limit for executor pods (cores)                                                                                                              |
| `CODE_EXECUTOR_CPU_REQUEST`            | string  | `"500m"`                              | Kubernetes CPU request for executor pods (millicores)                                                                                                       |
| `CODE_EXECUTOR_MAX_POD_POOL_SIZE`      | integer | `5`                                   | Max number of executor pods in dynamic pool for concurrent executions                                                                                       |
| `CODE_EXECUTOR_POD_NAME_PREFIX`        | string  | `"codemie-executor-"`                 | Prefix for dynamically created executor pod names                                                                                                           |
| `CODE_EXECUTOR_RUN_AS_USER`            | integer | `1001`                                | Unix user ID for pod security context (non-root execution)                                                                                                  |
| `CODE_EXECUTOR_RUN_AS_GROUP`           | integer | `1001`                                | Unix group ID for pod security context                                                                                                                      |
| `CODE_EXECUTOR_FS_GROUP`               | integer | `1001`                                | Filesystem group ID for pod volume permissions                                                                                                              |
| `CODE_EXECUTOR_SECURITY_THRESHOLD`     | string  | `"LOW"`                               | Security policy: `SAFE` (permissive), `LOW`, `MEDIUM`, `HIGH` (restrictive)                                                                                 |
| `CODE_EXECUTOR_YAML_POLICY_PATH`       | string  | `""`                                  | Path to custom YAML security policy file (optional, overrides default policy)                                                                               |
| `CODE_EXECUTOR_VERBOSE`                | boolean | `false`                               | Enable verbose logging for executor debugging                                                                                                               |
| `CODE_EXECUTOR_KEEP_TEMPLATE`          | boolean | `true`                                | Persist pod template after execution for performance optimization                                                                                           |
| `CODE_EXECUTOR_SKIP_ENVIRONMENT_SETUP` | boolean | `false`                               | Skip environment initialization in sandbox (faster startup but may break dependencies)                                                                      |

:::warning Security Considerations
**Local Mode:** `CODE_EXECUTOR_EXECUTION_MODE=local` provides less isolation and security. Use `sandbox` mode in production where untrusted code execution is required.

**Security Threshold:** The security policy controls what operations are allowed:

- `SAFE` (0): Most permissive, blocks almost nothing
- `LOW` (1): Allows common operations like HTTP requests (recommended default)
- `MEDIUM` (2): More restrictive, blocks potentially dangerous operations
- `HIGH` (3): Very restrictive, only allows safe operations
  :::

### Azure DevOps Integration

Configuration for Azure DevOps work items, test plans, and wiki integrations.

| Parameter                | Type   | Default | Description                                                                    |
| ------------------------ | ------ | ------- | ------------------------------------------------------------------------------ |
| `AZURE_DEVOPS_CACHE_DIR` | string | `""`    | Cache directory for Azure DevOps API responses (empty string disables caching) |

---

## Observability & Monitoring

Track LLM usage, performance metrics, and debugging information.

### Langfuse Configuration

Send LLM traces to Langfuse for observability, debugging, and prompt optimization.

| Parameter                                 | Type         | Default                 | Description                                             |
| ----------------------------------------- | ------------ | ----------------------- | ------------------------------------------------------- |
| `LANGFUSE_TRACES`                         | boolean      | `false`                 | Enable detailed LLM tracing (requires Langfuse account) |
| `LANGFUSE_BLOCKED_INSTRUMENTATION_SCOPES` | list[string] | `["elasticsearch-api"]` | Exclude noisy scopes from instrumentation               |

:::info
When `LANGFUSE_TRACES` is enabled, you must also set the following environment variables (provided by Langfuse):

- `LANGFUSE_PUBLIC_KEY` - Public API key from Langfuse project
- `LANGFUSE_SECRET_KEY` - Secret key for authentication
- `LANGFUSE_HOST` - Langfuse instance URL (cloud or self-hosted)
  :::

---

## Environment-Specific Configuration

### Loading Configuration

CodeMie uses Pydantic Settings to load configuration from multiple sources with precedence:

1. **Environment variables** - Highest priority, overrides all other sources
2. **`.env` file** - Loaded from project root, convenient for local development
3. **Default values** - Specified in configuration classes as fallbacks

### Sensitive Information

The following parameter patterns are automatically masked in logs and exports:

- Any parameter ending with: `KEY`, `PASSWORD`, `SECRET`, `TOKEN`
- Explicitly masked: `AZURE_STORAGE_CONNECTION_STRING`, `PG_URL`, `ELASTIC_URL`

**Security Best Practice:** Use secret management services in production rather than plain environment variables.

### Environment Detection

The application detects deployment environment using the `ENV` parameter:

```python
config.is_local  # Returns True when ENV == "local"
```

This affects logging format (JSON vs human-readable) and security defaults.

---

## LLM Model Configuration

LLM models are configured via YAML files located at `LLM_TEMPLATES_ROOT/llm-{MODELS_ENV}-config.yaml`.

### Model Configuration Structure

Each model entry supports these configuration options:

| Field                              | Type    | Description                                                                  |
| ---------------------------------- | ------- | ---------------------------------------------------------------------------- |
| `base_name`                        | string  | Canonical model identifier (e.g., `gpt-4`, `claude-3-opus-20240229`)         |
| `deployment_name`                  | string  | Provider-specific deployment name (Azure deployment, Bedrock model ID)       |
| `label`                            | string  | Human-friendly display name shown in UI model selector                       |
| `multimodal`                       | boolean | Model supports vision (images/video) in addition to text                     |
| `react_agent`                      | boolean | Compatible with ReAct agent pattern (reasoning + acting)                     |
| `enabled`                          | boolean | Model available for selection (allows disabling without removal)             |
| `provider`                         | string  | Provider type: `azure_openai`, `aws_bedrock`, `google_vertexai`, `anthropic` |
| `default_for_categories`           | list    | Categories where this model is auto-selected                                 |
| `cost.input`                       | float   | USD per million input tokens for cost tracking                               |
| `cost.output`                      | float   | USD per million output tokens                                                |
| `cost.cache_read_input_token_cost` | float   | USD per million cached tokens (for providers supporting caching)             |
| `max_output_tokens`                | integer | Maximum generation length supported by model                                 |
| `features.streaming`               | boolean | Supports streaming responses for real-time output                            |
| `features.tools`                   | boolean | Supports function calling / tool use                                         |
| `features.parallel_tool_calls`     | boolean | Can execute multiple tools simultaneously                                    |

### Model Categories

Models can be designated as defaults for specific use cases:

- `global` - Fallback default for all operations
- `chat` - Conversational interactions and general Q&A
- `code` - Code generation, review, and analysis
- `documentation` - Technical documentation generation
- `summarization` - Long-form text summarization
- `translation` - Language translation tasks
- `knowledge_base` - Information retrieval and RAG
- `workflow` - Workflow step execution
- `file_analysis` - Document and file content analysis
- `reasoning` - Complex reasoning and problem-solving
- `planning` - Strategic planning and task decomposition

---

## Customer Configuration

Customer-specific settings are loaded from `CUSTOMER_CONFIG_DIR/customer-config.yaml` for specific clients configuration.

### Components Configuration

Enable/disable features and integrations per deployment:

```yaml
components:
  - id: component-id
    settings:
      enabled: true # Component active
      availableForExternal: true # External users can access
      name: Component Name # Display name
      url: https://component.url # Deep link or service URL
      icon_url: https://icon.url # UI icon
```

### Preconfigured Assistants

Define assistants automatically created on deployment:

```yaml
preconfigured_assistants:
  - id: assistant-slug # Unique assistant identifier
    settings:
      enabled: true # Assistant active
      index_name: custom_index # Override default search index
    project: project-name # Restrict to specific project
```

---

## Authorized Applications Configuration

External applications that can access CodeMie APIs via JWT authentication are configured in `AUTHORIZED_APPS_CONFIG_DIR/authorized-applications-config.yaml`.

### Application Configuration Structure

```yaml
authorized_applications:
  - name: app-name # Application identifier
    public_key_url: https://app.com/.well-known/public-key # JWT verification key URL
    # OR
    public_key_path: /path/to/public/key.pem # Local public key file
    allowed_resources: # Permitted resource types
      - ASSISTANT
      - WORKFLOW
      - CONVERSATION
```

### Resource Types

Control granular access to CodeMie resources:

- `ASSISTANT` - Create, read, update assistant configurations
- `WORKFLOW` - Execute workflows and access results
- `CONVERSATION` - Read/write conversation history
- `USER` - User profile management
- `PROJECT` - Project-level access

---

## See Also

- [AWS Deployment Guide](../aws/overview) - Complete AWS deployment walkthrough
- [Azure Deployment Guide](../azure/overview) - Azure-specific setup instructions
- [GCP Deployment Guide](../gcp/overview) - Google Cloud deployment steps
