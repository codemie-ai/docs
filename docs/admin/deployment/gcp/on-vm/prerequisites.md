---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
pagination_prev: admin/deployment/gcp/on-vm/overview
pagination_next: admin/deployment/gcp/on-vm/architecture
---

# Prerequisites

This page outlines the requirements for deploying AI/Run CodeMie On VM on GCP. Ensure all prerequisites are met before proceeding.

## GCP Account Requirements

### Required Access and Permissions

- **Active GCP Project** with sufficient quota for the required resources
- The operator account must have the following roles or equivalent permissions:
  - `roles/iap.tunnelResourceAccessor` — SSH access to the VM via IAP
  - `roles/secretmanager.secretAccessor` — fetch SSH key from Secret Manager
  - Permissions to create: GCE VM, GCS bucket, Cloud KMS key, Cloud DNS private zone, VPC firewall rules

### Quota Requirements

Verify sufficient quota for:

| Resource               | Count        |
| ---------------------- | ------------ |
| n2-highmem-4 VM        | 1            |
| GCS Bucket             | 1            |
| Cloud KMS Key          | 1            |
| Cloud DNS Private Zone | 1 (optional) |

## Deployment Machine Tools

The following tools must be installed on the machine where you run `./deploy.sh`:

| Tool                                                           | Version | Purpose                           |
| -------------------------------------------------------------- | ------- | --------------------------------- |
| [Terraform](https://developer.hashicorp.com/terraform/install) | 1.15.x  | Infrastructure provisioning       |
| [gcloud CLI](https://cloud.google.com/sdk/docs/install)        | latest  | GCP authentication and management |
| [jq](https://jqlang.github.io/jq/download/)                    | latest  | JSON parsing                      |
| openssl                                                        | latest  | Secret generation                 |
| envsubst                                                       | latest  | Template rendering                |

**Enterprise profile only:**

| Tool                                  | Version | Purpose             |
| ------------------------------------- | ------- | ------------------- |
| [nsc](https://github.com/nats-io/nsc) | latest  | NATS key generation |

### Verify Installation

```bash
terraform version    # Should show 1.15.x
gcloud version
jq --version
openssl version
envsubst --version
```

## GCP Container Registry Access

CodeMie container images are hosted on `europe-west3-docker.pkg.dev`. You need a **GCP service account key file** (`key.json`) with read access to the registry.

:::info Obtaining key.json
Contact your CodeMie administrator or EPAM delivery team to obtain the `key.json` file for registry access.
:::

## GCP Authentication

Authenticate before running the deployment:

```bash
gcloud auth application-default login

# Verify active project
gcloud config get-value project
```

## Repository Access

Clone the deployment repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-on-vm.git
cd codemie-on-vm
```

The repository structure:

| Directory                       | Purpose                                        |
| ------------------------------- | ---------------------------------------------- |
| `compose/`                      | Docker Compose files and service configuration |
| `deploy.sh`                     | Deployment script                              |
| `destroy.sh`                    | Destroy script                                 |
| `terraform/gcp/remote-backend/` | GCS bucket for Terraform state                 |
| `terraform/gcp/platform/`       | VM, GCS bucket, KMS key, DNS, firewall         |

## Next Steps

After verifying all prerequisites, review the [Architecture](../architecture) to understand what will be deployed.
