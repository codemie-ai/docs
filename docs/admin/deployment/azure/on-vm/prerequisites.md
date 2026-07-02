---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
pagination_prev: admin/deployment/azure/on-vm/overview
pagination_next: admin/deployment/azure/on-vm/architecture
---

# Prerequisites

This page outlines the requirements for deploying AI/Run CodeMie On VM on Azure. Ensure all prerequisites are met before proceeding.

## Azure Account Requirements

### Required Access and Permissions

- **Active Azure Subscription** with sufficient quota for the required resources
- **Contributor role** (or equivalent) on the subscription to create VMs, Storage Accounts, Key Vaults, and DNS zones
- **AZURE_SUBSCRIPTION_ID** and **AZURE_TENANT_ID** — available in the Azure Portal under **Azure Active Directory → Overview**

### Quota Requirements

Verify sufficient quota for:

| Resource         | Count |
| ---------------- | ----- |
| Standard_E4s_v5  | 1     |
| Azure Key Vault  | 1     |
| Storage Account  | 1     |
| Private DNS Zone | 1     |

## Deployment Machine Tools

The following tools must be installed on the machine where you run `./deploy.sh`:

| Tool                                                                       | Version | Purpose                             |
| -------------------------------------------------------------------------- | ------- | ----------------------------------- |
| [Terraform](https://developer.hashicorp.com/terraform/install)             | 1.15.x  | Infrastructure provisioning         |
| [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) | latest  | Azure authentication and management |
| [jq](https://jqlang.github.io/jq/download/)                                | latest  | JSON parsing                        |
| openssl                                                                    | latest  | Secret generation                   |
| envsubst                                                                   | latest  | Template rendering                  |

**Enterprise profile only:**

| Tool                                  | Version | Purpose             |
| ------------------------------------- | ------- | ------------------- |
| [nsc](https://github.com/nats-io/nsc) | latest  | NATS key generation |

### Verify Installation

```bash
terraform version    # Should show 1.15.x
az version           # Azure CLI
jq --version
openssl version
envsubst --version
```

## GCP Container Registry Access

CodeMie container images are hosted on `europe-west3-docker.pkg.dev`. You need a **GCP service account key file** (`key.json`) with read access to the registry.

:::info Obtaining key.json
Contact your CodeMie administrator or EPAM delivery team to obtain the `key.json` file for registry access.
:::

## Azure Authentication

Authenticate before running the deployment:

```bash
az login
az account set --subscription "<AZURE_SUBSCRIPTION_ID>"

# Verify active subscription
az account show
```

## Repository Access

Clone the deployment repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-on-vm.git
cd codemie-on-vm
```

The repository structure:

| Directory                         | Purpose                                        |
| --------------------------------- | ---------------------------------------------- |
| `compose/`                        | Docker Compose files and service configuration |
| `deploy.sh`                       | Deployment script                              |
| `destroy.sh`                      | Destroy script                                 |
| `terraform/azure/remote-backend/` | Azure Storage Terraform state backend          |
| `terraform/azure/platform/`       | VM, Storage Account, Key Vault, DNS, NSG       |
| `terraform/azure/ai-models/`      | Azure OpenAI cognitive accounts (optional)     |

## Next Steps

After verifying all prerequisites, review the [Architecture](../architecture) to understand what will be deployed.
