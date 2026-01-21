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
import NetworkRequirements from '../common/deployment/02-prerequisites/\_network-requirements.mdx';
import ClusterRequirements from '../common/deployment/02-prerequisites/\_cluster-requirements.mdx';
import DeploymentMachineTools from '../common/deployment/02-prerequisites/\_deployment-machine-tools.mdx';
import NextSteps from '../common/deployment/02-prerequisites/\_next-steps.mdx';

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

## Network Requirements

### DNS and Certificate Requirements

AI/Run CodeMie requires proper DNS and TLS certificate configuration:

- **Route 53 Hosted Zone** with available wildcard DNS configuration
- **Automatic Certificate Management** - AI/Run CodeMie Terraform modules will automatically create:
  - DNS Records in Route 53
  - TLS certificates through AWS Certificate Manager for ALB and NLB

:::tip Automatic Setup
DNS and certificate provisioning is fully automated through Terraform when using AI/Run CodeMie-managed infrastructure. You only need to provide the hosted zone. However, if you're using self-provisioned infrastructure, you will need to handle DNS records and certificates for it.
:::

<NetworkRequirements clusterName="EKS" networkSecurityName="Security Groups and Network ACLs" natGatewayName="NAT Gateway" />

<ClusterRequirements clusterName="EKS" networkName="VPC" />

<DeploymentMachineTools />

**Cloud-Specific Tools:**

| Tool                                                                                     | Version | Purpose                 |
| ---------------------------------------------------------------------------------------- | ------- | ----------------------- |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | latest  | AWS resource management |

### Required Repository Access

You will need access to the following repositories to complete the deployment:

- **Terraform IAM Module:** [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)
- **Terraform Platform Module:** [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform)
- **Terraform Remote Backend:** [codemie-terraform-aws-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-remote-backend)
- **Helm Charts:** [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

:::info Air-Gapped Environments
If your deployment machine operates in an isolated environment without direct internet or repository access, the repositories can be provided as ZIP/TAR archives and transferred through approved channels.
:::

<NextSteps />
