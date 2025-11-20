---
id: components-deployment-overview
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

![AI/Run CodeMie Application Stack](../../common/images/application-stack-diagram.drawio.png)

The AI/Run CodeMie deployment includes:

### Core Components

:::info
AI/Run CodeMie latest releases for core components versions can be found by executing following script in the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository for each component.

```bash
bash get-codemie-latest-release-version.sh
bash get-codemie-latest-release-version.sh -c ./path/to/key.json
```

Make sure you logged in with `key.json` shared with you.

:::info
Versions for Docker containers and Helm releases are matching
:::

| Component name                   | Images                                                                                              | Description                                                                                                                                                                                       |
| -------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AI/Run CodeMie API               | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie:x.y.z`                     | The backend service of the AI/Run CodeMie application responsible for business logic, data processing, and API operations                                                                         |
| AI/Run CodeMie UI                | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie-ui:x.y.z`                  | The frontend service of the AI/Run CodeMie application that provides the user interface for interacting with the system                                                                           |
| AI/Run CodeMie Nats Auth Callout | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie-nats-auth-callout:x.y.z`   | Authorization component of AI/Run CodeMie Plugin Engine that handles authentication and authorization for the NATS messaging system                                                               |
| AI/Run CodeMie MCP Connect       | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie-mcp-connect-service:x.y.z` | A lightweight bridge tool that enables cloud-based AI services to communicate with local Model Context Protocol (MCP) servers via protocol translation while maintaining security and flexibility |
| AI/Run Mermaid Server            | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/mermaid-server:x.y.z`              | Implementation of open-source service that generates image URLs for diagrams based on the provided Mermaid code for workflow visualization                                                        |

### Required Third-Party Components

| Component name           | Images                                                                                                                                 | Description                                                                                                                                                                                                      |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ingress Nginx Controller | `registry.k8s.io/ingress-nginx/controller:x.y.z`                                                                                       | Handles external traffic routing to services within the Kubernetes cluster. The AI/Run CodeMie application uses oauth2-proxy, which relies on the Ingress Nginx Controller for proper routing and access control |
| Storage Class            | –                                                                                                                                      | Provides persistent storage capabilities                                                                                                                                                                         |
| Elasticsearch            | `docker.elastic.co/elasticsearch/elasticsearch:x.y.z`                                                                                  | Database component that stores all AI/Run CodeMie data, including datasources, projects, and other application information                                                                                       |
| Kibana                   | `docker.elastic.co/kibana/kibana:x.y.z`                                                                                                | Web-based analytics and visualization platform that provides visualization of the data stored in Elasticsearch. Allows monitoring and analyzing AI/Run CodeMie data                                              |
| Postgres-operator        | `registry.developers.crunchydata.com/crunchydata/postgres-operator:x.y.z`                                                              | Manages PostgreSQL database instances required by other components in the stack. Handles database lifecycle operations                                                                                           |
| Keycloak-operator        | `epamedp/keycloak-operator:x.y.z`                                                                                                      | Manages Keycloak identity and access management instance and it's configuration                                                                                                                                  |
| Keycloak                 | `docker.io/busybox:x.y.z`, `quay.io/keycloak/keycloak:x.y.z`, `registry.developers.crunchydata.com/crunchydata/crunchy-postgres:x.y.z` | Identity and access management solution that provides authentication and authorization capabilities for integration with oauth2-proxy component                                                                  |
| Oauth2-Proxy             | `quay.io/oauth2-proxy/oauth2-proxy:x.y.z`                                                                                              | Authentication middleware that provides secure authentication for the AI/Run CodeMie application by integrating with Keycloak or any other IdP                                                                   |
| NATS                     | `nats:x.y.z`, `natsio/nats-server-config-reloader:x.y.z`                                                                               | Message broker that serves as a crucial component of the AI/Run CodeMie Plugin Engine, facilitating communication between services                                                                               |
| LLM Proxy                | –                                                                                                                                      | Optional proxy component that balances requests to Azure OpenAI language models (LLMs), providing high availability and load distribution                                                                        |
| Fluentbit                | `cr.fluentbit.io/fluent/fluent-bit:x.y.z`                                                                                              | Fluentbit enables logs and metrics collection from AI/Run CodeMie enabling the Agents observability                                                                                                              |

## Deployment Methods

Choose your preferred deployment method:

- **[Scripted Deployment](./components-scripted-deployment)** - Automated deployment using helm-charts.sh script
- **[Manual Deployment](./manual-deployment/)** - Step-by-step manual component installation

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

After successful components deployment, proceed to [Post-Installation Configuration](../post-installation/) to complete required setup steps.
