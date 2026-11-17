# Why was my hosted application version rejected in CodeMie?

CodeMie checks every uploaded version and rejects it when the files are not safe to serve. Open the application details, open the version menu (**⋮**), and select **Validation details** to see the reason and how to fix it. The most common reasons are:

- a file type that is not allowed, such as source maps (`.map`), `.wasm`, or `.pdf`;
- server or package files, such as `package.json`, `node_modules`, or a `server` folder;
- hidden files, or a credential such as a private key or an access token;
- a text file that is not UTF-8, or an SVG with `DOCTYPE` or entity declarations;
- a ZIP that is damaged, encrypted, too large, or has unsafe paths.

A rejected version cannot be published. Fix the files and upload a new version. A **Failed** version is different: the checks did not finish, and **Retry** starts them again.

## Sources

- [Versions and Validation](https://docs.codemie.ai/user-guide/applications/hosted-applications/versions-and-validation/)
- [Create and Upload a Hosted Application](https://docs.codemie.ai/user-guide/applications/hosted-applications/create-and-upload/)
