---
id: update-image-pull-secret
title: Update Image Pull Secret
sidebar_label: Update Image Pull Secret
sidebar_position: 2
pagination_prev: admin/update/codemie-platform/codemie-platform
pagination_next: null
---

# Update Image Pull Secret

The `gcp-artifact-registry` Kubernetes secret stores the credentials used to pull container
images from the AI/Run CodeMie container registry. This secret must be updated whenever the
GCP service account key (`key.json`) is rotated — typically every 90 days.

:::info When to update
Pods stuck in `ImagePullBackOff` or `ErrImagePull` after a routine deployment or update are
a common sign that the image pull secret contains expired credentials.
:::

## Prerequisites

- `kubectl` configured with access to the target Kubernetes cluster (EKS/AKS/GKE)
- Updated `key.json` file obtained from the AI/Run CodeMie support team

## Update the Secret

Delete the existing secret and recreate it with the new credentials.

Replace `<client_email_from_key.json>` with the value of the `client_email` field from the
provided `key.json` file:

```bash
kubectl delete secret gcp-artifact-registry -n codemie
kubectl create secret docker-registry gcp-artifact-registry \
  --docker-server=https://europe-west3-docker.pkg.dev \
  --docker-email=<client_email_from_key.json> \
  --docker-username=_json_key \
  --docker-password="$(cat key.json)" \
  -n codemie
```

## Verify

Confirm the secret exists in the `codemie` namespace:

```bash
kubectl get secret gcp-artifact-registry -n codemie
```

After updating the secret, pods in `ImagePullBackOff` state should recover automatically.
To force an immediate restart:

```bash
kubectl rollout restart deployment -n codemie
```

## Automated Deployment

:::warning
If the platform was originally deployed using automated deployment scripts and those scripts
are still used for platform updates, the `key.json` file in the `codemie-helm-charts`
directory must also be replaced with the new credentials. Without this update, the next scripted platform update will fail with a container registry authorization error when it attempts to pull images using the outdated key.
:::
