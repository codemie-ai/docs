# How do I run development tools with codemie-plugins?

You can run the development toolkit with the codemie-plugins CLI by following these steps:

## Basic usage

Run development toolkit on current directory  
codemie-plugins development run

Run on a specific repository  
codemie-plugins development run --repo-path /path/to/repo

Run with a custom timeout  
codemie-plugins development run --timeout 600

Using environment variables:

On MacOS/Linux:  
REPO_FILE_PATH=/path/to/repo codemie-plugins development run

On Windows:  
$env:REPO_FILE_PATH="C:\path\to\repo"  
codemie-plugins development run

The development toolkit will use the specified repository (or the current directory by default) as the context for analysis and generation tasks.

## Sources

- [Plugin](https://docs.codemie.ai/user-guide/tools_integrations/tools/plugin)
