---
id: index
title: Configuration Guide
sidebar_label: Configuration
sidebar_position: 2
---

# Configuration Guide

Configure AI/Run CodeMie to match your organizational requirements and workflows.

## Configuration Areas

### Data Sources

Configure backend settings for how the platform processes different types of data sources.

**[Data Sources Configuration](./datasources-configuration)** - Configure loaders for code files, Confluence, Jira, JSON, and file uploads. Set chunking strategies, token limits, batch sizes, and file extensions for optimal data processing.

### User Interface

Control the visibility and configuration of UI components.

**[UI Customization](./ui-customization)** - Show or hide UI components like video portal, user guide, admin actions, feedback assistant, and workflow documentation. Configure custom URLs for help resources.

### User Management

Manage user access, roles, and identity integration.

**[User Configuration](./user-configuration/)** - Configure authentication, provision users, assign roles and permissions, and integrate with identity providers like Microsoft Entra ID, Okta, etc.

Key areas:

- **[Initial Realm Setup](./user-configuration/initial-realm-setup)** - Configure Keycloak realm settings
- **[User Provisioning](./user-configuration/user-provisioning/)** - Add users manually or via identity provider integration
- **[User Authorization](./user-configuration/user-authorization/)** - Assign roles and manage permissions
- **[Platform Administration](./user-configuration/platform-administration)** - Administrative controls and settings

### API Configuration

Configure CodeMie API environment variables and application settings.

**[API Configuration Reference](./api-configuration)** - Comprehensive reference for all CodeMie API configuration parameters including application settings, AI provider integrations, database connections, security, file storage, NATS messaging, MCP protocol, tools configuration, and observability settings.

## Before You Begin

:::tip Configuration Prerequisites

- Ensure AI/Run CodeMie is deployed and accessible
- Have administrative access to Keycloak and the platform
- Gather any credentials needed for external integrations (identity providers, data sources)
  :::

## Getting Help

Each configuration guide provides detailed instructions and troubleshooting steps. For additional assistance, consult the [FAQ](../deployment/faq) or contact your support team.
