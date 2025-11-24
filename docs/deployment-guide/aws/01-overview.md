---
sidebar_position: 1
title: Overview
description: Overview of AI/Run CodeMie deployment on AWS
---

# AI/Run Deployment Guide on AWS

This guide provides step-by-step instructions for deploying the AI/Run CodeMie application to Amazon EKS and related AWS services. By following these instructions, you will:

- Get along with AI/Run CodeMie architecture
- Deploy AWS infrastructure using Terraform
- Configure and deploy all AI/Run CodeMie application components
- Integrate and configure AI models

## How to Use This Guide

For successful deployment, please follow these steps in sequence:

1. First, verify all prerequisites and set up your AWS environment accordingly. Next, deploy the required infrastructure using Terraform.
2. Finally, deploy and configure the AI/Run CodeMie components on EKS cluster.
3. Complete post-installation configuration

Each section contains detailed instructions to ensure a smooth deployment process. The guide is structured to walk you through from initial setup to a fully functional AI/Run CodeMie environment on AWS.

## Deployment Guide Structure

### [Prerequisites](./02-prerequisites.md)

Review all requirements before starting the deployment, including AWS account access, domain configuration, and required tools.

### [Architecture](./03-architecture.md)

Understand the AI/Run CodeMie deployment architecture and resource requirements.

### [Infrastructure Deployment](./infrastructure-deployment/)

Deploy AWS infrastructure using Terraform, including EKS cluster, networking, and supporting services.

### [Components Deployment](./components-deployment/)

Install and configure all AI/Run CodeMie application components on your EKS cluster.

### [Post-Installation Configuration](./post-installation/)

Complete required and optional configuration steps after deployment.

### [AI Models Integration](./ai-models-integration/)

Configure LLM and embedding models from various providers.

### [Update AI/Run CodeMie](./09-update.md)

Learn how to update your AI/Run CodeMie installation.

### [Elasticsearch and Kibana Upgrade](./08-elasticsearch-kibana-upgrade.md)

Upgrade guide for Elasticsearch and Kibana components (8.14.2 → 8.18.4).

### [Extensions](./extensions/)

Optional extensions and additional features you can enable.

### [FAQ](../faq.md)

Frequently asked questions about deployment and configuration.
