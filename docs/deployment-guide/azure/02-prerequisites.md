---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
---

# Prerequisites

Before installing AI/Run CodeMie, carefully review the prerequisites and requirements.

## Prerequisites Checklist

### Azure Account Requirements

- Active Azure subscription
- Deployer user has built-in `contributor` role in Azure with permissions to access Entra ID App Registration (to obtain App ID and Secret for AI/Run CodeMie usage)
- Access to Entra ID on the Azure portal to get application details (Tenant, etc.)
- DNS Zone delegated to Azure and TLS certificate is available (only if public access to CodeMie is required, otherwise private DNS zone will be created by AI/Run CodeMie terraform modules)

### External Connections

- Firewall or NSG of AKS cluster allow outbound access to:
  - AI/Run CodeMie container registry – `europe-west3-docker.pkg.dev`
  - 3rd party container registries – `quay.io`, `docker.io`, `registry.developers.crunchydata.com`
  - Any service you're planning to use with AI/Run CodeMie (for example, GitLab instance)
- Firewall on your integration service allow inbound traffic from the AI/Run CodeMie NAT Gateway public IP address

:::info
AKS cluster public IP address will be known after installation
:::

### User Permissions and Admission Control Requirements for AKS

- Admin AKS permissions with rights to create `namespaces`
- Admission webhook allows creation of Kubernetes resources listed below (applicable when deploying onto an existing AKS cluster):

| AI/Run CodeMie Component | Kubernetes APIs                                                           | Description                                                                                                                                                                                                                                                                                                                                                                      |
| ------------------------ | ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| NATS                     | `Service`                                                                 | NATS messaging system requires a LoadBalancer service type for client-server communication. When running `codemie-plugins`:<br/>– within the same virtual network as the AKS cluster – Internal LoadBalancer configured for secure, private network communication<br/>– outside the AKS cluster's virtual network – Public LoadBalancer required for cross-network communication |
| keycloak-operator        | `ClusterRole`, `ClusterRoleBinding`, `Role`, `RoleBinding`, `CRDs`, `CRs` | Cluster-wide permissions required for managing Keycloak configuration, including realms, clients, and user federation settings                                                                                                                                                                                                                                                   |
| Postgres-operator        | `ClusterRole`, `ClusterRoleBinding`, `CRDs`, `CRs`                        | Cluster-wide permissions required for managing PostgreSQL instances and their lifecycle                                                                                                                                                                                                                                                                                          |
| All components           | `Pod(securityContext)`                                                    | All components require SecurityContext with `readOnlyRootFilesystem: false` for proper operation                                                                                                                                                                                                                                                                                 |

## Deployer Instance Requirements

### Required Software

The next software must be pre-installed and configured on the deployer laptop or VDI instance before beginning the deployment process:

- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) `1.5.7`
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [helm](https://helm.sh/docs/intro/install/) `3.16.0+`
- [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- [docker](https://docs.docker.com/get-started/get-docker/)
- [natscli](https://github.com/nats-io/natscli?tab=readme-ov-file#installation)
- [nsc](https://github.com/nats-io/nsc)
- [azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [azure kubelogin](https://azure.github.io/kubelogin/install.html)
- [jq](https://jqlang.org/download/)
- [curl](https://github.com/curl/curl)
- htpasswd

### Required Repository Access

Access to the following repositories is necessary for deployment:

- [codemie-terraform-azure](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure)
- [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info
Repositories can be extracted as archives and uploaded to a VDI if direct repository access is not available
:::
