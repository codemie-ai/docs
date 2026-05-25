# What asset types can I manage with the codemie-sdk skill?

The `codemie-sdk` skill supports full CRUD operations (list, get, create, update, delete)
across seven asset types:

| Asset type               | What it is                                                               |
| ------------------------ | ------------------------------------------------------------------------ |
| **Assistants**           | AI assistants with system prompts, models, and tools                     |
| **Workflows**            | Automated multi-step pipelines                                           |
| **Datasources**          | Indexed knowledge bases (Confluence, Jira, Git, files, SharePoint, etc.) |
| **Integrations**         | Stored credentials for external services                                 |
| **Skills**               | Reusable prompt-based skills                                             |
| **Users**                | Your profile and accessible projects                                     |
| **Assistant Categories** | Labels for organizing assistants in the marketplace (admin only)         |

In addition to basic CRUD, the skill supports skill-specific operations such as
import/export from markdown files, attaching skills to assistants, and publishing to the
marketplace.

## Sources

- [Manage Platform Assets from CLI](https://codemie-ai.github.io/docs/user-guide/codemie-cli/sdk-asset-management)
