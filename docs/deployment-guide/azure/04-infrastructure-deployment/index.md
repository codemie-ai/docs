---
id: infrastructure-deployment-overview
title: Azure Infrastructure Deployment
sidebar_label: Infrastructure Deployment
sidebar_position: 4
---

# Azure Infrastructure Deployment

This section guides you through deploying the Azure infrastructure foundation required for AI/Run CodeMie using Terraform automation.

:::info Existing Infrastructure
If you already have a provisioned AKS cluster with all required Azure services (networking, storage, databases, etc.), you can skip this section and proceed directly to [Components Deployment](../components-deployment).
:::

## Overview

The Terraform deployment is organized into three distinct phases, each with its own set of resources and purpose:

1. **Terraform State Backend** - Infrastructure for storing Terraform state files securely
2. **Core Platform Infrastructure** - Main Azure resources for running AI/Run CodeMie
3. **AI Model Deployments** - Optional Azure OpenAI services for AI capabilities

This modular approach allows you to deploy only what you need and maintain clear separation between infrastructure layers.

## Phase 1: Terraform State Backend

The state backend is deployed first to provide secure, centralized storage for Terraform state files.

| Resource               | Purpose                                                                        |
| ---------------------- | ------------------------------------------------------------------------------ |
| **Resource Group**     | Dedicated resource group for Terraform state management resources              |
| **Storage Account**    | Azure Storage Account for storing Terraform state files with versioning        |
| **Storage Containers** | Blob containers for state files (`tfstate`) and deployment scripts (`scripts`) |

:::tip State Backend Purpose
The Terraform state backend enables:

- **Team Collaboration**: Multiple engineers can work on infrastructure simultaneously
- **State Locking**: Prevents concurrent modifications that could corrupt state
- **Versioning**: Maintains history of infrastructure changes
- **Security**: State files contain sensitive data and require secure storage
  :::

## Phase 2: Core Platform Infrastructure

The core platform infrastructure provisions all Azure resources needed to run AI/Run CodeMie. This is the main deployment phase and following Azure resources will be deployed:

### Compute & Orchestration

| Resource                      | Purpose                                                                 |
| ----------------------------- | ----------------------------------------------------------------------- |
| **AKS Cluster**               | Private Kubernetes cluster for running AI/Run CodeMie workloads         |
| **Default Node Pool**         | Primary node pool with system workloads                                 |
| **Additional Node Pool**      | Secondary node pool for application workloads with custom labels/taints |
| **Virtual Machine (Jumpbox)** | Management VM for secure cluster access and administrative tasks        |

### Networking

| Resource                    | Purpose                                                              |
| --------------------------- | -------------------------------------------------------------------- |
| **Hub Virtual Network**     | Central network hub for shared services (Bastion, private endpoints) |
| **AKS Virtual Network**     | Isolated network for AKS cluster with multiple dedicated subnets     |
| **VNet Peering**            | Secure connectivity between Hub and AKS virtual networks             |
| **NAT Gateway**             | Provides consistent outbound public IP for internet connectivity     |
| **Public IP Address**       | Static public IP associated with NAT Gateway                         |
| **DNS Zones**               | Name resolution for CodeMie components                               |
| **Azure Bastion**           | Secure RDP/SSH access to VMs without exposing public IP addresses    |
| **Network Security Groups** | Firewall rules controlling traffic flow between subnets              |

### Data & Storage

| Resource                       | Purpose                                                                         |
| ------------------------------ | ------------------------------------------------------------------------------- |
| **PostgreSQL Flexible Server** | Managed database service for CodeMie application data with private connectivity |
| **Storage Account**            | Persistent storage for CodeMie application data and artifacts                   |
| **Container Registry (ACR)**   | Private Docker image repository for CodeMie container images                    |

:::info Optional: Azure Container Registry
ACR deployment is optional. If you plan to use an external container registry (e.g., Google Container Registry, Docker Hub, or a corporate registry), ACR can be omitted from the deployment.
:::

### Security & Identity

| Resource               | Purpose                                                                                     |
| ---------------------- | ------------------------------------------------------------------------------------------- |
| **Azure Key Vault**    | Centralized secrets management and encryption key storage                                   |
| **Managed Identities** | System-assigned identities for AKS cluster and workload identity federation                 |
| **Private Endpoints**  | Secure, private network access to Azure PaaS services (Storage, ACR, PostgreSQL, Key Vault) |
| **SSH Key Pair**       | Generated SSH key pair for secure VM access (stored in Key Vault)                           |
| **Role Assignments**   | RBAC permissions for AKS to pull from ACR and access Key Vault                              |
| **Workload Identity**  | OIDC federation enabling Kubernetes service accounts to authenticate with Azure AD          |

### Observability

| Resource                    | Purpose                                                       |
| --------------------------- | ------------------------------------------------------------- |
| **Log Analytics Workspace** | Centralized repository for logs, metrics, and monitoring data |

## Phase 3: AI Model Deployments (Optional)

The AI model deployment phase provisions Azure OpenAI services. This phase is **optional** and only needed if you want to use Azure-hosted AI models.

| Resource                  | Purpose                                                                                      |
| ------------------------- | -------------------------------------------------------------------------------------------- |
| **Azure OpenAI Services** | Azure Cognitive Services for OpenAI model deployments (GPT-5, GPT-4, embeddings models, etc) |
| **Azure AI Application**  | Application registration and managed identity for AI service access control                  |
| **Private DNS Zone**      | Private DNS zone for Azure OpenAI (`privatelink.openai.azure.com`)                           |
| **Private Endpoint**      | Private network connectivity to Azure OpenAI services                                        |
| **VNet Link**             | Links OpenAI private DNS zone to AKS virtual network                                         |

:::info Alternative AI Providers
Azure OpenAI Services are optional. AI/Run CodeMie supports other external AI providers:

- **AWS Bedrock**: Direct integration with api.openai.com
- **GCP VertexAI**: Integration with Anthropic's Claude models
- **Any Other Providers**: Any LLM API endpoint that can be integrated with LLM Proxy

If using external AI providers or other models, skip Phase 3 entirely.
:::

## Security Architecture

The infrastructure deployment implements security with multiple layers of protection:

:::tip Security
All resources are deployed with Azure security best practices enabled by default.
:::

### Network Security

- **Private AKS Cluster**: API server accessible only through private endpoint, not exposed to internet
- **Hub-Spoke Topology**: Centralized security controls in hub VNet with isolated spoke networks
- **Private Endpoints**: All Azure PaaS services (Storage, ACR, PostgreSQL, Key Vault, OpenAI) accessible only through private IPs
- **User Defined Routing (UDR)**: Custom route tables control traffic flow with NAT Gateway for internet egress
- **Network Segmentation**: Dedicated subnets for different workload tiers (nodes, pods, databases, private endpoints)

### Identity & Access Management

- **Managed Identities**: System-assigned identities eliminate need for credential management
- **Workload Identity**: OIDC federation enables Kubernetes pods to authenticate with Azure AD
- **Azure RBAC**: Role-based access control for AKS cluster and Azure resource management
- **Least Privilege**: Minimal permission sets granted through role assignments

### Data Protection

- **Encryption at Rest**: Azure Storage Service Encryption for all storage accounts
- **Encryption in Transit**: HTTPS/TLS enforced for all service communications
- **Key Vault**: Centralized management of encryption keys, secrets, and certificates
- **Private Connectivity**: Database, storage, and AI services isolated from public internet

### Compliance & Monitoring

- **Audit Logging**: All resource activities logged to Log Analytics Workspace
- **Diagnostic Settings**: Resource-level diagnostics for compliance and troubleshooting
- **Bastion Access**: Jump server access through Azure Bastion eliminates need for public IPs on VMs

## Deployment Methods

Proceed to the next step to deploy the infrastructure:

- [**Scripted Deployment** →](./infrastructure-scripted-deployment) - Recommended automated deployment using Terraform wrapper scripts

:::note Manual Deployment
For advanced users or custom scenarios, manual Terraform deployment is possible but not documented. The scripted approach handles all prerequisites, variable management, and deployment orchestration automatically.
:::
