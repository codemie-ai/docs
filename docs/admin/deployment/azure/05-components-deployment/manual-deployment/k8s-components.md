---
id: k8s-components
sidebar_position: 1
title: Kubernetes Components
sidebar_label: Kubernetes Components
pagination_prev: admin/deployment/azure/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/azure/components-deployment/manual-deployment/data-layer
---

import StorageIngressOverview from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-overview.mdx';
import StorageIngressNginx from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-nginx.mdx';
import StorageClassInstallation from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-class-installation.mdx';
import StorageIngressValidation from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-validation.mdx';

<StorageIngressOverview
  storageClassName="Azure Storage Class"
  clusterName="AKS"
/>

<StorageIngressNginx
  cloudProvider="Azure"
  valuesFileName="values-azure.yaml"
/>

### Step 4: Configure DNS Record

Create an A record in your Azure Private DNS zone pointing to the ingress controller's load balancer IP:

```bash
# Retrieve ingress controller IP
ingressip=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Ingress IP: ${ingressip}"

# Create A record (adjust parameters to match your environment)
az network private-dns record-set a add-record \
  -g CodeMieRG \
  -z example.com \
  -n codemie \
  -a ${ingressip}
```

**Parameters to Adjust**:

- `-g CodeMieRG` - Replace with your resource group name
- `-z example.com` - Replace with your Private DNS zone name
- `-n codemie` - Replace with your desired hostname (subdomain)

:::tip DNS Configuration
These values should match what you configured during infrastructure deployment. Check your `deployment_outputs.env` file for the correct DNS zone and resource group names.
:::

### Verification

Confirm the DNS record was created:

```bash
# List DNS records
az network private-dns record-set a list \
  -g CodeMieRG \
  -z example.com \
  -o table

# Test DNS resolution (from within VNet or via VPN)
nslookup codemie.example.com
```

<StorageClassInstallation
  storageClassName="Azure Storage Class"
  storageType="Azure Disk volumes"
  existingStorageExamples="`managed-premium` or similar"
  cloudProvider="Azure"
  storageClassFileName="storageclass-azure.yaml"
/>

<StorageIngressValidation />
