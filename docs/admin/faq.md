---
id: faq
sidebar_position: 4
title: FAQ
description: Frequently asked questions about AI/Run CodeMie deployment
pagination_prev: admin/index
pagination_next: null
---

# Frequently Asked Questions

Find answers to common questions about deploying and managing AI/Run CodeMie. If you can't find what you're looking for, please contact our support team.

## General Questions

<details>
<summary><strong>Can I share documentation with external clients?</strong></summary>

Yes, all documentation including architecture and deployment guides can be shared with external clients.

</details>

<details>
<summary><strong>Client-side approvals for LLMs are taking too long. Can we start deploying without them?</strong></summary>

Yes, AI/Run CodeMie can be deployed with mock LLM configurations initially. Real LLM configurations can be provided later once client-side approvals are complete.

This allows you to:

- Begin infrastructure setup immediately
- Test deployment and connectivity
- Configure other components while waiting for LLM approvals
- Switch to production LLM configurations when ready

</details>

<details>
<summary><strong>We're planning integrations with Azure DevOps, GitLab, AWS S3, etc. Do we need to configure these during deployment?</strong></summary>

No, integration configurations happen after deployment during actual AI/Run CodeMie usage. All you need to ensure is:

- Your integration services allow incoming traffic from the AI/Run CodeMie instance's public IP address
- You have the necessary credentials ready for when you configure integrations in the UI

Integration actions, including supplying credentials and configuring connections, are done through the CodeMie interface post-deployment.

</details>

<details>
<summary><strong>What roles does CodeMie have and what can each role do?</strong></summary>

Role descriptions and capability details are documented in
[Role Descriptions](./security/roles-rbac.md#role-descriptions).

Source:

- [CodeMie Roles Overview](./security/roles-rbac.md)

</details>

## Authentication & Identity

<details>
<summary><strong>How does CodeMie authenticate with external integrations like Jira, Confluence, or Git?</strong></summary>

OAuth2/OIDC governs user authentication **into the CodeMie platform** only. Access to external integrations (Jira, Confluence, Git, SharePoint) is controlled entirely by the token or account configured for each integration — the user's platform session is not forwarded to those services.

This means:

- A **shared service account** configured for a project covers all project members using that service account's permission scope.
- A **personal token** configured in a personal project is bounded by that individual user's permissions on the external platform.

The platform does not re-check the authenticated user's original permissions on external sources at query or retrieval time. Data returned by the system is based on what was accessible to the configured credential at indexing time. For shared projects, ensure the service account only has access to content that all project members are permitted to see.

</details>

<details>
<summary><strong>Why do we need Keycloak if we already have OKTA, Entra ID, or another Identity Provider?</strong></summary>

Keycloak serves as a middleware identity broker that provides several key benefits:

**Enhanced Flexibility:**

- Greater configuration flexibility for CodeMie-specific authentication needs
- Standardized authentication flow across different IdPs

**Better Control:**

- Enhanced control over user attributes and roles required by CodeMie
- Custom attribute management for project access control

**Seamless Integration:**

- Works with OAuth2-proxy for application-level authentication
- Easier management of authentication flows specific to AI/Run CodeMie

While you can integrate your existing IdP (OKTA, Entra ID, etc.) with Keycloak, having Keycloak as an intermediary layer offers better customization and centralized authentication management.

</details>

## Deployment & Infrastructure

<details>
<summary><strong>What external network access is required by the platform?</strong></summary>

The platform requires outbound access to the following external resources:

**From the Kubernetes cluster** (container image registries):

- `europe-west3-docker.pkg.dev`
- `docker.io`
- `docker.elastic.co`
- `cr.fluentbit.io`
- `ghcr.io`
- `registry.k8s.io`
- `quay.io`
- `registry.developers.crunchydata.com`

**From the administrator's machine** (Helm chart repositories):

- `https://europe-west3-docker.pkg.dev`
- `https://helm.elastic.co`
- `https://fluent.github.io/helm-charts`
- `https://kubernetes.github.io/ingress-nginx`
- `https://codecentric.github.io/helm-charts`
- `https://epam.github.io/edp-helm-charts/stable`
- `https://oauth2-proxy.github.io/manifests`
- `oci://registry.developers.crunchydata.com`
- `oci://ghcr.io`
- `https://helm.runix.net`

More detailed information can be provided upon request.

</details>

<details>
<summary><strong>Can Microsoft SQL Server be used instead of PostgreSQL?</strong></summary>

No. Platform components currently only support PostgreSQL as the database backend. Microsoft SQL Server is not supported.

</details>

<details>
<summary><strong>Why do we need external access to NATS via Network Load Balancer?</strong></summary>

NATS is part of the AI/Run CodeMie Plugin Engine and enables tool execution in external environments beyond the CodeMie backend.

**Use Cases:**

- Execute tools on local developer laptops
- Run tools in CI/CD environments
- Connect to on-premises resources

**Requirements:**

- Network Load Balancer with public access
- TLS certificate for secure communication
- DNS name for consistent connectivity

This architecture allows CodeMie to securely connect to and execute tools in distributed environments outside the main cluster.

</details>

<details>
<summary><strong>Terraform fails during infrastructure deployment</strong></summary>

**Common Causes and Solutions:**

**Credentials & Permissions:**

- Verify cloud provider credentials are properly configured
- Ensure IAM role/service principal has all required permissions
- Check for MFA requirements or expired tokens

**Quotas & Limits:**

- Check cloud provider quotas and service limits
- Request quota increases if needed
- Verify subscription/account limits

**Configuration Issues:**

- Review Terraform logs for specific error messages
- Validate variable values in `terraform.tfvars`
- Ensure resource names are unique and comply with naming conventions

**State Management:**

- Check Terraform state file isn't corrupted
- Verify state backend is accessible
- Consider state file locking issues

Run `terraform plan` first to identify issues before applying changes.

</details>

<details>
<summary><strong>Kubernetes cluster pods are not starting</strong></summary>

**Troubleshooting Steps:**

**Resource Availability:**

- Verify node groups are properly scaled and running
- Check pod resource requests don't exceed available node capacity
- Review node resource utilization

**Networking:**

- Verify security group and network ACL configurations
- Check pod network policies
- Ensure cluster networking add-ons are healthy

**Image Access:**

- Ensure container images are accessible from the cluster
- Verify image pull secrets are configured correctly
- Check container registry permissions

**Pod Status:**

```bash
kubectl get pods -n codemie
kubectl describe pod <pod-name> -n codemie
kubectl logs <pod-name> -n codemie
```

Review events and logs for specific error messages.

</details>

<details>
<summary><strong>Applications not accessible via domain name</strong></summary>

**Troubleshooting Steps:**

**DNS Configuration:**

- Verify DNS records are created and propagated (use `nslookup` or `dig`)
- Check DNS points to correct load balancer endpoint
- Allow time for DNS propagation (up to 48 hours in some cases)

**SSL/TLS Certificates:**

- Verify certificate status and validation
- Check certificate covers the correct domain(s)
- Ensure certificate is properly attached to load balancer

**Load Balancer Health:**

- Check load balancer target groups show healthy targets
- Verify backend services are running
- Review load balancer access logs

**Network Security:**

- Verify security group rules allow inbound traffic on ports 80/443
- Check network ACLs aren't blocking traffic
- Ensure firewall rules permit access

**Testing:**

```bash
# Test DNS resolution
nslookup your-domain.com

# Test direct connectivity to load balancer
curl -I https://your-domain.com

# Check SSL certificate
openssl s_client -connect your-domain.com:443 -servername your-domain.com
```

</details>

## Security & Data Privacy

<details>
<summary><strong>What data is sent to LLMs during a conversation?</strong></summary>

Only the user's prompt and the relevant retrieved context are sent to the LLM — not entire databases or all indexed content. Integration and data source credentials are never included in LLM requests and cannot be accessed by the model.

The exact content sent depends on how assistants, workflows, and data sources are configured. Any data available in indexed sources or provided directly in user prompts can appear in the context forwarded to the LLM. The platform itself does not classify data types before transmission.

LLM providers used under enterprise agreements do not train on customer data.

</details>

<details>
<summary><strong>Can MCP server connectivity be restricted or disabled?</strong></summary>

Two levels of MCP access control are available via `customer-config.yaml`.

For a full description of `customer-config.yaml` components and other available feature flags, see [Customer Feature Configuration](../configuration/codemie/customer-feature-configuration).

**Restrict to catalog-only**

Use the `mcpCustomServersDisabled` component to keep MCP connectivity available while preventing users from configuring custom (inline) MCP servers. Only servers from the admin-managed catalog can be selected.

```yaml
components:
  - id: "mcpCustomServersDisabled"
    settings:
      enabled: true
```

**Disable MCP entirely**

Fully disabling MCP requires these steps:

1. **Disable the UI component** — set `mcpConnect` to `false` in `customer-config.yaml` to remove the MCP Servers option from all assistant and workflow configurations:

   ```yaml
   components:
     - id: "mcpConnect"
       settings:
         enabled: false
   ```

2. **Disable the backend** — set `MCP_CONNECT_ENABLED=false` in the `codemie-api` values and redeploy. This variable is documented in the [API Configuration Guide](../configuration/codemie/api-configuration#mcp-model-context-protocol-configuration).

3. **Remove the MCP Connect service** (optional) — uninstall the Helm release or scale the deployment to 0 to free up cluster resources:

   ```bash
   # Uninstall
   helm uninstall codemie-mcp-connect-service -n codemie

   # Or scale down without uninstalling
   kubectl scale deployment codemie-mcp-connect-service --replicas=0 -n codemie
   ```

   The `codemie-mcp-connect-service` is a core component deployed as part of the standard CodeMie installation. Refer to your cloud-specific components deployment guide for reinstallation steps if needed.

</details>

<details>
<summary><strong>Does CodeMie support human-in-the-loop approval for write actions?</strong></summary>

Human-in-the-loop controls are available within the **Workflows** feature. You can configure approval gates that pause execution and require a human to confirm before the workflow proceeds.

However, mandatory human-in-the-loop is not a platform-wide default — it is configured per-workflow, not enforced automatically for all write actions. Each workflow that performs write operations (creating Jira tickets, modifying Confluence pages, Git operations, etc.) must have an approval node explicitly added to its definition.

</details>

<details>
<summary><strong>How are integration credentials (Jira, Confluence, Git tokens) stored?</strong></summary>

Integration and data source credentials are stored as KMS/Vault-encrypted strings in PostgreSQL. Decryption happens on-demand via KMS/Vault APIs only when an API call requires it. Plaintext credentials exist only in memory for the duration of that call and are never persisted to disk.

By default, only the CodeMie API service has access to the database. No direct human database access is provisioned out of the box.

</details>

<details>
<summary><strong>Can a user access information through the agent that they would not have direct access to?</strong></summary>

It depends on how integrations are configured:

- **Per-user integrations (MCP with user context propagation):** The user's own JWT token is forwarded to the external service via `{{user.token}}` placeholders. Access is bounded by that individual user's permissions on the source system.

- **Shared project-level integrations (Jira, Confluence, Git):** All project members inherit the configured service account's permission scope. A user can effectively access anything the service account can access, regardless of their direct permissions on the source.

For maximum access control, use per-user authentication where possible (e.g., MCP servers with `{{user.token}}`, GitHub App integration) and configure service account credentials with the minimum required permissions scoped to approved sources only.

</details>

<details>
<summary><strong>Does CodeMie enforce per-user access control when retrieving indexed documents?</strong></summary>

No. CodeMie uses a local-first indexing architecture: data from external sources (Jira, Confluence, Git, SharePoint) is fetched using the service credential configured by the customer and stored locally. At retrieval time, the system does not dynamically verify the authenticated user's original permissions on the source — it returns content based on what was accessible to the configured credential at indexing time.

**Practical implication:** For shared projects, the configured service account must only have access to content that all authorized project members are permitted to see. Restrict the service account's scope at the source (Jira project, Confluence space, Git repository) to match the intended audience.

</details>

<details>
<summary><strong>Is LangFuse observability data sent to external cloud services?</strong></summary>

No. LangFuse is deployed exclusively as a self-hosted Kubernetes workload within the CodeMie cluster. All LLM traces, prompt/response data, and analytics remain within the cluster boundary — no data is sent to `langfuse.cloud` or any external LangFuse endpoint.

Integration between CodeMie and LangFuse is handled entirely via internal Kubernetes service DNS.

</details>

<details>
<summary><strong>Can chat history retention be configured?</strong></summary>

Chat history and user profile retention are not configurable in CodeMie. No retention period, purge schedule, or data lifecycle controls are exposed by default.

</details>

<details>
<summary><strong>Does LiteLLM support guardrails for prompt injection or content filtering?</strong></summary>

Yes. LiteLLM supports guardrails natively, including integrations with providers and custom guardrail hooks.

Guardrail configuration is not part of the default CodeMie deployment and must be explicitly configured. Refer to the [LiteLLM guardrails documentation](https://docs.litellm.ai/docs/guardrail_providers) for available options.

</details>

## Getting Help

If you need additional assistance or have questions not covered here:

- **Review Detailed Documentation**: Check the specific deployment guides for your cloud provider
- **Check Component Logs**: Review logs from failing components for detailed error messages
- **Contact Support**: Reach out to the AI/Run CodeMie support team with:
  - Detailed description of the issue
  - Relevant error messages or logs
  - Information about your environment and deployment configuration
  - Steps you've already tried
