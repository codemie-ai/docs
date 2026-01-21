---
id: k8s-components
sidebar_position: 1
title: Kubernetes Components
sidebar_label: Kubernetes Components
---

import StorageIngressOverview from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-overview.mdx';
import StorageIngressNginx from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-nginx.mdx';
import StorageClassInstallation from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-class-installation.mdx';
import StorageIngressValidation from '../../../common/deployment/05-components-deployment/manual-deployment/k8s/\_storage-ingress-validation.mdx';

<StorageIngressOverview
  storageClassName="GCP Storage Class"
  clusterName="GKE"
/>

<StorageIngressNginx
  cloudProvider="GCP"
  valuesFileName="values-gcp.yaml"
/>

<StorageClassInstallation
  storageClassName="GCP Storage Class"
  storageType="GCP Persistent Disks"
  existingStorageExamples="`standard-rwo` or similar"
  cloudProvider="GCP"
  storageClassFileName="storageclass-gcp-pd-balanced.yaml"
/>

<StorageIngressValidation />
