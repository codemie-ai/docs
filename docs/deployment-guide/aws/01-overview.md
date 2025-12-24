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

Each section contains detailed instructions to ensure a smooth deployment process. The guide is structured to walk you through from initial setup to a fully functional AI/Run CodeMie environment on AWS.

## Deployment Guide Structure

### [Prerequisites](./prerequisites)

Review all requirements before starting the deployment, including AWS account access, domain configuration, and required tools.

### [Architecture](./architecture)

Understand the AI/Run CodeMie deployment architecture and resource requirements.

### [Infrastructure Deployment](./infrastructure-deployment)

Deploy AWS infrastructure using Terraform, including EKS cluster, networking, and supporting services.

### [Components Deployment](./components-deployment)

Install and configure all AI/Run CodeMie application components on your EKS cluster.

### [AI Models Integration](./ai-models-integration)

Configure LLM and embedding models from various providers.

### [Update AI/Run CodeMie](../update/codemie/update-version)

Learn how to update your AI/Run CodeMie installation.

### [Extensions](../extensions)

Optional extensions and additional features you can enable.

### [FAQ](../faq)

Frequently asked questions about deployment and configuration.
