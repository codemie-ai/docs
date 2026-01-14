---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
pagination_prev: admin/deployment/aws/overview
pagination_next: admin/deployment/aws/architecture
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Prerequisites

This page outlines the requirements and prerequisites necessary for deploying AI/Run CodeMie on Amazon Web Services. Please ensure all requirements are met before proceeding with the installation.

## AWS Account Requirements

### Required Access and Permissions

To deploy AI/Run CodeMie on AWS, you need:

- **Active AWS Account** with preferred region for deployment
- **Programmatic Access** with credentials that have permissions to create and manage IAM Roles and Policy Documents
- **Sufficient Quota** for the required resources (EKS, RDS, networking, storage, etc.)
  :::info Complete Resource List
  For a detailed list of all AWS resources that will be provisioned, refer to the [Infrastructure Deployment](./infrastructure-deployment) section or review the Terraform modules in the deployment repository.
  :::

### DNS and Certificate Requirements

AI/Run CodeMie requires proper DNS and TLS certificate configuration:

- **Route 53 Hosted Zone** with available wildcard DNS configuration
- **Automatic Certificate Management** - AI/Run CodeMie Terraform modules will automatically create:
  - DNS Records in Route 53
  - TLS certificates through AWS Certificate Manager for ALB and NLB

:::tip Automatic Setup
DNS and certificate provisioning is fully automated through Terraform when using AI/Run CodeMie-managed infrastructure. You only need to provide the hosted zone. However, if you're using self-provisioned infrastructure, you will need to handle DNS records and certificates for it.
:::

## Network Requirements

### Outbound Connectivity

Your EKS cluster's Security Groups and Network ACLs must allow **outbound access** to the following endpoints:

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

## EKS Cluster Requirements

### Administrative Permissions

The deployment user must have:

- **EKS Admin permissions** with the ability to create and manage namespaces
- Access to configure cluster-level resources (if deploying to an existing cluster)

### Admission Control and Resource Requirements

If deploying to an **existing EKS cluster**, ensure that admission webhooks allow the creation of the following Kubernetes resources:

<Tabs>
  <TabItem value="nats" label="NATS Messaging" default>
    **Kubernetes API:** `Service` (LoadBalancer type)

    **Purpose:** NATS is a core component of the CodeMie Plugin Engine, providing messaging infrastructure for communication between the [codemie-plugins](https://pypi.org/project/codemie-plugins/) CLI tool with MCP and the AI/Run CodeMie platform.

    The LoadBalancer configuration depends on where the CLI tool will be executed:

    | CLI Tool Execution Location | LoadBalancer Type | Description |
    |----------------|------------------|-------------|
    | Same VPC as EKS | Internal LoadBalancer | Secure, private network communication within the VPC |
    | External to EKS VPC | Public LoadBalancer | Cross-network communication when CLI is run outside the VPC |

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

## AI Model Requirements

### AWS Bedrock Configuration

To use AI models with AI/Run CodeMie, you need:

- **Activated Region** where [AWS Bedrock Models](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html) are available
- **Model Access** for desired LLMs and embeddings models in your AWS account (for example, Claude Sonnet 4.5, AWS Titan, etc)

:::info Mock Configuration Support
AI/Run CodeMie can be deployed with mock LLM configurations initially. Real configurations can be provided later if client-side approvals require additional time.
:::

## Deployment Machine Requirements

### Required Software Tools

The following tools must be pre-installed and properly configured on your deployment machine (laptop, workstation, or VDI instance):

| Tool                                                                                         | Version        | Purpose                                                   |
| -------------------------------------------------------------------------------------------- | -------------- | --------------------------------------------------------- |
| [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) | `1.5.7`        | Infrastructure as Code provisioning                       |
| [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)                                   | Latest stable  | Kubernetes cluster management                             |
| [Helm](https://helm.sh/docs/intro/install/)                                                  | `3.16.0+`      | Kubernetes package management                             |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)     | Latest         | AWS resource management                                   |
| [gcloud CLI](https://cloud.google.com/sdk/docs/install)                                      | Latest         | Authentication to AI/Run CodeMie container registry (GCR) |
| [Docker](https://docs.docker.com/get-started/get-docker/)                                    | Latest stable  | Container operations                                      |
| [natscli](https://github.com/nats-io/natscli#installation)                                   | Latest         | NATS messaging CLI                                        |
| [nsc](https://github.com/nats-io/nsc)                                                        | Latest         | NATS security configuration                               |
| [jq](https://jqlang.org/download/)                                                           | Latest         | JSON processing and parsing                               |
| [curl](https://curl.se/download.html)                                                        | Latest         | HTTP requests and file transfers                          |
| `htpasswd`                                                                                   | System package | Password hash generation                                  |

### Required Repository Access

You will need access to the following repositories to complete the deployment:

- **Terraform IAM Module:** [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)
- **Terraform Platform Module:** [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform)
- **Terraform Remote Backend:** [codemie-terraform-aws-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-remote-backend)
- **Helm Charts:** [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info Air-Gapped Environments
If your deployment machine operates in an isolated environment without direct internet or repository access, the repositories can be provided as ZIP/TAR archives and transferred through approved channels.
:::

## Next Steps

Once all prerequisites are met, proceed to the [Architecture Overview](./architecture) to understand the deployment architecture, or continue directly to [Infrastructure Deployment](./infrastructure-deployment) to begin the installation process.
