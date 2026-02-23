---
id: terraform-upgrade
title: Terraform Version Upgrade (1.5.7 → 1.13.5)
sidebar_label: Terraform Upgrade
sidebar_position: 1
pagination_next: null
pagination_prev: admin/update/update-overview
---

# Terraform Version Upgrade (1.5.7 → 1.13.5)

This guide covers upgrading Terraform from **1.5.7** to **1.13.5** for AI/Run CodeMie infrastructure deployments.

## What Changed

| Area                       | AWS                                                                     | Azure                                                  |
| -------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------ |
| Terraform                  | 1.5.7 → **1.13.5**                                                      | 1.5.7 → **1.13.5**                                     |
| Kubernetes                 | EKS 1.33 → **1.35** (two-step upgrade required)                         | AKS 1.33.5 → **1.34.2**                                |
| State locking              | DynamoDB → **S3 native**                                                | —                                                      |
| Provider versions          | —                                                                       | `azurerm`, `azapi`, `azuread`, `random`, `tls` updated |
| Terraform registry modules | `vpc`, `alb`, `eks`, `iam`, `ecr`, `route53`, `acm`, `key-pair` updated | —                                                      |

### AWS — S3 Native State Locking and Module Updates

Terraform 1.13.5 introduces built-in S3 state locking, making a separate DynamoDB table unnecessary. The `remote-backend` module will remove the DynamoDB table and configure locking directly on the S3 bucket using `use_lockfile=true`.

All Terraform registry modules used in the `platform` module were also updated.

The default EKS Kubernetes version was bumped from **1.33** to **1.35**. EKS does not allow skipping minor versions — you must upgrade **1.33 → 1.34 → 1.35** in two separate steps. See the [AWS guide](./aws.md) for details.

### Azure — Provider and Kubernetes Updates

The Azure deployment requires updated provider versions across all three modules, and the default Kubernetes version for AKS is bumped to **1.34.2**:

- **Platform modules:** `azurerm ~> 4.60`, `azapi ~> 2.8`, `azuread ~> 3.7`, `random ~> 3.8`, `tls ~> 4.2`
- **Remote-backend module:** `azurerm ~> 4.60`
- **AI-models modules:** `azurerm ~> 3.117`, `azapi ~> 1.15`, `azuread ~> 2.53`

See the [Azure guide](./azure.md) for exact old/new version numbers.

## Prerequisites

Before upgrading, install [tfenv](https://github.com/tfutils/tfenv#installation) and switch to the required version:

```bash
tfenv install 1.13.5 && tfenv use 1.13.5
```

Verify the installed version:

```bash
terraform version
# Terraform v1.13.5
```

:::warning Back Up Your State

Before running any migration commands, ensure your Terraform state is backed up and there are no pending changes (`terraform plan` shows no diff).

:::

## Cloud-Specific Guides

- [AWS Migration](./aws.md) — remove DynamoDB, migrate to S3 native locking
- [Azure Migration](./azure.md) — upgrade provider versions across all modules and Kubernetes to 1.34.2
