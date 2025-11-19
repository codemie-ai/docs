---
id: kubernetes
title: Kubernetes
sidebar_label: Kubernetes
---

# Kubernetes

Container orchestration platform integration.

AI/Run™ CodeMie can assist you with managing Kubernetes clusters. Generally, you need an **API server endpoint** and **bearer-token** to integrate AI/Run™ CodeMie with your cluster. In our example, we will be using Amazon Web Services (AWS).

To integrate Kubernetes cluster with AI/Run™ CodeMie, follow the steps below:

## 1. Configure AWS EKS Cluster

### 1.1 Access EKS Service

In the AWS search bar, enter **EKS** and click it.

### 1.2 Select Clusters

On the EKS page, select **Clusters**:

![Kubernetes EKS Clusters](./images/kubernetes-eks-clusters.png)

### 1.3 Click Clusters Button

On the EKS page, click the **Clusters** button:

![Kubernetes Select Cluster](./images/kubernetes-select-cluster.png)

### 1.4 Copy API Server Endpoint

Select one of your clusters you want to integrate. Navigate to **Overview > Details** and copy **API server endpoint** (`https://xxxxxxxxxxxxxxxxxxxxxxxxxxxx..xxxxxxxxxx.eks.amazonaws.com`):

![Kubernetes API Endpoint](./images/kubernetes-api-endpoint.png)

## 2. Create Bearer Token

In Kubernetes cluster, use commands below from your terminal to create **bearerToken**:

### 2.1 Create Service Account

Create `codemie` service account:

```bash
cat <<EOF | kubectl apply -n kube-system -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: codemie
  namespace: kube-system
EOF
```

### 2.2 Create ClusterRoleBinding

Create ClusterRoleBinding to grant your `codemie` user with the cluster-admin role:

```bash
cat <<EOF | kubectl apply -n kube-system -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: codemie-crb
subjects:
  - kind: ServiceAccount
    name: codemie
    namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
EOF
```

### 2.3 Create Secret

Create a secret that will store the `codemie` bearer token:

```bash
cat <<EOF | kubectl apply -n kube-system -f -
apiVersion: v1
kind: Secret
metadata:
  name: codemie-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: codemie
type: kubernetes.io/service-account-token
EOF
```

### 2.4 Generate Bearer Token

Run the command below to generate a bearer token for `codemie` user:

```bash
kubectl get -n kube-system secret/codemie-token -o jsonpath='{.data.token}' | base64 --decode
```

### 2.5 Copy Bearer Token

Copy the created **bearerToken**.

## 3. Create Integration in AI/Run™ CodeMie

### 3.1 Navigate to Integrations

In the AI/Run™ CodeMie main menu, click the **Integrations** button.

Select **User or Project** and click **Create**.

### 3.2 Fill in Required Fields

Fill in the required fields and click **Create**:

- **Project Name**: Specify project name.
- **Credential Type**: Kubernetes
- **Alias**: Specify the integration name.
- **Region**: Specify the AWS Region to work in.
- **Kubernetes URL**: Paste the **API server endpoint** data copied from step 1.4.
- **Kubernetes bearer token**: Paste the **codemie-token** data copied from step 2.5.

![Kubernetes Integration Form](./images/kubernetes-integration-form.png)

(Optional) you can "Test Integration" connection before creating.

## 4. Configure Assistant

### 4.1 Enable Kubernetes Integration

Modify your assistant by enabling Kubernetes integration or create a new assistant with this tool:

![Kubernetes Assistant Configuration](./images/kubernetes-assistant-config.png)

## 5. Verify Kubernetes Integration

Verify **Kubernetes** integration by asking assistant a relevant question:

![Kubernetes Verification](./images/kubernetes-verification.png)

Now your assistant can interact with Kubernetes clusters to view and manage containerized applications.
