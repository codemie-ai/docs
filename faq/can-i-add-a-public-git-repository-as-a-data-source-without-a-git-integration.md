# Can I add a public Git repository as a data source without a Git integration?

Yes. A Git integration is required only for private repositories. For a public repository, leave the **Integration for Git** field empty when creating the data source. AI/Run CodeMie checks that the repository can be reached without credentials and indexes it as usual.

If the repository turns out to require authentication, the data source is not created and a **Repository Not Publicly Accessible** error is shown. Select a Git integration with read access to the repository and save again.

## Sources

- [Add and Index Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources#prerequisites)
