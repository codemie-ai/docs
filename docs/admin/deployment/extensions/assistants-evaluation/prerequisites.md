---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 1
description: Prerequisites for installing Langfuse
pagination_prev: admin/deployment/extensions/assistants-evaluation/assistants-evaluation
pagination_next: null
---

# Prerequisites

Before starting any deployment method, ensure you have:

## Required Tools

- `kubectl` configured and connected to your cluster
- `helm` installed (version 3.x)
- `openssl` for generating secure secrets

## Infrastructure Requirements

- Installed and deployed AI/Run CodeMie instance
- PostgreSQL database instance
- Sufficient cluster resources for Langfuse components
- Kubernetes cluster with appropriate permissions
- Object storage bucket for Langfuse event, batch-export, and media uploads — one of:
  - **AWS S3** (recommended for EKS): a dedicated S3 bucket with an IRSA role granting `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject`, `s3:ListBucket`. Provisioned automatically via `codemie-terraform-aws-platform` with `TF_VAR_enable_langfuse_s3=true`.
  - **Azure Blob Storage**: a Storage Account with a container; static credentials required (IRSA not supported by Langfuse for Azure).
  - **Google Cloud Storage**: a GCS bucket. On GKE, use Workload Identity (recommended) — annotate the Langfuse service account with `iam.gke.io/gcp-service-account` and grant the GCP SA `storage.objectAdmin` on the bucket; no static credentials needed. Also can provide a service-account JSON key.

:::warning Minimum CodeMie Version

Minimal supported version of AI/Run CodeMie for evaluation is 1.3.0. Make sure you've updated your CodeMie installation before proceeding.

:::

## Access to the following repositories:

- [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

Review Langfuse system requirements before proceeding.
