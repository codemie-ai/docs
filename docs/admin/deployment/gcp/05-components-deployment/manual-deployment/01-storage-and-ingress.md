---
id: storage-and-ingress
sidebar_position: 1
title: Storage and Ingress
sidebar_label: Storage and Ingress
---

import StorageIngressOverview from '../../../common/deployment/05-components-deployment/manual-deployment/\_storage-ingress-overview.mdx';
import StorageIngressNginx from '../../../common/deployment/05-components-deployment/manual-deployment/\_storage-ingress-nginx.mdx';
import StorageClassInstallation from '../../../common/deployment/05-components-deployment/manual-deployment/\_storage-class-installation.mdx';
import StorageIngressValidation from '../../../common/deployment/05-components-deployment/manual-deployment/\_storage-ingress-validation.mdx';

<StorageIngressOverview
  storageClassName="GCP Storage Class"
  clusterName="GKE"
/>

<StorageIngressNginx
  cloudName="gcp"
  cloudProvider="GCP"
/>

<StorageClassInstallation
  storageClassName="GCP Storage Class"
  storageType="GCP Persistent Disks"
  existingStorageExamples="`standard-rwo` or similar"
  cloudProvider="GCP"
  storageClassFileName="storageclass-gcp-pd-balanced.yaml"
/>

<StorageIngressValidation />
