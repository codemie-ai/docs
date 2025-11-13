---
sidebar_position: 5
title: Components Deployment
description: Deploy AI/Run CodeMie components on EKS
---

# AI/Run CodeMie Components Deployment

## Overview

This section describes the process of deploying the main AI/Run CodeMie components to the AWS EKS cluster.

:::info
For infrastructure deployment details, refer to the [Infrastructure Deployment](../infrastructure-deployment/) section.
:::

## Prerequisites

1. Obtain kubeconfig for created cluster:

   ```bash
   aws eks update-kubeconfig --region <REGION> --name <PLATFORM_NAME>
   ```

2. Ensure EKS cluster has installed:
   - Nginx Ingress Controller
   - AWS gp3 storage class

:::info
If your EKS cluster does not have these components, the detailed instructions are provided in the Manual Components Installation section.
:::

3. Clone the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository

4. Set up pull secrets for container registry access. For detailed instructions, see [Container Registry Access](./manual-deployment#container-registry-access).

## Application Stack Overview

![AI/Run CodeMie Application Stack](../images/application-stack-diagram.svg)

The AI/Run CodeMie deployment includes:

### Core Components

- **AI/Run CodeMie API** - Backend service for business logic and API operations
- **AI/Run CodeMie UI** - Frontend user interface
- **AI/Run CodeMie NATS Auth Callout** - Authorization for NATS messaging
- **AI/Run CodeMie MCP Connect** - Bridge for Model Context Protocol servers
- **Mermaid Server** - Diagram generation service

### Required Third-Party Components

- **Nginx Ingress Controller** - Traffic routing
- **Storage Class** - Persistent storage
- **Elasticsearch** - Data storage
- **Kibana** - Analytics and visualization
- **Postgres-operator** - Database management
- **Keycloak-operator** - Identity management operator
- **Keycloak** - Authentication and authorization
- **OAuth2-Proxy** - Authentication middleware
- **NATS** - Message broker
- **Fluentbit** - Log collection

## Deployment Methods

Choose your preferred deployment method:

- **[Scripted Deployment](./scripted-deployment.md)** - Automated deployment using helm-charts.sh script
- **[Manual Deployment](./manual-deployment.md)** - Step-by-step manual component installation

## Finalizing Installation

After component deployment, you should have access to:

| Component          | URL Pattern                                           |
| ------------------ | ----------------------------------------------------- |
| AI/Run CodeMie UI  | `https://codemie.<your-domain>`                       |
| AI/Run CodeMie API | `https://codemie.<your-domain>/code-assistant-api/v1` |
| Keycloak UI        | `https://keycloak.<your-domain>/auth/admin`           |
| Kibana             | `https://kibana.<your-domain>`                        |

:::info
Some components may be missing depending on your setup configuration or use `http` protocol in private clusters.
:::

## Next Steps

After successful components deployment, proceed to [Post-Installation Configuration](../06-post-installation.md) to complete required setup steps.
