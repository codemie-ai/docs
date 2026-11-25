---
id: elasticsearch-kibana-upgrade
sidebar_position: 8
title: Elasticsearch and Kibana Upgrade
description: Upgrade Elasticsearch and Kibana to a newer version
pagination_next: null
pagination_prev: admin/update/3rd-party-components/elasticsearch/elasticsearch
---

# Elasticsearch and Kibana Upgrade Guide

:::warning IMPORTANT
Create a backup before starting the upgrade process!
:::

The steps are the same for every version. The target version is set by `imageTag` in the Helm values files of the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository. Check the [release notes](../../release-notes/release-notes.md) for the version your CodeMie release ships.

## Pre-Upgrade Requirements

- A complete backup of your Elasticsearch data.
- A maintenance window. With two master-eligible nodes (the default on AWS), the cluster has no elected master while the nodes restart, so Elasticsearch, Kibana and log ingestion are unavailable until both nodes are back.
- The upgrade tested in a non-production environment.
- A green cluster before you start:

  ```bash
  ES_USER=$(kubectl -n elastic get secret elasticsearch-master-credentials -o jsonpath='{.data.username}' | base64 -d)
  ES_PASS=$(kubectl -n elastic get secret elasticsearch-master-credentials -o jsonpath='{.data.password}' | base64 -d)
  kubectl -n elastic exec elasticsearch-master-0 -c elasticsearch -- \
    curl -sk -u "$ES_USER:$ES_PASS" 'https://localhost:9200/_cluster/health?pretty'
  ```

  Expect `"status" : "green"` and `"unassigned_shards" : 0`.

## Upgrade Order

1. **Elasticsearch first**
2. **Kibana second**, only after Elasticsearch is back and green. Kibana cannot authenticate to a cluster that is down.

If you deploy through ArgoCD, pause auto-sync on the `kibana` application until Elasticsearch is green.

## Elasticsearch Upgrade

1. **Backup Your Data** ⚠️

   Ensure you have a backup of your Elasticsearch data before proceeding with the upgrade.

2. **Update the codemie-helm-charts repo**

   Pull the latest version from the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository.

3. **Update the Elasticsearch Helm Chart Release**

   ```bash
   helm upgrade --install elastic elasticsearch/. -n elastic --values elasticsearch/values-<cloud_name>.yaml --wait --timeout 900s --dependency-update
   ```

4. **Wait for a green cluster**

   Both `elasticsearch-master-*` pods must be `Running` and ready on the new image. Re-run the health check from the pre-upgrade requirements and confirm every node reports the new version:

   ```bash
   kubectl -n elastic exec elasticsearch-master-0 -c elasticsearch -- \
     curl -sk -u "$ES_USER:$ES_PASS" 'https://localhost:9200/_cat/nodes?v&h=name,version,master'
   ```

## Kibana Upgrade

1. **Update the Helm Chart**

   Pull the latest version of the values file for Kibana.

2. **Create `kibana-encryption-keys` Kubernetes secret** (if not already created)

   ```bash
   kubectl create secret generic "kibana-encryption-keys" \
     --namespace="elastic" \
     --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
     --type=Opaque
   ```

3. **Delete the existing Kibana token secret**

   This step is required. The pre-install hook creates a new token secret and fails if the old one still exists.

   ```bash
   kubectl -n elastic delete secret kibana-kibana-es-token
   ```

4. **Remove old Chart.lock and tgz files**

   Delete `kibana/Chart.lock` and the packaged chart archive in `kibana/charts/` so `--dependency-update` fetches the current chart.

5. **Upgrade the Kibana Helm Chart Release**

   ```bash
   helm upgrade --install kibana kibana/. -n elastic --values kibana/values-<cloud_name>.yaml --wait --timeout 900s --dependency-update
   ```

## Post-Upgrade Verification

- Elasticsearch cluster health is green and all nodes run the new version
- Kibana is accessible and running the new version
- Data is intact
- Critical dashboards and searches work

## Troubleshooting

| Symptom                                                                                  | Cause                                                               | Fix                                                                                                             |
| ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `master_not_discovered_exception` (HTTP 503)                                             | The first node restarted while the second is still down.            | Wait for the second node to become ready. Do not restart the first node.                                        |
| `elasticsearch-master-1` stays `Pending` with `FailedAttachVolume: Waiting for detach`   | On AWS, the EBS volume is still attached to the previous node.      | Wait. It recovers on its own. Do not delete the PVC or the volume.                                              |
| `pre-install-kibana-kibana-*` pods in `Error`, or the ArgoCD app waiting on the hook Job | The old `kibana-kibana-es-token` secret was not deleted (HTTP 409). | Delete the secret, then delete the failed `pre-install-kibana-kibana` Job and its pods, and re-run the upgrade. |

For anything else, check pod logs, resource availability (CPU, memory, storage) and network connectivity between components, then consult the official Elasticsearch and Kibana upgrade documentation.
