---
id: mf-lens
title: MF Lens
sidebar_label: ✨ MF Lens
sidebar_position: 6
description: Mainframe code analysis and exploration solution within the EPAM AI/Run platform
pagination_prev: admin/deployment/extensions/extensions-overview
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# MF Lens

<EnterpriseFeature />

MF Lens is a mainframe code analysis and exploration solution within the EPAM AI/Run platform.

## MF Lens System Requirements

### MF Lens Container Resource Requirements

| Component Name | Replicas | Memory | CPU (cores) |
| -------------- | -------- | ------ | ----------- |
| backend        | 1        | 6Gi    | 1.0         |
| frontend       | 1        | 256Mi  | 0.1         |
| neo4j          | 1        | 4Gi    | 2.0         |

### Core MF Lens Components Overview

| Component Name       | Images                                         | Description |
| -------------------- | ---------------------------------------------- | ----------- |
| mf-analyzer-backend  | `liubuss/epam-ai-mf-analyzer:backend-develop`  | -           |
| mf-analyzer-frontend | `liubuss/epam-ai-mf-analyzer:frontend-develop` | -           |

### Third-Party MF Lens Components

| Component Name | Images          | Description |
| -------------- | --------------- | ----------- |
| neo4j          | `neo4j:5.26.16` | -           |

## PostgreSQL Configuration

Configure the PostgreSQL instance with the necessary database and user.

:::warning
We strongly recommend using a **dedicated PostgreSQL instance** for MF Lens. Do not share the same instance used by AI/Run CodeMie, as this may cause resource contention and complicate maintenance.
:::

### Configuring PostgreSQL Running in Managed Cloud

1. Navigate to the SQL section in Managed Cloud

2. Connect to PostgreSQL database `codemie` depending on the cloud provider:
   - Some cloud providers have built-in query tools
   - Deploy pgadmin inside the cluster to access a private Postgres instance:

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

   # access via localhost:8080 with secret from pgadmin namespace, user - "pgadmin4@example.com"
   ```

3. Open the SQL Editor tab

4. Execute the following SQL commands:

   ```sql
   CREATE DATABASE postgres_mflens;
   CREATE USER mflens WITH PASSWORD '<strong-password>';
   GRANT ALL PRIVILEGES ON DATABASE postgres_mflens TO mflens;
   ```

5. Switch to the `postgres_mflens` database

6. Grant schema privileges:

   ```sql
   GRANT ALL ON SCHEMA public TO mflens;
   ```

## Prerequisites

Create the Kubernetes namespace for all MF Lens components before proceeding:

```bash
kubectl create namespace mf-analyzer
```

## Step 1: Deploy Neo4j

### Create Neo4j Secret

Generate a password and create the Kubernetes secret:

```bash
kubectl create secret generic mf-analyzer-neo4j \
  --namespace mf-analyzer \
  --from-literal=NEO4J_AUTH="neo4j/$(openssl rand -hex 16)"
```

:::tip
The value format must be `neo4j/<password>`. Neo4j uses this value directly for authentication.
:::

### Configure Values

Update `mflens/neo4j-values.yaml` before deploying. Set `storageClassName` to the storage class available in the cluster:

```yaml {7}
neo4j:
  # ... additional configuration fields
  volumes:
    data:
      mode: "dynamic"
      dynamic:
        storageClassName: "storage-class"  # e.g., "gp3", "standard", etc.
  # ... additional configuration fields
```

### Install Helm Chart

Install or upgrade Neo4j using Helm:

```bash
helm upgrade --install neo4j \
  neo4j/neo4j \
  --version 5.26.16 \
  --namespace mf-analyzer \
  -f ./mflens/neo4j-values.yaml \
  --wait \
  --timeout 600s
```

## Step 2: Deploy MF Lens Backend

### Create Secrets

**LiteLLM API Key**

Generate an API key in the LiteLLM proxy admin UI (or via the LiteLLM API), then create the secret:

```bash
kubectl create secret generic backend-litellm-api-key \
  --namespace mf-analyzer \
  --from-literal=litellm-api-key="<litellm-api-key>"
```

**PostgreSQL Credentials**

Use the database, user, and password created in the [PostgreSQL Configuration](#postgresql-configuration) step:

```bash
kubectl create secret generic mf-analyzer-postgresql \
  --namespace mf-analyzer \
  --from-literal=PG_USER="mflens" \
  --from-literal=PG_PASS="<pg-password>" \
  --from-literal=PG_HOST="<pg-host>" \
  --from-literal=PG_DATABASE="postgres_mflens"
```

**Neo4j Password**

Use the password from the Neo4j secret created in [Step 1](#step-1-deploy-neo4j):

```bash
kubectl create secret generic mf-analyzer-backend-neo4j \
  --namespace mf-analyzer \
  --from-literal=password="<neo4j-password>"
```

### Configure Values

Update `mflens/backend-values.yaml` before deploying. Set `storageClassName` to the storage class available in the cluster:

```yaml {7}
volumeClaimTemplates:
  - spec:
      # ... additional configuration fields
      accessModes:
        - "ReadWriteOnce"
      storageClassName: "storage-class"  # e.g., "gp3", "standard", etc.
      # ... additional configuration fields
```

### Install Helm Chart

Install or upgrade MF Lens Backend using Helm:

```bash
helm upgrade --install mf-analyzer-backend \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mf-analyzer-backend \
  --version x.y.z \
  --namespace mf-analyzer \
  -f ./mflens/backend-values.yaml \
  --wait \
  --timeout 600s
```

### Backend Application Settings

These settings control the MF Analyzer Backend behavior and integrations. All values are configured via environment variables in `mflens/backend-values.yaml`.

#### Core Application Settings

| Parameter                | Type   | Default | Description                                                           |
| ------------------------ | ------ | ------- | --------------------------------------------------------------------- |
| `ENV`                    | string | `""`    | Deployment environment identifier affecting logging and feature flags |
| `SPRING_PROFILES_ACTIVE` | string | `""`    | Active Spring profile controlling configuration loading               |
| `JVM_OPTS`               | string | `""`    | JVM heap settings; adjust based on available node memory              |

#### Database Configuration

| Parameter                    | Type   | Default | Description                                                                 |
| ---------------------------- | ------ | ------- | --------------------------------------------------------------------------- |
| `SPRING_DATASOURCE_USERNAME` | string | `""`    | Database username with read/write permissions on the MF Lens database       |
| `SPRING_DATASOURCE_PASSWORD` | string | `""`    | Database password (use a secrets manager in production)                     |
| `POSTGRES_HOST`              | string | `""`    | PostgreSQL server hostname or IP address                                    |
| `POSTGRES_DB`                | string | `""`    | Database name for MF Lens tables and data                                   |
| `SPRING_DATASOURCE_URL`      | string | `""`    | Full JDBC connection URL constructed from `POSTGRES_HOST` and `POSTGRES_DB` |

#### LLM Configuration

| Parameter            | Type   | Default | Description                                          |
| -------------------- | ------ | ------- | ---------------------------------------------------- |
| `LLM_API_KEY`        | string | `""`    | API key for LiteLLM proxy authentication             |
| `LLM_APIURL`         | string | `""`    | LiteLLM proxy server URL (e.g., http://litellm:4000) |
| `LLM_DEPLOYMENTNAME` | string | `""`    | Model deployment name to use for analysis requests   |

#### Neo4j Configuration

| Parameter                              | Type   | Default | Description                                                                                                |
| -------------------------------------- | ------ | ------- | ---------------------------------------------------------------------------------------------------------- |
| `SPRING_NEO4J_URI`                     | string | `""`    | Bolt connection URI for the Neo4j graph database (e.g., `bolt://neo4j.mf-analyzer.svc.cluster.local:7687`) |
| `SPRING_NEO4J_AUTHENTICATION_USERNAME` | string | `""`    | Neo4j database username for backend authentication                                                         |
| `SPRING_NEO4J_AUTHENTICATION_PASSWORD` | string | `""`    | Neo4j database password (use a secrets manager in production)                                              |

#### Storage and Runtime

| Parameter                          | Type   | Default | Description                                          |
| ---------------------------------- | ------ | ------- | ---------------------------------------------------- |
| `APP_WORKING_STORAGE`              | string | `""`    | Working directory for temporary analysis data        |
| `PORTFOLIO_COBOL_PREPROCESSOR_JAR` | string | `""`    | Path to the COBOL preprocessor JAR file              |
| `JAVA_EXECUTABLE_PATH`             | string | `""`    | Path to the Java executable used by the preprocessor |

## Step 3: Deploy MF Lens Frontend

### Configure Values

Update `mflens/frontend-values.yaml` before deploying. Set the `host` values to the actual domain:

```yaml {4}
ingress:
  # ... additional configuration fields
  hosts:
    - host: codemie.%%DOMAIN%%
      paths:
        - path: "/mflens"
          pathType: Prefix
```

### Install Helm Chart

Install or upgrade MF Lens Frontend using Helm:

```bash
helm upgrade --install mf-analyzer-frontend \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mf-analyzer-frontend \
  --version x.y.z \
  --namespace mf-analyzer \
  -f ./mflens/frontend-values.yaml \
  --wait \
  --timeout 600s
```

## Step 4: Verify MF Lens Deployment

Check that MF Lens components are running:

```bash
# Check pod status
kubectl get pods -n mf-analyzer

# Check deployments
kubectl get deployment -n mf-analyzer mf-analyzer-backend
kubectl get deployment -n mf-analyzer mf-analyzer-frontend

# Check logs
kubectl logs -n mf-analyzer deployment/mf-analyzer-backend --tail=50
kubectl logs -n mf-analyzer deployment/mf-analyzer-frontend --tail=50
```

Expected output:

- Pods should be in `Running` state
- Deployments should show ready replicas
- Logs should indicate successful startup

## Step 5: Access the Application

MF Lens UI is accessible at the following URL:

- **URL Pattern**: `https://codemie.%%DOMAIN%%/mflens`
- **Example**: `https://codemie.airun.example.com/mflens`

## Step 6: Register MF Lens in the Applications Menu

To make MF Lens available in the **Applications** menu, add it to the integrated applications configuration.

See [Integrated Applications](../../../configuration/codemie/customer-feature-configuration/#integrated-applications) for full configuration details.

Add the following entry to the configuration:

```yaml
- id: "applications:mflens"
  settings:
    enabled: true
    name: "MFLens"
    url: "https://codemie.%%DOMAIN%%/mflens/?theme=codemie"
    type: "iframe"
    description: "Mainframe code analysis and exploration solution within the EPAM AI/Run platform."
    created_by: "AIMF Team"
    icon_url: "https://raw.githubusercontent.com/epam-gen-ai-run/ai-run-install/main/docs/assets/ai/ai-run-mflens-logo.png"
```

## Next Steps

- Return to [Extensions Overview](../)
- Configure other extensions
