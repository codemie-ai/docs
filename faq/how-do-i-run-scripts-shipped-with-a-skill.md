# How do I run scripts shipped with a Skill? Can Skills include scripts and supporting files? Where are Skill files in the workspace?

Yes. A skill can ship with supporting files, such as scripts, templates, and data, uploaded together with the skill as an archive. When an assistant with such a skill handles its first request in a conversation or workflow run, the files are made available in the workspace under `skills/<skill-name>/`. The assistant can then run the scripts with the script-execution tool, as with any other workspace script.

Skill files are placed in the workspace only when the assistant has the script-execution tool selected, the Code Executor runs in `sandbox-jobs` mode, and the workspace script bridge is switched on for the environment. The main skill instructions (`SKILL.md`) are not copied to the workspace.

Scripts should locate their own files relative to the script location, so they work wherever they are placed.

## Sources

- [Skill Bundles and Workspace Scripts](https://docs.codemie.ai/user-guide/skills/skill-bundles)
