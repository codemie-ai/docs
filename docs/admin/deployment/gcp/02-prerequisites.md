---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
pagination_prev: admin/deployment/gcp/overview
pagination_next: admin/deployment/gcp/architecture
---

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

### User Permissions and Admission Control Requirements for GKE

- Admin GKE permissions with rights to create `namespaces`

- Admission webhook allows creation of Kubernetes resources listed below (applicable when deploying onto an existing GKE cluster with enforced policies):

| AI/Run CodeMie Component | Kubernetes APIs                                                           | Description                                                                                                                                                                                                                                                                                                                                                                                                  |
| ------------------------ | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| NATS                     | `Service`                                                                 | NATS messaging system requires a LoadBalancer service type for client-server communication. When running [`codemie-plugins`](https://gitbud.epam.com/epm-cdme/codemie-plugins):<br/>– within the same VPC as the EKS cluster – Internal LoadBalancer configured for secure, private network communication<br/>– outside the EKS cluster's VPC – Public LoadBalancer required for cross-network communication |
| keycloak-operator        | `ClusterRole`, `ClusterRoleBinding`, `Role`, `RoleBinding`, `CRDs`, `CRs` | Cluster-wide permissions required for managing Keycloak configuration, including realms, clients, and user federation settings                                                                                                                                                                                                                                                                               |
| Postgres-operator        | `ClusterRole`, `ClusterRoleBinding`, `CRDs`, `CRs`                        | Cluster-wide permissions required for managing PostgreSQL instances and their lifecycle                                                                                                                                                                                                                                                                                                                      |
| All components           | `Pod(securityContext)`                                                    | All components require SecurityContext with `readOnlyRootFilesystem: false` for proper operation                                                                                                                                                                                                                                                                                                             |

## Deployer Instance Requirements

- The following software must be pre-installed and configured on the deployer laptop or VDI instance before beginning the deployment process:
  - [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) `1.5.7`
  - [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
  - [helm](https://helm.sh/docs/intro/install/) `3.16.0+`
  - [gcloud CLI](https://cloud.google.com/sdk/gcloud)
  - [docker](https://docs.docker.com/get-started/get-docker/)
  - [natscli](https://github.com/nats-io/natscli?tab=readme-ov-file#installation)
  - [nsc](https://github.com/nats-io/nsc)
  - [jq](https://jqlang.org/download/)
  - [curl](https://github.com/curl/curl)
  - htpasswd

- Access to the following repositories is necessary for deployment:
  - [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend)
  - [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform)
  - [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info
Repositories can be extracted as archives and uploaded to a VDI if direct repository access is not available.
:::
