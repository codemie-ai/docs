---
id: datasources-configuration
sidebar_position: 2
title: Data Sources Configuration
description: Configure data sources and loaders for AI/Run CodeMie
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
      - .pdf
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
      - .xlsx
      - .lock
    docs_only:
      - .md
      - .toml
      - .json
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
  loader_max_pages: 1000            # Maximum pages to load
  loader_pages_per_request: 20      # Pages per API request
  loader_batch_size: 50             # Pages per processing batch
  loader_timeout: 180               # Request timeout (seconds)
```

**Key Parameters:**

- `loader_max_pages` - Set limits for large Confluence instances
- `loader_timeout` - Increase for slow networks or large pages

### File Loader

Processes uploaded files and documents.

```yaml
file_loader:
  chunk_size: 1500              # Characters per chunk
  chunk_overlap: 100            # Overlap between chunks
```

## Storage Configuration

Configure how processed data is stored and indexed in Elasticsearch.

```yaml
storage:
  embeddings_max_docs_count: 20                         # Max documents for embedding context
  indexing_bulk_max_chunk_bytes: 104857600              # Max bulk request size (100 MB)
  indexing_max_retries: 10                              # Retry attempts for failed indexing
  indexing_error_retry_wait_min_seconds: 10             # Minimum retry wait time
  indexing_error_retry_wait_max_seconds: 600            # Maximum retry wait time
  indexing_threads_count: 20                            # Parallel indexing threads
  processed_documents_threshold: 1000                   # Max processed documents in Elasticsearch
```

**Key Parameters:**

- `indexing_threads_count` - Increase for faster indexing on high-performance clusters
- `indexing_bulk_max_chunk_bytes` - Adjust based on Elasticsearch cluster capacity
- `indexing_max_retries` - Higher values improve reliability for transient failures

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
                - .pdf
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
                - .xlsx
                - .lock
              docs_only:
                - .md
                - .toml
                - .json
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

        storage:
          embeddings_max_docs_count: 20
          indexing_bulk_max_chunk_bytes: 104857600  # 100 MB
          indexing_max_retries: 10
          indexing_error_retry_wait_min_seconds: 10
          indexing_error_retry_wait_max_seconds: 600
          indexing_threads_count: 20
          processed_documents_threshold: 1000
```

</details>
