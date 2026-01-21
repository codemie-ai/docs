---
id: k8s-components
sidebar_position: 1
title: Kubernetes Components
sidebar_label: Kubernetes Components
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/data-layer
---

import StorageIngressOverview from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-overview.mdx';
import StorageIngressNginx from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-nginx.mdx';
import StorageClassInstallation from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-class-installation.mdx';
import StorageIngressValidation from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-validation.mdx';

<StorageIngressOverview
  storageClassName="AWS gp3"
  clusterName="EKS"
/>

<StorageIngressNginx
  cloudProvider="AWS"
  valuesFileName="values-aws.yaml"
/>

### Step 4: Configure DNS Record

Create a DNS record pointing to the ingress controller's load balancer:

```bash
# Retrieve ingress controller hostname/IP
INGRESS_HOST=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "Ingress Host: ${INGRESS_HOST}"
```

**DNS Configuration Options**:

If using **Route 53**:

```bash
# Get your hosted zone ID
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
  --dns-name example.com \
  --query 'HostedZones[0].Id' \
  --output text | cut -d'/' -f3)

# Create CNAME record
aws route53 change-resource-record-sets \
  --hosted-zone-id ${HOSTED_ZONE_ID} \
  --change-batch '{
    "Changes": [{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "codemie.example.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{"Value": "'${INGRESS_HOST}'"}]
      }
    }]
  }'
```

**Parameters to Adjust**:

- `example.com` - Replace with your domain name
- `codemie.example.com` - Replace with your desired hostname

:::tip DNS Configuration
These values should match what you configured during infrastructure deployment. Check your `deployment_outputs.env` file for the correct domain name.
:::

### Verification

Confirm the DNS record was created:

```bash
# List DNS records in Route 53
aws route53 list-resource-record-sets \
  --hosted-zone-id ${HOSTED_ZONE_ID} \
  --query "ResourceRecordSets[?Name=='codemie.example.com.']"

# Test DNS resolution
nslookup codemie.example.com
```

<StorageClassInstallation
  storageClassName="AWS gp3"
  storageType="Amazon EBS gp3 volumes"
  existingStorageExamples="`gp2` or `gp3`"
  cloudProvider="AWS"
  storageClassFileName="storageclass-aws-gp3.yaml"
/>

<StorageIngressValidation />
