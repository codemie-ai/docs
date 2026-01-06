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

### Outbound Connectivity

Your GKE cluster's firewall or VPC firewall rules must allow **outbound access** to the following endpoints:

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

## GKE Cluster Requirements

### Administrative Permissions

The deployment user must have:

- **GKE Admin permissions** with the ability to create and manage namespaces
- Access to configure cluster-level resources (if deploying to an existing cluster)

### Admission Control and Resource Requirements

If deploying to an **existing GKE cluster**, ensure that admission webhooks allow the creation of the following Kubernetes resources:

<Tabs>
  <TabItem value="nats" label="NATS Messaging" default>
    **Kubernetes API:** `Service` (LoadBalancer type)

    **Purpose:** NATS is a core component of the CodeMie Plugin Engine, providing messaging infrastructure for communication between the [codemie-plugins](https://pypi.org/project/codemie-plugins/) CLI tool with MCP and the AI/Run CodeMie platform.

    The LoadBalancer configuration depends on where the CLI tool will be executed:

    | CLI Tool Execution Location | LoadBalancer Type | Description |
    |----------------|------------------|-------------|
    | Same VPC as GKE cluster | Internal LoadBalancer | Secure, private network communication within the VPC |
    | External to GKE VPC | Public LoadBalancer | Cross-network communication when CLI is run outside the VPC |

  </TabItem>

  <TabItem value="keycloak" label="Keycloak Operator">
    **Kubernetes APIs:** `ClusterRole`, `ClusterRoleBinding`, `Role`, `RoleBinding`, Custom Resource Definitions (CRDs), Custom Resources (CRs)

    **Purpose:** Manages Keycloak configuration including realms, clients, and user federation

    :::note
    Requires cluster-wide permissions for identity and access management operations.
    :::

  </TabItem>

  <TabItem value="postgresql" label="PostgreSQL Operator">
    **Kubernetes APIs:** `ClusterRole`, `ClusterRoleBinding`, Custom Resource Definitions (CRDs), Custom Resources (CRs)

    **Purpose:** Manages PostgreSQL database instances and their lifecycle

    :::note
    Requires cluster-wide permissions for database provisioning and management.
    :::

  </TabItem>

  <TabItem value="security" label="Security Context">
    **Kubernetes API:** `Pod` with `securityContext`

    **Requirement:** All AI/Run CodeMie components require `readOnlyRootFilesystem: false` in their security context for proper operation

  </TabItem>
</Tabs>

## Deployment Machine Requirements

### Required Software Tools

The following tools must be pre-installed and properly configured on your deployment machine (laptop, workstation, or VDI instance):

| Tool                                                           | Version       | Purpose                                        |
| -------------------------------------------------------------- | ------------- | ---------------------------------------------- |
| [Terraform](https://developer.hashicorp.com/terraform/install) | `1.5.7`       | Infrastructure as Code provisioning            |
| [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)     | Latest stable | Kubernetes cluster management                  |
| [Helm](https://helm.sh/docs/intro/install/)                    | `3.16.0+`     | Kubernetes package management                  |
| [gcloud CLI](https://cloud.google.com/sdk/docs/install)        | Latest        | GCP resource management and GCR authentication |
| [Docker](https://docs.docker.com/get-started/get-docker/)      | Latest stable | Container operations                           |
| [natscli](https://github.com/nats-io/natscli#installation)     | Latest        | NATS messaging CLI                             |
| [nsc](https://github.com/nats-io/nsc)                          | Latest        | NATS security configuration                    |
| [jq](https://jqlang.org/download/)                             | Latest        | JSON processing and parsing                    |
| [curl](https://curl.se/download.html)                          | Latest        | HTTP requests and file transfers               |
| `htpasswd` (apache2-utils)                                     | Latest        | Password hash generation                       |

### Required Repository Access

You will need access to the following repositories to complete the deployment:

- **Terraform Remote Backend:** [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend)
- **Terraform Platform Modules:** [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform)
- **Helm Charts:** [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info Air-Gapped Environments
If your deployment machine operates in an isolated environment without direct internet or repository access, the repositories can be provided as ZIP/TAR archives and transferred through approved channels.
:::

## Next Steps

Once all prerequisites are met, proceed to the [Architecture Overview](./architecture) to understand the deployment architecture, or continue directly to [Infrastructure Deployment](./infrastructure-deployment) to begin the installation process.
