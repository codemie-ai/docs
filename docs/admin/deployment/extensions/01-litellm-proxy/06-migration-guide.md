---
id: migration-guide
sidebar_label: Migration from DIAL
sidebar_position: 7
title: Appendix - Migration Guide from DIAL to LiteLLM
description: Migrate from deprecated DIAL Proxy to LiteLLM
---

# Appendix: Migration Guide from DIAL to LiteLLM

This guide provides a safe, step-by-step process for migrating from the deprecated DIAL component to LiteLLM without service interruption.

:::info Migration Strategy

We will first deploy and verify a standalone LiteLLM instance. Only after confirming it is operational will we reconfigure the CodeMie API to use the new proxy.

:::

## Migration Steps

### 1. Prepare the PostgreSQL Database

Follow the instructions in [PostgreSQL Database Setup](./postgres-setup).

### 2. Deploy LiteLLM Proxy Standalone

Follow the first three parts of the manual deployment guide to install LiteLLM without connecting it to the CodeMie API yet:

- [Step 5.1: Create Namespace](./deployment/manual-deployment#step-51-create-namespace)
- [Step 5.2: Create Secrets and ConfigMaps](./deployment/manual-deployment#step-52-create-secrets-and-configmaps)
- [Step 5.3: Deploy the LiteLLM Helm Chart](./deployment/manual-deployment#step-53-deploy-the-litellm-helm-chart)

### 3. Verify the Standalone LiteLLM Instance

Before proceeding, use the verification commands from [Step 5.5](./deployment/manual-deployment#step-55-verify-deployment-and-access-ui) to ensure LiteLLM is running correctly and you can access its UI. The dashboard will show no traffic, which is expected.

### 4. Reconfigure and Redeploy the CodeMie API

Now, switch the CodeMie API from DIAL to LiteLLM.

#### 4.1. Create the Integration Secret

Create the integration secret by following the instructions in [Step 5.4.1: Create the Integration Secret](./deployment/manual-deployment#541-create-the-integration-secret).

#### 4.2. Update CodeMie API Configuration

In your `codemie-api/values-<cloud>.yaml`, remove the old DIAL environment variables and ensure the LiteLLM variables (as specified in [Configure Values](./configure-values)) are correctly configured.

```yaml title="Update extraEnv in codemie-api/values-<cloud_name>.yaml"
# In codemie-api/values-<cloud_name>.yaml
extraEnv:
  # ... other existing variables ...

  # 1. REMOVE or COMMENT OUT the old DIAL variables
  # - name: AZURE_OPENAI_URL
  #   value: "http://dial-core.codemie-dial"
  # - name: AZURE_OPENAI_API_KEY
  #   value: "b9bcf6fce0243f2599ef1e7ee4fb9951"

  # 2. ENSURE the new LiteLLM variables are present and configured
  - name: LLM_PROXY_MODE
    value: 'lite_llm'
  - name: LLM_PROXY_ENABLED
    value: 'true'
  - name: LITE_LLM_URL
    value: 'http://litellm.litellm:4000'
  - name: LITE_LLM_TAGS_HEADER_VALUE
    value: 'global'
  - name: LITE_LLM_APP_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-app-key
  - name: LITE_LLM_MASTER_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-master-key
```

#### 4.3. Redeploy the CodeMie API

Redeploy the CodeMie API to apply the changes by following the instructions in [Step 5.4.2: Redeploy the CodeMie API](./deployment/manual-deployment#542-redeploy-the-codemie-api).

### 5. Verify the Full Integration

After the `codemie-api` pod restarts, test the integration by using a feature in the CodeMie UI that makes an LLM call. Check the **Dashboard** in the LiteLLM UI to confirm that new requests are appearing and being processed successfully.

### 6. Deprecate and Remove DIAL

:::warning Destructive Operation

This is a destructive operation. Ensure your platform is fully functional with LiteLLM before proceeding.

:::

Once you have confirmed the integration is stable, you can safely remove the old DIAL components.

```bash
# Uninstall the DIAL Helm release
helm uninstall dial --namespace codemie-dial

# Delete the DIAL namespace and all its resources
kubectl delete namespace codemie-dial

# Delete the old integration secret from the 'codemie' namespace
kubectl delete secret secret-azure-openai-api -n codemie
```

The migration is now complete.

## Next Steps

- Return to [LiteLLM Proxy Overview](./)
- Return to [Extensions Overview](../)
