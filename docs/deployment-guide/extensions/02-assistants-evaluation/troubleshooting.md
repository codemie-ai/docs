---
id: troubleshooting
title: Troubleshooting
sidebar_label: Troubleshooting
sidebar_position: 7
description: Troubleshooting common Langfuse deployment issues
---

# Troubleshooting

## Common Issues

### 1. PostgreSQL Connection Failed

- Ensure PostgreSQL is running in `codemie` namespace
- Check PostgreSQL pod name and connectivity
- Verify PostgreSQL service name

### 2. Helm Deployment Failed

- Review `values.yaml` configuration
- Check resource availability in cluster
- Verify Helm chart version compatibility
- Ensure domain placeholders are replaced

### 3. Errors in LangFuse components

- Check that resource limits are appropriate
- Follow system requirements outlined in this document or in the official [guide](https://langfuse.com/self-hosting/infrastructure/containers)

### 4. ClickHouse runs out of resources

- Make sure that ClickHouse pods have at least 8 Gb of memory
- Follow LangFuse [scaling](https://langfuse.com/self-hosting/scaling) recommendations

## Recovery

If deployment fails:

### 1. Clean up resources

```bash
# Remove namespace
kubectl delete namespace langfuse

# Delete langfuse-integration secret
kubectl -n codemie delete secret langfuse-integration

# Reset postgresql database instance
# Connect to the "postgres" database first, if not already connected
psql -U postgres

# -- Revoke schema and database privileges
REVOKE ALL ON SCHEMA public FROM langfuse_admin;
REVOKE ALL ON DATABASE postgres FROM langfuse_admin;

# -- Drop the user
DROP USER langfuse_admin;

# -- Drop the database
DROP DATABASE IF EXISTS postgres_langfuse;
```

### 2. Fix configuration issues

Review and update your configuration files based on the error messages.

### 3. Re-run deployment

Choose one of the following:

- **Automated**: `./deploy-langfuse.sh`
- **Manual**: Follow manual steps again
