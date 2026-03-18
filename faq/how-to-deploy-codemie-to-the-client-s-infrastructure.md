# How to deploy CodeMie to the client's infrastructure? Can platform be deployed to AWS, GCP, Azure? What is the cost of infrastructure? Required resources for platform deployment into own infra? LLM usage cost per person or LLM usage per month of the host platform?

AI/Run CodeMie platform is designed for flexible deployment across all major cloud providers:

Cloud Compatibility

- **AWS**: Fully supported with optimized architecture
- **GCP**: Fully supported
- **Azure**: Fully supported
- **On-premise**: Possible with appropriate Kubernetes setup

Deployment Requirements

- **Kubernetes cluster** is required for all deployment scenarios
- Detailed step-by-step deployment guides are available at: [https://epa.ms/codemie-deployment-guide](https://epa.ms/codemie-deployment-guide)

AWS-Specific Deployment  
AWS deployment utilizes several key components:

- **Amazon EKS**: Managed Kubernetes service for application deployment
- **EKS Worker Nodes**: For running containerized applications
- **Load Balancers**: Both Application and Network LBs for traffic management
- **Route 53**: For DNS management
- **NAT Gateway**: Enables internet access for instances without external IP addresses
- **Amazon S3**: For data storage
- **Amazon KMS**: For encryption/decryption of sensitive data
- **IAM Roles**: For secure access management

Infrastructure Requirements (AWS Example)

- **Backend**: 8GB + 4 CPU (2 pods)
- **Frontend**: 128MB + 0.1 CPU
- **Elasticsearch**: 16GB + 4 CPU (2 pods)
- **Kibana**: 1GB + 1 CPU
- **Keycloak + DB**: 4GB + 2 CPU
- **Nginx Ingress Controller**: 1GB + 0.1 CPU
- **OAuth2 Proxy**: 100MB + 0.05 CPU

Cost Estimate

- **AWS**: Approximately $700 per month (without LLM usage)
- **GCP/Azure**: Similar pricing structure with minor variations
- Note: LLM integration costs are additional and depend on usage patterns. Usually it takes $2-$4 per day for users.

Kubernetes Components  
The deployment includes essential services:

- **Nginx Ingress Controller**: Manages external access
- **Keycloak**: Open-source Identity and Access Management
- **OAuth2 Proxy**: Authentication using OAuth2
- **Elasticsearch**: Search and analytics engine
- **Kibana**: Data visualization tool

For detailed deployment assistance or customized infrastructure planning, please contact our support team.

## Sources

- [Overview](https://docs.codemie.ai/admin/deployment/aws/overview)
- [Overview](https://docs.codemie.ai/admin/deployment/gcp/overview)
- [Overview](https://docs.codemie.ai/admin/deployment/azure/overview)
