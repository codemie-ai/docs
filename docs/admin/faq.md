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

## Authentication & Identity

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

## Getting Help

If you need additional assistance or have questions not covered here:

- **Review Detailed Documentation**: Check the specific deployment guides for your cloud provider
- **Check Component Logs**: Review logs from failing components for detailed error messages
- **Contact Support**: Reach out to the AI/Run CodeMie support team with:
  - Detailed description of the issue
  - Relevant error messages or logs
  - Information about your environment and deployment configuration
  - Steps you've already tried
