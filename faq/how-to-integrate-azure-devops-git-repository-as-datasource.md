# How to integrate Azure Devops git repository as datasource?

## Step 1: Generate Git Credentials

1. Navigate to [Azure DevOps](https://dev.azure.com/).
2. Select your organization.
3. Go to Repos and choose the specific repository you want to integrate with Codemie-UI.
4. Click on the Clone repository options.
5. Select Generate Git credentials.
6. Copy the Token Name and Token Value generated.
7. Save these credentials securely as you will need them for the integration.

## Step 2: Create Git integrations on Codemie-UI

1. Open Codemie-UI.
2. Go to the Git integrations section.
3. Enter the token values you saved from Azure DevOps:
   - Token Name
   - Token Value
4. Set the URL value as [https://dev.azure.com](https://dev.azure.com/).

## Step 3: Create Datasource

1. In Codemie-UI, navigate to the datasource creation section.
2. Use the URL in the following schema:  
   https://dev.azure.com/{organisationName}/_git/{repoName}
   - Replace {organisationName} with your Azure DevOps organization name.
   - Replace {repoName} with your repository name.
3. Once indexing is complete, you can start using your datasource in Codemie-UI

## Sources

- [Add Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources)
