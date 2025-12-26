---
id: storage-and-ingress
sidebar_position: 2
title: Storage and Ingress
description: Install storage class and ingress controller
---

# Storage and Ingress Setup

## AWS gp3 Storage Class

Install only if your EKS cluster does not have AWS gp3 storage class:

```bash
kubectl apply -f storage-class/storageclass-aws-gp3.yaml
```

## Nginx Ingress Controller

Install only if your EKS cluster does not have Nginx Ingress Controller:

1. Create namespace:

   ```bash
   kubectl create namespace ingress-nginx
   ```

2. Install Nginx Ingress:
   ```bash
   helm upgrade --install ingress-nginx ingress-nginx/. \
     -n ingress-nginx \
     --values ingress-nginx/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

## Next Steps

Proceed to [Data Layer](./data-layer) installation.
