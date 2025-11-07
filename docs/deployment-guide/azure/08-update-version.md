---
id: update-version
title: Update AI/Run CodeMie Version
sidebar_label: Update Version
sidebar_position: 8
---

# Update AI/Run CodeMie Version

To keep your environment up to date, it's recommended to regularly update it with new AI/Run CodeMie releases.

:::info
AI/Run CodeMie releases can be found here: [https://codemie.lab.epam.com/#/release-notes](https://codemie.lab.epam.com/#/release-notes)
:::

## For 0.x.x AI/Run CodeMie Versions

It's sufficient to update the following components:

| Component name                   | Images                                                                                              | Description                                                                                                                                                                                       |
| -------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AI/Run CodeMie API               | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie:x.y.z`                     | The backend service of the AI/Run CodeMie application responsible for business logic, data processing, and API operations                                                                         |
| AI/Run CodeMie UI                | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie-ui:x.y.z`                  | The frontend service of the AI/Run CodeMie application that provides the user interface for interacting with the system                                                                           |
| AI/Run СodeMie Nats Auth Callout | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie-nats-auth-callout:x.y.z`   | Authorization component of AI/Run CodeMie Plugin Engine that handles authentication and authorization for the NATS messaging system                                                               |
| AI/Run CodeMie MCP Connect       | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/codemie-mcp-connect-service:x.y.z` | A lightweight bridge tool that enables cloud-based AI services to communicate with local Model Context Protocol (MCP) servers via protocol translation while maintaining security and flexibility |
| AI/Run Mermaid Server            | `europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/prod/mermaid-server:x.y.z`              | Implementation of open-source service that generates image URLs for diagrams based on the provided Mermaid code for workflow visualization                                                        |

## Manual Update

:::info
Before applying `codemie-nats-auth-callout`, `codemie-ui`, `codemie`, `mermaid-server` and `codemie-mcp-connect-service` helm-charts it's necessary to login into AI/Run CodeMie GCR:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev
```

:::

1. Make sure your `codemie-helm-charts` repo is up to date and with values you used during initial deployment.

2. Update `codemie-nats-auth-callout` first. Replace `--version "x.y.z"` with your target version, for example `--version "0.26.0"`:

```bash
helm upgrade --install codemie-nats-auth-callout \
"oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout" \
--version "x.y.z" \
--namespace "codemie" \
-f "./codemie-nats-auth-callout/values-azure.yaml" \
--wait --timeout 600s
```

3. Update `codemie-mcp-connect-service` helm chart:

```bash
helm upgrade --install codemie-mcp-connect-service oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-mcp-connect-service/values.yaml" \
--wait --timeout 600s
```

4. Update `codemie-ui`:

```bash
helm upgrade --install codemie-ui oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-ui/values-azure.yaml" \
--wait --timeout 180s
```

5. Update `codemie-api` component:

```bash
helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-azure.yaml" \
--wait --timeout 600s
```

6. Lastly update `mermaid-server` component:

```bash
helm upgrade --install mermaid-server oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
--version x.y.z \
--namespace "codemie" \
-f "./mermaid-server/values.yaml" \
--wait --timeout 600s
```

7. Verify all pods are up and running.

## Scripted Update

1. Make sure your `codemie-helm-charts` repo is up to date and with values you used during initial deployment.

2. Before applying helm-charts, login into AI/Run CodeMie GCR:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev
```

3. To update your CodeMie components, run the following command:

```bash
bash helm-charts.sh cloud=azure version=x.y.z mode=minimal
```

:::info
The `minimal` mode is recommended for safer updates as it focuses only on the core AI/Run components (`codemie-nats-auth-callout`, `codemie-ui`, `codemie`, `mermaid-server` and `codemie-mcp-connect-service`) while leaving third-party services untouched.
:::

## Elasticsearch and Kibana Upgrade Guide (8.14.2 → 8.18.4)

:::warning IMPORTANT
Create a backup before starting the upgrade process!
:::

This page will guide your journey from 8.14.2 Elasticsearch/Kibana to 8.18.4

### Pre-Upgrade Requirements

**Before proceeding with any upgrade, ensure you have:**

- ✅ Created a complete backup of your Elasticsearch data
- ✅ Planned for potential downtime
- ✅ Tested the upgrade process in a non-production environment

### Elasticsearch Upgrade (8.14.2 → 8.18.4)

Steps to Upgrade Elasticsearch:

1. **Backup Your Data** ⚠️ - Ensure you have a backup of your Elasticsearch data before proceeding with the upgrade.

2. **Update the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repo** - Pull the latest version

3. **Update the Elasticsearch Helm Chart Release** - Use the following command to upgrade Elasticsearch:

```bash
helm upgrade --install elastic elasticsearch/. -n elastic --values elasticsearch/values-<cloud_name>.yaml --wait --timeout 900s --dependency-update
```

### Kibana Upgrade (8.14.2 → 8.18.4)

Steps to Upgrade Kibana:

1. **Update the Helm Chart** - Pull the latest version of the values file for Kibana.

2. **Create `kibana-encryption-keys` Kubernetes secret** (if not already created):

```bash
kubectl create secret generic "kibana-encryption-keys" \
      --namespace="elastic" \
      --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
      --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
      --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
      --type=Opaque
```

3. **Delete the existing Kibana token secret**:

```bash
kubectl -n elastic delete secret kibana-kibana-es-token
```

4. **Remove old Chart.lock and tgz files**

5. **Upgrade the Kibana Helm Chart Release**:

```bash
helm upgrade --install kibana kibana/. -n elastic --values kibana/values-<cloud_name>.yaml --wait --timeout 900s --dependency-update
```

### Recommended Upgrade Order

1. **Elasticsearch first** - Always upgrade Elasticsearch before Kibana
2. **Kibana second** - Upgrade Kibana after Elasticsearch is successfully upgraded and running

### Post-Upgrade Verification

After completing both upgrades:

- Verify Elasticsearch cluster health
- Check Kibana accessibility and functionality
- Validate data integrity
- Test critical dashboards and searches

### Troubleshooting

If you encounter issues during the upgrade:

1. Check pod logs for error messages
2. Verify resource availability (CPU, memory, storage)
3. Ensure network connectivity between components
4. Consult the official Elasticsearch/Kibana upgrade documentation
