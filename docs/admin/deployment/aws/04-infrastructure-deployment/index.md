---
id: infrastructure-deployment-overview
title: AWS Infrastructure Deployment
sidebar_label: Infrastructure Deployment
sidebar_position: 4
pagination_prev: admin/deployment/aws/architecture
pagination_next: admin/deployment/aws/infrastructure-deployment/infrastructure-scripted-deployment
---

# AWS Infrastructure Deployment

This section guides you through deploying the AWS infrastructure foundation required for AI/Run CodeMie using Terraform automation.

:::info Existing Infrastructure
If you already have a provisioned EKS cluster with all required AWS services (networking, storage, databases, etc.), you can skip this section and proceed directly to [Components Deployment](../components-deployment).
:::

## Overview

The Terraform deployment is organized into three distinct phases, each with its own set of resources and purpose:

1. **IAM Deployer Role** - Privileged role for executing Terraform operations
2. **Terraform State Backend** - Infrastructure for storing Terraform state files securely
3. **Core Platform Infrastructure** - Main AWS resources for running AI/Run CodeMie

:::note Important
The deployment uses a registered domain name in AWS Route 53, which allows Terraform to automatically create SSL/TLS certificates via AWS Certificate Manager for the Application Load Balancer (ALB) and Network Load Balancer (NLB).
:::

## Phase 1: IAM Deployer Role

The IAM deployer role is created first to provide necessary permissions for all subsequent infrastructure operations.

| Resource           | Purpose                                                              |
| ------------------ | -------------------------------------------------------------------- |
| **IAM Role**       | Deployer role with permissions to create and manage AWS resources    |
| **IAM Policies**   | Granular permission policies for EKS, networking, storage, databases |
| **Trust Policies** | Trust relationships allowing specific principals to assume the role  |

:::tip IAM Role Purpose
The IAM deployer role enables:

- **Least Privilege**: Scoped permissions for infrastructure operations only
- **Separation of Duties**: Dedicated role for infrastructure deployment
- **Auditability**: CloudTrail logging of all actions performed by the role
- **Consistency**: Same permissions across different deployment environments
  :::

## Phase 2: Terraform State Backend

The state backend is deployed to provide secure, centralized storage for Terraform state files.

| Resource            | Purpose                                                     |
| ------------------- | ----------------------------------------------------------- |
| **S3 Bucket**       | Storage for Terraform state files with versioning enabled   |
| **DynamoDB Table**  | State locking mechanism to prevent concurrent modifications |
| **Bucket Policies** | Access control policies for state file security             |
| **Encryption**      | Server-side encryption for state files at rest              |

:::tip State Backend Purpose
The Terraform state backend enables:

- **Team Collaboration**: Multiple engineers can work on infrastructure simultaneously
- **State Locking**: Prevents concurrent modifications that could corrupt state
- **Versioning**: Maintains history of infrastructure changes
- **Security**: State files contain sensitive data and require secure storage
  :::

## Phase 3: Core Platform Infrastructure

The core platform infrastructure provisions all AWS resources needed to run AI/Run CodeMie. This is the main deployment phase and following AWS resources will be deployed:

### Compute & Orchestration

| Resource                | Purpose                                                         |
| ----------------------- | --------------------------------------------------------------- |
| **EKS Cluster**         | Managed Kubernetes cluster for running AI/Run CodeMie workloads |
| **Managed Node Groups** | Auto-scaling node groups for application workloads              |
| **Launch Templates**    | EC2 instance configurations for node groups                     |

### Networking

| Resource                      | Purpose                                                             |
| ----------------------------- | ------------------------------------------------------------------- |
| **VPC**                       | Isolated virtual network for AI/Run CodeMie resources               |
| **Public Subnets**            | Subnets for load balancers and NAT gateways                         |
| **Private Subnets**           | Subnets for EKS nodes and pods (application workloads)              |
| **Database Subnets**          | Isolated subnets for RDS PostgreSQL instances                       |
| **Internet Gateway**          | Enables internet connectivity for public subnets                    |
| **NAT Gateway**               | Provides consistent outbound public IP for private subnet resources |
| **Route Tables**              | Controls routing between subnets and internet                       |
| **Application Load Balancer** | Distributes incoming HTTPS traffic to application services          |
| **Network Load Balancer**     | Handles TCP traffic for NATS messaging system                       |
| **Route 53 DNS Records**      | Automated DNS record creation for CodeMie services                  |
| **Network Security Groups**   | Firewall rules controlling traffic flow                             |

### Data & Storage

| Resource             | Purpose                                                       |
| -------------------- | ------------------------------------------------------------- |
| **RDS PostgreSQL**   | Managed database service for CodeMie application data         |
| **RDS Subnet Group** | Database subnet group for multi-AZ deployment                 |
| **S3 Bucket**        | Persistent storage for CodeMie application data and artifacts |
| **EBS Volumes**      | Block storage for Kubernetes persistent volumes               |

### Security & Identity

| Resource                    | Purpose                                                         |
| --------------------------- | --------------------------------------------------------------- |
| **AWS Certificate Manager** | Automated SSL/TLS certificates for ALB and NLB                  |
| **KMS Key**                 | Encryption key for S3 bucket and other encrypted resources      |
| **IAM Roles for EKS**       | Service roles for EKS cluster and node groups                   |
| **IAM Roles for Workloads** | IRSA (IAM Roles for Service Accounts) for pod-level permissions |
| **Security Groups**         | Network access control lists for EKS, RDS, load balancers       |
| **Secrets Manager**         | Optional secret storage for database credentials                |

### Optional Features

| Resource                    | Purpose                                              |
| --------------------------- | ---------------------------------------------------- |
| **Internal ALB**            | Private load balancer for internal-only access       |
| **Private DNS Hosted Zone** | Private Route 53 zone for internal service discovery |
| **VPC Endpoints**           | Private connectivity to AWS services (S3, ECR, etc.) |

## Next Steps

Proceed to the next step to deploy the infrastructure:

- [**Scripted Deployment** →](./infrastructure-scripted-deployment) - Recommended automated deployment using Terraform wrapper scripts
- [**Manual Deployment** →](./infrastructure-manual-deployment) - Advanced option for custom scenarios with manual Terraform control

:::note Deployment Method Selection

- **Scripted Deployment**: Handles prerequisites, validation, and orchestration automatically (recommended for most users)
- **Manual Deployment**: Provides full control over Terraform operations for advanced customization
  :::
