# How to integrate Kubernetes cluster with CodeMie?

To integrate Kubernetes cluster with CodeMie, follow the steps below(fo example EKS):

1. In AWS cloud:  
    1.1. In the search bar enter EKS and click it, select the necessary cluster from the list.  
   1.2. Navigate Overview > Details and copy API server endpoint (​​https://xxxxxxxxxxxxxxxxxxxxxxxxxxxx..xxxxxxxxxx.eks.amazonaws.com).
2. In Kubernetes cluster use commands below from your terminal to create bearerToken:  
   2.1. cat \<\<EOF | kubectl apply -n kube-system -f -  
    apiVersion: v1  
    kind: ServiceAccount  
    metadata:  
    name: codemie  
    namespace: kube-system  
    EOF  
   2.2. cat \<\<EOF | kubectl apply -n kube-system -f -  
   apiVersion: rbac.authorization.k8s.io/v1  
   kind: ClusterRoleBinding  
   metadata:  
    name: codemie-crb  
   subjects:

- kind: ServiceAccount  
   name: codemie  
   namespace: kube-system  
  roleRef:  
   apiGroup: rbac.authorization.k8s.io  
   kind: ClusterRole  
   name: cluster-admin  
  EOF  
  2.3. cat \<\<EOF | kubectl apply -n kube-system -f -  
  apiVersion: v1  
  kind: Secret  
  metadata:  
   name: codemie-token  
   namespace: kube-system  
   annotations:  
   [kubernetes.io/service-account.name](http://kubernetes.io/service-account.name): codemie  
  type: kubernetes.io/service-account-token  
  EOF  
  2.4. kubectl get -n kube-system secret/codemie-token -o jsonpath='{.data.token}' | base64 --decode  
  2.5. Copy bearerToken.

2. In the CodeMie main menu, click the Integrations button.
3. Select Integration Type: User or Project and click Create
4. Select the Project Name.
5. Select the Credential Type: Kubernetes.
6. Fill in the Alias is a representation of the user setting.
7. Fill in the Kubernetes URL field from 1.2.
8. Fill in the Kubernetes Bearer Token field from 2.5.
9. Click Create Integration.
10. Create or edit assistant.
11. Click Explore Assistant, Click Create Assistant fill in the following parameters:

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Cloud and select from drop down list Kubernetes of credentials from step 6.

12. Click Create.

Query Example: The query example depends on what permissions you give to this service account.

## Sources

- [Kubernetes](https://docs.codemie.ai/user-guide/tools_integrations/tools/kubernetes)
