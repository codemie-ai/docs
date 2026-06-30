---
id: deployment
title: Deployment
sidebar_label: Deployment
sidebar_position: 4
pagination_prev: admin/deployment/gcp/on-vm/architecture
pagination_next: admin/deployment/gcp/on-vm/deployment/scripted-deployment
---

# Deployment

This section covers deploying CodeMie On VM infrastructure and application stack on GCP.

## Deployment Methods

| Method                                           | Description                                                                 | When to Use                                                           |
| ------------------------------------------------ | --------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| [**Scripted Deployment**](./scripted-deployment) | Fully automated — single `./deploy.sh` handles Terraform and provisioning   | Recommended for most users                                            |
| [**Manual Deployment**](./manual-deployment)     | Step-by-step Terraform commands, then BYO mode for application provisioning | When you need full control or are integrating with existing workflows |

:::tip Recommendation
Use **Scripted Deployment** unless you have specific requirements for manual Terraform control. The script handles prerequisite checks, configuration validation, and proper phase sequencing automatically.
:::

## Deployment Phases

Both methods execute the same logical phases:

| Phase                        | Description                                                              |
| ---------------------------- | ------------------------------------------------------------------------ |
| **Terraform State Backend**  | Creates GCS bucket for Terraform state (one-time)                        |
| **Platform Infrastructure**  | Provisions VM, GCS bucket, Cloud KMS key, Private DNS zone, firewall     |
| **Application Provisioning** | Installs Docker, syncs compose files, generates secrets, starts services |

## Next Steps

- [Scripted Deployment](./scripted-deployment) — Automated deployment with `./deploy.sh`
- [Manual Deployment](./manual-deployment) — Manual Terraform + BYO application provisioning
