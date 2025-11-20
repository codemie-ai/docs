---
id: post-installation-overview
sidebar_position: 1
title: Post-Installation Configuration
description: Required and optional configuration steps after deployment
---

# AI/Run CodeMie Post-Installation Configuration

## Overview

After successfully deploying all AI/Run CodeMie components, you need to complete the post-installation configuration to make the system operational.

## Configuration Steps

### Required Configuration

#### [User Configuration](./user-configuration/)

Complete user setup including authentication and authorization:

- Initial realm setup in Keycloak
- User provisioning (manual, assistant, or SSO)
- Role and permission assignment
- Platform administration guide

### Optional Configuration

#### [UI Customization](./ui-customization)

Customize the AI/Run CodeMie user interface:
- Configure UI components visibility
- Custom links and documentation
- Admin actions and feedback settings

#### [Data Sources Configuration](./datasources-configuration)

Configure data sources and loaders:
- Code loader settings for multiple programming languages
- Integration with Jira, Confluence, and JSON sources
- Storage and indexing configuration
- File processing parameters

## Quick Path

For a minimal setup:

1. Complete [Initial Realm Setup](./user-configuration/initial-realm-setup)
2. Create your first admin user via [Manual Creation](./user-configuration/user-provisioning/manual-creation)
3. [Assign admin role](./user-configuration/user-authorization/assign-roles) to the user
4. Test login at `https://codemie.<your-domain>`

## Next Steps

After completing post-installation configuration:

- Configure [AI Models Integration](../ai-models-integration/ai-models-overview) for LLM and embedding models
- Review [Extensions](../extensions/extensions-overview) for additional capabilities
- Set up monitoring and backups as described in [Platform Administration](./user-configuration/platform-administration)
