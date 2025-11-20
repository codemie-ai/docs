---
id: ai-models-overview
sidebar_position: 1
title: AI Models Integration
description: Configure LLM and embedding models
---

# AI Models Integration and Configuration

## Managing LLM and embedding models

AI/Run CodeMie provides a way to configure LLM and embedding models from different cloud providers. Configuration file can be found by path in container: [config/llms](https://gitbud.epam.com/epm-cdme/codemie/-/tree/main/config/llms?ref_type=heads).

The `MODELS_ENV` is used to specify the environment for the models. For example, `MODELS_ENV=dial` will use the models from the `config/llms/llm-dial-config.yaml` file (Pattern: `llm-<MODELS_ENV>-config.yaml`).

Example of providing LLM and embedding models for the custom environment:

1. Go to the `codemie-helm-charts/codemie-api/values.yaml` file
2. Fill the following values to create and mount custom configmap to AI/Run pod:

```yaml
extraEnv:
  - name: MODELS_ENV
    value: <project-name>

extraVolumeMounts: |
  ...
  - name: codemie-llm-customer-config
    mountPath: /app/config/llms/llm-<project-name>-config.yaml
    subPath: llm-<project-name>-config.yaml
  ...

extraVolumes: |
  ...
  - name: codemie-llm-customer-config
    configMap:
      name: codemie-llm-customer-config
  ...

extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-llm-customer-config
    data:
      llm-<project-name>-config.yaml: |
        llm_models:
          - base_name: "gpt-4o-2024-08-06"
            deployment_name: "gpt-4o-2024-08-06"
            label: "GPT-4o 2024-08-06"
            multimodal: true
            enabled: true
            default: true
            provider: "azure_openai"
            cost:
              input: 0.0000025
              output: 0.000011

        embeddings_models:
          - base_name: "ada-002"
            deployment_name: "text-embedding-ada-002"
            label: "Text Embedding Ada"
            enabled: true
            default: true
            provider: "azure_openai"
            cost:
              input: 0.0000001
              output: 0
```
