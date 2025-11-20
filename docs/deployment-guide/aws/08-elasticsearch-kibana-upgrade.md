---
id: elasticsearch-kibana-upgrade
sidebar_position: 8.5
title: Elasticsearch and Kibana Upgrade
description: Upgrade Elasticsearch and Kibana from 8.14.2 to 8.18.4
---

# Elasticsearch and Kibana Upgrade Guide (8.14.2 → 8.18.4)

:::warning IMPORTANT
Create a backup before starting the upgrade process!
:::

This page will guide your journey from 8.14.2 Elasticsearch/Kibana to 8.18.4

## Pre-Upgrade Requirements

**Before proceeding with any upgrade, ensure you have:**

- ✅ Created a complete backup of your Elasticsearch data
- ✅ Planned for potential downtime
- ✅ Tested the upgrade process in a non-production environment

## Elasticsearch Upgrade (8.14.2 → 8.18.4)

Steps to Upgrade Elasticsearch:

1. **Backup Your Data** ⚠️

   Ensure you have a backup of your Elasticsearch data before proceeding with the upgrade.

2. **Update the codemie-helm-charts repo**

   Pull the latest version from the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository.

3. **Update the Elasticsearch Helm Chart Release**

   Use the following command to upgrade Elasticsearch:

   ```bash
   helm upgrade --install elastic elasticsearch/. -n elastic --values elasticsearch/values-<cloud_name>.yaml --wait --timeout 900s --dependency-update
   ```

## Kibana Upgrade (8.14.2 → 8.18.4)

Steps to Upgrade Kibana:

1. **Update the Helm Chart**

   Pull the latest version of the values file for Kibana.

2. **Create `kibana-encryption-keys` Kubernetes secret** (if not already created)

   Use the following command to create the secret:

   ```bash
   kubectl create secret generic "kibana-encryption-keys" \
     --namespace="elastic" \
     --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
     --type=Opaque
   ```

3. **Delete the existing Kibana token secret**

   Use the following command to delete the existing secret:

   ```bash
   kubectl -n elastic delete secret kibana-kibana-es-token
   ```

4. **Remove old Chart.lock and tgz files**

5. **Upgrade the Kibana Helm Chart Release**

   Use the following command to upgrade Kibana:

   ```bash
   helm upgrade --install kibana kibana/. -n elastic --values kibana/values-<cloud_name>.yaml --wait --timeout 900s --dependency-update
   ```

## Recommended Upgrade Order

1. **Elasticsearch first** - Always upgrade Elasticsearch before Kibana
2. **Kibana second** - Upgrade Kibana after Elasticsearch is successfully upgraded and running

## Post-Upgrade Verification

After completing both upgrades:

- Verify Elasticsearch cluster health
- Check Kibana accessibility and functionality
- Validate data integrity
- Test critical dashboards and searches

## Troubleshooting

If you encounter issues during the upgrade:

1. Check pod logs for error messages
2. Verify resource availability (CPU, memory, storage)
3. Ensure network connectivity between components
4. Consult the official Elasticsearch/Kibana upgrade documentation

## Next Steps

- [Extensions](./extensions/) - Explore optional extensions
