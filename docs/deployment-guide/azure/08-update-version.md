---
id: update-version
sidebar_position: 9
title: Update AI/Run CodeMie
description: Update procedures for AI/Run CodeMie components
---

# Update AI/Run CodeMie

## Overview

This guide describes the process of updating AI/Run CodeMie components to newer versions.

## Prerequisites

- Access to the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository
- `kubectl` access to your EKS cluster
- Helm 3.16.0+ installed
- Backup of critical data (recommended)
- `codemie-helm-charts` repo is up to date with values used during initial deployment

:::info GCR Login Required
Before updating AI/Run CodeMie components, login to AI/Run CodeMie GCR:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev
```

:::

## Update Methods

### Scripted Update

Use the automated script for updates:

```bash
bash helm-charts.sh --cloud azure --version x.y.z --mode update
```

The `--mode update` flag updates AI/Run CodeMie core components in the following order:

1. CodeMie MCP Connect
2. Mermaid Server
3. CodeMie NATS Auth Callout
4. CodeMie UI
5. CodeMie API

### Manual Component Update

1. Update `codemie-mcp-connect-service` helm chart with the command. Replace `--version "x.y.z"` with your target version, for example `--version "2.2.5"`:

   ```bash
   helm upgrade --install codemie-mcp-connect-service oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
   --version x.y.z \
   --namespace "codemie" \
   -f "./codemie-mcp-connect-service/values.yaml" \
   --wait --timeout 600s
   ```

2. Update `mermaid-server` component. Replace `--version "x.y.z"` with your target version, for example `--version "2.2.5"`:

   ```bash
   helm upgrade --install mermaid-server oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
   --version x.y.z \
   --namespace "codemie" \
   -f "./mermaid-server/values.yaml" \
   --wait --timeout 600s
   ```

3. Update `codemie-nats-auth-callout` first. Replace `--version "x.y.z"` with your target version, for example `--version "2.2.5"`:

   ```bash
   helm upgrade --install codemie-nats-auth-callout \
   "oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout" \
   --version "x.y.z" \
   --namespace "codemie" \
   -f "./codemie-nats-auth-callout/values-azure.yaml" \
   --wait --timeout 600s
   ```

4. Update `codemie-ui` then. Replace `--version "x.y.z"` with your target version, for example `--version "2.2.5"`:

   ```bash
   helm upgrade --install codemie-ui oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
   --version x.y.z \
   --namespace "codemie" \
   -f "./codemie-ui/values-azure.yaml" \
   --wait --timeout 180s
   ```

5. Lastly update `codemie-api` component. Replace `--version "x.y.z"` with your target version, for example `--version "2.2.5"`:

   ```bash
   helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
   --version x.y.z \
   --namespace "codemie" \
   -f "./codemie-api/values-azure.yaml" \
   --wait --timeout 600s
   ```

6. Verify all pods are up and running.

## Next Steps

- [Extensions](../extensions/) - Explore optional extensions
