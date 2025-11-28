---
id: deployment-prerequisites
title: Prerequisites for Deployment
sidebar_label: Deployment Prerequisites
sidebar_position: 3
description: Configuration steps required before deploying Langfuse
---

# Prerequisites for Deployment

Before deploying Langfuse, complete the following steps:

## Step 1: Clone the Repository

Clone the `codemie-helm-charts` repository.

## Step 2: Update `langfuse/values.yaml`

Before deployment, you **MUST** update the `langfuse/values.yaml` file with your environment-specific values:

```yaml
# Update the domain in these sections:
langfuse:
  nextauth:
    url: "https://langfuse.%%DOMAIN%%"  # Replace with your domain
  ingress:
    hosts:
     - host: "langfuse.%%DOMAIN%%"   # Replace with your domain

# Adjust storage class if needed:
global:
  defaultStorageClass: "your-storage-class"  # e.g., "gp3", "standard", etc.

# Adjust resource limits based on your requirements:
langfuse:
  web:
    resources:
      limits:
        cpu: "2"      # Adjust as needed
        memory: "4Gi"  # Adjust as needed
  worker:
    resources:
      limits:
        cpu: "2"      # Adjust as needed
        memory: "4Gi"  # Adjust as needed

postgresql:
  deploy: false
  host: some-postgresql.database.example.com # Replace with your database host
  auth:
    username: langfuse_admin
    existingSecret: langfuse-postgresql
    secretKeys:
      userPasswordKey: password

# Adjust component resources:
clickhouse:
  resources:
    limits:
      cpu: "2"        # Adjust as needed
      memory: "8Gi"     # Adjust as needed
  persistence:
    size: "100Gi"         # Adjust as needed

redis:
  persistence:
    size: "2Gi"         # Adjust as needed

s3:
  persistence:
    size: "100Gi"         # Adjust as needed
```

## Step 3: Configure PostgreSQL

Configure PostgreSQL running in managed cloud.

### 3.1. Connect to PostgreSQL Database

Connect to PostgreSQL database `codemie` depending on your cloud provider. Choose one of the following options:

- Some cloud providers have built-in query tools
- Deploy pgadmin inside the cluster to access your private Postgres instance:

```bash
# Create namespace and secret
kubectl create ns pgadmin

kubectl create secret generic pgadmin4-credentials \
--namespace pgadmin \
--from-literal=password="$(openssl rand -hex 16)" \
--type=Opaque

helm upgrade --install pgadmin pgadmin/. -n pgadmin --values pgadmin/values.yaml --wait --timeout 900s --dependency-update

# port-forward to svc
kubectl -n pgadmin port-forward svc/pgadmin-pgadmin4 8080:80

# access via localhost:8080 with secret from pgadmin namespace

# Default user: "pgadmin4@example.com"
# Retrieve the pgAdmin password from the Kubernetes secret.
kubectl -n pgadmin get secret pgadmin4-credentials -o jsonpath='{.data.password}' | base64 -d; echo
```

### 3.2. Create Database and User

Execute the following SQL commands to create the database and user:

```sql
CREATE DATABASE postgres_langfuse;
```

```sql
CREATE USER langfuse_admin WITH PASSWORD 'your_strong_password_here';
GRANT ALL PRIVILEGES ON DATABASE postgres_langfuse TO langfuse_admin;
```

### 3.3. Grant Schema Privileges

Switch to the `postgres_langfuse` database and grant schema privileges:

```sql
GRANT ALL ON SCHEMA public TO langfuse_admin;
```
