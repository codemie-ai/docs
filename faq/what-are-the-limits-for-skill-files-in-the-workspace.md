# What are the limits for Skill files in the workspace? Why are some Skill files missing in the workspace? What does the Skill upload warning mean?

Each skill bundle has three limits for files placed in the workspace: 100 files per skill, 10 MB per file, and 50 MB in total (defaults). Files are taken in path order until a limit is reached. The remaining files are skipped, stay readable through the skill tool, and the assistant is told which files are missing.

A bundle over the limits is still accepted. The skill editor shows a warning after the archive is uploaded, naming the files that will not be available in an assistant workspace. Files of older skills that are stored inline in the skill are also not placed in the workspace and must be read through the skill tool.

Files added to a skill after a conversation has started do not appear in that conversation. A new conversation is required.

## Sources

- [Skill Bundles and Workspace Scripts](https://docs.codemie.ai/user-guide/skills/skill-bundles)
