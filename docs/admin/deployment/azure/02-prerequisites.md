---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
pagination_prev: admin/deployment/azure/overview
pagination_next: admin/deployment/azure/architecture
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import ClusterRequirements from '../common/\_cluster-requirements.mdx';

# Prerequisites

This page outlines the requirements and prerequisites necessary for deploying AI/Run CodeMie on Microsoft Azure. Please ensure all requirements are met before proceeding with the installation.

## Azure Account Requirements

### Required Access and Permissions

To deploy AI/Run CodeMie on Azure, you need:

- **Active Azure Subscription** with sufficient quota for the required resources
- **Contributor Role** for the deployment user with the following permissions:
  - Access to **Entra ID App Registration** to obtain Application ID and Secret
  - Ability to create and manage Azure resources (AKS, networking, storage, etc.)
    :::info Complete Resource List
    For a detailed list of all Azure resources that will be provisioned, refer to the [Infrastructure Deployment](./infrastructure-deployment) section or review the Terraform modules in the deployment repository.
    :::
- **Entra ID Access** on the Azure portal to retrieve application details such as Tenant ID

### DNS and Certificate Requirements

DNS and TLS certificate requirements depend on your access model:

<Tabs>
  <TabItem value="public" label="Public Access" default>
    If you require **public internet access** to AI/Run CodeMie:

    - Azure DNS Zone must be created and domain delegated there
    - Valid wildcard TLS certificate must be available for HTTPS connections

  </TabItem>
  <TabItem value="private" label="Private Access">
    If you only require **internal access** within your organization:

    - AI/Run CodeMie Terraform modules will automatically create a private DNS zone
    - No external DNS delegation or public certificates are required

  </TabItem>
</Tabs>

## Network Requirements

### Outbound Connectivity

Your AKS cluster's Network Security Group (NSG) or firewall must allow **outbound access** to the following endpoints:

| Destination                           | Purpose                                                        |
| ------------------------------------- | -------------------------------------------------------------- |
| `europe-west3-docker.pkg.dev`         | AI/Run CodeMie container registry (Google Container Registry)  |
| `quay.io`                             | Third-party container images                                   |
| `docker.io`                           | Docker Hub container images                                    |
| `registry.developers.crunchydata.com` | PostgreSQL operator images                                     |
| Your integration services             | GitLab, GitHub, or other services you plan to use with CodeMie |

:::note Container Registry Access
AI/Run CodeMie container images are hosted on Google Container Registry (GCR). You will need **gcloud CLI** installed on your deployment machine to authenticate and pull helm charts from GCR.
:::

### Inbound Connectivity on Corporate Services

If you plan to integrate AI/Run CodeMie with external corporate services (e.g., GitLab, GitHub, internal APIs):

- Configure the **firewall on your external service** to allow inbound traffic from the AI/Run CodeMie NAT Gateway public IP address
- This allows AI/Run CodeMie to make outbound API calls to your external services (e.g., GitLab API, GitHub API, internal services)

:::warning
The AI/Run CodeMie NAT Gateway public IP address will only be available **after infrastructure deployment**. You will need to configure external service firewalls after the installation is complete.
:::

### Access Control Network List

To restrict access to AI/Run CodeMie and prevent unauthorized access from the public internet, prepare a list of allowed networks:

- **Corporate network CIDR ranges** from which users will access AI/Run CodeMie
- **VPN network ranges** if remote users connect via VPN
- **Office locations** and their public IP addresses or CIDR blocks
- **Any other trusted networks** that require access to the platform

<ClusterRequirements clusterName="AKS" networkName="VNet" />

## Deployment Machine Requirements

### Required Software Tools

The following tools must be pre-installed and properly configured on your deployment machine (laptop, workstation, or VDI instance):

| Tool                                                                       | Version        | Purpose                                                   |
| -------------------------------------------------------------------------- | -------------- | --------------------------------------------------------- |
| [Terraform](https://developer.hashicorp.com/terraform/install)             | `1.5.7`        | Infrastructure as Code provisioning                       |
| [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)                 | Latest stable  | Kubernetes cluster management                             |
| [Helm](https://helm.sh/docs/intro/install/)                                | `3.16.0+`      | Kubernetes package management                             |
| [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) | Latest         | Azure resource management                                 |
| [kubelogin](https://azure.github.io/kubelogin/install.html)                | Latest         | AKS authentication plugin                                 |
| [gcloud CLI](https://cloud.google.com/sdk/docs/install)                    | Latest         | Authentication to AI/Run CodeMie container registry (GCR) |
| [Docker](https://docs.docker.com/get-started/get-docker/)                  | Latest stable  | Container operations                                      |
| [natscli](https://github.com/nats-io/natscli#installation)                 | Latest         | NATS messaging CLI                                        |
| [nsc](https://github.com/nats-io/nsc)                                      | Latest         | NATS security configuration                               |
| [jq](https://jqlang.org/download/)                                         | Latest         | JSON processing and parsing                               |
| [curl](https://curl.se/download.html)                                      | Latest         | HTTP requests and file transfers                          |
| `htpasswd`                                                                 | System package | Password hash generation                                  |

### Required Repository Access

You will need access to the following repositories to complete the deployment:

- **Terraform Modules:** [codemie-terraform-azure](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure)
- **Helm Charts:** [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info Air-Gapped Environments
If your deployment machine operates in an isolated environment without direct internet or repository access, the repositories can be provided as ZIP/TAR archives and transferred through approved channels.
:::

## Next Steps

Once all prerequisites are met, proceed to the [Architecture Overview](./architecture) to understand the deployment architecture, or continue directly to [Infrastructure Deployment](./infrastructure-deployment) to begin the installation process.
