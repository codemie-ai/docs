# Can I add a public Git repository as a data source without a Git integration?

Yes. A Git integration is required only for **private repositories**. For public repositories, no integration needs to be configured — AI/Run CodeMie verifies access directly without credentials.

When creating a Git data source, the **Select integration for Git** field can be left empty if the repository is publicly accessible. The platform will probe the repository URL to confirm public access before creating the data source.

If the repository is not publicly accessible and no integration is provided, the data source creation will fail with a **Repository Not Publicly Accessible** error. In this case, either make the repository public or configure a Git integration and select it in the form.

## Sources

- [Add and Index Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources)
