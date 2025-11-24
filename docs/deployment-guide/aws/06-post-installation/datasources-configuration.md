---
id: datasources-configuration
sidebar_position: 4
title: Data Sources Configuration (Optional)
description: Configure data sources and loaders for AI/Run CodeMie
---

# Data Sources Configuration (Optional)

## Configuration

To configure data sources, add the following blocks with your specific configuration to the `codemie-helm-charts/codemie-api/values.yaml`:

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
          processed_documents_threshold: 1000  # Max amount of processed documents to store in elastic
```

```yaml
extraVolumes: |
  ...
  - name: datasources-config
    configMap:
      name: datasources-config
  ...
```

```yaml
extraVolumeMounts: |
  ...
  - name: datasources-config
    mountPath: /app/config/datasources/datasources-config.yaml
    subPath: datasources-config.yaml
  ...
```

And apply helm chart with the command:

```bash
helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-aws.yaml" \
--wait --timeout 600s
```
