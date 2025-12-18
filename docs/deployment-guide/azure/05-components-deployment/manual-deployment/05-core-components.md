---
id: core-components
sidebar_position: 5
title: Core Components
sidebar_label: Core Components
pagination_next: deployment-guide/azure/components-deployment/manual-deployment/observability
---

# Core Components Installation

This guide covers the installation of the main AI/Run CodeMie application components that provide the core functionality of the platform.

## Overview

The core components consist of four services:

- **MCP Connect** - Model Context Protocol connector enabling integration with AI Assistants and MCP servers
- **Mermaid Server** - Diagram rendering service for visualizing workflows and diagrams
- **CodeMie UI** - Frontend web application providing the user interface
- **CodeMie API** - Backend REST API handling business logic, data processing, and AI orchestration

## MCP Connect Installation

MCP Connect implements the Model Context Protocol, enabling CodeMie to integrate with AI models and external tooling.

### Install MCP Connect Helm Chart

Deploy MCP Connect:

```bash
helm upgrade --install codemie-mcp-connect-service \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
  --version x.y.z \
  --namespace codemie \
  -f ./codemie-mcp-connect-service/values.yaml \
  --wait \
  --timeout 600s
```

**Command Breakdown**:

- `codemie-mcp-connect-service` - Release name
- `--version x.y.z` - Replace with your CodeMie version
- `--namespace codemie` - Deploys to codemie namespace
- `-f ./codemie-mcp-connect-service/values.yaml` - Uses component configuration

:::tip Version Number
Use the same version number you retrieved in the [Getting Started](../manual-deployment-overview#step-4-get-latest-codemie-version) section.
:::

### Verify MCP Connect Deployment

Check that MCP Connect is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep mcp-connect

# Check deployment
kubectl get deployment -n codemie codemie-mcp-connect-service

# Check logs
kubectl logs -n codemie deployment/codemie-mcp-connect-service --tail=50
```

Expected output:

- Pod should be in `Running` state
- Deployment should show ready replicas
- Logs should indicate successful startup

## Mermaid Server Installation

Mermaid Server provides diagram rendering capabilities for visualizing workflows, architecture diagrams, and process flows.

### Install Mermaid Server Helm Chart

Deploy Mermaid Server:

```bash
helm upgrade --install mermaid-server \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
  --version x.y.z \
  --namespace codemie \
  -f ./mermaid-server/values.yaml \
  --wait \
  --timeout 600s
```

**Command Breakdown**:

- `mermaid-server` - Release name
- `--version x.y.z` - Replace with your CodeMie version
- `--namespace codemie` - Deploys to codemie namespace
- `-f ./mermaid-server/values.yaml` - Uses component configuration

### Verify Mermaid Server Deployment

Check that Mermaid Server is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep mermaid-server

# Check deployment
kubectl get deployment -n codemie mermaid-server

# Check logs
kubectl logs -n codemie deployment/mermaid-server --tail=50
```

Expected output:

- Pod should be in `Running` state
- Deployment should show ready replicas
- Logs should indicate successful HTTP server startup

## CodeMie UI Installation

CodeMie UI provides the web-based user interface for interacting with AI assistants and managing workflows.

### Step 1: Configure UI Values

The domain configuration should already be set from the [Getting Started](../manual-deployment-overview#step-2-configure-domain-name) section. Verify the values in `codemie-ui/values-azure.yaml` are correct.

### Step 2: Install CodeMie UI Helm Chart

Deploy CodeMie UI:

```bash
helm upgrade --install codemie-ui \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
  --version x.y.z \
  --namespace codemie \
  -f ./codemie-ui/values-azure.yaml \
  --wait \
  --timeout 180s
```

**Command Breakdown**:

- `codemie-ui` - Release name
- `--version x.y.z` - Replace with your CodeMie version
- `--namespace codemie` - Deploys to codemie namespace
- `-f ./codemie-ui/values-azure.yaml` - Uses Azure-specific configuration

### Step 3: Verify CodeMie UI Deployment

Check that CodeMie UI is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep codemie-ui

# Check deployment
kubectl get deployment -n codemie codemie-ui

# Check service
kubectl get service -n codemie codemie-ui
```

Expected output:

- Pod should be in `Running` state
- Deployment should show ready replicas
- Service should be available

## CodeMie API Installation

CodeMie API is the backend service that handles all business logic, AI orchestration, and data processing.

### Step 1: Configure API Values

The domain configuration should already be set from the [Getting Started](../manual-deployment-overview#step-2-configure-domain-name) section. Verify the values in `codemie-api/values-azure.yaml` are correct:

- `%%DOMAIN%%` should be replaced with your domain (e.g., `example.com`)
- `codemie.private.lab.com` should be replaced with your full hostname (e.g., `codemie.example.com`)

:::tip Domain Configuration
If you followed the [Getting Started](../manual-deployment-overview#step-2-configure-domain-name) steps, these replacements should already be done.
:::

### Step 2: Copy Elasticsearch Credentials

CodeMie API needs access to Elasticsearch. Copy the credentials to the codemie namespace:

```bash
kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | \
  sed '/namespace:/d' | \
  kubectl apply -n codemie -f -
```

**Command Breakdown**:

- `kubectl get secret ... -o yaml` - Exports secret as YAML from elastic namespace
- `sed '/namespace:/d'` - Removes namespace field to allow cross-namespace copy
- `kubectl apply -n codemie -f -` - Applies to codemie namespace

### Step 3: Install CodeMie API Helm Chart

Deploy CodeMie API:

```bash
helm upgrade --install codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version x.y.z \
  --namespace codemie \
  -f ./codemie-api/values-azure.yaml \
  --wait \
  --timeout 600s
```

**Command Breakdown**:

- `codemie-api` - Release name
- Chart name is `codemie` (the main backend chart)
- `--version x.y.z` - Replace with your CodeMie version
- `--namespace codemie` - Deploys to codemie namespace
- `-f ./codemie-api/values-azure.yaml` - Uses Azure-specific configuration

### Step 4: Verify CodeMie API Deployment

Check that CodeMie API is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep codemie-api

# Check deployment
kubectl get deployment -n codemie codemie-api

# Check logs
kubectl logs -n codemie deployment/codemie-api --tail=100

# Check API health endpoint
kubectl exec -n codemie deployment/codemie-api -- curl -s http://localhost:8080/health
```

Expected output:

- Pod should be in `Running` state
- Deployment should show ready replicas
- Logs should show successful connections to all dependencies
- Health endpoint should return healthy status

## Access CodeMie Application

Once all core components are deployed, access the CodeMie UI:

```
https://<your-domain>
```

**Example URLs**:

- `https://codemie.private.lab.com` (default domain)
- `https://codemie.example.com` (custom domain)

:::warning User Creation Required
You'll be redirected to Keycloak for authentication, but no users exist yet. You must complete the [Post-Installation Configuration](../../post-installation) guide to create users before you can log in to the application.
:::

## Post-Installation Validation

After completing all core component installations, verify the following:

```bash
# All core components are running
kubectl get pods -n codemie | grep -E "(mcp-connect|mermaid|codemie-ui|codemie-api)"

# Check all deployments
kubectl get deployments -n codemie

# Check all services
kubectl get services -n codemie

# Verify ingress is configured
kubectl get ingress -n codemie

# Check overall namespace status
kubectl get all -n codemie
```

All checks should return successful results before proceeding.

## Next Steps

Once core components are deployed and verified, proceed to **[Observability](./observability)** installation to deploy logging and monitoring infrastructure.
