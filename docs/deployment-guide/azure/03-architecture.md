---
id: architecture
title: AI/Run CodeMie Deployment Architecture
sidebar_label: Architecture
sidebar_position: 3
---

import ContainerResources from '../common/03-architecture/\_container-resources.mdx';

# AI/Run CodeMie Deployment Architecture

This page provides an overview of the AI/Run CodeMie deployment architecture on Microsoft Azure, including infrastructure components, network design, and resource requirements.

## Architecture Overview

AI/Run CodeMie is deployed on Azure Kubernetes Service (AKS) with supporting Azure services for networking, storage, and identity management.

### High-Level Architecture Diagram

The diagram below illustrates the complete AI/Run CodeMie infrastructure deployment on Azure:

![Azure Architecture Diagram](./images/architecture-diagram.drawio.png)

:::tip Architecture Customization
The architecture can be customized based on your organization's security policies, compliance requirements, and operational preferences. Consult with your deployment team to discuss specific requirements.
:::

## Resource Requirements

<ContainerResources />

## Next Steps

After understanding the architecture, proceed to:

- [Infrastructure Deployment](./infrastructure-deployment) - Deploy the Azure infrastructure using Terraform
- [Components Deployment](./components-deployment) - Deploy AI/Run CodeMie application components using Helm
