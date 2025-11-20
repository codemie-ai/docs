---
id: faq
sidebar_position: 10
title: FAQ
description: Frequently asked questions about AI/Run CodeMie deployment
---

# Frequently Asked Questions

---

### Can I share documentation with external clients?

**Yes**, all documentation including architecture and deployment guides can be shared with external clients.

---

### Why do we need external access to NATS via NLB?

NATS component is part of AI/Run CodeMie Plugin Engine and is used to move tool execution from CodeMie backend to some EXTERNAL environment (local laptop, CI env, etc). Therefore, it's required to have such balancer with TLS certificate and DNS name added.

---

### Client-side approvals for LLMs taking too long. Can we start deploying AI/Run CodeMie and connect LLMs later?

**Yes**, AI/Run CodeMie can be deployed with mock LLM configurations initially. Real configurations can be provided later if client-side approvals require additional time.

---

### We are planning to integrate AI/Run CodeMie with Azure DevOps, GitLab, AWS S3, etc. Do we need to worry about it during deployment phase?

**No**, all integration actions (including supplying credentials) with these services happen after deployment and during actual AI/Run CodeMie usage.

Just ensure that your integration services allow incoming traffic from the AI/Run CodeMie instance's public IP address.

---

### Why do we need to install Keycloak if we already have OKTA, Entra ID, or another custom Identity Provider (IdP)?

Keycloak serves as a middleware identity broker that provides:

- Greater configuration flexibility for our specific needs
- Standardized authentication flow across different IdPs
- Enhanced control over user attributes and roles
- Seamless integration with OAuth2-proxy for application-level authentication

While you can integrate your existing IdP (OKTA, Entra ID, etc.) with Keycloak, having Keycloak as an intermediary layer offers better customization and easier management of authentication flows specific to AI/Run CodeMie.

---

### Terraform fails during infrastructure deployment

**Check the following:**

- Verify AWS credentials are properly configured
- Ensure IAM role has required permissions
- Check AWS quotas and service limits
- Review Terraform logs for specific errors

---

### EKS cluster pods not starting

**Solutions:**

- Verify node groups are properly scaled
- Check pod resource requests match available node capacity
- Review security group and network ACL configurations
- Ensure container images are accessible from the cluster

---

### Applications not accessible via domain

**Solutions:**

- Verify Route53 DNS records are created
- Check ACM certificate status
- Ensure load balancer target groups are healthy
- Verify security group rules allow inbound traffic

---

## Additional Support

For additional support or questions not covered in this FAQ, please contact the AI/Run CodeMie support team or refer to the detailed deployment documentation sections.
