---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
---

# Prerequisites

Before installing AI/Run CodeMie, review the prerequisites and requirements.

## Prerequisites Checklist

### GCP Account Access Requirements

- Active GCP Account with administrative access

- User credentials with role permissions to create and manage IAM Roles and Policy Documents

- Enabled GCP APIs in your GCP project:
  - [Cloud Identity-Aware Proxy API](https://console.cloud.google.com/marketplace/product/google/iap.googleapis.com)
  - [Service Networking API](https://console.cloud.google.com/marketplace/product/google/servicenetworking.googleapis.com)
  - [Secret Manager API](https://console.cloud.google.com/marketplace/product/google/secretmanager.googleapis.com)
  - [Vertex AI API](https://console.cloud.google.com/marketplace/product/google/aiplatform.googleapis.com)

  :::info
  Make sure you are familiar with Gemini models, their parameters, available regions and other crucial details in [Vertex AI documentation](https://cloud.google.com/vertex-ai/generative-ai/docs/models).
  :::

- User needs to be able to bind the following roles to service accounts:
  - `roles/aiplatform.user`
  - `roles/storage.admin`
  - `roles/cloudkms.cryptoKeyEncrypterDecrypter`

### Domain Name

- Registered domain name delegated to Cloud DNS with permissions to create records

- Wildcard TLS certificate is available (https://kubernetes.github.io/ingress-nginx/user-guide/tls/)

### External Connections

- Firewall or VPC firewall rules of GKE cluster allow outbound access to:
  - AI/Run CodeMie container registry – europe-west3-docker.pkg.dev
  - 3rd party container registries – quay.io, docker.io, registry.developers.crunchydata.com
  - Any service you're planning to use with AI/Run CodeMie (for example, GitLab instance)

:::info
AI/Run CodeMie can be deployed with mock LLM configurations initially. Real configurations can be provided later if client-side approvals require additional time.
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

- Access to the following repositories is necessary for deployment:
  - [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend)
  - [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform)
  - [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info
Repositories can be extracted as archives and uploaded to a VDI if direct repository access is not available.
:::
