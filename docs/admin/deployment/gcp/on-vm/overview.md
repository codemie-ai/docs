---
id: overview
title: AI/Run CodeMie On VM Deployment Guide (GCP)
sidebar_label: Overview
sidebar_position: 1
pagination_prev: admin/deployment/index
pagination_next: admin/deployment/gcp/on-vm/prerequisites
---

# AI/Run CodeMie On VM Deployment (GCP)

CodeMie On VM deploys the full AI/Run CodeMie platform on a **single GCE VM** using Docker Compose. It provides the same core functionality as the full GCP (GKE) deployment but with minimal infrastructure overhead.

## When to Use

CodeMie On VM is designed for:

- **Proof of Concept (PoC)** — quickly validate CodeMie capabilities in your environment
- **Demo environments** — showcase CodeMie to stakeholders without complex infrastructure

:::warning Not for Production
For production workloads with high availability, scaling, and redundancy, use the full [GCP GKE Deployment Guide](../../kubernetes/overview).
:::

## Deployment Profiles

CodeMie On VM supports two profiles:

| Profile        | Authentication          | LLM Proxy | Plugin Tool |
| -------------- | ----------------------- | --------- | ----------- |
| **OSS**        | Local (built-in)        | Internal  | No          |
| **Enterprise** | Keycloak + OAuth2 Proxy | LiteLLM   | Yes         |

## Deployment Modes

| Mode         | Command             | Infrastructure                                       |
| ------------ | ------------------- | ---------------------------------------------------- |
| **Standard** | `./deploy.sh`       | Terraform creates VM, GCS bucket, Cloud KMS key, DNS |
| **BYO VM**   | `./deploy.sh --byo` | Use your existing GCE VM                             |

## Repository

All deployment code is hosted at: [codemie-on-vm](https://gitbud.epam.com/epm-cdme/codemie-on-vm)

```
codemie-on-vm/
├── compose/                          # Docker Compose files and config
├── deploy.sh                         # Deployment script
├── destroy.sh                        # Destroy script
├── deployment.conf.gcp.example       # GCP configuration template
└── terraform/
    └── gcp/
        ├── remote-backend/           # GCS bucket for Terraform state
        └── platform/                 # VM, GCS bucket, KMS key, DNS infrastructure
```

## Next Steps

Proceed to [Prerequisites](../prerequisites) to verify your environment is ready for deployment.
