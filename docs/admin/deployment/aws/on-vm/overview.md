---
id: overview
title: AI/Run CodeMie On VM Deployment Guide
sidebar_label: Overview
sidebar_position: 1
pagination_prev: admin/deployment/index
pagination_next: admin/deployment/aws/on-vm/prerequisites
---

# AI/Run CodeMie On VM Deployment

CodeMie On VM deploys the full AI/Run CodeMie platform on a **single EC2 instance** using Docker Compose. It provides the same core functionality as the full AWS (EKS) deployment but with minimal infrastructure overhead.

## When to Use

CodeMie On VM is designed for:

- **Proof of Concept (PoC)** — quickly validate CodeMie capabilities in your environment
- **Demo environments** — showcase CodeMie to stakeholders without complex infrastructure

:::warning Not for Production
For production workloads with high availability, scaling, and multi-AZ redundancy, use the full [AWS EKS Deployment Guide](/admin/deployment/aws/kubernetes/overview).
:::

## Deployment Profiles

CodeMie On VM supports two profiles:

| Profile        | Authentication          | LLM Proxy | Plugin Tool |
| -------------- | ----------------------- | --------- | ----------- |
| **OSS**        | Local (built-in)        | Internal  | No          |
| **Enterprise** | Keycloak + OAuth2 Proxy | LiteLLM   | Yes         |

## Deployment Modes

| Mode         | Command             | Infrastructure                           |
| ------------ | ------------------- | ---------------------------------------- |
| **Standard** | `./deploy.sh`       | Terraform creates EC2, VPC, ALB, S3, KMS |
| **BYO EC2**  | `./deploy.sh --byo` | Use your existing EC2 instance           |

## Repository

All deployment code is hosted at: [codemie-on-vm](https://gitbud.epam.com/epm-cdme/codemie-on-vm)

```
codemie-on-vm/
├── compose/                              # Docker Compose files and config
├── deploy.sh                             # Deployment script
├── destroy.sh                            # Destroy script
├── deployment.conf.aws.example               # Configuration template
└── terraform/
    └── aws/
        ├── codemie-on-vm-aws-iam/        # IAM deployer role Terraform module
        ├── platform/                     # EC2, VPC, ALB, S3, KMS infrastructure
        └── remote-backend/               # S3 Terraform state bucket
```

## Next Steps

Proceed to [Prerequisites](/admin/deployment/aws/on-vm/prerequisites) to verify your environment is ready for deployment.
