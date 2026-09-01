---
id: api-configuration
title: CodeMie API Configuration Reference
sidebar_label: API Configuration
sidebar_position: 4
pagination_prev: admin/configuration/index
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# CodeMie API Configuration Reference

This document provides a comprehensive reference for all configuration parameters available in the CodeMie API.

These parameters control application behavior, AI provider integrations, tools configuration, storage, security, and more. Configure them through environment variables or `.env` files.

## Core Application Settings

These settings control fundamental application behavior, deployment environment, and runtime characteristics.

### Application Metadata

| Parameter          | Type    | Default    | Description                                                                                                                           |
| ------------------ | ------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `APP_VERSION`      | string  | `"0.16.0"` | Application version displayed in UI and logs for tracking deployments                                                                 |
| `ENV`              | string  | `"local"`  | Deployment environment identifier affecting logging format and feature flags                                                          |
| `MODELS_ENV`       | string  | `"dial"`   | LLM configuration profile to load (points to `llm-{value}-config.yaml`)                                                               |
| `LOG_LEVEL`        | string  | `"INFO"`   | Minimum log severity to output; use `DEBUG` for troubleshooting, `INFO` for production                                                |
| `TIMEZONE`         | string  | `"UTC"`    | System timezone for timestamp normalization across distributed components                                                             |
| `API_ROOT_PATH`    | string  | `""`       | URL prefix for API endpoints when behind reverse proxy (e.g., `/api/v1`)                                                              |
| `WORKERS`          | integer | `1`        | Uvicorn worker processes; increase for production to handle concurrent requests                                                       |
| `HTTPS_VERIFY_SSL` | boolean | `true`     | Verify SSL certificates for outbound HTTP requests; disable only in controlled development environments with self-signed certificates |

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

| Parameter                      | Type   | Default | Description                                                                         |
| ------------------------------ | ------ | ------- | ----------------------------------------------------------------------------------- |
| `A2A_AGENT_CARD_FETCH_TIMEOUT` | float  | `30.0`  | Max seconds to fetch agent capability cards for discovery                           |
| `A2A_AGENT_REQUEST_TIMEOUT`    | float  | `30.0`  | Max seconds to wait for responses from external agents                              |
| `A2A_PROVIDER_ORGANIZATION`    | string | `""`    | Organization identifier sent to external A2A providers for routing and auth context |
| `A2A_PROVIDER_URL`             | string | `""`    | Base URL of the external A2A provider endpoint                                      |

### Datasource Indexing Concurrency

Limit simultaneous datasource indexing operations to prevent overloading backend resources.

| Parameter                              | Type    | Default | Description                                                                                   |
| -------------------------------------- | ------- | ------- | --------------------------------------------------------------------------------------------- |
| `DATASOURCE_CONCURRENCY_LIMIT_ENABLED` | boolean | `false` | Enable concurrency limiting for datasource indexing operations                                |
| `MAX_CONCURRENT_DATASOURCE_INDEXING`   | integer | `5`     | Max number of datasource indexing jobs that can run simultaneously                            |
| `DATASOURCE_QUEUE_TIMEOUT`             | integer | `3600`  | Max seconds an indexing job can wait in the queue before timing out; `0` disables the timeout |

### Stale Indexing Watchdog

| Parameter                         | Type    | Default | Description                                                                                   |
| --------------------------------- | ------- | ------- | --------------------------------------------------------------------------------------------- |
| `STALE_INDEXING_WATCHDOG_ENABLED` | boolean | `false` | Enable background watchdog that detects and resets datasource indexing jobs stuck in-progress |

### Platform & Marketplace

Configure marketplace integration for sharing and discovering assistants.

| Parameter                              | Type    | Default                    | Description                                        |
| -------------------------------------- | ------- | -------------------------- | -------------------------------------------------- |
| `PLATFORM_MARKETPLACE_DATASOURCE_NAME` | string  | `"marketplace_assistants"` | Datasource name for marketplace assistant catalog  |
| `PLATFORM_DATASOURCES_SYNC_ENABLED`    | boolean | `false`                    | Automatically sync platform datasources on startup |

### State Management & Import/Export

Configure data migration, backup, and state import/export capabilities.

| Parameter                           | Type    | Default            | Description                                                 |
| ----------------------------------- | ------- | ------------------ | ----------------------------------------------------------- |
| `STATE_IMPORT_DIR`                  | string  | `"./state_import"` | Directory containing state files for bulk import            |
| `STATE_IMPORT_ENABLED`              | boolean | `false`            | Enable state import on startup (for migrations)             |
| `CODEMIE_EXPORT_ROOT`               | string  | `"/app"`           | Root path for exported data and backups                     |
| `THREAD_POOL_MAX_WORKERS`           | integer | `20`               | Worker threads for parallel background tasks                |
| `ASSISTANT_THREAD_POOL_MAX_WORKERS` | integer | `60`               | Dedicated thread pool size for assistant request processing |

### Feature Flags & Experimental Features

Enable or disable experimental features and beta functionality.

| Parameter                                       | Type    | Default | Description                                                                                                                                                         |
| ----------------------------------------------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AMNA_AIRN_PRECREATE_WORKFLOWS`                 | boolean | `false` | Pre-create AMNA-AIRN workflows on deployment (beta feature)                                                                                                         |
| `LLM_REQUEST_ADD_MARKDOWN_PROMPT`               | boolean | `true`  | Add markdown formatting hint to improve LLM output structure                                                                                                        |
| `MARKETPLACE_LLM_VALIDATION_ON_PUBLISH_ENABLED` | boolean | `true`  | Run LLM-based quality validation when publishing an assistant to the marketplace; disable to skip validation and allow any assistant to be published without review |
| `HIDE_AGENT_STREAMING_EXCEPTIONS`               | boolean | `false` | Suppress agent exceptions from being surfaced in the UI response stream; useful to hide internal errors from end-users in production                                |

### Support & Help

| Parameter         | Type   | Default                            | Description                                   |
| ----------------- | ------ | ---------------------------------- | --------------------------------------------- |
| `CODEMIE_SUPPORT` | string | `"https://epa.ms/codemie-support"` | URL for user support and documentation portal |

### Configuration File Paths

These parameters define paths to configuration files and directories. Typically auto-detected and rarely need manual configuration.

| Parameter                         | Type | Default                          | Description                                                                                    |
| --------------------------------- | ---- | -------------------------------- | ---------------------------------------------------------------------------------------------- |
| `PROJECT_ROOT`                    | Path | Auto-detected                    | Project root directory (auto-detected from installation)                                       |
| `LLM_TEMPLATES_ROOT`              | Path | `config/llms`                    | Directory containing LLM model configuration YAML files                                        |
| `DATASOURCES_CONFIG_DIR`          | Path | `config/datasources`             | Datasource connector definitions and schemas                                                   |
| `ASSISTANT_TEMPLATES_DIR`         | Path | `config/templates/assistant`     | Pre-built assistant templates for quick setup                                                  |
| `WORKFLOW_TEMPLATES_DIR`          | Path | `config/templates/workflow`      | Workflow templates for common automation patterns                                              |
| `SKILL_TEMPLATES_DIR`             | Path | `config/templates/skill`         | Directory scanned at startup to discover and upsert built-in skill templates into the database |
| `CUSTOMER_CONFIG_DIR`             | Path | `config/customer`                | Customer-specific customizations and branding                                                  |
| `ASSISTANT_CATEGORIES_CONFIG_DIR` | Path | `config/categories`              | Assistant categorization and organization                                                      |
| `AUTHORIZED_APPS_CONFIG_DIR`      | Path | `config/authorized_applications` | External application access control definitions                                                |
| `INDEX_DUMPS_DIR`                 | Path | `config/index-dumps`             | Pre-built index snapshots for faster deployment                                                |
| `ALEMBIC_MIGRATIONS_DIR`          | Path | `external/alembic`               | Database schema migration scripts                                                              |
| `ALEMBIC_INI_PATH`                | Path | `external/alembic/alembic.ini`   | Alembic database migration configuration                                                       |

---

## AI Providers Configuration

Configure connections to AI model providers. At least one provider must be configured for CodeMie to function.

### OpenAI / Azure OpenAI

For LLMs and embedding models via Azure OpenAI Service.

| Parameter                  | Type    | Default                | Description                                                                    |
| -------------------------- | ------- | ---------------------- | ------------------------------------------------------------------------------ |
| `OPENAI_API_TYPE`          | string  | `"azure"`              | Provider type: `azure` for Azure OpenAI, `openai` for direct OpenAI API        |
| `OPENAI_API_VERSION`       | string  | `"2025-04-01-preview"` | Azure OpenAI API version; update to access new features or model capabilities  |
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

| Parameter                                 | Type    | Default | Description                                                                                                                                                                |
| ----------------------------------------- | ------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GOOGLE_VERTEXAI_REGION`                  | string  | `""`    | Region for Vertex AI models (e.g., `us-central1`, `europe-west4`)                                                                                                          |
| `GOOGLE_CLAUDE_VERTEXAI_REGION`           | string  | `""`    | Separate region for Claude on Vertex AI if different from main region                                                                                                      |
| `GOOGLE_VERTEXAI_MAX_RETRIES`             | integer | `5`     | Retry attempts for rate-limited or failed Vertex AI requests                                                                                                               |
| `GOOGLE_PROJECT_ID`                       | string  | `""`    | GCP project ID where Vertex AI is enabled                                                                                                                                  |
| `GOOGLE_REGION`                           | string  | `""`    | Default GCP region for all Google services                                                                                                                                 |
| `GCP_API_KEY`                             | string  | `""`    | Base64-encoded service account JSON key for GCP authentication; not recommended for production — use Workload Identity instead to avoid storing long-lived credentials     |
| `VERTEX_AI_ANTHROPIC_ENABLE_PROMPT_CACHE` | boolean | `false` | Enable Anthropic prompt-caching headers when calling Claude models via Vertex AI; set to `true` only when the Vertex AI endpoint has confirmed support for caching headers |

---

## Additional AI Service Integrations

Additional AI services for multimodal capabilities beyond text generation.

### Image Generation

Enables AI-generated images for visual content creation within assistants.

| Parameter                | Type   | Default                  | Description                        |
| ------------------------ | ------ | ------------------------ | ---------------------------------- |
| `IMAGE_GENERATION_MODEL` | string | `gemini-3.1-flash-image` | Model used for AI image generation |

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

| Parameter              | Type                                 | Default       | Description                                                                                                                                                                                            |
| ---------------------- | ------------------------------------ | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `POSTGRES_HOST`        | string                               | `"localhost"` | PostgreSQL server hostname or IP address                                                                                                                                                               |
| `POSTGRES_PORT`        | integer                              | `5432`        | PostgreSQL server port                                                                                                                                                                                 |
| `POSTGRES_DB`          | string                               | `"postgres"`  | Database name for CodeMie tables and data                                                                                                                                                              |
| `POSTGRES_USER`        | string                               | `"postgres"`  | Database username with read/write permissions                                                                                                                                                          |
| `POSTGRES_PASSWORD`    | string                               | `"password"`  | Database password (use secrets manager in production)                                                                                                                                                  |
| `PG_URL`               | string                               | `""`          | Complete connection string (overrides individual params if set)                                                                                                                                        |
| `PG_POOL_SIZE`         | integer                              | `10`          | Connection pool size; increase for high concurrency workloads                                                                                                                                          |
| `DEFAULT_DB_SCHEMA`    | string                               | `"codemie"`   | PostgreSQL schema for organizing CodeMie tables                                                                                                                                                        |
| `PG_IAM_AUTH_PROVIDER` | string (`""`, `gcp`, `aws`, `azure`) | `""`          | Enables cloud IAM token-based authentication for PostgreSQL instead of a static password; when set, `POSTGRES_PASSWORD` is ignored and a short-lived token is fetched from the matching cloud provider |
| `PG_AWS_RDS_REGION`    | string                               | `""`          | AWS region used when generating an RDS IAM auth token (`PG_IAM_AUTH_PROVIDER=aws`); falls back to `AWS_DEFAULT_REGION` when empty                                                                      |

### Elasticsearch

Document store for full-text search, analytics, and unstructured data.

| Parameter                     | Type    | Default                   | Description                                                                                                                                                                          |
| ----------------------------- | ------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ELASTIC_URL`                 | string  | `"http://localhost:9200"` | Elasticsearch cluster endpoint URL                                                                                                                                                   |
| `ELASTIC_PASSWORD`            | string  | `""`                      | Password for `elastic` user or configured username                                                                                                                                   |
| `ELASTIC_USERNAME`            | string  | `""`                      | Username for Elasticsearch authentication                                                                                                                                            |
| `ELASTIC_DATASOURCE_REPLICAS` | integer | `1`                       | Number of replica shards for datasource indexes; set to `0` to have only the primary shard for each indexed datasource, reducing total shard usage on clusters with limited capacity |

#### Elasticsearch Indexes

Index names for different data types. Customize to avoid collisions in shared clusters.

| Parameter                                 | Type   | Default                                | Description                                                                                                                                                                            |
| ----------------------------------------- | ------ | -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ELASTIC_APPLICATION_INDEX`               | string | `"applications"`                       | Indexed applications and their metadata                                                                                                                                                |
| `ELASTIC_GIT_REPO_INDEX`                  | string | `"repositories"`                       | Code repository metadata and indexing status                                                                                                                                           |
| `ELASTIC_LOGS_INDEX`                      | string | `"logs-codemie-infra*"`                | Infrastructure logs pattern for monitoring and debugging                                                                                                                               |
| `ELASTIC_METRICS_INDEX`                   | string | `"codemie_metrics_logs*"`              | Index pattern used by the analytics repository for all ES\|QL queries and dashboard aggregations; changing this redirects the entire analytics dashboard to a different index or alias |
| `FEEDBACK_INDEX_NAME`                     | string | `"ca_feedback"`                        | User feedback and ratings on AI responses                                                                                                                                              |
| `BACKGROUND_TASKS_INDEX`                  | string | `"background_tasks"`                   | Async task queue and execution status                                                                                                                                                  |
| `USER_CONVERSATION_INDEX`                 | string | `"codemie_raw_user_conversations"`     | Complete conversation history and messages                                                                                                                                             |
| `USER_CONVERSATION_FOLDER_INDEX`          | string | `"codemie_conversation_folder"`        | Folder organization for conversation management                                                                                                                                        |
| `CONVERSATIONS_METRICS_INDEX`             | string | `"codemie_conversation_metrics"`       | Analytics data on conversation usage and performance                                                                                                                                   |
| `SHARED_CONVERSATION_INDEX`               | string | `"codemie_shared_conversations"`       | Conversations shared across users or teams                                                                                                                                             |
| `ASSISTANTS_INDEX`                        | string | `"codemie_assistants"`                 | Assistant definitions, configurations, and templates                                                                                                                                   |
| `WORKFLOWS_INDEX`                         | string | `"workflows"`                          | Workflow definitions and templates                                                                                                                                                     |
| `SETTINGS_INDEX`                          | string | `"codemie_user_settings"`              | User preferences and personalization data                                                                                                                                              |
| `USER_DATA_INDEX`                         | string | `"codemie_user_data"`                  | Additional user-related data and metadata                                                                                                                                              |
| `INDEX_STATUS_INDEX`                      | string | `"index_status"`                       | Status tracking for repository and datasource indexing                                                                                                                                 |
| `PROVIDERS_INDEX`                         | string | `"providers"`                          | AI provider configurations and availability                                                                                                                                            |
| `WORKFLOW_EXECUTION_INDEX`                | string | `"workflows_execution_history"`        | Historical workflow runs and outcomes                                                                                                                                                  |
| `WORKFLOW_EXECUTION_STATE_INDEX`          | string | `"workflows_execution_states"`         | Current state of running workflows                                                                                                                                                     |
| `WORKFLOW_EXECUTION_STATE_THOUGHTS_INDEX` | string | `"workflows_execution_state_thoughts"` | Workflow reasoning and decision logs                                                                                                                                                   |
| `TOOLS_INDEX_NAME`                        | string | `"codemie_tools"`                      | Semantic index for intelligent tool selection                                                                                                                                          |

---

## File Storage Configuration

Configure where and how CodeMie stores uploaded files, attachments, and generated content.

### General Storage Settings

| Parameter                       | Type    | Default               | Description                                                                                                 |
| ------------------------------- | ------- | --------------------- | ----------------------------------------------------------------------------------------------------------- |
| `FILES_STORAGE_TYPE`            | string  | `"filesystem"`        | Storage backend: `filesystem` (local on pod), `aws` (S3), `azure` (blob), `gcp` (bucket)                    |
| `FILES_STORAGE_DIR`             | string  | `"./codemie-storage"` | Local directory path when using `filesystem` storage type                                                   |
| `FILES_STORAGE_MAX_UPLOAD_SIZE` | integer | `104857600`           | Maximum file size in bytes (100 MB default); increase for large document processing                         |
| `REPOS_LOCAL_DIR`               | string  | `"./codemie-repos"`   | Directory for cloned Git repositories during code indexing                                                  |
| `IMAGE_INDEXING_MAX_SIZE_BYTES` | integer | `10485760`            | Maximum image file size in bytes (10 MB) during datasource indexing; files exceeding this limit are skipped |

### Cloud Storage - AWS S3

Configuration for Amazon S3 storage backend (requires `FILES_STORAGE_TYPE=aws`).

| Parameter                     | Type   | Default                    | Description                                                                                       |
| ----------------------------- | ------ | -------------------------- | ------------------------------------------------------------------------------------------------- |
| `AWS_DEFAULT_REGION`          | string | `""`                       | AWS region. Must be set if `AWS_S3_REGION` or `AWS_KMS_REGION` are not configured                 |
| `AWS_S3_REGION`               | string | `AWS_DEFAULT_REGION`       | S3-specific region override. When set, takes priority over `AWS_DEFAULT_REGION` for S3 operations |
| `AWS_S3_BUCKET_NAME`          | string | `""`                       | S3 bucket name for user files and attachments                                                     |
| `CODEMIE_STORAGE_BUCKET_NAME` | string | `"codemie-global-storage"` | Bucket for system-level shared assets and resources                                               |

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

## Redis Configuration

| Parameter                       | Type   | Default     | Description                                                                            |
| ------------------------------- | ------ | ----------- | -------------------------------------------------------------------------------------- |
| `REDIS_HOST`                    | string | `localhost` | Redis endpoint address                                                                 |
| `REDIS_PORT`                    | int    | `6379`      | Remote port                                                                            |
| `REDIS_PASSWORD`                | string | `""`        | Authentication secret for `default` user                                               |
| `REDIS_DB`                      | int    | `0`         | Redis database ID                                                                      |
| `REDIS_SSL`                     | bool   | `False`     | Enforce SSL connection to the remote endpoint                                          |
| `REDIS_SSL_CERT_REQS`           | string | `none`      | Require valid certificates from endpoint. Valid values: `none`, `optional`, `required` |
| `REDIS_CONNECT_TIMEOUT_SECONDS` | float  | `5.0`       | Connection timeout                                                                     |
| `REDIS_TIMEOUT_SECONDS`         | float  | `5.0`       | Socket timeout for regular operations                                                  |

---

## Security & Encryption

### Encryption Configuration

Protect sensitive data at rest using cloud key management services or HashiCorp Vault.

| Parameter         | Type   | Default   | Description                                                                                                                           |
| ----------------- | ------ | --------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `ENCRYPTION_TYPE` | string | `"plain"` | Encryption method: `plain` (none), `aws` (KMS), `azure` (Key Vault), `gcp` (Cloud KMS), `vault` (HashiCorp Vault with Transit Engine) |

### AWS KMS

Encrypt secrets and sensitive data using AWS Key Management Service.

| Parameter        | Type   | Default              | Description                                                                                         |
| ---------------- | ------ | -------------------- | --------------------------------------------------------------------------------------------------- |
| `AWS_KMS_KEY_ID` | string | `""`                 | KMS key ID or ARN for encryption/decryption operations                                              |
| `AWS_KMS_REGION` | string | `AWS_DEFAULT_REGION` | KMS-specific region override. When set, takes priority over `AWS_DEFAULT_REGION` for KMS operations |

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

## Identity & Access Management

Configure authentication providers and access control for users and administrators.

### IDP Configuration

| Parameter             | Type   | Default   | Description                                                            |
| --------------------- | ------ | --------- | ---------------------------------------------------------------------- |
| `IDP_PROVIDER`        | string | `"local"` | Identity provider: `keycloak` (recommended), `local` (for development) |
| `KEYCLOAK_LOGOUT_URL` | string | `""`      | Keycloak logout endpoint for proper session termination                |
| `ADMIN_USER_ID`       | string | `""`      | User ID to automatically grant admin privileges on startup             |
| `ADMIN_ROLE_NAME`     | string | `"admin"` | Role name identifying administrators in the system                     |

### User Management Mode

Controls whether user roles and project access are read from JWT claims (Keycloak-managed mode)
or stored in the platform database (Platform-managed mode). See
[Access Control Overview](../access-control/index.md) for a full comparison.

For step-by-step instructions on enabling Platform-managed mode and migrating existing
Keycloak users, see
[Platform-managed Mode Configuration](../access-control/platform-managed-mode-configuration.md).

| Parameter                | Type | Default | Description                                                                                                                                                                                                                          |
| ------------------------ | ---- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ENABLE_USER_MANAGEMENT` | bool | `false` | Master switch. `true` enables Platform-managed mode: roles and project membership are stored in the platform DB and managed through the in-app UI. `false` uses Keycloak-managed mode where JWT claims are the authoritative source. |
| `USER_PROJECT_LIMIT`     | int  | `3`     | Maximum number of shared projects a regular user can be assigned to. Enforced only when `ENABLE_USER_MANAGEMENT=true`. Super Admins always have unlimited access.                                                                    |

#### Keycloak User Migration

Required only when `ENABLE_USER_MANAGEMENT=true` and `IDP_PROVIDER=keycloak`. Enables a
one-time import of existing Keycloak users and their project attributes into the platform
database on startup.

| Parameter                                  | Type    | Default | Description                                                                                                                                      |
| ------------------------------------------ | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `KEYCLOAK_MIGRATION_ENABLED`               | bool    | `false` | Enables the one-time import of Keycloak users into the platform database. Run once during initial migration; disable after the import completes. |
| `KEYCLOAK_ADMIN_URL`                       | string  | `""`    | Keycloak base URL for admin API access (e.g., `https://keycloak.example.com`).                                                                   |
| `KEYCLOAK_ADMIN_REALM`                     | string  | `""`    | Keycloak realm to migrate (e.g., `codemie-prod`).                                                                                                |
| `KEYCLOAK_ADMIN_CLIENT_ID`                 | string  | `""`    | Service account client ID with Keycloak admin permissions.                                                                                       |
| `KEYCLOAK_ADMIN_CLIENT_SECRET`             | string  | `""`    | Service account client secret.                                                                                                                   |
| `KEYCLOAK_MIGRATION_BATCH_SIZE`            | integer | `100`   | Number of Keycloak users fetched per paginated API call; smaller values reduce memory pressure during large migrations.                          |
| `KEYCLOAK_MIGRATION_LOCK_TIMEOUT_MINUTES`  | integer | `30`    | Age threshold after which a migration lock held by another pod is considered stale and may be taken over; prevents deadlocks when a pod crashes. |
| `KEYCLOAK_MIGRATION_WAIT_INTERVAL_SECONDS` | integer | `5`     | How long a follower pod sleeps between polls while waiting for the leader pod to finish the migration.                                           |

---

### Admin Bootstrap

Auto-create a SuperAdmin account on startup when none exists. Active only when `IDP_PROVIDER=local` and `ENABLE_USER_MANAGEMENT=true` in non-local environments.

| Parameter             | Type   | Default | Description                                                                            |
| --------------------- | ------ | ------- | -------------------------------------------------------------------------------------- |
| `SUPERADMIN_EMAIL`    | string | `""`    | Email for the auto-created SuperAdmin; both fields must be set to trigger bootstrap    |
| `SUPERADMIN_PASSWORD` | string | `""`    | Password for the auto-created SuperAdmin; both fields must be set to trigger bootstrap |

---

### Local Authentication (JWT)

Used only when `IDP_PROVIDER=local`. Keys are auto-generated on first startup if the files do not exist.

| Parameter              | Type    | Default                   | Description                                                                                                      |
| ---------------------- | ------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `JWT_ALGORITHM`        | string  | `"RS256"`                 | Algorithm used to sign and verify local-auth JWTs; changing this requires regenerating the key files             |
| `JWT_EXPIRATION_HOURS` | integer | `24`                      | Lifetime of locally-issued access tokens in hours                                                                |
| `JWT_PRIVATE_KEY_PATH` | string  | `".keys/jwt_private.pem"` | Path to the RSA private key PEM file used to sign tokens                                                         |
| `JWT_PUBLIC_KEY_PATH`  | string  | `".keys/jwt_public.pem"`  | Path to the RSA public key PEM file used to verify tokens                                                        |
| `JWT_ISSUER`           | string  | `"codemie-local"`         | Value of the `iss` claim in every locally-issued JWT; tokens with a mismatched issuer are rejected with HTTP 401 |

---

### JWKS Signature Validation

Optional defense-in-depth layer that cryptographically verifies inbound bearer JWTs against trusted issuers' JWKS endpoints before any IDP claim extraction.

| Parameter                   | Type    | Default | Description                                                                                                                          |
| --------------------------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `JWKS_VALIDATION_ENABLED`   | boolean | `false` | When `true`, wraps the active IDP with a JWKS-validating layer; every inbound JWT is verified against the configured trusted issuers |
| `JWKS_TRUSTED_ISSUERS`      | string  | `""`    | JSON array of `{issuer, audience, jwks_uri?, discovery_url?}` objects; required when `JWKS_VALIDATION_ENABLED=true`                  |
| `JWKS_CACHE_TTL_SECONDS`    | integer | `300`   | How long fetched public key sets are cached in memory before a fresh fetch from the issuer's endpoint                                |
| `JWKS_HTTP_TIMEOUT_SECONDS` | float   | `3.0`   | Per-request HTTP timeout when fetching JWKS or OIDC discovery documents from trusted issuers                                         |
| `JWKS_LEEWAY_SECONDS`       | integer | `30`    | Clock-skew tolerance applied when verifying JWT `exp` and `nbf` claims                                                               |

---

### Cookie-Based Authentication

Session cookie settings for the local-auth login flow. Only relevant when `IDP_PROVIDER=local`.

| Parameter                   | Type                             | Default                  | Description                                                                                                                          |
| --------------------------- | -------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `RATE_LIMIT_LOGIN`          | string                           | `"5/15minutes"`          | Slowdown rate for the login endpoint expressed as `"<count>/<period>"`; exceeding it returns HTTP 429 to prevent credential-stuffing |
| `AUTH_COOKIE_NAME`          | string                           | `"codemie_access_token"` | Name of the HTTP cookie that carries the access token to browsers                                                                    |
| `AUTH_COOKIE_HTTPONLY`      | boolean                          | `true`                   | Sets `HttpOnly` on the auth cookie; prevents JavaScript from reading it, reducing XSS token-theft risk                               |
| `AUTH_COOKIE_SECURE`        | boolean                          | `false`                  | Sets `Secure` on the auth cookie so browsers transmit it over HTTPS only; must be `true` in production                               |
| `AUTH_COOKIE_SAMESITE`      | string (`lax`, `strict`, `none`) | `"lax"`                  | `SameSite` attribute controlling cross-site request inclusion; use `strict` for maximum CSRF protection                              |
| `AUTH_COOKIE_PATH`          | string                           | `"/"`                    | Cookie `Path` attribute; narrowing this prevents the cookie from being sent to unrelated endpoints                                   |
| `AUTH_TOKEN_CACHE_MAX_SIZE` | integer                          | `10000`                  | Maximum entries in the in-memory cache that maps validated tokens to user objects, avoiding repeated database lookups                |
| `AUTH_TOKEN_CACHE_TTL`      | integer                          | `30`                     | TTL in seconds for cached token-to-user mappings; shorter values shrink the window where a revoked token is still accepted           |

---

### Email & Password (Local Auth)

SMTP configuration for sending verification and password-reset emails. Only active when `IDP_PROVIDER=local`.

| Parameter                    | Type    | Default                   | Description                                                                                               |
| ---------------------------- | ------- | ------------------------- | --------------------------------------------------------------------------------------------------------- |
| `EMAIL_VERIFICATION_ENABLED` | boolean | `true`                    | When `true`, new users must verify their email before logging in; set `false` to auto-verify all accounts |
| `EMAIL_SMTP_HOST`            | string  | `""`                      | SMTP server hostname; leave empty to disable email sending entirely                                       |
| `EMAIL_SMTP_PORT`            | integer | `587`                     | SMTP server port                                                                                          |
| `EMAIL_SMTP_USERNAME`        | string  | `""`                      | SMTP account username                                                                                     |
| `EMAIL_SMTP_PASSWORD`        | string  | `""`                      | SMTP account password                                                                                     |
| `EMAIL_FROM_ADDRESS`         | string  | `""`                      | `From:` address for outbound emails; must be set for email delivery to be active                          |
| `EMAIL_FROM_NAME`            | string  | `"CodeMie"`               | Display name shown alongside `EMAIL_FROM_ADDRESS` in email clients                                        |
| `EMAIL_USE_TLS`              | boolean | `true`                    | Use STARTTLS upgrade on the configured port; set `false` for servers using implicit TLS or no TLS         |
| `FRONTEND_URL`               | string  | `"http://localhost:3000"` | Base URL of the frontend, used to build clickable verification and password-reset links in emails         |
| `PASSWORD_MIN_LENGTH`        | integer | `12`                      | Minimum character length for passwords; shorter passwords are rejected with HTTP 400                      |

---

### Cost Center

| Parameter                  | Type   | Default                   | Description                                                                                                            |
| -------------------------- | ------ | ------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `COST_CENTER_NAME_PATTERN` | string | `"^[a-z0-9]+-[a-z0-9]+$"` | Regex applied via `re.fullmatch` to every cost-center name at creation or update time; names not matching are rejected |

---

### Broker Token Exchange

Multi-hop Keycloak token exchange chain. Activated automatically when `BROKER_TOKEN_URLS` is non-empty.

| Parameter                  | Type   | Default | Description                                                                                                                                 |
| -------------------------- | ------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `BROKER_TOKEN_URLS`        | string | `""`    | Comma-separated base URLs for each hop in the exchange chain; must have the same length as `BROKER_TOKEN_REALMS` and `BROKER_TOKEN_BROKERS` |
| `BROKER_TOKEN_REALMS`      | string | `""`    | Comma-separated realm names, one per hop                                                                                                    |
| `BROKER_TOKEN_BROKERS`     | string | `""`    | Comma-separated broker identifiers, one per hop                                                                                             |
| `BROKER_TOKEN_TIMEOUT`     | float  | `5.0`   | Per-hop HTTP request timeout in seconds                                                                                                     |
| `BROKER_AUTH_LOCATION_URL` | string | `""`    | Value placed in the `x-user-mcp-auth-location` response header when a broker exchange step returns an auth failure                          |

---

### OIDC Token Exchange

Swaps a user's current access token for an audience-scoped token required by an MCP server, using a Keycloak or Okta token endpoint.

| Parameter                           | Type   | Default                                             | Description                                                                                              |
| ----------------------------------- | ------ | --------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `TOKEN_EXCHANGE_URL`                | string | `""`                                                | OAuth 2.0 token endpoint URL; leave empty to disable OIDC token exchange                                 |
| `TOKEN_EXCHANGE_GRANT_TYPE`         | string | `"urn:ietf:params:oauth:grant-type:token-exchange"` | OAuth 2.0 `grant_type` sent to the exchange endpoint; rarely needs changing                              |
| `TOKEN_EXCHANGE_CLIENT_ID`          | string | `""`                                                | OAuth 2.0 client ID for the token exchange service account                                               |
| `TOKEN_EXCHANGE_CLIENT_SECRET`      | string | `""`                                                | OAuth 2.0 client secret for the token exchange service account                                           |
| `TOKEN_EXCHANGE_SUBJECT_TOKEN_TYPE` | string | `"urn:ietf:params:oauth:token-type:access_token"`   | `subject_token_type` parameter sent with the exchange request                                            |
| `TOKEN_EXCHANGE_TIMEOUT`            | float  | `5.0`                                               | HTTP request timeout in seconds for each token exchange call                                             |
| `TOKEN_EXCHANGE_SERVICE`            | string | `"keycloak"`                                        | Credential encoding: `keycloak` sends credentials in the POST body; `okta` uses HTTP Basic Authorization |

---

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
| `GOOGLE_SEARCH_API_KEY` | string | `""`    | API key for Google Custom Search integration. Can be registered in the GCP account                                                   |
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

### SharePoint OAuth

Enable delegated authentication for SharePoint datasources using Authorization Code + PKCE flow.

| Parameter                    | Type    | Default                                                    | Description                                                                                                                                 |
| ---------------------------- | ------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `SHAREPOINT_PKCE_ENABLED`    | boolean | `false`                                                    | Enable Authorization Code + PKCE flow for SharePoint OAuth. Requires `SHAREPOINT_OAUTH_CLIENT_ID` and a matching Azure AD app registration. |
| `SHAREPOINT_OAUTH_CLIENT_ID` | string  | `""`                                                       | Azure AD application (client) ID used for SharePoint OAuth authorization.                                                                   |
| `SHAREPOINT_OAUTH_SCOPES`    | string  | `"Sites.Read.All Files.Read.All offline_access User.Read"` | Space-separated OAuth scopes requested during authorization.                                                                                |

:::warning Redis Required
SharePoint PKCE flow stores OAuth state and tokens in Redis during the authorization handshake. A running Redis instance must be configured (see [Redis Configuration](#redis-configuration)) before enabling `SHAREPOINT_PKCE_ENABLED`.
:::

:::info Azure AD Setup
The redirect URI registered in the Azure AD app must match:

```
{CALLBACK_API_BASE_URL}{API_ROOT_PATH}/v1/sharepoint/oauth/callback
```

Use the **Web** platform type in Azure AD app registration. Also enable the customer feature flag `features:sharepointCodeMieOAuth` to show the "Sign in with Microsoft" button in the SharePoint datasource setup UI.
:::

### Google OAuth

Enable delegated Google authentication for Google Docs datasources using Authorization Code + PKCE flow.

| Parameter                    | Type   | Default | Description                                        |
| ---------------------------- | ------ | ------- | -------------------------------------------------- |
| `GOOGLE_OAUTH_CLIENT_ID`     | string | `""`    | OAuth 2.0 Client ID from Google Cloud Console.     |
| `GOOGLE_OAUTH_CLIENT_SECRET` | string | `""`    | OAuth 2.0 Client Secret from Google Cloud Console. |

:::warning Redis Required
The Google OAuth flow stores PKCE state and tokens in Redis during the authorization handshake. A running Redis instance must be configured (see [Redis Configuration](#redis-configuration)) before enabling Google OAuth.
:::

:::info Google Cloud Console Setup

1. Create an **OAuth 2.0 Client ID** (application type: **Web application**) in [Google Cloud Console](https://console.cloud.google.com/) under **APIs & Services → Credentials**.
2. Register the following **Authorized Redirect URI**:
   ```
   {CALLBACK_API_BASE_URL}{API_ROOT_PATH}/v1/google-oauth/callback
   ```
   `CALLBACK_API_BASE_URL` is documented in [Callback Configuration](#callback-configuration). `API_ROOT_PATH` defaults to `/code-assistant-api` in Helm deployments.
3. Enable these APIs under **APIs & Services → Library**: **Google Docs API**.
   :::

---

## NATS Message Broker Configuration

:::warning Deprecated

NATS is currently deprecated as part of the NATS retirement direction.

:::

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

Control which HTTP headers are forwarded to downstream services (MCP servers, providers) for security and privacy.

| Parameter                     | Type   | Default                                                                                       | Description                                                                                                                                               |
| ----------------------------- | ------ | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `FORWARDED_HEADERS_BLOCKLIST` | string | `"authorization,cookie,set-cookie,x-api-key,x-auth-token,x-internal-secret,x-internal-token"` | Comma-separated header names (case-insensitive) to block from forwarding to downstream services; prevents credential leakage to MCP servers and providers |

### MCP Token Cache

| Parameter              | Type    | Default | Description                                                                    |
| ---------------------- | ------- | ------- | ------------------------------------------------------------------------------ |
| `TOKEN_CACHE_TTL`      | integer | `600`   | Lifetime in seconds for cached exchanged tokens (10 minutes)                   |
| `TOKEN_CACHE_MAX_SIZE` | integer | `1024`  | Max total entries across all token caches (per-user and per-audience combined) |

---

## MCP Auth Configuration

Configure MCP OAuth2 authorization server integration for secure MCP client authentication and token management.

### MCP Auth Core

| Parameter              | Type    | Default | Description                                                                                                      |
| ---------------------- | ------- | ------- | ---------------------------------------------------------------------------------------------------------------- |
| `MCP_AUTH_ENABLED`     | boolean | `false` | Enable MCP OAuth2 authorization server; required for MCP clients that need delegated access to external services |
| `MCP_AUTH_HMAC_SECRET` | string  | `""`    | HMAC secret for signing MCP auth state tokens; set a strong random value in production                           |

### MCP Auth Security

| Parameter                                  | Type    | Default              | Description                                                                                 |
| ------------------------------------------ | ------- | -------------------- | ------------------------------------------------------------------------------------------- |
| `MCP_AUTH_REDIS_KEY_NAMESPACE`             | string  | `"codemie:mcp_auth"` | Redis key namespace prefix for all MCP auth stores; must not end with `:`                   |
| `MCP_AUTH_ENFORCE_HTTPS`                   | boolean | `true`               | Enforce HTTPS for all MCP auth redirect and callback URLs; disable only in development      |
| `MCP_AUTH_ALLOW_LOCAL_CLIENT_METADATA_URL` | boolean | `false`              | Allow `localhost` URLs for MCP client metadata discovery; enable only for local development |

### MCP Auth Discovery

| Parameter                                              | Type    | Default | Description                                                             |
| ------------------------------------------------------ | ------- | ------- | ----------------------------------------------------------------------- |
| `MCP_AUTH_DISCOVERY_CONCURRENCY_LIMIT`                 | integer | `5`     | Max concurrent MCP authorization server metadata discovery requests     |
| `MCP_AUTH_AS_METADATA_DISCOVERY_TIMEOUT_SECONDS`       | float   | `30.0`  | Timeout in seconds for authorization server metadata discovery requests |
| `MCP_AUTH_DCR_REGISTRATION_TIMEOUT_SECONDS`            | float   | `30.0`  | Timeout in seconds for dynamic client registration (DCR) requests       |
| `MCP_AUTH_DISCOVERY_PROBE_OVERALL_TIMEOUT_SECONDS`     | float   | `30.0`  | Overall timeout in seconds for the full discovery probe sequence        |
| `MCP_AUTH_RESOURCE_METADATA_DISCOVERY_TIMEOUT_SECONDS` | float   | `30.0`  | Timeout in seconds for protected resource metadata discovery            |

### MCP Auth Token Management System (TMS)

Enterprise-grade PostgreSQL-backed token storage with KMS encryption. Replaces the default in-memory mock TMS.

| Parameter                                 | Type    | Default | Description                                                                                                   |
| ----------------------------------------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------- |
| `MCP_AUTH_TMS_ENABLED`                    | boolean | `false` | Enable PostgreSQL-backed enterprise TMS instead of the in-memory mock; required for production deployments    |
| `MCP_AUTH_TMS_KMS_KEY_ID`                 | string  | `""`    | KMS key ID for envelope encryption of stored credentials; required when TMS is enabled                        |
| `MCP_AUTH_TMS_REFRESH_TIMEOUT_SECONDS`    | float   | `2.5`   | OAuth2 token refresh timeout in seconds; enterprise validation requires a value between 0 and 3               |
| `MCP_AUTH_TMS_REDIS_LOCK_ENABLED`         | boolean | `true`  | Enable Redis refresh locks to prevent duplicate refresh storms across clustered backend instances             |
| `MCP_AUTH_TMS_REDIS_LOCK_TTL_SECONDS`     | integer | `10`    | Refresh lock TTL in seconds; must be greater than `MCP_AUTH_TMS_REFRESH_TIMEOUT_SECONDS`                      |
| `MCP_AUTH_TMS_AUDIT_REQUIRED`             | boolean | `true`  | Require a durable audit write to complete before credential operations return successfully                    |
| `MCP_AUTH_TMS_AUDIT_FALLBACK_ENABLED`     | boolean | `false` | Enable a durable fallback audit sink when the primary audit write path is unavailable                         |
| `MCP_AUTH_TMS_AUDIT_SANITIZE_DIAGNOSTICS` | boolean | `true`  | Sanitize sensitive diagnostic details from audit records before storage                                       |
| `MCP_AUTH_TMS_ALLOW_MOCK`                 | boolean | `false` | Allow in-memory mock TMS in non-production environments when real TMS is disabled; never enable in production |

### Webhook Rate Limiting

Protect webhook endpoints with Redis-backed fixed-window rate limiting.

| Parameter                                | Type    | Default                        | Description                                             |
| ---------------------------------------- | ------- | ------------------------------ | ------------------------------------------------------- |
| `WEBHOOK_RATE_LIMIT_ENABLED`             | boolean | `true`                         | Enable rate limiting on incoming webhook requests       |
| `WEBHOOK_RATE_LIMIT_MAX_REQUESTS`        | integer | `10`                           | Max webhook requests allowed per time window per client |
| `WEBHOOK_RATE_LIMIT_WINDOW_SECONDS`      | integer | `60`                           | Rate limit time window in seconds                       |
| `WEBHOOK_RATE_LIMIT_REDIS_KEY_NAMESPACE` | string  | `"codemie:webhook_rate_limit"` | Redis key namespace prefix for rate limit counters      |

---

## LLM Proxy & LiteLLM Configuration

<EnterpriseFeature />

Configure LiteLLM proxy for unified LLM access, budget management, and usage tracking.

### Proxy Mode

| Parameter                                               | Type    | Default      | Description                                                                                                                                                                                                                                                                                                                                            |
| ------------------------------------------------------- | ------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `LLM_PROXY_MODE`                                        | string  | `"internal"` | Proxy mode: `internal` (built-in routing), `lite_llm` (external LiteLLM proxy)                                                                                                                                                                                                                                                                         |
| `LLM_PROXY_ENABLED`                                     | boolean | `false`      | Enable LLM proxy for centralized model access control                                                                                                                                                                                                                                                                                                  |
| `LLM_PROXY_TIMEOUT`                                     | integer | `300`        | Max seconds to wait for proxy responses                                                                                                                                                                                                                                                                                                                |
| `LLM_PROXY_EMBEDDINGS_DISABLED`                         | boolean | `false`      | When `true`, bypasses the LiteLLM proxy for embedding requests and sends them directly to the native provider (e.g., Azure OpenAI). Useful when LiteLLM does not support a required embedding model or when lower-latency direct access is preferred for vector operations. Has no effect when `LLM_PROXY_ENABLED=false` or `LLM_PROXY_MODE=internal`. |
| `LLM_PROXY_LANGFUSE_TRACES`                             | boolean | `false`      | Enable Langfuse tracing for requests going through the LiteLLM proxy                                                                                                                                                                                                                                                                                   |
| `LLM_PROXY_TRACK_USAGE`                                 | boolean | `true`       | Track token usage for requests going through the LiteLLM proxy; disable to skip usage recording                                                                                                                                                                                                                                                        |
| `LLM_PROXY_SHARED_ASSET_PROJECT_BUDGET_ROUTING_ENABLED` | boolean | `true`       | Route requests for shared assets (assistants, workflows not owned by a personal project) to the project budget instead of the user's personal budget                                                                                                                                                                                                   |

### LiteLLM Connection

Connect to external LiteLLM proxy for advanced features like load balancing and fallbacks.

| Parameter                | Type   | Default | Description                                                                                           |
| ------------------------ | ------ | ------- | ----------------------------------------------------------------------------------------------------- |
| `LITE_LLM_URL`           | string | `""`    | LiteLLM proxy server URL (e.g., `http://litellm:4000`)                                                |
| `LITE_LLM_APP_KEY`       | string | `""`    | Application-specific key for LiteLLM authentication                                                   |
| `LITE_LLM_MASTER_KEY`    | string | `""`    | Master key for LiteLLM administrative operations                                                      |
| `LITE_LLM_PROXY_APP_KEY` | string | `""`    | Optional API key for proxy endpoints used by coding agents; falls back to `LITE_LLM_APP_KEY` if empty |

### LiteLLM Model Tagging

Tag LLM requests for cost tracking and usage analytics.

| Parameter                        | Type   | Default     | Description                                                  |
| -------------------------------- | ------ | ----------- | ------------------------------------------------------------ |
| `LITE_LLM_PROJECTS_TO_TAGS_LIST` | string | `""`        | Comma-separated project names to include as request tags     |
| `LITE_LLM_TAGS_HEADER_VALUE`     | string | `"default"` | Default tag value when project doesn't match configured list |

### LiteLLM Budget Configuration

Set spending limits per user or team to control LLM usage costs.

| Parameter                                         | Type         | Default          | Description                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ------------------------------------------------- | ------------ | ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `LLM_PROXY_BUDGET_CHECK_ENABLED`                  | boolean      | `false`          | Enables LLM budget enforcement. When `true`, CodeMie actively enforces spending limits - requests from users or projects that have exceeded their budget are blocked. Also enables budget API routes and background budget maintenance. `budgets-config.yaml` defines predefined budgets; set `LLM_PROXY_BUDGET_RECONCILIATION_ENABLED=true` to sync them into the database and LiteLLM on startup.                                          |
| `LLM_PROXY_BUDGET_RECONCILIATION_ENABLED`         | boolean      | `false`          | Runs a budget reconciliation job after app readiness to align LiteLLM and CodeMie budget states.                                                                                                                                                                                                                                                                                                                                             |
| `LLM_PROXY_BUDGET_RECONCILIATION_TIMEOUT_SECONDS` | integer      | `600`            | Timeout in seconds for a single reconciliation run.                                                                                                                                                                                                                                                                                                                                                                                          |
| `LITELLM_PREMIUM_MODELS_ALIASES`                  | list[string] | `[]`             | List of model name substrings treated as premium (e.g., `["opus", "claude-4"]`). Matched case-insensitively against the requested model name. When a match is found, the request is routed to a separate `premium_models` budget instead of the default platform budget, enabling independent spend tracking and stricter limits for costly models. Required when a `premium_models` budget category is configured in `budgets-config.yaml`. |
| `BUDGETS_CONFIG_DIR`                              | Path         | `config/budgets` | Directory path for the `budgets-config.yaml` file defining predefined budget policies.                                                                                                                                                                                                                                                                                                                                                       |

#### Budget Cache

Caches user-to-budget resolution results to reduce database load on high-traffic deployments.

| Parameter                             | Type    | Default  | Description                                                                                                                           |
| ------------------------------------- | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `BUDGET_ASSIGNMENT_CACHE_TTL`         | integer | `60`     | TTL in seconds for the user-to-budget assignment cache (user to category to budget ID mapping).                                       |
| `BUDGET_ASSIGNMENT_CACHE_MAX_SIZE`    | integer | `50000`  | Maximum number of entries in the assignment cache.                                                                                    |
| `BUDGET_RESOLUTION_CACHE_TTL`         | integer | `60`     | TTL in seconds for the budget resolution cache.                                                                                       |
| `BUDGET_RESOLUTION_CACHE_MAX_SIZE`    | integer | `50000`  | Maximum number of entries in the resolution cache.                                                                                    |
| `BUDGET_USAGE_STALENESS_THRESHOLD_MS` | integer | `600000` | Threshold in milliseconds (10 min) after which budget usage is considered stale and lazily refreshed on the `/budget_usage` endpoint. |

#### Budget Reset Tracking

Manages automatic reset of per-member budget windows aligned with LiteLLM's reset cycle.

| Parameter                                            | Type    | Default          | Description                                                                                                                             |
| ---------------------------------------------------- | ------- | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `LITELLM_BUDGET_RESET_TRACKER_ENABLED`               | boolean | `false`          | Enables the background job that monitors soon-to-reset project budget windows.                                                          |
| `LITELLM_BUDGET_RESET_TRACKER_SCHEDULE`              | string  | `"*/10 * * * *"` | Cron schedule (UTC) for the reset-window tracker job. Defaults to every 10 minutes.                                                     |
| `LITELLM_BUDGET_RESET_WINDOW_MINUTES`                | integer | `15`             | Look-ahead window in minutes for detecting project budgets that will reset soon.                                                        |
| `LITELLM_BUDGET_RESET_RECONCILIATION_ENABLED`        | boolean | `false`          | Enables the daily reconciliation job that re-syncs reset state at midnight UTC.                                                         |
| `LITELLM_BUDGET_RESET_RECONCILIATION_SCHEDULE`       | string  | `"10 0 * * *"`   | Cron schedule (UTC) for the reset reconciliation job. Must run within `LITELLM_BUDGET_RESET_RECONCILIATION_WINDOW_MINUTES` of midnight. |
| `LITELLM_BUDGET_RESET_RECONCILIATION_WINDOW_MINUTES` | integer | `10`             | Allowed execution window in minutes after midnight UTC for the reconciliation job.                                                      |

### LiteLLM Spend Tracking

Configure the background scheduler that collects project-level spending snapshots from LiteLLM
and stores them in the `project_spend_tracking` table. The collector runs automatically for all
projects — no per-project filtering configuration is required.

| Parameter                          | Type    | Default        | Description                                                                                   |
| ---------------------------------- | ------- | -------------- | --------------------------------------------------------------------------------------------- |
| `LITELLM_SPEND_COLLECTOR_ENABLED`  | boolean | `false`        | Enables the background spend collector job that stores project-level LiteLLM spend snapshots. |
| `LITELLM_SPEND_COLLECTOR_SCHEDULE` | string  | `"0 23 * * *"` | Cron schedule (UTC) for the spend collector. Defaults to nightly at 11 PM (`0 23 * * *`).     |

### LiteLLM Cache & Optimization

Reduce latency and API costs by caching metadata and responses.

| Parameter                            | Type    | Default | Description                                                                  |
| ------------------------------------ | ------- | ------- | ---------------------------------------------------------------------------- |
| `LITELLM_CUSTOMER_CACHE_TTL`         | integer | `300`   | Customer info cache duration in seconds (5 minutes)                          |
| `LITELLM_USER_CREDENTIALS_CACHE_TTL` | integer | `600`   | User LiteLLM credential lookup cache duration in seconds (10 minutes)        |
| `LITELLM_MODELS_CACHE_TTL`           | integer | `1800`  | Available models list cache duration in seconds (30 minutes)                 |
| `LITELLM_REQUEST_TIMEOUT`            | float   | `5.0`   | Timeout in seconds for metadata requests to LiteLLM proxy                    |
| `LITELLM_LIST_REQUEST_TIMEOUT`       | float   | `30.0`  | Timeout in seconds for list and bulk endpoints that return larger payloads   |
| `LITELLM_FAIL_OPEN_ON_503`           | boolean | `true`  | Allow requests when LiteLLM proxy is unavailable (bypass mode on 503 errors) |

---

## Agent & Workflow Configuration

Control AI agent behavior, workflow execution limits, and parallel processing.

### AI Agent Settings

| Parameter                                 | Type    | Default | Description                                                                          |
| ----------------------------------------- | ------- | ------- | ------------------------------------------------------------------------------------ |
| `AI_AGENT_RECURSION_LIMIT`                | integer | `150`   | Max agent reasoning steps to prevent infinite loops                                  |
| `ENABLE_LANGGRAPH_AITOOLS_AGENT`          | boolean | `true`  | Use LangGraph-based agent for advanced tool orchestration                            |
| `AI_AGENT_CONVERSATION_REPLAY_V2_ENABLED` | boolean | `true`  | Enable v2 conversation replay that summarizes older tool turns to reduce token usage |

### AI Agent History Replay

Control how previous conversation turns are replayed to the agent to balance context fidelity with token usage.

| Parameter                                       | Type    | Default | Description                                                                      |
| ----------------------------------------------- | ------- | ------- | -------------------------------------------------------------------------------- |
| `AI_AGENT_HISTORY_REPLAY_FULL_TOOL_TURNS`       | integer | `4`     | Number of most-recent tool turns to include in full (uncompressed) form          |
| `AI_AGENT_HISTORY_REPLAY_SUMMARIZED_TOOL_TURNS` | integer | `6`     | Number of older tool turns to include in summarized form before they are dropped |

### AI Agent History Compaction

Automatically compress long conversation histories when token usage exceeds a threshold, preserving recent context while summarizing older turns.

| Parameter                                       | Type    | Default  | Description                                                                                         |
| ----------------------------------------------- | ------- | -------- | --------------------------------------------------------------------------------------------------- |
| `AI_AGENT_HISTORY_COMPACTION_ENABLED`           | boolean | `false`  | Enable automatic history compaction when conversation exceeds the token limit                       |
| `AI_AGENT_HISTORY_COMPACTION_TOKEN_LIMIT`       | integer | `120000` | Token count that triggers compaction; history is summarized when this threshold is reached          |
| `AI_AGENT_HISTORY_COMPACTION_TRIGGER_RATE`      | float   | `0.8`    | Fraction of `TOKEN_LIMIT` at which compaction is triggered (e.g., `0.8` = trigger at 96000 tokens)  |
| `AI_AGENT_HISTORY_COMPACTION_TARGET_RATE`       | float   | `0.5`    | Fraction of `TOKEN_LIMIT` to reduce history to after compaction (e.g., `0.5` = target 60000 tokens) |
| `AI_AGENT_HISTORY_COMPACTION_PRESERVE_GROUPS`   | integer | `6`      | Number of most-recent conversation groups to preserve verbatim during compaction                    |
| `AI_AGENT_HISTORY_COMPACTION_BATCH_TOKEN_LIMIT` | integer | `24000`  | Max tokens per compaction summary batch; larger batches produce fewer but longer summaries          |

### Workflow Configuration

| Parameter                      | Type    | Default | Description                                                                           |
| ------------------------------ | ------- | ------- | ------------------------------------------------------------------------------------- |
| `WORKFLOW_MAX_CONCURRENCY`     | integer | `5`     | Max simultaneous workflow executions to control resource usage                        |
| `WORKFLOW_DEFAULT_CONCURRENCY` | integer | `2`     | Default concurrency when not specified by workflow                                    |
| `WORKFLOW_GENERATION_ENABLED`  | boolean | `false` | Enable AI-assisted workflow generation feature                                        |
| `WORKFLOW_GENERATOR_LLM_MODEL` | string  | `""`    | LLM model used for workflow generation; falls back to global default model when empty |

### Sub-workflows

The customer configuration feature gate `features:subWorkflow` controls whether Sub-workflows are available. When the gate is disabled, the visual editor hides Sub-workflow controls and the API and runtime reject Sub-workflow use, independently of the backend defaults below.

| Parameter                                  | Type    | Default | Description                                                                                         |
| ------------------------------------------ | ------- | ------- | --------------------------------------------------------------------------------------------------- |
| `SUBWORKFLOW_MAX_NESTING_DEPTH`            | integer | `1`     | Default nesting limit when the selected child workflow does not define `max_nesting_level`          |
| `SUBWORKFLOW_POOL_ENABLED`                 | boolean | `false` | Globally permits workflow pooling; the selected child must also set `pool_config.enabled` to `true` |
| `SUBWORKFLOW_POOL_MAX_SIZE`                | integer | `5`     | Global cap applied to the number of pooled instances for each workflow                              |
| `SUBWORKFLOW_POOL_WARMUP_INTERVAL_SECONDS` | integer | `60`    | Interval in seconds used by the background watcher to discover and refill eligible workflow pools   |

Pooling is active for a workflow only when `SUBWORKFLOW_POOL_ENABLED` and that workflow's `pool_config.enabled` are both enabled. The effective pool size cannot exceed `SUBWORKFLOW_POOL_MAX_SIZE`, even when the workflow defines a larger `pool_config.max_size`. The watcher cadence is controlled by `SUBWORKFLOW_POOL_WARMUP_INTERVAL_SECONDS`, not by the workflow's `pool_config.refill_interval_seconds` value.

For authoring instructions, see [Sub-workflows](../../../user-guide/workflows/subworkflows.md). For per-workflow YAML settings and supported ranges, see [Sub-workflow Node](../../../user-guide/workflows/configuration/specialized-nodes.md#85-sub-workflow-node).

### Background Jobs

| Parameter                    | Type    | Default | Description                                                                     |
| ---------------------------- | ------- | ------- | ------------------------------------------------------------------------------- |
| `CRON_SCHEDULER_MAX_WORKERS` | integer | `20`    | Max threads for the background cron scheduler; controls concurrent job capacity |

### Activity Events

| Parameter                        | Type    | Default | Description                                                               |
| -------------------------------- | ------- | ------- | ------------------------------------------------------------------------- |
| `ACTIVITY_EVENTS_ENABLED`        | boolean | `false` | Enable recording of user activity events for audit and analytics purposes |
| `ACTIVITY_EVENTS_RETENTION_DAYS` | integer | `90`    | Number of days to retain activity event records before automatic cleanup  |

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

| Parameter                                 | Type    | Default                           | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ----------------------------------------- | ------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `CODE_EXECUTOR_ENABLED`                   | boolean | `false`                           | Enable the Code Executor tool. When `false`, the tool is neither listed in the tools catalog nor executed. Set `true` to opt in.                                                                                                                                                                                                                                                                                                                                                                             |
| `CODE_EXECUTOR_EXECUTION_MODE`            | string  | `"sandbox"`                       | Execution mode. Only `sandbox` is accepted; code always runs in an isolated Kubernetes pod.                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `CODE_EXECUTOR_SANDBOX_MODE`              | string  | `"sandbox-shared"`                | Kubernetes sandbox sub-mode: `sandbox-shared` (reuse a shared pod across sessions — development only) or `sandbox-jobs` (create a dedicated Job pod per execution — recommended for production; requires gVisor or Kata Containers runtime class in the cluster).                                                                                                                                                                                                                                            |
| `CODE_EXECUTOR_RUNTIME_CLASS_NAME`        | string  | `"gvisor"`                        | Kubernetes `runtimeClassName` applied to Job pods when `CODE_EXECUTOR_SANDBOX_MODE=sandbox-jobs`. Must match an installed runtime class (`gvisor` or `kata-containers`). Set to `none` or leave empty to omit `runtimeClassName` from the Job manifest and fall back to the cluster default runtime. **Security risk:** omitting the runtime class disables sandbox isolation and is not recommended for production; use it only where the cluster default runtime provides equivalent isolation guarantees. |
| `CODE_EXECUTOR_KUBECONFIG_PATH`           | string  | `""`                              | Path to kubeconfig for Kubernetes authentication (optional, uses in-cluster config if empty). Set to move code execution to a dedicated cluster                                                                                                                                                                                                                                                                                                                                                              |
| `CODE_EXECUTOR_WORKDIR_BASE`              | string  | `"/home/codemie"`                 | Base working directory for code execution inside containers                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `CODE_EXECUTOR_NAMESPACE`                 | string  | `"codemie-runtime"`               | Kubernetes namespace for executor pods                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `CODE_EXECUTOR_DOCKER_IMAGE`              | string  | `"codemie/codemie-python:2.41.0"` | Docker image with Python environment and dependencies for code execution                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `CODE_EXECUTOR_EXECUTION_TIMEOUT`         | float   | `30.0`                            | Max seconds for code execution before timeout (prevents infinite loops)                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `CODE_EXECUTOR_SESSION_TIMEOUT`           | float   | `300.0`                           | Max session lifetime in seconds before automatic cleanup                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `CODE_EXECUTOR_DEFAULT_TIMEOUT`           | float   | `30.0`                            | Default timeout for operations in seconds                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `CODE_EXECUTOR_MEMORY_LIMIT`              | string  | `"256Mi"`                         | Kubernetes memory limit for executor pods                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `CODE_EXECUTOR_MEMORY_REQUEST`            | string  | `"256Mi"`                         | Kubernetes memory request for executor pods                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `CODE_EXECUTOR_CPU_LIMIT`                 | string  | `"1"`                             | Kubernetes CPU limit for executor pods (cores)                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `CODE_EXECUTOR_CPU_REQUEST`               | string  | `"100m"`                          | Kubernetes CPU request for executor pods (millicores)                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `CODE_EXECUTOR_EPHEMERAL_STORAGE_LIMIT`   | string  | `"1Gi"`                           | Kubernetes ephemeral storage limit for executor pods                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `CODE_EXECUTOR_EPHEMERAL_STORAGE_REQUEST` | string  | `"1Gi"`                           | Kubernetes ephemeral storage request for executor pods                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `CODE_EXECUTOR_MAX_THREADS`               | integer | `64`                              | Maximum number of threads allowed per execution, enforced inside the sandbox process (both shared and jobs modes).                                                                                                                                                                                                                                                                                                                                                                                           |
| `CODE_EXECUTOR_MAX_OPEN_FILES`            | integer | `256`                             | Maximum number of open files allowed per execution, enforced inside the sandbox process (both shared and jobs modes). The Python runtime itself opens roughly 20 files before user code runs.                                                                                                                                                                                                                                                                                                                |
| `CODE_EXECUTOR_MAX_POD_POOL_SIZE`         | integer | `5`                               | Max number of executor pods in dynamic pool for concurrent executions                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `CODE_EXECUTOR_POD_NAME_PREFIX`           | string  | `"codemie-executor-"`             | Prefix for dynamically created executor pod names                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `CODE_EXECUTOR_RUN_AS_USER`               | integer | `1001`                            | Unix user ID for pod security context (non-root execution)                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `CODE_EXECUTOR_RUN_AS_GROUP`              | integer | `1001`                            | Unix group ID for pod security context                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `CODE_EXECUTOR_FS_GROUP`                  | integer | `1001`                            | Filesystem group ID for pod volume permissions                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `CODE_EXECUTOR_SECURITY_THRESHOLD`        | string  | `"LOW"`                           | Required security policy threshold: `SAFE`, `LOW`, `MEDIUM`, `HIGH`                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `CODE_EXECUTOR_YAML_POLICY_PATH`          | string  | `""`                              | Path to custom YAML security policy file (optional, overrides default policy)                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `CODE_EXECUTOR_VERBOSE`                   | boolean | `false`                           | Enable verbose logging for executor debugging                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `CODE_EXECUTOR_KEEP_TEMPLATE`             | boolean | `true`                            | Persist pod template after execution for performance optimization                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `CODE_EXECUTOR_SKIP_ENVIRONMENT_SETUP`    | boolean | `false`                           | Skip environment initialization in sandbox (faster startup but may break dependencies)                                                                                                                                                                                                                                                                                                                                                                                                                       |

:::warning Security Considerations
**Sandbox Isolation:** `CODE_EXECUTOR_EXECUTION_MODE=sandbox` runs user-supplied code in a dedicated Kubernetes pod, isolated from the CodeMie API. This is the execution model for running untrusted code safely in production.

**Runtime Class:** In `sandbox-jobs` mode the Job pods run under the `CODE_EXECUTOR_RUNTIME_CLASS_NAME` runtime (defaults to `gvisor`), which provides kernel-level sandbox isolation for untrusted code. Setting it to `none` or leaving it empty omits `runtimeClassName` so pods use the cluster default runtime — this disables sandbox isolation and is not recommended for production. Only omit the runtime class in environments where the cluster default runtime already provides equivalent isolation guarantees.

**Security Threshold:** The security policy controls what operations are allowed:

- `SAFE` (0): Most permissive, blocks almost nothing
- `LOW` (1): Allows common operations like HTTP requests (recommended default)
- `MEDIUM` (2): More restrictive, blocks potentially dangerous operations
- `HIGH` (3): Very restrictive, only allows safe operations
  :::

### File Datasource Multiprocessing

Enable parallel processing of file indexing tasks using multiple worker processes.

| Parameter                                           | Type    | Default | Description                                                                            |
| --------------------------------------------------- | ------- | ------- | -------------------------------------------------------------------------------------- |
| `ENABLE_FILE_MULTIPROCESSING`                       | boolean | `false` | Enable multiprocessing for file datasource indexing to speed up large-volume ingestion |
| `FILE_DATASOURCE_MULTIPROCESSING_MAX_WORKERS`       | integer | `2`     | Max worker processes for parallel file indexing                                        |
| `FILE_MULTIPROCESSING_MAX_EXECUTED_TASK_PER_WORKER` | integer | `100`   | Max tasks each worker process handles before recycling to prevent memory accumulation  |

### Azure DevOps Integration

Configuration for Azure DevOps work items, test plans, and wiki integrations.

| Parameter                | Type   | Default | Description                                                                    |
| ------------------------ | ------ | ------- | ------------------------------------------------------------------------------ |
| `AZURE_DEVOPS_CACHE_DIR` | string | `""`    | Cache directory for Azure DevOps API responses (empty string disables caching) |

---

## Observability & Monitoring

Track LLM usage, performance metrics, and debugging information.

### Langfuse Configuration

<EnterpriseFeature />

Send LLM traces to Langfuse for observability, debugging, and prompt optimization.

| Parameter                                 | Type         | Default                                                                                                                                             | Description                                                                        |
| ----------------------------------------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `LANGFUSE_TRACES`                         | boolean      | `false`                                                                                                                                             | Enable detailed LLM tracing (requires Langfuse account)                            |
| `LANGFUSE_BLOCKED_INSTRUMENTATION_SCOPES` | list[string] | `["elasticsearch-api", "opentelemetry.instrumentation.fastapi", "opentelemetry.instrumentation.sqlalchemy", "opentelemetry.instrumentation.httpx"]` | Instrumentation scope names excluded from Langfuse tracing to suppress noisy spans |

:::info
When `LANGFUSE_TRACES` is enabled, the following environment variables (provided by Langfuse) must also be set:

- `LANGFUSE_PUBLIC_KEY` - Public API key from Langfuse project
- `LANGFUSE_SECRET_KEY` - Secret key for authentication
- `LANGFUSE_HOST` - Langfuse instance URL (cloud or self-hosted)
  :::

### Observability Provider

Select the active observability backend for distributed tracing. Only one provider is active at a time.

| Parameter                | Type   | Default  | Description                                                                                                           |
| ------------------------ | ------ | -------- | --------------------------------------------------------------------------------------------------------------------- |
| `OBSERVABILITY_PROVIDER` | string | `"none"` | Active tracing backend: `none` (disabled), `langfuse` (LLM traces), `phoenix` (Arize Phoenix), `otel` (OpenTelemetry) |

### Phoenix (Arize) Configuration

Send traces to Arize Phoenix for LLM observability and evaluation. Enable by setting `OBSERVABILITY_PROVIDER=phoenix`.

| Parameter                      | Type    | Default                   | Description                                                                             |
| ------------------------------ | ------- | ------------------------- | --------------------------------------------------------------------------------------- |
| `PHOENIX_HOST`                 | string  | `"http://localhost:6006"` | Phoenix server endpoint URL                                                             |
| `PHOENIX_PROJECT_NAME`         | string  | `"codemie"`               | Phoenix project name to group traces under                                              |
| `PHOENIX_API_KEY`              | string  | `null`                    | Phoenix API key for authenticated deployments; omit for local unauthenticated instances |
| `PHOENIX_BATCH_SPAN_PROCESSOR` | boolean | `true`                    | Use batch span processor for better throughput; set `false` for synchronous/debug mode  |

### OpenTelemetry Configuration

Export traces via OpenTelemetry to any OTLP-compatible backend. Enable by setting `OBSERVABILITY_PROVIDER=otel`.

| Parameter            | Type    | Default                 | Description                                                                                             |
| -------------------- | ------- | ----------------------- | ------------------------------------------------------------------------------------------------------- |
| `OTEL_ENABLED`       | boolean | `false`                 | Enable OpenTelemetry tracing bootstrap; setting `OBSERVABILITY_PROVIDER=otel` also requires this        |
| `OTEL_EXCLUDED_URLS` | string  | `"healthcheck,metrics"` | Comma-separated URL fragments excluded from tracing to suppress health check and metrics endpoint noise |

### Prometheus Configuration

Expose application metrics in Prometheus format on a dedicated port.

| Parameter                 | Type    | Default      | Description                                                               |
| ------------------------- | ------- | ------------ | ------------------------------------------------------------------------- |
| `PROMETHEUS_ENABLED`      | boolean | `false`      | Enable Prometheus metrics exposition                                      |
| `PROMETHEUS_ENDPOINT`     | string  | `"/metrics"` | HTTP path for the Prometheus metrics scrape endpoint                      |
| `PROMETHEUS_METRICS_HOST` | string  | `"0.0.0.0"`  | Host address the metrics server binds to                                  |
| `PROMETHEUS_METRICS_PORT` | integer | `9091`       | Port the dedicated metrics server listens on (separate from the API port) |

### Pyroscope Configuration

Continuous profiling integration for CPU and memory profiling in production.

| Parameter                       | Type    | Default                   | Description                                                                         |
| ------------------------------- | ------- | ------------------------- | ----------------------------------------------------------------------------------- |
| `PYROSCOPE_ENABLED`             | boolean | `false`                   | Enable Pyroscope continuous profiling                                               |
| `PYROSCOPE_SERVER_URL`          | string  | `"http://localhost:4040"` | Pyroscope server endpoint to send profiling data to                                 |
| `PYROSCOPE_APP_NAME`            | string  | `"codemie"`               | Application name label attached to all profiling data                               |
| `PYROSCOPE_SAMPLE_RATE`         | integer | `100`                     | Profiling samples per second; lower values reduce overhead                          |
| `PYROSCOPE_ONCPU`               | boolean | `true`                    | Enable CPU profiling via wall-clock sampling                                        |
| `PYROSCOPE_GIL_ONLY`            | boolean | `false`                   | Restrict sampling to GIL-holding threads only; reduces overhead but limits coverage |
| `PYROSCOPE_ENABLE_LOGGING`      | boolean | `false`                   | Enable Pyroscope internal debug logging                                             |
| `PYROSCOPE_DETECT_SUBPROCESSES` | boolean | `false`                   | Automatically profile spawned subprocesses                                          |
| `PYROSCOPE_TAGS`                | string  | `""`                      | Comma-separated `key=value` tags added to all profiling data for filtering          |

### Memory Profiling

Track memory usage and identify memory leaks during application runtime using Python's tracemalloc module.

| Parameter                           | Type    | Default              | Description                                                                       |
| ----------------------------------- | ------- | -------------------- | --------------------------------------------------------------------------------- |
| `MEMORY_PROFILING_ENABLED`          | boolean | `false`              | Enable tracemalloc and psutil based memory profiling                              |
| `MEMORY_PROFILING_INTERVAL_MINUTES` | integer | `10`                 | Interval between automatic snapshots (in minutes)                                 |
| `MEMORY_PROFILING_DETAIL_LEVEL`     | string  | `"file"`             | Detail level: "file" (fast, groups by file) or "line" (slower, shows exact lines) |
| `MEMORY_PROFILING_SNAPSHOT_PREFIX`  | string  | `"memory_snapshots"` | Prefix path for snapshot storage location                                         |

:::info
Memory profiling uses Python's built-in tracemalloc module to capture memory allocation snapshots at regular intervals. Available detail levels:

- file: Faster, groups memory usage by file (recommended for production debugging)
- line: Slower, shows exact line numbers (use for detailed analysis in development)
  :::

:::warning
Memory profiling adds CPU overhead and should be used cautiously in production environments. The file detail level has lower performance impact compared to line. Consider
increasing the interval (e.g., 30-60 minutes) for production use to minimize resource consumption.
:::

---

## Conversation Analysis

Automated background job that runs LLM-based analysis on completed conversations to extract insights, patterns, and quality signals.

| Parameter                             | Type    | Default            | Description                                                                                   |
| ------------------------------------- | ------- | ------------------ | --------------------------------------------------------------------------------------------- |
| `CONVERSATION_ANALYSIS_ENABLED`       | boolean | `false`            | Enable the nightly conversation analysis background job                                       |
| `CONVERSATION_ANALYSIS_SCHEDULE`      | string  | `"0 0 * * *"`      | Cron schedule (UTC) for the analysis job; defaults to midnight daily                          |
| `CONVERSATION_ANALYSIS_LOOKBACK_DAYS` | integer | `1`                | Analyze conversations that are at least this many days old (avoids in-progress conversations) |
| `CONVERSATION_ANALYSIS_BATCH_SIZE`    | integer | `20`               | Number of conversations processed per batch per pod                                           |
| `CONVERSATION_ANALYSIS_MAX_RETRIES`   | integer | `3`                | Max retry attempts for failed conversation analyses before marking as permanently failed      |
| `CONVERSATION_ANALYSIS_LLM_MODEL`     | string  | `"gemini-3-flash"` | LLM model used for conversation analysis; should be a fast, cost-efficient model              |

---

## Stale Datasource Detection

Nightly background job that identifies datasources with no recent usage or updates and marks them as stale to prompt review or cleanup.

| Parameter                         | Type    | Default       | Description                                                                                        |
| --------------------------------- | ------- | ------------- | -------------------------------------------------------------------------------------------------- |
| `STALE_DATASOURCE_ENABLED`        | boolean | `false`       | Enable the nightly stale datasource detection job                                                  |
| `STALE_DATASOURCE_SCHEDULE`       | string  | `"0 3 * * *"` | Cron schedule (UTC) for the detection job; defaults to 3 AM daily                                  |
| `STALE_DATASOURCE_NO_USAGE_DAYS`  | integer | `90`          | Days without usage metrics after which a datasource is considered stale                            |
| `STALE_DATASOURCE_NO_UPDATE_DAYS` | integer | `120`         | Days without any update used as a fallback staleness criterion when no usage metrics are available |
| `STALE_DATASOURCE_GRACE_DAYS`     | integer | `7`           | Newly created datasources are never marked stale within this grace period                          |
| `STALE_DATASOURCE_BATCH_SIZE`     | integer | `100`         | Elasticsearch query batch size for metrics aggregation during detection                            |

---

## Analytics

| Parameter                     | Type    | Default | Description                                                         |
| ----------------------------- | ------- | ------- | ------------------------------------------------------------------- |
| `ANALYTICS_DEFAULT_PAGE_SIZE` | integer | `20`    | Default number of rows returned per page by analytics API endpoints |

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

| Field                              | Type    | Description                                                                                                                                                                                                                                                                                                                                                               |
| ---------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `base_name`                        | string  | Canonical model identifier (e.g., `gpt-4`, `claude-3-opus-20240229`)                                                                                                                                                                                                                                                                                                      |
| `deployment_name`                  | string  | Provider-specific deployment name (Azure deployment, Bedrock model ID)                                                                                                                                                                                                                                                                                                    |
| `label`                            | string  | Human-friendly display name shown in UI model selector                                                                                                                                                                                                                                                                                                                    |
| `multimodal`                       | boolean | Model supports vision (images/video) in addition to text                                                                                                                                                                                                                                                                                                                  |
| `react_agent`                      | boolean | Compatible with ReAct agent pattern (reasoning + acting)                                                                                                                                                                                                                                                                                                                  |
| `enabled`                          | boolean | Model available for selection (allows disabling without removal)                                                                                                                                                                                                                                                                                                          |
| `provider`                         | string  | Provider type: `azure_openai`, `aws_bedrock`, `google_vertexai`, `anthropic`                                                                                                                                                                                                                                                                                              |
| `default_for_categories`           | list    | Categories where this model is auto-selected                                                                                                                                                                                                                                                                                                                              |
| `cost.input`                       | float   | USD per input token for cost tracking                                                                                                                                                                                                                                                                                                                                     |
| `cost.output`                      | float   | USD per output token                                                                                                                                                                                                                                                                                                                                                      |
| `cost.cache_read_input_token_cost` | float   | USD per cached token (for providers supporting caching)                                                                                                                                                                                                                                                                                                                   |
| `max_output_tokens`                | integer | Maximum generation length supported by model                                                                                                                                                                                                                                                                                                                              |
| `features.streaming`               | boolean | Supports streaming responses for real-time output                                                                                                                                                                                                                                                                                                                         |
| `features.tools`                   | boolean | Supports function calling / tool use                                                                                                                                                                                                                                                                                                                                      |
| `features.parallel_tool_calls`     | boolean | Whether the model can execute multiple tool calls in a single inference round. Defaults to `false`. Set to `false` explicitly for reasoning models (o-series) that do not support the `parallel_tool_calls` OpenAI parameter — sending it to these models causes an API error. When `false`, the platform strips the parameter from every outgoing request to that model. |

:::info How parallel tool calls work
When `parallel_tool_calls` is `true` for a model, the agent can issue and stream multiple
tool calls simultaneously within one inference round. Results arrive concurrently and are
rendered in the UI as parallel entries under the same thought step.

Standard GPT and Claude models support parallel tool calls. Reasoning models
(`o1`, `o3`, `o3-mini`, `o4-mini`, and similar) do **not** — always set
`parallel_tool_calls: false` in their `features` block.
:::

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

Customer-specific settings are loaded from `CUSTOMER_CONFIG_DIR/customer-config.yaml`. See [CodeMie Customer Feature Configuration](./customer-feature-configuration.md) for the full reference.

---

## Authorized Applications Configuration

External applications that can access CodeMie APIs via JWT authentication are configured in `AUTHORIZED_APPS_CONFIG_DIR/authorized-applications-config.yaml`.

### Application Configuration Structure

```yaml
authorized_applications:
  - name: app-name # Application identifier
    public_key_url: https://app.trusted.example/.well-known/public-key # JWT verification key URL, must use https and match an allowed domain
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

### Public Key URL Domain Allowlist

`public_key_url` values are validated against a domain allowlist before the key is fetched — once when the configuration loads (fails fast on startup) and again immediately before each fetch (defense in depth). This stops a tampered or misconfigured entry from pointing at an attacker-controlled host.

| Parameter                             | Type          | Default | Description                                                                                                            |
| ------------------------------------- | ------------- | ------- | ---------------------------------------------------------------------------------------------------------------------- |
| `AUTHORIZED_APPS_ALLOWED_KEY_DOMAINS` | list\[string] | `[]`    | Domains permitted to host `public_key_url` keys. A host matches if it equals a listed domain or is a subdomain of one. |

Validation rules:

- `public_key_url` must use `https`.
- The URL host must not be an IP literal.
- The URL host must equal, or be a subdomain of, one of the configured domains.
- An empty allowlist (the default) rejects every URL-based key — only `public_key_path` (local file) entries are permitted until at least one domain is configured.

Override with a JSON array via environment variable:

```bash
AUTHORIZED_APPS_ALLOWED_KEY_DOMAINS=["trusted.example","keys.trusted.example"]
```

---

## See Also

- [AWS Kubernetes Deployment](../../deployment/aws/kubernetes/overview.md) - Complete AWS Kubernetes deployment walkthrough
- [AWS On VM Deployment](../../deployment/aws/on-vm/overview.md) - AWS EC2 deployment with Docker Compose
- [Azure Kubernetes Deployment](../../deployment/azure/kubernetes/overview.md) - Azure Kubernetes setup instructions
- [Azure On VM Deployment](../../deployment/azure/on-vm/overview.md) - Azure VM deployment with Docker Compose
- [GCP Kubernetes Deployment](../../deployment/gcp/kubernetes/overview.md) - Google Cloud Kubernetes deployment steps
- [GCP On VM Deployment](../../deployment/gcp/on-vm/overview.md) - Google Cloud GCE deployment with Docker Compose
