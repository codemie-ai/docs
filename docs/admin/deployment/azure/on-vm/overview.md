---
id: overview
title: AI/Run CodeMie On VM Deployment Guide (Azure)
sidebar_label: Overview
sidebar_position: 1
pagination_prev: admin/deployment/index
pagination_next: admin/deployment/azure/on-vm/prerequisites
---

# AI/Run CodeMie On VM Deployment (Azure)

CodeMie On VM deploys the full AI/Run CodeMie platform on a **single Azure VM** using Docker Compose. It provides the same core functionality as the full Azure (AKS) deployment but with minimal infrastructure overhead.

## When to Use

CodeMie On VM is designed for:

- **Proof of Concept (PoC)** — quickly validate CodeMie capabilities in your environment
- **Demo environments** — showcase CodeMie to stakeholders without complex infrastructure

:::warning Not for Production
For production workloads with high availability, scaling, and redundancy, use the full [Azure AKS Deployment Guide](../../kubernetes/overview).
:::

## Deployment Profiles

CodeMie On VM supports two profiles:

| Profile        | Authentication          | LLM Proxy | Plugin Tool |
| -------------- | ----------------------- | --------- | ----------- |
| **OSS**        | Local (built-in)        | Internal  | No          |
| **Enterprise** | Keycloak + OAuth2 Proxy | LiteLLM   | Yes         |

## Deployment Modes

| Mode         | Command             | Infrastructure                                        |
| ------------ | ------------------- | ----------------------------------------------------- |
| **Standard** | `./deploy.sh`       | Terraform creates VM, Storage Account, Key Vault, DNS |
| **BYO VM**   | `./deploy.sh --byo` | Use your existing Azure VM                            |

## Repository

All deployment code is hosted at: [codemie-on-vm](https://gitbud.epam.com/epm-cdme/codemie-on-vm)

```
codemie-on-vm/
├── compose/                          # Docker Compose files and config
├── deploy.sh                         # Deployment script
├── destroy.sh                        # Destroy script
├── deployment.conf.azure.example     # Azure configuration template
└── terraform/
    └── azure/
        ├── remote-backend/           # Azure Storage Terraform state backend
        ├── platform/                 # VM, Storage Account, Key Vault, DNS infrastructure
        └── ai-models/                # Azure OpenAI cognitive accounts (optional)
```

## Next Steps

Proceed to [Prerequisites](../prerequisites) to verify your environment is ready for deployment.
