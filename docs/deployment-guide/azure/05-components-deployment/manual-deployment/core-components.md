---
id: core-components
sidebar_position: 5
title: Core Components
sidebar_label: Core Components
---

# AI/Run CodeMie Core Components Installation

## Install AI/Run CodeMie MCP Connect Component

Install `mcp-connect` helm chart with the command:

```bash
helm upgrade --install codemie-mcp-connect-service oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-mcp-connect-service/values.yaml" \
--wait --timeout 600s
```

## Install AI/Run Mermaid Server Component

Install mermaid-server helm chart with the command:

```bash
helm upgrade --install mermaid-server oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
--version x.y.z \
--namespace "codemie" \
-f "./mermaid-server/values.yaml" \
--wait --timeout 600s
```

## Install AI/Run CodeMie UI Component

1. Fill in missing values in values.yaml file in `codemie-helm-charts/codemie-ui`.

2. Install `codemie-ui` helm chart in created namespace, applying custom values file with the command:

   ```bash
   helm upgrade --install codemie-ui oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
   --version x.y.z \
   --namespace "codemie" \
   -f "./codemie-ui/values-azure.yaml" \
   --wait --timeout 180s
   ```

3. Deploy AI/Run CodeMie API component.

## Install AI/Run CodeMie API Component

1. Fill in missing values in values.yaml file in `codemie-helm-charts/codemie-api`:
   1. Replace `%%DOMAIN%%` with your domain name, e.g. `example.com`
   2. Replace `codemie.private.lab.com` with your host name

2. Copy Elasticsearch credentials to the application namespace with the command:

   ```bash
   kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n codemie -f -
   ```

3. Install `codemie-api` helm chart, applying custom values file with the command:

   ```bash
   helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
   --version x.y.z \
   --namespace "codemie" \
   -f "./codemie-api/values-azure.yaml" \
   --wait --timeout 600s
   ```

4. AI/Run CodeMie UI can be accessed by the following URL: `http://codemie.private.lab.com`, e.g. `https://codemie.example.com`

## Next Steps

Optionally proceed to [Observability](./observability) installation, or complete the deployment by going to [Post-Installation Configuration](../../post-installation).
