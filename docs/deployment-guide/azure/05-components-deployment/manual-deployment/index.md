---
id: manual-deployment-overview
sidebar_position: 2
title: Manual Deployment Overview
description: Overview of manual component installation process
---

# Manual AI/Run CodeMie Components Installation

Use this instruction to manually install AI/Run CodeMie by each component.

:::info
Manual steps are not mandatory when `helm-charts.sh` automated script was chosen.
:::

## Component Installation Order

This guide covers installation of the following components in order:

1. **[Storage and Ingress](./storage-and-ingress)** (if needed)
   - Azure Storage Class
   - Nginx Ingress Controller

2. **[Data Layer](./data-layer)**
   - Elasticsearch
   - Kibana
   - Postgres-operator
   - PostgreSQL

3. **[Security and Identity](./security-and-identity)**
   - Keycloak-operator
   - Keycloak
   - OAuth2 Proxy

4. **[Plugin Engine](./plugin-engine)**
   - NATS
   - NATS Auth Callout

5. **[AI/Run CodeMie Core](./core-components)**
   - CodeMie API
   - CodeMie UI
   - MCP Connect
   - Mermaid Server

6. **[Observability](./observability)** (optional)
   - Fluentbit
   - Kibana Dashboards

## Prerequisites Setup

### Container Registry Access

Before deploying AI/Run CodeMie components, set up pull secrets:

1. Obtain `key.json` file from AI/Run CodeMie team

2. Create the `codemie` namespace:

   ```bash
   kubectl create namespace codemie
   ```

3. Configure the secret. Replace `%%PROJECT_NAME%%` with your project name:

   ```bash
   kubectl create secret docker-registry gcp-artifact-registry \
     --docker-server=https://europe-west3-docker.pkg.dev \
     --docker-email=gsa-%%PROJECT_NAME%%-to-gcr@or2-msq-epmd-edp-anthos-t1iylu.iam.gserviceaccount.com \
     --docker-username=_json_key \
     --docker-password="$(cat key.json)" \
     -n codemie
   ```

4. Reference the secret in deployments:
   ```yaml
   imagePullSecrets:
     - name: gcp-artifact-registry
   ```

### Container Registry Login

Login to AI/Run CodeMie container registry:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev
```

## Next Steps

Follow the installation guide in the order listed above, starting with [Storage and Ingress](./storage-and-ingress).
