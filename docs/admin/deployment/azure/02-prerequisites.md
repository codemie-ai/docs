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
import ClusterRequirements from '../common/deployment/02-prerequisites/\_cluster-requirements.mdx';
import NetworkRequirements from '../common/deployment/02-prerequisites/\_network-requirements.mdx';
import DeploymentMachineTools from '../common/deployment/02-prerequisites/\_deployment-machine-tools.mdx';
import NextSteps from '../common/deployment/02-prerequisites/\_next-steps.mdx';

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

<NetworkRequirements clusterName="AKS" networkSecurityName="Network Security Group (NSG) or firewall" natGatewayName="NAT Gateway" />

<ClusterRequirements clusterName="AKS" networkName="VNet" />

<DeploymentMachineTools />

**Cloud-Specific Tools:**

| Tool                                                                       | Version | Purpose                   |
| -------------------------------------------------------------------------- | ------- | ------------------------- |
| [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) | latest  | Azure resource management |
| [kubelogin](https://azure.github.io/kubelogin/install.html)                | latest  | AKS authentication plugin |

### Required Repository Access

You will need access to the following repositories to complete the deployment:

- **Terraform Modules:** [codemie-terraform-azure](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure)
- **Helm Charts:** [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info Air-Gapped Environments
If your deployment machine operates in an isolated environment without direct internet or repository access, the repositories can be provided as ZIP/TAR archives and transferred through approved channels.
:::

<NextSteps />
