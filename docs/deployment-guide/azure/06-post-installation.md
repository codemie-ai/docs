---
id: post-installation
title: AI/Run CodeMie Post-Installation Configuration
sidebar_label: Post-Installation
sidebar_position: 6
---

# AI/Run CodeMie Post-Installation Configuration

## Required Steps

Before onboarding users, additional configuration steps are required to set up user authentication and authorization.

### Prerequisites

Before you begin, ensure you have:

- ✅ **A successful deployment of all AI/Run CodeMie components**
- ✅ **Access to your Kubernetes cluster via `kubectl`**

**Conditional Prerequisites:**

- For options involving Keycloak (A, B, and C): You will need administrative access to the Keycloak UI. Retrieve admin credentials:

```bash
kubectl get secret keycloak-initial-admin -n keycloak \
  -o jsonpath="{.data.username}" | base64 --decode && echo
kubectl get secret keycloak-initial-admin -n keycloak \
  -o jsonpath="{.data.password}" | base64 --decode && echo
```

## User Configuration Workflow

The user configuration workflow consists of two main parts:

**Part 1: User Provisioning** - Create user accounts
**Part 2: User Authorization** - Assign permissions and project access

### Initial Realm Setup

1. Navigate to Keycloak Admin Console: `http://codemie.example.com/keycloak/admin`
2. Log in using the credentials from Prerequisites
3. Select the `codemie-prod` realm from the dropdown (top-left corner)

## Part 1: User Provisioning

Choose one of the following options for creating users:

### Option A: Create Users Manually

Best for creating a small number of users with full control over each user's configuration.

**Steps:**

1. In Keycloak Admin Console, navigate to **Users** (left sidebar)
2. Click **Add user**
3. Fill in required information:
   - Username (required)
   - Email (required)
   - First Name / Last Name (optional)
   - Email Verified: Set to **ON**
4. Click **Create**
5. **Assign Credentials:**
   - Navigate to **Credentials** tab
   - Click **Set password**
   - Enter password and confirm
   - Set "Temporary" to **OFF** (so users won't need to change password on first login)
   - Click **Save**

:::tip
After creating a user, proceed to [Part 2: User Authorization](#part-2-user-authorization) to assign the necessary permissions.
:::

### Option B: Create Users with Keycloak Assistant

:::info Availability
The Keycloak Assistant is available as a system agent from AI/Run CodeMie version 0.25.0.
:::

Best for bulk user creation with an AI-powered assistant.

**Prerequisites:**

1. Create Keycloak client for the assistant:

```yaml
apiVersion: keycloak.org/v1alpha1
kind: KeycloakClient
metadata:
  name: keycloak-assistant
  namespace: oauth2-proxy
spec:
  realmSelector:
    matchLabels:
      app: keycloak
  client:
    clientId: keycloak-assistant
    name: keycloak-assistant
    description: Keycloak Assistant for user management
    enabled: true
    secret: CHANGE_ME
    clientAuthenticatorType: client-secret
    directAccessGrantsEnabled: false
    publicClient: false
    protocol: openid-connect
    protocolMappers:
      - config:
          access.token.claim: 'true'
          claim.name: roles
          id.token.claim: 'true'
          jsonType.label: String
          multivalued: 'true'
          userinfo.token.claim: 'true'
        name: roles
        protocol: openid-connect
        protocolMapper: oidc-usermodel-realm-role-mapper
    realmRef:
      kind: KeycloakRealm
      name: codemie-prod
    standardFlowEnabled: true
    serviceAccount:
      enabled: true
      realmRoles:
        - default-roles-codemie-prod
      clientRoles:
        - clientId: realm-management
          roles:
            - manage-clients
            - manage-events
            - manage-identity-providers
            - create-client
            - manage-authorization
            - manage-realm
            - manage-users
            - query-clients
            - query-groups
            - query-realms
            - query-users
            - realm-admin
            - view-authorization
            - view-clients
            - view-events
            - view-identity-providers
            - view-realm
            - view-users
```

2. Redeploy oauth2-proxy and create project integration in AI/Run CodeMie UI

**Usage:**

1. Navigate to **Assistants** tab in AI/Run CodeMie
2. Click **Start chat** for `Keycloak Manager`
3. Verify connection: `Show number of users in the realm`
4. Create users in bulk:

```
Create and add the following people to the "project_name" project –
first_lastname1@example.com, first_lastname2@example.com.
Assign to each of them the developer role.
Output the results in a table format.
```

5. **Important:** The assistant creates users but **does not set passwords**. You must manually set passwords in Keycloak UI (see Option A, step 5)

:::tip
After creating users, proceed to [Part 2: User Authorization](#part-2-user-authorization).
:::

### Option C (Recommended): Keycloak + Entra ID

Best for organizations using Microsoft Entra ID for Single Sign-On.

This option allows users to sign in with their corporate credentials and automatically assigns default permissions.

**Stage 1: Entra ID Configuration**

1. **Navigate to App Registrations**
   - Log in to Azure portal
   - Go to **Microsoft Entra ID** → **App registrations**
   - Click **New registration**

2. **Create Registration**
   - Name: `AI/Run CodeMie Keycloak Integration`
   - Click **Register**

3. **Create Client Secret**
   - Navigate to **Certificates & secrets**
   - Click **New client secret**
   - Add description (e.g., `Keycloak Secret`)
   - Click **Add**
   - **Important:** Copy the secret **Value** immediately (it's only shown once)

4. **Verify API Permissions**
   - Navigate to **API permissions**
   - Ensure `User.Read` permission for `Microsoft Graph` (Type: `Delegated`) is present

**Stage 2: Keycloak Configuration**

1. **Add Identity Provider**
   - In Keycloak `codemie-prod` realm
   - Navigate to **Identity Providers**
   - Select **OpenID Connect v1.0**

2. **Configure Provider Details**
   - **Alias:** `entra-id`
   - **Discovery endpoint:** Paste OpenID Connect metadata document URL from Azure
   - **Client ID:** Paste Application (client) ID from Azure
   - **Client Secret:** Paste the secret value you saved
   - Click **Add**

3. **Configure Redirect URI**
   - Copy **Redirect URI** from Keycloak
   - In Azure, go to **Authentication** → **Add a platform** → **Web**
   - Paste the URI and click **Configure**

4. **Automate Permissions with Mappers** (Required)

:::warning Critical
Without these mappers, SSO users will be created but cannot access the platform
:::

**Mapper 1: Assign Default Role**

- Navigate to **Mappers** tab
- Click **Add mapper**
- Configure:
  - **Name:** `codemie-developer-role`
  - **Sync Mode Override:** `Import`
  - **Mapper Type:** `Hardcoded Role`
  - **Role:** Select `developer`
- Click **Save**

**Mapper 2: Assign Default Project**

- Click **Add mapper** again
- Configure:
  - **Name:** `codemie-attribute`
  - **Sync Mode Override:** `Import`
  - **Mapper Type:** `Attribute Importer`
  - **Claim:** `email`
  - **User Attribute Name:** `applications`
- Click **Save**

5. **Grant Admin Consent**
   - Navigate to AI/Run CodeMie login page
   - Click to sign in with Entra ID
   - Sign in as **Azure Administrator**
   - Check **"Consent on behalf of your organization"**
   - Click **Accept**

:::tip
All new SSO users will automatically receive the `developer` role and a personal project. For additional permissions, proceed to [Part 2: User Authorization](#part-2-user-authorization).
:::

### Option D: Entra ID only

:::info
Content coming soon. This section will contain instructions for direct Entra ID integration.
:::

## Part 2: User Authorization

This is a **mandatory** follow-up step for users created in Part 1. Grant users permissions to access the platform and projects.

### Access Levels

1. **Platform Administrator (`admin` role):** Global access to everything
2. **Project Administrator (`developer` role + `applications` & `applications_admin` attributes):** Full admin rights within specific projects
3. **Standard User (`developer` role + `applications` attribute):** Standard rights within specific projects

### Step 2.1: Assign a Role

| Role        | Permissions & Configuration                                                                                                                                                                  |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `admin`     | **Global Platform Administrator.** Grants highest level access. **Does not require additional attributes.** Permissions: manage all assistants, create projects, create global integrations. |
| `developer` | **Base role for project-level access.** **Does nothing on its own**. Always requires at least one attribute (`applications` or `applications_admin`) to grant project access.                |

**How to Assign:**

1. In Keycloak, navigate to **Users** → Click on **Username**
2. Navigate to **Role mappings** tab
3. Click **Assign role**
4. Select required role → Click **Assign**

### Step 2.2: Assign Attributes to `developer` Users

| Attribute (Key)      | Grants Role               | Permissions                                                   | Value Configuration                                                   |
| -------------------- | ------------------------- | ------------------------------------------------------------- | --------------------------------------------------------------------- |
| `applications`       | **Standard User**         | Create, edit, delete, share, and publish their own assistants | Comma-separated list of project names (e.g., `my_project,team_alpha`) |
| `applications_admin` | **Project Administrator** | Manage all assistants and project integrations                | Comma-separated list of project names with admin rights               |

:::tip Automatic Project Creation
When you assign the `applications` attribute, any non-existent projects in the value will be **created automatically** on the platform. This applies to both personal projects (e.g., `john_doe` for user `john_doe`) and shared projects (e.g., `team-alpha`).
:::

:::note Configuring a Project Administrator
To grant **Project Administrator** privileges, assign **both** attributes:

1. Assign `developer` role
2. Add `applications` attribute (lists all accessible projects)
3. Add `applications_admin` attribute (lists projects with admin rights)
   :::

**How to Assign Attributes:**

1. In **User details** → Navigate to **Attributes** tab
2. Click **Add attributes**
3. Enter **Key** and **Value** based on desired role
4. Click **Save**

Examples:

- **Standard User:** Key: `applications`, Value: `my_project,shared_project`
- **Project Admin:** Key: `applications_admin`, Value: `shared_project`

## Platform Administration Guide

For users with the `admin` role:

### Creating a New Project

1. Click **Profile** icon (bottom left) → Select **Settings**
2. Navigate to **Administration** tab
3. Click **Create Project**
4. Enter unique **Project Name** (e.g., `sample_project`)
5. Click **Add**

After creating, assign it to users via Step 2.2.

### Accessing Existing Projects

:::note
Project dropdown appears empty for admins. To access any project, type at least **three characters** of the project name in the search bar.
:::

**Optional:** Assign `applications` attribute to admin users to show frequently used projects in the dropdown by default.

## Optional Steps

### Install DIAL (optional)

Consider installing DIAL LLM Proxy only if you want to balance between different LLM endpoints.

1. Create namespace:

```bash
kubectl create namespace codemie-dial
```

2. Create encryption keys:

```bash
kubectl -n codemie-dial create secret generic dial-core-encryption \
  --from-literal=aidial.encryption.key="$(pwgen -s -1 32)" \
  --from-literal=aidial.encryption.secret="$(pwgen -s -1 32)"
```

3. Create DIAL Core keys and configure secrets (refer to detailed installation guide)

4. Install DIAL helm chart:

```bash
helm repo add dial https://charts.epam-rail.com
helm repo update dial
helm upgrade --install dial dial/dial --version 5.3.0 \
  --namespace codemie-dial \
  --values "dial/values-azure.yaml" \
  --wait --timeout 900s \
  --set-file core.main=dial/config/azure.models.codemie.config.json
```

### UI Custom Configuration (optional)

To customize UI elements, create a `customer-config.yaml` ConfigMap with component configurations:

```yaml
components:
  - id: 'videoPortal'
    settings:
      name: 'Video Portal'
      enabled: false
      url: 'https://example-video-portal.com'
  - id: 'userGuide'
    settings:
      name: 'User Guide'
      enabled: false
      url: 'https://example-tutorial-portal.com'
  - id: 'adminActions'
    settings:
      enabled: true
  - id: 'feedbackAssistant'
    settings:
      enabled: false
  - id: 'workflowDocumentation'
    settings:
      name: 'Workflow Documentation'
      enabled: false
      url: 'https://example-documentation.com'
```

Add this to `codemie-helm-charts/codemie-api/values.yaml` under `extraObjects` and configure `extraVolumes` and `extraVolumeMounts` accordingly.
