---
id: automated-deployment
sidebar_label: Automated Deployment
sidebar_position: 1
title: Automated Deployment (Recommended)
description: Deploy LiteLLM Proxy automatically using the deployment script
---

# Automated Deployment (Recommended)

The deployment script automates:

- Kubernetes secret creation
- Helm repository configuration
- LiteLLM Proxy deployment
- Integration secret creation for CodeMie

## Pre-Deployment Checklist

Before running the script, ensure you have completed the following configuration steps:

1. **Clone the Repository:** Clone the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository and navigate to its root directory.

2. **Configure API and Proxy Values:** Update both the `codemie-api/values-<cloud>.yaml` and `litellm/values-<cloud_name>.yaml` files with your environment-specific settings as described in [Configure Values](../configure-values).

3. **Configure LLM Models:** Review and customize your desired models and regions in the `litellm/config/litellm-<cloud>-config.yaml` file, as detailed in [Model Configuration](../model-config).

:::warning

Completing all configuration steps mentioned in the checklist is **mandatory** for a successful installation.

:::

## Run the Deployment Script

Once all configurations are in place, execute the following command from the root of the repository. Replace `<cloud_name>` with your target cloud (`aws`, `azure`, or `gcp`) and specify the desired version.

```bash
bash helm-charts.sh --cloud <cloud_name> --version=x.y.z --mode all --optional litellm
```

During execution, the script may prompt you to enter authentication details if you are deploying for Azure or GCP.

## Next Steps

After successful deployment:

- Verify the deployment by checking pod status: `kubectl get pods -n litellm`
- Access the LiteLLM UI using the configured domain
- For migration from DIAL Proxy, see [Migration Guide](../migration-guide)
