---
id: core-components
sidebar_position: 6
title: Core Components
description: Install AI/Run CodeMie core components
---

# AI/Run CodeMie Core Installation

## MCP Connect

```bash
helm upgrade --install codemie-mcp-connect-service \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-mcp-connect-service/values.yaml" \
  --wait --timeout 600s
```

## Mermaid Server

```bash
helm upgrade --install mermaid-server \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
  --version x.y.z \
  --namespace "codemie" \
  -f "./mermaid-server/values.yaml" \
  --wait --timeout 600s
```

## CodeMie UI

1. Configure domain in `codemie-ui/values-aws.yaml` (replace `%%DOMAIN%%`)

2. Install:
   ```bash
   helm upgrade --install codemie-ui \
     oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
     --version x.y.z \
     --namespace "codemie" \
     -f "./codemie-ui/values-aws.yaml" \
     --wait --timeout 180s
   ```

## CodeMie API

1. Configure all placeholders in `codemie-api/values-aws.yaml`:
   - `%%DOMAIN%%`
   - `%%AWS_DEFAULT_REGION%%`
   - `%%EKS_AWS_ROLE_ARN%%`
   - `%%AWS_KMS_KEY_ID%%`
   - `%%AWS_S3_BUCKET_NAME%%`
   - `%%AWS_S3_REGION%%`

2. Copy Elasticsearch credentials:

   ```bash
   kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n codemie -f -
   ```

3. Install:
   ```bash
   helm upgrade --install codemie-api \
     oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
     --version x.y.z \
     --namespace "codemie" \
     -f "./codemie-api/values-aws.yaml" \
     --wait --timeout 600s
   ```

Access AI/Run CodeMie at: `https://codemie.<your-domain>`

## Next Steps

Proceed to [Observability](./observability) installation.
