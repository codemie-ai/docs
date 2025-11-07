---
id: maintenance
title: Maintenance and Updates
sidebar_label: Maintenance & Updates
sidebar_position: 10
---

# Maintenance and Updates

## Update AI/Run CodeMie Version

To update AI/Run CodeMie to a new version, follow these steps:

1. **Check the Latest Release**

   Use the script in the codemie-helm-charts repository to check available versions:

   ```bash
   bash get-codemie-latest-release-version.sh -c ./path/to/key.json
   ```

2. **Update Core Components**

   Using the scripted installation method:

   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS=key.json
   gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev

   bash helm-charts.sh --cloud gcp --version x.y.z --mode update
   ```

3. **Verify the Update**

   Check that all pods are running with the new version:

   ```bash
   kubectl get pods -n codemie
   kubectl describe pod <pod-name> -n codemie | grep Image
   ```

4. **Test the Application**
   - Access the AI/Run CodeMie UI
   - Test basic functionality
   - Verify that assistants are working correctly

## AI/Run CodeMie Extensions (Optional)

### LiteLLM Proxy

LiteLLM Proxy provides unified interface for multiple LLM providers.

**Installation steps:**

- Configure LiteLLM proxy settings
- Deploy using helm chart
- Update AI/Run CodeMie configuration to use the proxy

### AI/Run Assistants Evaluation

Evaluation framework for testing and comparing assistant performance.

### AI Code Explorer (AICE)

Advanced code exploration and analysis tool.

### Angular Upgrade Assistant

Specialized assistant for Angular framework upgrades.

### Salesforce DevForce AI

Salesforce-specific development assistant.

---

:::tip
For detailed installation instructions for extensions, refer to the component-specific documentation in the codemie-helm-charts repository.
:::

## Troubleshooting

### Common Issues

**Pods not starting:**

```bash
kubectl logs <pod-name> -n codemie
kubectl describe pod <pod-name> -n codemie
```

**Connection issues:**

- Check ingress configuration
- Verify DNS records
- Check security group/firewall rules

**Performance issues:**

- Review resource limits
- Check Elasticsearch health
- Monitor GKE cluster metrics
