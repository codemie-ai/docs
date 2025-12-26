---
id: components-deployment-overview
sidebar_position: 5
title: AI/Run CodeMie Components Deployment
sidebar_label: CodeMie Components Deployment
---

# AI/Run CodeMie Components Deployment

## Overview

This section guides you through deploying the AI/Run CodeMie application stack on your AKS cluster. After completing infrastructure deployment, this phase installs all necessary Kubernetes components including:

- **Core AI/Run CodeMie services** (API, UI, MCP Connect, NATS Auth)
- **Data layer** (Elasticsearch, PostgreSQL via operators)
- **Security & Identity** (Keycloak, OAuth2 Proxy)
- **Infrastructure services** (Ingress controller, storage)
- **Observability** (Kibana, Fluent Bit)
- **Optional LLM Proxy** (for load balancing AI model requests)

The deployment uses Helm charts to install and configure all components in the correct order, ensuring proper dependencies and integration.

:::info Prerequisites
This phase assumes you have completed [Infrastructure Deployment](../infrastructure-deployment/) and have a running AKS cluster with network, storage, and security configured.
:::

## Prerequisites

### Cluster Readiness

Ensure your AKS cluster is ready for component deployment:

- [x] **Infrastructure Deployed**: Completed [Infrastructure Deployment](../infrastructure-deployment/) phase
- [x] **Cluster Access**: kubectl configured and authenticated to AKS cluster
- [x] **Jumpbox Access**: Connected to Jumpbox VM via Azure Bastion (for deployment)

### Required Components

The following components will be installed during this phase if not already present:

- **Nginx Ingress Controller**: Routes external traffic to services
- **Azure Storage Class**: Provides persistent storage for stateful components

:::tip Automated Installation
If your cluster doesn't have these components, don't worry. The deployment scripts and manual guides include steps to install them automatically.
:::

### Repository and Access {#repository-and-access}

- **Helm Charts Repository**: Clone [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository
- **Container Registry Credentials**: Request `key.json` access credentials from the AI/Run CodeMie team for GCR authentication

## Application Stack Components

The AI/Run CodeMie application consists of multiple integrated components organized into functional categories:

![Application Stack](../../common/images/application-stack-diagram.drawio.png)

### Component Categories

#### Core AI/Run CodeMie Services

Proprietary services that provide the main AI/Run CodeMie functionality:

| Component             | Container Registry                                                  | Description                                                                           |
| --------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| **CodeMie API**       | `europe-west3-docker.pkg.dev/.../codemie:x.y.z`                     | Backend service handling business logic, data processing, and API operations          |
| **CodeMie UI**        | `europe-west3-docker.pkg.dev/.../codemie-ui:x.y.z`                  | Frontend web application providing the user interface                                 |
| **NATS Auth Callout** | `europe-west3-docker.pkg.dev/.../codemie-nats-auth-callout:x.y.z`   | Authentication and authorization service for NATS messaging (Plugin Engine component) |
| **MCP Connect**       | `europe-west3-docker.pkg.dev/.../codemie-mcp-connect-service:x.y.z` | Bridge enabling CodeMie to communicate with MCP servers                               |
| **Mermaid Server**    | `europe-west3-docker.pkg.dev/.../mermaid-server:x.y.z`              | Diagram generation service for visualization in chats                                 |

:::info Version Information
To find the latest release versions for CodeMie components:

```bash
# Clone the helm charts repository
git clone git@gitbud.epam.com:epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts

# Check latest versions (requires GCR authentication)
bash get-codemie-latest-release-version.sh -c /path/to/key.json
```

**Note**: Docker container versions match Helm chart release versions.
:::

#### Data Layer

Database and search components for data persistence:

| Component               | Container Registry                                                | Description                                                                        |
| ----------------------- | ----------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| **Elasticsearch**       | `docker.elastic.co/elasticsearch/elasticsearch:x.y.z`             | Primary data store for AI/Run CodeMie (datasources, projects, conversations, etc.) |
| **Kibana**              | `docker.elastic.co/kibana/kibana:x.y.z`                           | Analytics and visualization interface for Elasticsearch data                       |
| **PostgreSQL Operator** | `registry.developers.crunchydata.com/.../postgres-operator:x.y.z` | Manages PostgreSQL instances for Keycloak                                          |

#### Security & Identity Management

Authentication and authorization components:

| Component             | Container Registry                        | Description                                                                 |
| --------------------- | ----------------------------------------- | --------------------------------------------------------------------------- |
| **Keycloak Operator** | `epamedp/keycloak-operator:x.y.z`         | Manages Keycloak deployment and configuration                               |
| **Keycloak**          | `quay.io/keycloak/keycloak:x.y.z`         | Identity and access management (IAM) solution providing SSO, authentication |
| **OAuth2 Proxy**      | `quay.io/oauth2-proxy/oauth2-proxy:x.y.z` | Authentication middleware integrating with Keycloak for secure access       |

#### Infrastructure Services

Essential Kubernetes infrastructure components:

| Component                    | Container Registry                               | Description                                         |
| ---------------------------- | ------------------------------------------------ | --------------------------------------------------- |
| **Nginx Ingress Controller** | `registry.k8s.io/ingress-nginx/controller:x.y.z` | Routes external traffic to internal services        |
| **Storage Class**            | Azure CSI Driver                                 | Provides persistent volumes for stateful components |

#### Messaging & Integration

Message broker for Plugin Engine:

| Component | Container Registry | Description                                                       |
| --------- | ------------------ | ----------------------------------------------------------------- |
| **NATS**  | `nats:x.y.z`       | High-performance messaging system for Plugin Engine communication |

#### Observability

Logging and monitoring components:

| Component      | Container Registry                        | Description                                            |
| -------------- | ----------------------------------------- | ------------------------------------------------------ |
| **Fluent Bit** | `cr.fluentbit.io/fluent/fluent-bit:x.y.z` | Lightweight log collector enabling agent observability |

#### Optional Components

Components that can be omitted based on configuration:

| Component     | Container Registry | Description                                                                                     |
| ------------- | ------------------ | ----------------------------------------------------------------------------------------------- |
| **LLM Proxy** | –                  | Optional proxy for load balancing and high availability of AI model requests and usage insights |

### Deployment Dependencies

Components must be deployed in the following order due to dependencies:

1. **Infrastructure** → Ingress Controller, Storage Class
2. **Operators** → PostgreSQL Operator, Keycloak Operator
3. **Data Layer** → Elasticsearch, PostgreSQL instances
4. **Security** → Keycloak, OAuth2 Proxy
5. **Messaging** → NATS
6. **Core Services** → CodeMie API, UI, MCP Connect, NATS Auth
7. **Observability** → Fluent Bit, Kibana
8. **Optional** → LLM Proxy (if needed)

## Deployment Methods

Two deployment approaches are available depending on your needs:

### Scripted Deployment (Recommended)

Automated deployment using the `helm-charts.sh` wrapper script:

- **Best for**: Standard deployments, quick setup, production environments
- **Advantages**: Automated dependency ordering, validation checks, consistent configuration
- **Duration**: ~20-30 minutes (depending on component count)

[→ Scripted Deployment Guide](./components-scripted-deployment)

### Manual Deployment

Step-by-step manual installation of each component:

- **Best for**: Custom configurations, learning the stack, troubleshooting
- **Advantages**: Full control over each component, easier to debug issues
- **Duration**: ~1-2 hours (depending on familiarity)

[→ Manual Deployment Guide](./manual-deployment/)

:::tip Recommendation
Use **Scripted Deployment** for initial installations. Switch to manual deployment only if you need custom configurations or are troubleshooting specific issues.
:::

## Accessing Applications

Once deployment is complete and validated, access the AI/Run CodeMie applications:

### Application URLs

Replace `<your-domain>` with your configured domain name (from infrastructure deployment):

| Application        | URL                                                     | Description                      |
| ------------------ | ------------------------------------------------------- | -------------------------------- |
| **CodeMie UI**     | `http(s)://codemie.<your-domain>`                       | Main user interface              |
| **CodeMie API**    | `http(s)://codemie.<your-domain>/code-assistant-api/v1` | REST API endpoint                |
| **Keycloak Admin** | `http(s)://codemie.<your-domain>/keycloak/admin`        | Identity management console      |
| **Kibana**         | `http(s)://codemie.<your-domain>/kibana`                | Data visualization and analytics |

:::info Protocol and Domain

- **HTTP vs HTTPS**: Private clusters typically use HTTP. Public deployments should use HTTPS with valid TLS certificates.
- **Domain Name**: Configured during infrastructure deployment (`CODEMIE_DOMAIN_NAME` in `deployment_outputs.env`)
- **Private DNS**: If using private DNS, ensure your client machine can resolve the domain (VPN or internal network required)
  :::
