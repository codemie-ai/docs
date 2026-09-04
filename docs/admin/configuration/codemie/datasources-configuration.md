---
id: datasources-configuration
sidebar_position: 2
title: Data Sources Configuration
description: Configure data sources and loaders for AI/Run CodeMie
pagination_next: null
---

# Data Sources Configuration

Configure how AI/Run CodeMie processes and indexes different types of data sources. This configuration controls chunking strategies, batch processing, and file handling for optimal AI assistant performance.

## Overview

Data source loaders control how content from various sources is processed and made available to AI assistants. Each loader is optimized for specific content types and can be tuned for your organization's needs.

:::tip When to Configure
The default configuration works for most deployments. Customize these settings if you need to:

- Adjust performance for large-scale data processing
- Fine-tune chunking for specific content types
- Add support for custom file extensions
- Optimize token usage for your LLM models
  :::

## Configuration Steps

### 1. Edit Values File

Open `codemie-helm-charts/codemie-api/values.yaml` and add the configuration blocks below.

### 2. Add ConfigMap

Add the data sources configuration as a ConfigMap in the `extraObjects` section:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: datasources-config
    data:
      datasources-config.yaml: |
        ---
        loaders:
          # Loader configurations (see below)
        storage:
          # Storage configurations (see below)
```

### 3. Mount Configuration

Add volume and volume mount configurations:

```yaml
extraVolumes: |
  - name: datasources-config
    configMap:
      name: datasources-config
```

```yaml
extraVolumeMounts: |
  - name: datasources-config
    mountPath: /app/config/datasources/datasources-config.yaml
    subPath: datasources-config.yaml
```

### 4. Apply Changes

Deploy the updated configuration:

```bash
helm upgrade --install codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-api/values.yaml" \
  --wait --timeout 600s
```

Replace `x.y.z` with your version.

## Loader Configurations

### Code Loader

Processes code files from Git repositories and other code sources. Supports language-aware splitting for better context preservation.

```yaml
code_loader:
  languages_for_splitting:
    cpp:
      - .cpp
      - .h
      - .hpp
      - .cxx
      - .cc
      - .C
      - .c++
    go:
      - .go
    java:
      - .java
    js:
      - .js
    php:
      - .php
      - .phtml
      - .php3
      - .php4
      - .php5
      - .php7
      - .phps
      - .phpt
    proto:
      - .proto
    python:
      - .py
      - .pyc
      - .pyd
      - .pyo
      - .pyw
      - .pyz
    rst:
      - .rst
    ruby:
      - .rb
      - .rbx
      - .rjs
      - .rhtml
      - .ru
    rust:
      - .rs
    scala:
      - .scala
    swift:
      - .swift
    markdown:
      - .md
      - .markdown
    latex:
      - .tex
    html:
      - .html
      - .htm
      - .shtml
      - .xhtml
    sol:
      - .sol

  chunk_size: 2000                          # Characters per chunk
  tokens_size_limit: 2000                   # Maximum tokens per chunk
  chunk_overlap: 30                         # Overlap between chunks (characters)
  summarization_max_tokens_limit: 4000      # Token limit for summarization
  summarization_tokens_overlap: 100         # Overlap for summarization chunks
  summarization_batch_size: 10              # Files processed per batch
  loader_batch_size: 250                    # Documents per processing batch
  enable_multiprocessing: false             # Enable parallel processing

  excluded_extensions:
    common:
      - .ico
      - .mng
      - .bpm
      - .exe
      - .dll
      - .jar
      - .key
      - .mp3
      - .mp4
      - .otf
      - .pyc
      - .rar
      - .rtf
      - .tar
      - .gz
      - .webm
      - .zip
      - .xls
      - .lock
    docs_only:
      - .md
      - .toml
      - .json
      - .pdf
      - .xlsx
    code_only: []
```

**Key Parameters:**

- `chunk_size` - Larger chunks provide more context but use more tokens
- `chunk_overlap` - Prevents context loss at chunk boundaries
- `loader_batch_size` - Higher values improve throughput but use more memory
- `excluded_extensions` - Skip binary and non-text files

### Jira Loader

Processes Jira issues and associated content.

```yaml
jira_loader:
  chunk_size: 1000              # Characters per chunk
  chunk_overlap: 50             # Overlap between chunks
  loader_batch_size: 50         # Issues per batch
```

### JSON Loader

Processes structured JSON data.

```yaml
json_loader:
  chunk_size: 2000              # Characters per chunk
  chunk_overlap: 100            # Overlap between chunks
```

### Confluence Loader

Processes Confluence pages and spaces.

```yaml
confluence_loader:
  loader_max_pages: 1000            # Number of pages lazy_load holds in memory at once before yielding and moving to the next chunk
  loader_pages_per_request: 20      # Number of pages returned by a single Confluence API HTTP request (the ?limit= param)
  loader_batch_size: 50             # Number of Documents passed to one _process_batch call (splitting + embedding + ES write)
  loader_timeout: 180               # Request timeout (seconds)
```

**Key Parameters:**

- `loader_max_pages` - Controls the in-memory page buffer for lazy loading; set lower for memory-constrained environments
- `loader_pages_per_request` - Maps directly to the `?limit=` parameter of the Confluence API; lower values reduce individual request size
- `loader_batch_size` - Number of documents sent through splitting, embedding, and Elasticsearch write in a single batch
- `loader_timeout` - Increase for slow networks or large pages

### File Loader

Processes uploaded files and documents.

```yaml
file_loader:
  chunk_size: 1500              # Characters per chunk
  chunk_overlap: 100            # Overlap between chunks
```

### Azure DevOps Wiki Loader

Processes Azure DevOps wiki pages.

```yaml
azure_devops_wiki_loader:
  chunk_size: 1000              # Characters per chunk
  chunk_overlap: 50             # Overlap between chunks
  loader_batch_size: 50         # Documents per processing batch
```

### Azure DevOps Work Item Loader

Processes Azure DevOps work items, optionally including comments and attachments.

```yaml
azure_devops_work_item_loader:
  chunk_size: 1000              # Characters per chunk
  chunk_overlap: 50             # Overlap between chunks
  loader_batch_size: 50         # Work items per processing batch
  index_comments: true          # Index work item comments
  index_attachments: true       # Index work item attachments
```

**Key Parameters:**

- `index_comments` - Enable to include work item comment threads in the index
- `index_attachments` - Enable to include attached files in the index

### Xray Loader

Processes Xray test management data from Jira.

```yaml
xray_loader:
  chunk_size: 1000              # Characters per chunk
  chunk_overlap: 50             # Overlap between chunks
  loader_batch_size: 50         # Documents per processing batch
```

### SharePoint Loader

Processes SharePoint documents and libraries via the Microsoft Graph API.

```yaml
sharepoint_loader:
  loader_batch_size: 20                        # Documents per processing batch
  loader_timeout: 300                          # Request timeout (seconds)
  chunk_size: 2000                             # Characters per chunk
  chunk_overlap: 200                           # Overlap between chunks
  max_file_size_mb: 50                         # Maximum file size to process (MB)
  max_retries: 3                               # Retry attempts for failed requests
  graph_api_version: "v1.0"                   # Microsoft Graph API version
  graph_base_url: "https://graph.microsoft.com" # Microsoft Graph API base URL
```

**Key Parameters:**

- `max_file_size_mb` - Files exceeding this limit are skipped during indexing
- `graph_api_version` - Update if a newer stable Graph API version is required
- `max_retries` - Increase for unstable network connections to SharePoint

### SVN Loader

Processes Subversion repositories.

```yaml
svn_loader:
  loader_batch_size: 250              # Documents per processing batch
  checkout_timeout_seconds: 300       # Timeout for SVN checkout operations
  max_file_size_kb: 5000              # Maximum file size to process (KB)
```

**Key Parameters:**

- `checkout_timeout_seconds` - Increase for large repositories or slow SVN servers
- `max_file_size_kb` - Files exceeding this limit are skipped during indexing

## Storage Configuration

Configure how processed data is stored and indexed in Elasticsearch.

```yaml
storage:
  embeddings_max_docs_count: 20                         # Max documents for embedding context
  indexing_bulk_max_chunk_bytes: 104857600              # Max bulk request size (100 MB)
  indexing_max_retries: 2                               # Retry attempts for failed indexing
  indexing_error_retry_wait_min_seconds: 10             # Minimum retry wait time (seconds)
  indexing_error_retry_wait_max_seconds: 120            # Maximum retry wait time (seconds)
  indexing_threads_count: 20                            # Parallel indexing threads
  processed_documents_threshold: 1000                   # Max processed documents stored in Elasticsearch
  stale_indexing_threshold_seconds: 300                 # Time after which an indexing task is considered stale
  stale_indexing_resume_batch_size: 5                   # Number of stale tasks resumed per cycle
  indexing_heartbeat_interval: 10                       # Frequency (in completed docs) for committing indexing stats
```

**Key Parameters:**

- `indexing_threads_count` - Increase for faster indexing on high-performance clusters
- `indexing_bulk_max_chunk_bytes` - Adjust based on Elasticsearch cluster capacity
- `indexing_max_retries` - Worst-case retry duration equals `indexing_max_retries × indexing_error_retry_wait_max_seconds`; keep below `stale_indexing_threshold_seconds`
- `stale_indexing_threshold_seconds` - Tasks that exceed this duration without a heartbeat are treated as stale and resumed
- `indexing_heartbeat_interval` - Lower values keep `update_date` fresher and reduce false stale detection

## Complete Configuration Example

<details>
<summary>Full datasources-config.yaml example</summary>

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: datasources-config
    data:
      datasources-config.yaml: |
        ---
        loaders:
          code_loader:
            languages_for_splitting:
              cpp:
                - .cpp
                - .h
                - .hpp
                - .cxx
                - .cc
                - .C
                - .c++
              go:
                - .go
              java:
                - .java
              js:
                - .js
              php:
                - .php
                - .phtml
                - .php3
                - .php4
                - .php5
                - .php7
                - .phps
                - .phpt
              proto:
                - .proto
              python:
                - .py
                - .pyc
                - .pyd
                - .pyo
                - .pyw
                - .pyz
              rst:
                - .rst
              ruby:
                - .rb
                - .rbx
                - .rjs
                - .rhtml
                - .ru
              rust:
                - .rs
              scala:
                - .scala
              swift:
                - .swift
              markdown:
                - .md
                - .markdown
              latex:
                - .tex
              html:
                - .html
                - .htm
                - .shtml
                - .xhtml
              sol:
                - .sol

            chunk_size: 2000
            tokens_size_limit: 2000
            chunk_overlap: 30
            summarization_max_tokens_limit: 4000
            summarization_tokens_overlap: 100
            summarization_batch_size: 10
            loader_batch_size: 250
            enable_multiprocessing: false
            excluded_extensions:
              common:
                - .ico
                - .mng
                - .bpm
                - .exe
                - .dll
                - .jar
                - .key
                - .mp3
                - .mp4
                - .otf
                - .pyc
                - .rar
                - .rtf
                - .tar
                - .gz
                - .webm
                - .zip
                - .xls
                - .lock
              docs_only:
                - .md
                - .toml
                - .json
                - .pdf
                - .xlsx
              code_only: []

          jira_loader:
            chunk_size: 1000
            chunk_overlap: 50
            loader_batch_size: 50

          json_loader:
            chunk_size: 2000
            chunk_overlap: 100

          confluence_loader:
            loader_max_pages: 1000
            loader_pages_per_request: 20
            loader_batch_size: 50
            loader_timeout: 180

          file_loader:
            chunk_size: 1500
            chunk_overlap: 100

          azure_devops_wiki_loader:
            chunk_size: 1000
            chunk_overlap: 50
            loader_batch_size: 50

          azure_devops_work_item_loader:
            chunk_size: 1000
            chunk_overlap: 50
            loader_batch_size: 50
            index_comments: true
            index_attachments: true

          xray_loader:
            chunk_size: 1000
            chunk_overlap: 50
            loader_batch_size: 50

          sharepoint_loader:
            loader_batch_size: 20
            loader_timeout: 300
            chunk_size: 2000
            chunk_overlap: 200
            max_file_size_mb: 50
            max_retries: 3
            graph_api_version: "v1.0"
            graph_base_url: "https://graph.microsoft.com"

          svn_loader:
            loader_batch_size: 250
            checkout_timeout_seconds: 300
            max_file_size_kb: 5000

        storage:
          embeddings_max_docs_count: 20
          indexing_bulk_max_chunk_bytes: 104857600
          indexing_max_retries: 2
          indexing_error_retry_wait_min_seconds: 10
          indexing_error_retry_wait_max_seconds: 120
          indexing_threads_count: 20
          processed_documents_threshold: 1000
          stale_indexing_threshold_seconds: 300
          stale_indexing_resume_batch_size: 5
          indexing_heartbeat_interval: 10
```

</details>

## Datasource Lifecycle Management

AI/Run CodeMie includes an automatic nightly job that detects and marks stale datasources — those that have not been used or updated for a configurable period. Stale datasources are marked in the database and their Elasticsearch indexes can be cleaned up to reclaim storage.

### Lifecycle States

| State      | Description                                                |
| ---------- | ---------------------------------------------------------- |
| `ACTIVE`   | Default state. Datasource is in use.                       |
| `STALE`    | Unused beyond the configured threshold. Marked for review. |
| `ARCHIVED` | Marked for deletion. Elasticsearch index will be removed.  |

### How Detection Works

Each night the scheduler evaluates all active datasources against two criteria:

1. **No usage metrics** — no Elasticsearch usage events recorded for `STALE_DATASOURCE_NO_USAGE_DAYS` days.
2. **No update** — no DB update recorded for `STALE_DATASOURCE_NO_UPDATE_DAYS` days (fallback for datasources without metrics).

Newly created datasources are always skipped for `STALE_DATASOURCE_GRACE_DAYS` days.

### Configuration

Add the following environment variables to your `values.yaml`:

```yaml
extraEnv:
  # Stale Datasource Lifecycle
  - name: STALE_DATASOURCE_ENABLED
    value: "true"
  - name: STALE_DATASOURCE_SCHEDULE
    value: "0 3 * * *"
  - name: STALE_DATASOURCE_NO_USAGE_DAYS
    value: "90"
  - name: STALE_DATASOURCE_NO_UPDATE_DAYS
    value: "120"
  - name: STALE_DATASOURCE_GRACE_DAYS
    value: "7"
  - name: STALE_DATASOURCE_BATCH_SIZE
    value: "100"
```

**Parameters:**

| Variable                          | Default     | Description                                               |
| --------------------------------- | ----------- | --------------------------------------------------------- |
| `STALE_DATASOURCE_ENABLED`        | `false`     | Enable the nightly detection job.                         |
| `STALE_DATASOURCE_SCHEDULE`       | `0 3 * * *` | Cron schedule (UTC). Default: 3 AM daily.                 |
| `STALE_DATASOURCE_NO_USAGE_DAYS`  | `90`        | Days without ES usage metrics before marking stale.       |
| `STALE_DATASOURCE_NO_UPDATE_DAYS` | `120`       | Days without a DB update before marking stale (fallback). |
| `STALE_DATASOURCE_GRACE_DAYS`     | `7`         | Newly created datasources are immune for this many days.  |
| `STALE_DATASOURCE_BATCH_SIZE`     | `100`       | Elasticsearch query batch size for metrics aggregation.   |

:::note
The feature is disabled by default (`STALE_DATASOURCE_ENABLED=false`). Enable it only after reviewing the thresholds for your organization's usage patterns.
:::
