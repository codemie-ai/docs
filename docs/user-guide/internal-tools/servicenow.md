---
id: servicenow
title: ServiceNow
sidebar_label: ServiceNow
---

# ServiceNow

ServiceNow platform integration for IT service management.

Integrate AI/Run CodeMie with ServiceNow's Table API for comprehensive ITSM operations including incident management, change requests, service catalog interactions, and configuration management database (CMDB) operations.

## Overview

The ServiceNow integration enables assistants to interact with ServiceNow's powerful IT Service Management (ITSM) platform. This integration leverages the ServiceNow Table API to provide comprehensive access to:

- **Incident Management**: Create, update, and track incidents
- **Change Requests**: Manage change requests and approval workflows
- **Service Catalog**: Interact with service catalog items and requests
- **CMDB Operations**: Query and update configuration items
- **Problem Management**: Track and resolve recurring issues
- **Knowledge Base**: Access and search ServiceNow knowledge articles

## Prerequisites

Before integrating ServiceNow with AI/Run CodeMie, ensure you have:

1. **ServiceNow Instance**: Access to a ServiceNow instance (production or developer instance)
2. **API Access**: Appropriate permissions to use the ServiceNow Table API
3. **Credentials**: Valid ServiceNow credentials (username/password or API key)

For information on setting up a ServiceNow developer instance, refer to:
- [ServiceNow Developer Portal](https://developer.servicenow.com/dev.do#!/learn/learning-plans/washingtondc/new_to_servicenow/app_store_learnv2_buildmyfirstapp_washingtondc_personal_developer_instances)
- [ServiceNow API Key Configuration](https://www.servicenow.com/docs/bundle/yokohama-platform-security/page/integrate/authentication/task/configure-api-key.html)

## 1. Create Integration in AI/Run CodeMie

### 1.1 Navigate to Integrations

In the AI/Run CodeMie main menu, click the **Integrations** button.

### 1.2 Select Integration Type

Select **User** or **Project** and click the **+ Create** button.

:::tip
You can also click the **Add User Integration** button when creating/editing your assistant. This will open the integration creation page directly. Note that this option only appears if no ServiceNow integration has been configured yet.
:::

### 1.3 Configure Integration Parameters

Fill in the following parameters:

- **Project Name**: Select the name of your project
- **Credential Type**: ServiceNow
- **Alias**: Specify the integration name (e.g., "ServiceNow Production")
- **Instance URL**: Your ServiceNow instance URL (e.g., `https://your-instance.service-now.com`)
- **Username**: Your ServiceNow username
- **Password**: Your ServiceNow password (or API key)

:::note Authentication Options
ServiceNow supports multiple authentication methods:
- **Basic Authentication**: Username and password
- **OAuth 2.0**: For enhanced security
- **API Key**: Generated from ServiceNow for API access

Refer to ServiceNow documentation for your preferred authentication method.
:::

### 1.4 Test Integration

(Optional) Click **Test Integration** to verify the connection before saving.

### 1.5 Save Integration

Click **Create** to save the integration.

## 2. Configure Assistant

### 2.1 Enable ServiceNow Tool

When creating or editing an assistant:

1. Navigate to the **Available Tools** section
2. Select **Project Management** or **ITSM** category
3. Enable **ServiceNow Table API**
4. Select your configured ServiceNow integration from the dropdown

### 2.2 Configure Permissions

Ensure your assistant has appropriate permissions to access ServiceNow data:

- Read permissions for querying incidents, change requests, and CMDB data
- Write permissions for creating and updating records (if needed)
- Access to specific ServiceNow tables based on your use case

## 3. Using ServiceNow Integration

Once configured, your assistant can perform various ServiceNow operations:

### Common Use Cases

#### Incident Management

- **Create Incidents**: Report new incidents directly from chat
- **Query Incidents**: Search for incidents by number, status, priority, or assignee
- **Update Incidents**: Modify incident fields, add work notes, or change status
- **Track Progress**: Monitor incident resolution progress

**Example**: "Create a P2 incident for database connection timeout in production environment"

#### Change Management

- **Create Change Requests**: Initiate change requests with proper documentation
- **Review Changes**: Query pending change requests and their approval status
- **Update Changes**: Add implementation notes or update change status

**Example**: "Show me all pending change requests for this week"

#### CMDB Operations

- **Query Configuration Items**: Search for servers, applications, or other CI's
- **View Relationships**: Understand dependencies between configuration items
- **Update CI Information**: Modify configuration item attributes

**Example**: "Find all servers related to the payment processing application"

#### Service Catalog

- **Browse Catalog**: View available service catalog items
- **Request Services**: Submit service requests through the assistant
- **Track Requests**: Monitor the status of service requests

**Example**: "Request a new laptop for a new team member"

### ServiceNow Table API Capabilities

The integration provides access to ServiceNow Table API operations:

- **GET**: Retrieve records from ServiceNow tables
- **POST**: Create new records
- **PUT**: Update existing records
- **DELETE**: Remove records (with appropriate permissions)
- **Query**: Use ServiceNow query syntax for complex filtering

## Best Practices

### Security

- **Use API Keys**: Prefer API keys over username/password for better security
- **Least Privilege**: Grant only necessary permissions to the integration
- **Rotate Credentials**: Regularly update API keys and passwords
- **Audit Access**: Monitor integration usage through ServiceNow audit logs

### Performance

- **Limit Query Results**: Use appropriate filters to minimize data transfer
- **Cache Common Data**: For frequently accessed reference data
- **Batch Operations**: Group multiple operations when possible
- **Monitor API Limits**: Be aware of ServiceNow API rate limits

### Data Management

- **Validate Input**: Ensure data quality before creating/updating records
- **Follow Naming Conventions**: Adhere to your organization's ServiceNow standards
- **Document Changes**: Include clear descriptions in work notes and comments
- **Test in Development**: Use a ServiceNow development instance for testing

## Available Operations

The ServiceNow integration supports comprehensive ITSM operations:

### Tables

Common ServiceNow tables accessible through the integration:

- `incident`: Incident records
- `change_request`: Change management
- `cmdb_ci`: Configuration items
- `sc_request`: Service catalog requests
- `sc_req_item`: Service catalog request items
- `problem`: Problem records
- `kb_knowledge`: Knowledge base articles
- `sys_user`: User records
- `sys_user_group`: User groups

### Query Capabilities

- **Filtering**: Use ServiceNow query syntax (`field=value^field>value`)
- **Sorting**: Order results by any field
- **Limiting**: Control the number of returned records
- **Field Selection**: Retrieve only needed fields to improve performance

## Troubleshooting

### Common Issues

**Connection Errors**:
- Verify instance URL is correct and accessible
- Check credentials are valid
- Ensure network connectivity to ServiceNow instance

**Permission Errors**:
- Verify user has necessary roles in ServiceNow
- Check table-level access controls
- Confirm API access is enabled for the user

**Query Issues**:
- Validate query syntax matches ServiceNow standards
- Check field names are spelled correctly
- Ensure referenced fields exist in the target table

:::warning Rate Limiting
ServiceNow enforces API rate limits. If you encounter rate limit errors, reduce the frequency of API calls or contact your ServiceNow administrator to increase limits.
:::

## Additional Resources

- [ServiceNow REST API Documentation](https://docs.servicenow.com/bundle/tokyo-application-development/page/integrate/inbound-rest/concept/c_RESTAPI.html)
- [ServiceNow Table API Reference](https://docs.servicenow.com/bundle/tokyo-application-development/page/integrate/inbound-rest/concept/c_TableAPI.html)
- [ServiceNow Developer Portal](https://developer.servicenow.com/)

Now your assistant can interact with ServiceNow to manage incidents, change requests, and other ITSM operations efficiently.
