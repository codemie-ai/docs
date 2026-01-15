---
id: infrastructure-deployment-overview
title: GCP Infrastructure Deployment
sidebar_label: Infrastructure Deployment
sidebar_position: 4
pagination_prev: admin/deployment/gcp/architecture
pagination_next: admin/deployment/gcp/infrastructure-deployment/infrastructure-manual-deployment
---

# GCP Infrastructure Deployment

This section guides you through deploying the GCP infrastructure foundation required for AI/Run CodeMie using Terraform automation.

:::info Existing Infrastructure
If you already have a provisioned GKE cluster with all required GCP services (networking, storage, databases, etc.), you can skip this section and proceed directly to [Components Deployment](../components-deployment).
:::

## Overview

The Terraform deployment is organized into two distinct phases, each with its own set of resources and purpose:

1. **Terraform State Backend** - Infrastructure for storing Terraform state files securely
2. **Core Platform Infrastructure** - Main GCP resources for running AI/Run CodeMie

## Phase 1: Terraform State Backend

The state backend is deployed first to provide secure, centralized storage for Terraform state files.

| Resource           | Purpose                                                                       |
| ------------------ | ----------------------------------------------------------------------------- |
| **Storage Bucket** | Google Cloud Storage bucket for storing Terraform state files with versioning |

:::tip State Backend Purpose
The Terraform state backend enables:

- **Team Collaboration**: Multiple engineers can work on infrastructure simultaneously
- **State Locking**: Prevents concurrent modifications that could corrupt state
- **Versioning**: Maintains history of infrastructure changes
- **Security**: State files contain sensitive data and require secure storage
  :::

## Phase 2: Core Platform Infrastructure

The core platform infrastructure provisions all GCP resources needed to run AI/Run CodeMie. This is the main deployment phase and following GCP resources will be deployed:

### Compute & Orchestration

| Resource         | Purpose                                                                   |
| ---------------- | ------------------------------------------------------------------------- |
| **GKE Cluster**  | Private or public Kubernetes cluster for running AI/Run CodeMie workloads |
| **Node Pools**   | Managed node groups for application workloads                             |
| **Bastion Host** | Management VM for secure cluster access (optional, for private clusters)  |

### Networking

| Resource           | Purpose                                                          |
| ------------------ | ---------------------------------------------------------------- |
| **VPC Network**    | Virtual Private Cloud for isolated network environment           |
| **Subnets**        | Network segmentation for GKE nodes and pods                      |
| **Cloud NAT**      | Provides consistent outbound public IP for internet connectivity |
| **Cloud Router**   | Enables dynamic routing for VPC                                  |
| **DNS Zones**      | Name resolution for CodeMie components (public or private)       |
| **Firewall Rules** | Network access control and traffic filtering                     |

### Data & Storage

| Resource                   | Purpose                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------ |
| **Cloud SQL (PostgreSQL)** | Managed PostgreSQL database service for CodeMie application data with private connectivity |
| **Cloud Storage Buckets**  | Optional persistent storage for CodeMie application data and artifacts                     |

:::info Optional Components
Some components like Cloud Storage buckets or public DNS zones may be optional depending on your deployment configuration and requirements.
:::

### Security & Identity

| Resource                   | Purpose                                                                       |
| -------------------------- | ----------------------------------------------------------------------------- |
| **Cloud KMS Key**          | Encryption key for encrypting and decrypting sensitive data in AI/Run CodeMie |
| **Service Accounts**       | Identity for accessing GCP services (Vertex AI, Cloud Storage, etc.)          |
| **IAM Role Bindings**      | Role-based access control for service accounts                                |
| **Private Service Access** | Secure, private network access to Cloud SQL                                   |

## Terraform Modules

The core platform infrastructure leverages proven Terraform modules from the community to ensure reliability, security, and best practices:

- [terraform-google-modules/service-accounts](https://registry.terraform.io/modules/terraform-google-modules/service-accounts/google/latest)
- [terraform-google-modules/kms](https://registry.terraform.io/modules/terraform-google-modules/kms/google/latest)
- [terraform-google-modules/network](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest)
- [terraform-google-modules/cloud-nat](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/latest)
- [terraform-google-modules/kubernetes-engine](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)
- [terraform-google-modules/bastion-host](https://registry.terraform.io/modules/terraform-google-modules/bastion-host/google/latest)
- [terraform-google-modules/cloud-dns](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest)
- [TerraformFoundation/sql-db/google/private_service_access](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/private_service_access)
- [TerraformFoundation/sql-db/google/postgresql](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/postgresql)

## Next Steps

With the infrastructure resources defined, you are now ready to proceed with the deployment of the GCP infrastructure.

Continue to the [Infrastructure Deployment Guide](./infrastructure-manual-deployment) to execute the deployment process and provision all required GCP resources for AI/Run CodeMie.
