---
sidebar_position: 2
title: Prerequisites
description: Prerequisites for deploying AI/Run CodeMie on AWS
---

# Prerequisites

Before installing AI/Run CodeMie, carefully review the prerequisites and requirements.

## Prerequisites Checklist

### AWS Account Access Requirements

- Active AWS Account with preferable region for deployment
- User credentials with programmatic access to AWS account with permissions to create and manage IAM Roles and Policy Documents

### Domain Name

- Available wildcard DNS hosted zone in Route53

:::info
AI/Run CodeMie terraform modules will automatically create:

- DNS Records
- TLS certificate through AWS Certificate Manager, which will be used later by the ALB and NLB
  :::

### External Connections

- Firewall or SG and NACLs of EKS cluster allow outbound access to:
  - AI/Run CodeMie container registry – `europe-west3-docker.pkg.dev`
  - 3rd party container registries – `quay.io`, `docker.io`, `registry.developers.crunchydata.com`
  - Any service you're planning to use with AI/Run CodeMie (for example, GitLab instance)

- Firewall on your integration service allow inbound traffic from the AI/Run CodeMie NAT Gateway public IP address

:::info
NAT Gateway public IP address will be known after EKS installation
:::

### LLM Models

- Activated region in AWS where [AWS Bedrock Models](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html) are available
- Activated desired LLMs and embeddings models in AWS account (for example, Sonnet 3.5v3/3.7, AWS Titan 2.0)

:::info
AI/Run CodeMie can be deployed with mock LLM configurations initially. Real configurations can be provided later if client-side approvals require additional time.
:::

### User Permissions and Admission Control Requirements for EKS

- Admin EKS permissions with rights to create `namespaces`
- Admission webhook allows creation of Kubernetes resources listed below (applicable when deploying onto an existing EKS cluster with enforced policies):

| AI/Run CodeMie Component | Kubernetes APIs                                                           | Description                                                                                                                                                                                                                                                                                                                                              |
| ------------------------ | ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| NATS                     | `Service`                                                                 | NATS messaging system requires a LoadBalancer service type for client-server communication. When running `codemie-plugins`:<br/>– within the same VPC as the EKS cluster – Internal LoadBalancer configured for secure, private network communication<br/>– outside the EKS cluster's VPC – Public LoadBalancer required for cross-network communication |
| keycloak-operator        | `ClusterRole`, `ClusterRoleBinding`, `Role`, `RoleBinding`, `CRDs`, `CRs` | Cluster-wide permissions required for managing Keycloak configuration, including realms, clients, and user federation settings                                                                                                                                                                                                                           |
| Postgres-operator        | `ClusterRole`, `ClusterRoleBinding`, `CRDs`, `CRs`                        | Cluster-wide permissions required for managing PostgreSQL instances and their lifecycle                                                                                                                                                                                                                                                                  |
| All components           | `Pod(securityContext)`                                                    | All components require SecurityContext with `readOnlyRootFilesystem: false` for proper operation                                                                                                                                                                                                                                                         |

## Deployer Instance Requirements

### Required Software

The following software must be pre-installed and configured on the deployer laptop or VDI instance before beginning the deployment process:

- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) `v1.5.7`
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [helm](https://helm.sh/docs/intro/install/) `v3.16.0+`
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- [docker](https://docs.docker.com/get-started/get-docker/)
- [natscli](https://github.com/nats-io/natscli?tab=readme-ov-file#installation)
- [nsc](https://github.com/nats-io/nsc)

### Required Repository Access

Access to the following repositories is necessary for deployment:

- [codemie-terraform-aws-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-remote-backend)
- [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform)
- [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)
- [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info
Repositories can be extracted as archives and uploaded to a VDI if direct repository access is not available
:::
