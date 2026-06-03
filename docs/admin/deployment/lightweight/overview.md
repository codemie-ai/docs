---
id: overview
title: AI/Run CodeMie Lightweight Deployment Guide
sidebar_label: Overview
sidebar_position: 1
pagination_prev: admin/deployment/index
pagination_next: admin/deployment/lightweight/prerequisites
---

# AI/Run CodeMie Lightweight Deployment

CodeMie Lightweight deploys the full AI/Run CodeMie platform on a **single EC2 instance** using Docker Compose. It provides the same core functionality as the full AWS (EKS) deployment but with minimal infrastructure overhead.

## When to Use

CodeMie Lightweight is designed for:

- **Proof of Concept (PoC)** — quickly validate CodeMie capabilities in your environment
- **Demo environments** — showcase CodeMie to stakeholders without complex infrastructure

:::warning Not for Production
For production workloads with high availability, scaling, and multi-AZ redundancy, use the full [AWS Deployment Guide](/admin/deployment/aws/overview).
:::

## Deployment Profiles

CodeMie Lightweight supports two profiles:

| Profile        | Authentication          | LLM Proxy | NATS Messaging | Use Case                   |
| -------------- | ----------------------- | --------- | -------------- | -------------------------- |
| **OSS**        | Local (built-in)        | Internal  | No             | Simple setups, quick demos |
| **Enterprise** | Keycloak + OAuth2 Proxy | LiteLLM   | Yes            | Full feature set, SSO      |

## Deployment Modes

| Mode         | Command             | Infrastructure                           |
| ------------ | ------------------- | ---------------------------------------- |
| **Standard** | `./deploy.sh`       | Terraform creates EC2, VPC, ALB, S3, KMS |
| **BYO EC2**  | `./deploy.sh --byo` | Use your existing EC2 instance           |

## Repository

All deployment code is hosted at: [codemie-lightweight](https://gitbud.epam.com/epm-cdme/codemie-lightweight)

```
codemie-lightweight/
├── codemie-lightweight/          # Main deployment (Terraform + Compose + script)
└── codemie-lightweight-aws-iam/  # IAM deployer role Terraform module
```

## Next Steps

Proceed to [Prerequisites](/admin/deployment/lightweight/prerequisites) to verify your environment is ready for deployment.
