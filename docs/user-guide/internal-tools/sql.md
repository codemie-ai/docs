---
id: sql
title: SQL
sidebar_label: SQL
---

# SQL

Database query and management tool integration.

AI/Run CodeMie is capable with SQL databases, such as MySQL and PostgreSQL. By enabling SQL integration, assistants can perform various operations like reading and modifying tables. To set up an SQL integration, follow the steps below:

## 1. Create SQL Integration

### 1.1 Navigate to Integrations

In **AI/Run CodeMie**, navigate to the **Integrations** tab **-> User/Project** and click **+ Create**:

![Create Integration](./images/sql-create-integration.png)

### 1.2 Configure Integration Parameters

Add an SQL integration with the following parameters and click **Create**:

![SQL Integration Form](./images/sql-integration-form.png)

Below is a list of required fields:

- **Project**: Enter your project name. It is expected to be predefined by default.
- **Credential tool**: Select SQL.
- **Alias**: Enter the name for your integration. E.g., my-SQL-tool.
- **Database Dialect**: PostgreSQL, MSSql, MySQL or influxDB
- **Database URL**: Enter the URL of your database endpoint.
- **Port**: Specify the port your database works on.
- **Database name**: Enter your database name.
- **Username**: Enter your username.
- **Password**: Enter your user's password.

## 2. Configure Assistant

### 2.1 Enable SQL Integration

Modify or Create your assistant with enabling integration:

![SQL Assistant Configuration](./images/sql-assistant-config.png)

Now your assistant can interact with SQL databases to query data, modify tables, and perform various database operations.
