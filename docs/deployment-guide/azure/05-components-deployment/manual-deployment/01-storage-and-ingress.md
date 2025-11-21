---
id: storage-and-ingress
sidebar_position: 1
title: Storage and Ingress
sidebar_label: Storage and Ingress
---

# Storage and Ingress Installation

## Install Ingress NGINX Controller

1. Create Kubernetes namespace, e.g. `ingress-nginx` with the command:

   ```bash
   kubectl create namespace ingress-nginx
   ```

2. Install `ingress-nginx` helm chart in created namespace:

   ```bash
   helm upgrade --install ingress-nginx ingress-nginx/. -n ingress-nginx --values ingress-nginx/values-azure.yaml --wait --timeout 900s --dependency-update
   ```

3. Create A record in the Private DNS:

   ```bash
   ingressip=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   az network private-dns record-set a add-record \
    -g CodeMieRG \
    -z private.lab.com \
    -n codemie \
    -a ${ingressip}
   ```

## Azure Storage Class

Install only in case if your AKS cluster does not have Azure storage class:

```bash
kubectl apply -f storage-class/storageclass-azure.yaml
```

## Next Steps

Proceed to [Data Layer](./data-layer) installation.
