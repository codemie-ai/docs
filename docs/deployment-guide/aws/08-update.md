---
sidebar_position: 8
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

## Update Methods

### Scripted Update

Use the automated script for updates:

```bash
bash helm-charts.sh --cloud aws --version x.y.z --mode update
```

The `--mode update` flag will update only AI/Run CodeMie core components:

- CodeMie API
- CodeMie UI
- CodeMie NATS Auth Callout
- CodeMie MCP Connect
- Mermaid Server

### Manual Component Update

To update individual components manually:

```bash
helm upgrade codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version x.y.z \
  --namespace codemie \
  -f ./codemie-api/values-aws.yaml
```

Repeat for other components as needed.

## Update Order

Follow this order when updating components:

1. **Third-party components** (if needed)
   - Elasticsearch
   - Kibana
   - Postgres-operator
   - Keycloak-operator

2. **AI/Run CodeMie core components**
   - CodeMie API
   - CodeMie UI
   - NATS Auth Callout
   - MCP Connect
   - Mermaid Server

## Elasticsearch and Kibana Update

:::warning Important Update Order
Always upgrade Elasticsearch before Kibana to maintain compatibility.
:::

### Recommended Upgrade Order

1. **Elasticsearch First**

   ```bash
   helm upgrade elastic elasticsearch/. \
     -n elastic \
     --values elasticsearch/values-aws.yaml
   ```

2. **Kibana Second**
   ```bash
   helm upgrade kibana kibana/. \
     -n elastic \
     --values kibana/values-aws.yaml
   ```

### Post-Upgrade Verification

After completing upgrades:

- Verify Elasticsearch cluster health
- Check Kibana accessibility and functionality
- Validate data integrity
- Test critical dashboards and searches

## Rollback Procedure

If issues occur during update:

```bash
# List release history
helm history codemie-api -n codemie

# Rollback to previous version
helm rollback codemie-api [REVISION] -n codemie
```

## Troubleshooting Updates

### Issue: Pod fails to start after update

**Solutions:**

- Check pod logs: `kubectl logs <pod-name> -n codemie`
- Verify resource availability
- Ensure ConfigMaps and Secrets are up to date
- Review breaking changes in release notes

### Issue: Database migration fails

**Solutions:**

- Check CodeMie API logs for migration errors
- Verify database connectivity
- Ensure database user has required permissions
- Restore from backup if needed

### Issue: Incompatible component versions

**Solutions:**

- Review compatibility matrix in release notes
- Update dependent components first
- Use scripted update to ensure version compatibility

## Verification Steps

After update:

1. Check all pods are running:

   ```bash
   kubectl get pods -n codemie
   ```

2. Verify services are accessible:
   - AI/Run CodeMie UI
   - AI/Run CodeMie API
   - Keycloak
   - Kibana

3. Test core functionality:
   - User authentication
   - Project access
   - Assistant creation
   - Model interaction

4. Review logs for errors:
   ```bash
   kubectl logs -f deployment/codemie -n codemie
   ```

## Next Steps

- [Extensions](./09-extensions.md) - Explore optional extensions
- [FAQ](../faq.md) - Common questions and troubleshooting
