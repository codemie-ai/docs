---
id: postgres-setup
sidebar_label: PostgreSQL Setup
sidebar_position: 2
title: Step 1 - PostgreSQL Database Setup
description: Configure PostgreSQL database for LiteLLM Proxy
pagination_prev: admin/deployment/extensions/litellm-proxy/litellm-proxy-overview
pagination_next: null
---

# Step 1: PostgreSQL Database Setup

LiteLLM requires a dedicated database and user in your PostgreSQL instance. Follow these steps to configure it.

## Connect to PostgreSQL

Connect to your main PostgreSQL instance.

:::info Finding Your Database Credentials

Your main database connection details (host, port, user, and password) are generated during the Terraform deployment and can be found in the **`deployment_outputs.env`** file. Use these values to connect with a database management tool.

```bash title="Example from deployment_outputs.env"
# Database Outputs
CODEMIE_POSTGRES_DATABASE_HOST=...
CODEMIE_POSTGRES_DATABASE_PORT=...
CODEMIE_POSTGRES_DATABASE_NAME=...
CODEMIE_POSTGRES_DATABASE_USER=...
CODEMIE_POSTGRES_DATABASE_PASSWORD="..."
```

:::

You can connect using one of the following methods:

- Use your cloud provider's built-in query tools.
- Deploy pgAdmin inside the cluster to access your private PostgreSQL instance.

<details>
<summary>Click here for instructions on deploying pgAdmin</summary>

```bash
# Create a dedicated namespace
kubectl create ns pgadmin

# Create credentials for pgadmin
kubectl create secret generic pgadmin4-credentials \
--namespace pgadmin \
--from-literal=password="$(openssl rand -hex 16)" \
--type=Opaque

# Inside cloned codemie-helm-charts
# Deploy pgadmin using Helm
helm upgrade --install pgadmin pgadmin/. -n pgadmin --values pgadmin/values.yaml --wait --timeout 900s --dependency-update

# Forward a local port to the service to access the UI
kubectl -n pgadmin port-forward svc/pgadmin-pgadmin4 8080:80

# You can now access the pgadmin UI at http://localhost:8080
# Default user: "pgadmin4@example.com"
# Retrieve the pgAdmin password from the Kubernetes secret.
kubectl -n pgadmin get secret pgadmin4-credentials -o jsonpath='{.data.password}' | base64 -d; echo
```

</details>

## Create Database and User

Execute the following SQL commands to create the dedicated database and user for LiteLLM.

:::warning Important

Replace `'your_strong_password_here'` with a new, secure password for the `litellm` user.
You can generate one using:

```bash
openssl rand -base64 16 | tr '+/' '-_' | tr -d '= ' | cut -c1-16
```

The command above generates a URL-safe password using only alphanumeric characters, hyphens (`-`), and underscores (`_`). This is intentional — passwords containing special characters such as `@`, `#`, `$`, `!`, `%`, `&`, `=`, `\`, spaces, etc., can cause issues when embedded in connection strings, shell scripts, or Helm values files. Using a password without such characters reduces the risk of quoting or escaping errors.

:::

### Create Database

```sql
CREATE DATABASE postgres_litellm;
```

### Create User and Grant Privileges

```sql
CREATE USER litellm WITH PASSWORD 'your_strong_password_here';
GRANT ALL PRIVILEGES ON DATABASE postgres_litellm TO litellm;
```

## Configure Schema Permissions

1. Switch your connection to the newly created `postgres_litellm` database:

```sql
\c postgres_litellm
```

or reconnect to the `postgres_litellm` database **using PG admin credentials**.

2. Grant all privileges on the `public` schema to the `litellm` user:

```sql
GRANT ALL ON SCHEMA public TO litellm;
```

## Next Steps

Continue to [Configure API and Proxy Values](./configure-values).
