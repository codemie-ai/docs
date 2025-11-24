---
id: components-scripted-deployment
sidebar_position: 1
title: Scripted Deployment
sidebar_label: Scripted Deployment
---

# Scripted AI/Run CodeMie Components Installation

The `helm-charts.sh` script (codemie-helm-charts repository) automates the deployment of components using Helm charts. It follows the steps described in the official documentation for deploying with Helm.

## Prerequisites

- Make sure AKS cluster has installed:
  - Nginx Ingress Controller
  - AKS Storage Class

:::info
Step-by-step installation examples are available in the "Nginx Ingress Controller" and "AKS Storage Class" subsections under the "Manual AI/Run CodeMie Components Installation" section.
:::

- Ensure you have [Helm](https://helm.sh/docs/intro/install/) installed and configured.
- Ensure that the required cloud provider CLI tools and credentials are set up (e.g., Azure CLI, Google Cloud SDK).
- The script assumes that you are familiar with basic Helm chart deployment and the underlying cloud environment.

## Script Parameters

The script requires exactly three input parameters to control its behavior:

1. **Cloud Provider**
   The target cloud provider where the deployment should be executed.
   **Allowed Values:**
   - `aws`
   - `azure`
   - `gcp`

2. **AI/Run Version**
   The version of the AI/Run components to deploy. Format should follow semantic versioning, for example:
   - `x.y.z`

3. **Mode Name**
   Specifies which components are to be installed.
   **Allowed Values:**
   - `all` - Installs both AI/Run components and the third-party components.
   - `recommended` - Installs both AI/Run components and the third-party components except of Nginx Ingress Controller
   - `update` - updates only AI/Run CodeMie core components

## Component-specific placeholders

| Component    | Placeholder               | Description                | Example               | File to edit                                          |
| ------------ | ------------------------- | -------------------------- | --------------------- | ----------------------------------------------------- |
| Kibana       | `codemie.private.lab.com` | Your public/private host   | `codemie.example.com` | `codemie-helm-charts/kibana/values-azure.yaml`        |
| Keycloak     | `codemie.private.lab.com` | Your public/private host   | `codemie.example.com` | `codemie-helm-charts/keycloak-helm/values-azure.yaml` |
| OAuth2 Proxy | `codemie.private.lab.com` | Your public/private host   | `codemie.example.com` | `codemie-helm-charts/oauth2-proxy/values-azure.yaml`  |
| CodeMie UI   | `codemie.private.lab.com` | Your public/private host   | `codemie.example.com` | `codemie-helm-charts/codemie-ui/values-azure.yaml`    |
| CodeMie API  | `codemie.private.lab.com` | Your public/private host   | `codemie.example.com` | `codemie-helm-charts/codemie-api/values-azure.yaml`   |
| CodeMie API  | `%%DOMAIN%%`              | Your public/private domain | `example.com`         | `codemie-helm-charts/codemie-api/values-azure.yaml`   |

## Usage

Below is example demonstrating how to run the script:

**Example: Deploy AI/Run CodeMie + Third-Party Components**

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev

bash helm-charts.sh --cloud azure --version x.y.z --mode all
```

## Next Steps

After successful deployment, proceed to [Post-Installation Configuration](../post-installation) to complete required setup steps.
