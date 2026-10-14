# Why does my xWiki integration return a 404 error?

A 404 error when CodeMie connects to an xWiki instance almost always means the base URL in the integration is missing the path prefix that the xWiki deployment uses.

Most xWiki instances are deployed under `/xwiki`, so the correct base URL is:

```
https://wiki.example.com/xwiki
```

Not:

```
https://wiki.example.com
```

If the instance is configured to serve xWiki at the root (no `/xwiki` prefix), then the root URL is correct and the 404 points to another issue such as network connectivity or a firewall rule.

Check the integration URL, update it to include the correct prefix, and trigger a manual reindex.

## Sources

- [Add and Index xWiki Data Source](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-xwiki-data-source)
