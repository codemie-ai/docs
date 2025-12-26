---
id: infrastructure-deployment-overview
sidebar_position: 4
title: Infrastructure Deployment
description: Deploy AWS infrastructure for AI/Run CodeMie
---

# AWS Infrastructure Deployment

## Overview

:::info
Skip if you have ready EKS cluster with all required services (see [AI/Run CodeMie Architecture](../architecture)).
:::

This section describes the process of deploying the AI/Run CodeMie infrastructure within an AWS environment. Terraform is used to manage resources and configure services.

:::note Important
A crucial step involves using a registered domain name added to AWS Route 53, which allows Terraform to automatically create SSL/TLS certificates via AWS Certificate Manager. These certificates are essential for securing traffic handled by the Application Load Balancer (ALB) and Network Load Balancer (NLB).
:::

There are two deployment options available:

- **[Scripted Deployment](./infrastructure-scripted-deployment)** - Use the script if you want an easier deployment flow
- **[Manual Deployment](./infrastructure-manual-deployment)** - Use the manual option if you want to control Terraform resources and provide customization

## Deployment Resources

The deployment provisions all required AWS infrastructure components described in the [Architecture](../architecture#infrastructure-components) section using the following Terraform modules:

| #   | Resource name      | Source                                                                                            |
| --- | ------------------ | ------------------------------------------------------------------------------------------------- |
| 1   | IAM deployer role  | [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)           |
| 2   | Main AWS resources | [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform) |

## Next Steps

Choose your deployment method:

- [Scripted Deployment →](./infrastructure-scripted-deployment)
- [Manual Deployment →](./infrastructure-manual-deployment)
