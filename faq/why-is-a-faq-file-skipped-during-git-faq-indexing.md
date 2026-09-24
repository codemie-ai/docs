# Why is a FAQ file skipped during Git FAQ indexing?

A `.md` file in a Git FAQ data source is skipped on its own when it has a problem — the rest of the files still get indexed normally. This usually happens when:

- The optional settings block at the top of the file (the part between two lines of `---`) is not written correctly.
- That settings block is written as a list instead of individual settings.
- The file is empty once the settings block is removed.
- The file's content cannot be read as text at all (rare — usually a corrupted file).

**The most common cause**: a description or instructions line in the settings block contains a colon followed by a space, without quotes around it — for example `description: Examples: see the guide at <url>`. That second colon confuses the formatting rules and the whole file gets rejected as invalid.

**Fix**: put quotes around the value, for example `description: "Examples: see the guide at <url>"`.

A single bad file never stops the whole data source from being created — only if every file has a problem does the setup fail completely, which is a sign to check the repository content or the Files Filter rather than one file's formatting.

## Sources

- [Add and Index Git Data Sources](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-git-data-sources#why-a-faq-file-might-get-skipped)
