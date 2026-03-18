# How do I manage Providers in administrative CodeMie settings? Where can I manage external toolkits?

## Overview:

Providers are registered services that supply external toolkits to AI Assistants on the platform. Each Provider represents a backend service implementation that delivers specific capabilities through toolkits available in the **External Tools** section when configuring assistants.

The Providers management interface in administrative settings allows platform administrators to register, view, and manage these service providers, controlling which external toolkits become available across the platform.

## Understanding Providers and External Toolkits:

When configuring an assistant's **External Tools**, the available toolkits depend on which Providers are registered in the administrative settings.

## Providers and Datasource Processing:

**Important:** Providers are utilized during **Datasource Context** processing when assistants work with indexed repositories and code data.

**How it works:**

1. When configuring an assistant, the **Context & Data Sources** section allows selection of **Datasource Context**
2. Datasource Context provides indexed repository data to the assistant
3. When the assistant processes datasource queries, it can leverage tools from registered Providers (such as CodeAnalysisToolkit and CodeExplorationToolkit)
4. These Provider-supplied tools enable the assistant to:
   - Analyze code structure and patterns
   - Explore repository contents
   - Extract insights from indexed data
   - Perform advanced code understanding tasks

**Configuration flow:**

```
Datasource Context (indexed repositories)
    ↓
Assistant with External Tools enabled
    ↓
Provider toolkits (CodeAnalysisToolkit, CodeExplorationToolkit)
    ↓
Enhanced datasource processing capabilities
```

**Note:** Only repositories that have fully completed the indexing process are available for selection in Datasource Context. The combination of indexed datasources and Provider toolkits enables assistants to perform sophisticated code analysis and exploration tasks.

## Accessing Providers Management:

**Prerequisites:** Administrator role/permissions on the AI/RUN CodeMie platform

**Navigation:**

1. Log in to the AI/RUN CodeMie platform
2. Click on profile icon **Settings** in the left bottom corner
3. Expand **Administration** section
4. Select **"Providers management"**

The Providers management option appears between "Projects management" and "MCPs management" in the administration menu.

## Viewing Registered Providers:

The Providers Management interface displays a table with registered providers:

| Column          | Description                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------- |
| **ID**          | Unique identifier for the Provider (UUID format)                                                |
| **Name**        | The Provider's service name (e.g., CodeAnalysisServiceProvider, CodeExplorationServiceProvider) |
| **Actions (⋮)** | Menu for managing the individual provider                                                       |

The interface shows all currently registered Providers, giving administrators visibility into available external toolkit infrastructure.

## Adding a New Provider:

To register a new Provider on the platform:

1. Click the **"Add Provider"** button in the top-right corner of the Providers management screen
2. Complete the Provider registration form with required information:
   - Provider service identifier
   - Configuration details
   - Connection parameters (if applicable)
3. Save the registration

**Result:** Once registered, the Provider's toolkit(s) become available in the **External Tools** section when configuring assistants. The toolkit will appear as an expandable section with the provider's name or corresponding toolkit name.

## Managing Existing Providers:

To perform actions on a registered Provider:

1. Locate the Provider in the table by name or ID
2. Click the three-dots menu (⋮) on the right side of the provider row
3. Select the desired action:
   - **View details**: Review Provider configuration and connection status
   - **Edit**: Modify Provider settings or configuration
   - **Delete/Remove**: Unregister the Provider from the platform

**Important:** Removing a Provider makes its toolkit(s) unavailable to all assistants. Before deleting a Provider, verify that:

- No active assistants are using tools from this Provider's toolkit
- The Provider service is no longer needed for any project
- You have communicated the change to relevant users

## How Providers Appear in Assistant Configuration:

After registering a Provider in administrative settings, its toolkit becomes visible when editing an assistant:

**Location:** Assistants → Edit Assistant → Tools & Integrations → **External Tools**

**Display:**

- External Tools section shows: _"These toolkits are provided by third-party vendors"_
- Each registered Provider's toolkit appears as an expandable accordion section
- Initial state shows: _"No tools selected"_ or _"No servers selected"_
- Expanding the toolkit allows selection of specific tools provided by that service

**Example Toolkits:**

- CodeAnalysisToolkit
- CodeExplorationToolkit
- MCP Servers
- Other registered provider toolkits

## Relationship with MCP Servers:

Both **Providers management** and **MCPs management** appear in the Administration section and both supply external capabilities to assistants:

| Aspect                | Providers                                        | MCP Servers                                   |
| --------------------- | ------------------------------------------------ | --------------------------------------------- |
| **Purpose**           | Register service providers that supply toolkits  | Register Model Context Protocol servers       |
| **Admin Location**    | Settings → Administration → Providers management | Settings → Administration → MCPs management   |
| **Assistant Display** | External Tools section (as individual toolkits)  | External Tools section (as MCP Servers group) |
| **Architecture**      | Backend service integration                      | MCP protocol implementation                   |

Both appear in the same **External Tools** section when configuring assistants, providing complementary external capabilities.

## Security and Permissions:

- Providers management interface is accessible only to users with **Administrator** permissions
- All Provider registrations, modifications, and removals are tracked according to platform audit standards
- Provider availability impacts which external capabilities can be configured for assistants across all projects
- Third-party vendor toolkits operate according to their own security and data handling policies

## Best Practices

- **Verify service availability**: Before registering a Provider, ensure the backend service is operational and accessible from the platform
- **Document Provider purposes**: Maintain internal documentation on which Providers serve which use cases or projects
- **Review dependencies before removal**: Before unregistering a Provider, audit which assistants are using its toolkit
- **Coordinate with assistant owners**: Notify users before removing Providers that impact their configured assistants
- **Monitor toolkit availability**: If assistants show "No tools selected" but the toolkit appears, verify the Provider registration and service connectivity
- **Plan with MCP Servers**: Consider both Providers and MCP servers when designing external tool architecture for assistants

## Troubleshooting

**Problem: Toolkit not appearing in Assistant's External Tools section**

**Possible causes:**

- Provider is not registered in Providers management
- Provider service is not operational
- Provider configuration is incomplete

## Sources

- [Platform Administration](https://docs.codemie.ai/admin/configuration/codemie/platform-administration)
