---
sidebar_position: 4
title: Infrastructure Deployment
description: Deploy AWS infrastructure for AI/Run CodeMie
---

# AWS Infrastructure Deployment

## Overview

:::info
Skip if you have ready EKS cluster with all required services (see [AI/Run CodeMie Architecture](../03-architecture.md)).
:::

This section describes the process of deploying the AI/Run CodeMie infrastructure within an AWS environment. Terraform is used to manage resources and configure services.

:::note Important
A crucial step involves using a registered domain name added to AWS Route 53, which allows Terraform to automatically create SSL/TLS certificates via AWS Certificate Manager. These certificates are essential for securing traffic handled by the Application Load Balancer (ALB) and Network Load Balancer (NLB).
:::

There are two deployment options available:

- **[Scripted Deployment](./scripted-deployment.md)** - Use the script if you want an easier deployment flow
- **[Manual Deployment](./manual-deployment.md)** - Use the manual option if you want to control Terraform resources and provide customization

## Deployment Resources

The deployment process creates the following resources in order:

| #   | Resource name      | Source                                                                                            |
| --- | ------------------ | ------------------------------------------------------------------------------------------------- |
| 1   | IAM deployer role  | [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)           |
| 2   | Main AWS resources | [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform) |

### Main AWS Resources

The deployment creates:

- **EKS Cluster** - Managed Kubernetes environment
- **AWS ASGs** - Auto Scaling Groups for the EKS Cluster
- **AWS ALB & AWS NLB** - Load balancers for HTTP/HTTPS and TCP traffic
- **AWS KMS key** - For encrypting and decrypting sensitive data
- **AWS IAM Roles** - Access to AWS KMS and Bedrock services
- **AWS IAM role ExternalSecretOperator** - For use with AWS Systems Manager
- **AWS RDS Postgres** - Managed PostgreSQL database
- **Internal AWS ALB** (Optional) - Private DNS hosted zone for private network connections

## Next Steps

Choose your deployment method:

- [Scripted Deployment →](./scripted-deployment.md)
- [Manual Deployment →](./manual-deployment.md)
