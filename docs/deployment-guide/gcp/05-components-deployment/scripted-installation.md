---
id: components-scripted-installation
title: Scripted Components Installation
sidebar_label: Scripted Installation
sidebar_position: 1
---

# Scripted AI/Run CodeMie Components Installation

The `helm-charts.sh` script ([codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository) automates the deployment of components using Helm charts.

## Prerequisites

- Make sure GKE cluster has installed:
  - Nginx Ingress Controller
  - GKE Storage Class

:::info
Use `all` script mode to install them, or step-by-step installation examples are available in the "Nginx Ingress Controller" and "GKE Storage Class" subsections under the "Manual AI/Run CodeMie Components Installation" section.
:::

- Ensure you have [Helm](https://helm.sh/docs/intro/install/) installed and configured
- Ensure that the required cloud provider CLI tools and credentials are set up (e.g., Google Cloud SDK)
- The script assumes that you are familiar with basic Helm chart deployment and the underlying cloud environment

## Script Parameters

The script requires exactly three input parameters to control its behavior:

### 1. Cloud Provider

The target cloud provider where the deployment should be executed.

**Allowed Values:**

- `aws`
- `azure`
- `gcp`

### 2. AI/Run Version

The version of the AI/Run components to deploy. Format should follow semantic versioning, for example:

- `x.y.z`

### 3. Mode Name

Specifies which components are to be installed.

**Allowed Values:**

- `all` – installs both AI/Run CodeMie components and 3rd-party components. Use for fresh installation on an empty cluster
- `recommended` – installs both AI/Run components and the third-party components except Nginx Ingress Controller
- `update` – when you want to update AI/Run CodeMie core components version

## Component-Specific Placeholders

:::info
Fill these values before running installation script.
:::

| Component    | Placeholder / Env variable  | Description                                                                                                                                                                       | Example           | File to edit                                        |
| ------------ | --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | --------------------------------------------------- |
| Kibana       | `%%DOMAIN%%`                | Your public domain                                                                                                                                                                | `example.com`     | `codemie-helm-charts/kibana/values-gcp.yaml`        |
| Keycloak     | `%%DOMAIN%%`                | Your public domain                                                                                                                                                                | `example.com`     | `codemie-helm-charts/keycloak-helm/values-gcp.yaml` |
| OAuth2 Proxy | `%%DOMAIN%%`                | Your public domain                                                                                                                                                                | `example.com`     | `codemie-helm-charts/oauth2-proxy/values-gcp.yaml`  |
| CodeMie UI   | `%%DOMAIN%%`                | Your public domain                                                                                                                                                                | `example.com`     | `codemie-helm-charts/codemie-ui/values-gcp.yaml`    |
| CodeMie API  | `%%DOMAIN%%`                | Your public domain                                                                                                                                                                | `example.com`     | `codemie-helm-charts/codemie-api/values-gcp.yaml`   |
| CodeMie API  | `%%GOOGLE_PROJECT_ID%%`     | GCP project ID                                                                                                                                                                    | `some-project-id` | `codemie-helm-charts/codemie-api/values-gcp.yaml`   |
| CodeMie API  | `%%GOOGLE_REGION%%`         | GCP region                                                                                                                                                                        | `europe-west3`    | `codemie-helm-charts/codemie-api/values-gcp.yaml`   |
| CodeMie API  | `%%GOOGLE_KMS_PROJECT_ID%%` | GCP project ID of KMS Key                                                                                                                                                         | `some-project-id` | `codemie-helm-charts/codemie-api/values-gcp.yaml`   |
| CodeMie API  | `%%GOOGLE_KMS_REGION%%`     | GCP region of KMS Key                                                                                                                                                             | `europe-west3`    | `codemie-helm-charts/codemie-api/values-gcp.yaml`   |
| CodeMie API  | `PG_URL`                    | Leave as is if planning to use in-cluster postgres. Change to `postgresql://admin:$(POSTGRES_PASSWORD)@%%DB_HOST%%:5432/codemie` in case of using cloud managed Postgres instance |                   |                                                     |

## Create Service Account Key for Kubernetes

1. Access "IAM & Admin" in Google Cloud Console
2. Create a key for the "codemie-gsa" service account
3. Download and save the key to `codemie-helm-charts/codemie-gsa-key.json` file

## Public or Private LoadBalancer for GKE NGINX Ingress Controller

There are two main options for accessing resources deployed in a Google Kubernetes Engine (GKE) cluster:

1. **Internal LoadBalancer (Private Access)**
   - Use a Bastion Host to access services through a privately scoped Internal LoadBalancer
   - Suitable when resources must not be exposed to the public internet

2. **External LoadBalancer (Public Access)**
   - Access resources directly from your laptop or any external network using an External LoadBalancer

### Configuration Steps for Private Access

No changes are required to the default Helm chart values of the NGINX Ingress Controller.

:::info
The "networking.gke.io/load-balancer-type: Internal" annotation is used to deploy GCP internal loadbalancer:

```yaml
ingress-nginx:
  controller:
    ...
    service:
      annotations:
        networking.gke.io/load-balancer-type: Internal
    ...
```

:::

Deploy the Ingress Controller with an internal (private) LoadBalancer.

### Configuration Steps for Public Access

:::warning
For public access make sure you deployed initial infrastructure with public DNS name.
:::

1. Modify your NGINX Ingress Controller Helm chart values in `codemie-helm-charts/ingress-nginx/values-gcp.yaml` to allow public access:
   - The **"networking.gke.io/load-balancer-type: Internal" annotation** must be removed to deploy public LoadBalancer

   - The **"loadBalancerSourceRanges"** is used to pass a list of allowed IP addresses that have access to resources provided through this LoadBalancer

:::warning
Do not leave **loadBalancerSourceRanges** empty when "**networking.gke.io/load-balancer-type: Internal**" annotation is removed, as it will expose your application to the world.
:::

```yaml
ingress-nginx:
  controller:
    ...
    service:
      # The "networking.gke.io/load-balancer-type: Internal" annotation must be removed to deploy public LoadBalancer
      annotations: {}
      type: LoadBalancer
      # Allow external access to the NGINX Ingress Controller, list of IPs that are allowed to access the load balancer.
      loadBalancerSourceRanges:
        - 85.223.209.0/24 # Example of IP range
      enableHttp: false
    ...
```

2. Modify your NATS Helm chart values in `codemie-helm-charts/codemie-nats/values-gcp.yaml` to allow public access:

```yaml
service:
  merge:
    metadata:
      # The "networking.gke.io/load-balancer-type: Internal" annotation must be removed to deploy public LoadBalancer
      annotations: {}
    spec:
      type: LoadBalancer
      # Allow external access to the NATS, list of IPs that are allowed to access the load balancer.
      loadBalancerSourceRanges:
        - 85.223.209.0/24 # Example of IP range
```

3. Create a TLS secret in `codemie` namespace:

```bash
kubectl create ns codemie
kubectl -n codemie create secret tls custom-tls --key ${KEY_FILE} --cert ${CERT_FILE}
```

4. Copy it to `security`, `elastic` and `oauth2-proxy` namespaces:

```bash
kubectl get secret custom-tls -n codemie -o yaml | sed '/namespace:/d' | kubectl apply -n security -f -
kubectl get secret custom-tls -n codemie -o yaml | sed '/namespace:/d' | kubectl apply -n elastic -f -
kubectl get secret custom-tls -n codemie -o yaml | sed '/namespace:/d' | kubectl apply -n oauth2-proxy -f -
```

:::info
It's possible to use [cert-manager](https://cert-manager.io/) but this option is not covered by this guide. Please reference its official documentation.
:::

5. Reference this secret in `ingress.tls` by uncommenting this section of files:

```yaml
tls:
  - secretName: custom-tls
    hosts:
      - %%DOMAIN%%
# Hosts must match ingress hosts. For example,
#tls:
#   - secretName: custom-tls
#     hosts:
#       - airun-codemie.example.com
```

In the following files:

- `codemie-helm-charts/codemie-api/values-gcp.yaml`
- `codemie-helm-charts/codemie-ui/values-gcp.yaml`
- `codemie-helm-charts/kibana/values-gcp.yaml`
- `codemie-helm-charts/keycloak-helm/values-gcp.yaml`
- `codemie-helm-charts/codemie-nats/values-gcp.yaml`

## Usage

Below is an example demonstrating how to run the script:

### Example: Deploy AI/Run CodeMie + Third-Party Components

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev

bash helm-charts.sh --cloud gcp --version x.y.z --mode all
```

## Setting up DNS Records

To make your applications and components accessible via friendly domain names, you need to add **A records** in your DNS provider's zone.

### Required DNS Records

#### 1. The "\*" Wildcard Record for NGINX Ingress Controller

This allows access to any subdomain managed by the NGINX Ingress Controller.

DNS record to add:

- **Type**: A
- **Name**: "\*"
- **Value**: `<public_or_private_ip_of_nginx_ingress_controller>`

Get the Ingress Controller's IP:

```bash
kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

#### 2. The "nats-codemie" Record for NATS Component

This allows direct access to the NATS service from outside the cluster.

DNS record to add:

- **Type**: A
- **Name**: "nats-codemie"
- **Value**: `<public_or_private_ip_of_nats_service>`

Get the NATS service IP:

```bash
kubectl get service codemie-nats -n codemie -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```
