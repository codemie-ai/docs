---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
pagination_prev: admin/deployment/gcp/overview
pagination_next: admin/deployment/gcp/architecture
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import ClusterRequirements from '../common/deployment/02-prerequisites/\_cluster-requirements.mdx';
import NetworkRequirements from '../common/deployment/02-prerequisites/\_network-requirements.mdx';
import DeploymentMachineTools from '../common/deployment/02-prerequisites/\_deployment-machine-tools.mdx';
import NextSteps from '../common/deployment/02-prerequisites/\_next-steps.mdx';

# Prerequisites

This page outlines the requirements and prerequisites necessary for deploying AI/Run CodeMie on Google Cloud Platform (GCP). Please ensure all requirements are met before proceeding with the installation.

## GCP Account Requirements

### Required Access and Permissions

To deploy AI/Run CodeMie on GCP, you need:

- **Active GCP Project** with sufficient quota for the required resources
- **Project Owner or Editor Role** for the deployment user with the following permissions:
  - Ability to create and manage IAM Roles and Service Accounts
  - Access to create and manage GCP resources (GKE, VPC, Cloud SQL, etc.)
    :::info Complete Resource List
    For a detailed list of all GCP resources that will be provisioned, refer to the [Infrastructure Deployment](./infrastructure-deployment) section or review the Terraform modules in the deployment repository.
    :::
  - Ability to bind the following IAM roles to service accounts:
    - `roles/aiplatform.user` - For Vertex AI access
    - `roles/storage.admin` - For Cloud Storage management
    - `roles/cloudkms.cryptoKeyEncrypterDecrypter` - For encryption key operations

### Required GCP APIs

The following APIs must be enabled in your GCP project before deployment:

| API                                                                                                                    | Purpose                              |
| ---------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| [Cloud Identity-Aware Proxy API](https://console.cloud.google.com/marketplace/product/google/iap.googleapis.com)       | Secure identity-based access control |
| [Service Networking API](https://console.cloud.google.com/marketplace/product/google/servicenetworking.googleapis.com) | Private service connectivity         |
| [Secret Manager API](https://console.cloud.google.com/marketplace/product/google/secretmanager.googleapis.com)         | Centralized secrets management       |
| [Vertex AI API](https://console.cloud.google.com/marketplace/product/google/aiplatform.googleapis.com)                 | AI model integration and inference   |

:::info Vertex AI Models
Make sure you are familiar with Gemini models, their parameters, available regions, and other crucial details in the [Vertex AI documentation](https://cloud.google.com/vertex-ai/generative-ai/docs/models).
:::

## Network Requirements

### Domain Name and DNS

- Registered domain name delegated to Cloud DNS with permissions to create DNS records
- Valid wildcard TLS certificate must be available for HTTPS connections (see [Ingress NGINX TLS guide](https://kubernetes.github.io/ingress-nginx/user-guide/tls/))

<NetworkRequirements clusterName="GKE" networkSecurityName="firewall or VPC firewall rules" natGatewayName="Cloud NAT" />

<ClusterRequirements clusterName="GKE" networkName="VPC" />

## GKE Cluster Configuration

### VPC-Native Networking and Container-Native Load Balancing

AI/Run CodeMie requires GKE clusters configured with **VPC-native networking** and **container-native load balancing (NEGs)** for proper Ingress functionality.

**Required Configuration:**

- **Networking Mode:** `VPC_NATIVE` with IP allocation policy (secondary ranges for pods and services)
- **HTTP Load Balancing Addon:** Enabled (default)

:::warning Network Policy Disables Automatic NEGs
If your cluster uses **GKE Network Policy** or **Calico**, container-native load balancing will NOT be enabled automatically. This causes Ingress errors:

```
service "namespace/service" is type "ClusterIP", expected "NodePort" or "LoadBalancer"
```

**Solution:** Manually enable NEGs by adding this annotation to all Services exposed via Ingress in chart values. For example:

```yaml
service:
  type: ClusterIP
  port: 8080
  annotations:
    cloud.google.com/neg: '{"ingress": true}'
```

:::

<DeploymentMachineTools />

:::note gcloud CLI Multi-Purpose
For GCP deployments, gcloud CLI serves dual purposes: GCP resource management and authentication to AI/Run CodeMie container registry (GCR).
:::

### Required Repository Access

You will need access to the following repositories to complete the deployment:

- **Terraform Remote Backend:** [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend)
- **Terraform Platform Modules:** [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform)
- **Helm Charts:** [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info Air-Gapped Environments
If your deployment machine operates in an isolated environment without direct internet or repository access, the repositories can be provided as ZIP/TAR archives and transferred through approved channels.
:::

<NextSteps />
