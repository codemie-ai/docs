# How do I install Kimi Code with CodeMie CLI on Windows?

Run `codemie install kimi` (or `codemie install kimi-acp`) from PowerShell or Command Prompt on Windows 11. Both agents share the same installer. CodeMie CLI downloads the official Kimi PowerShell installer and runs it with Windows-compatible syntax.

Add `--verbose` to see the installation steps. After installation, restart the terminal so the updated `PATH` is picked up, then run `codemie doctor` to verify. If the installation fails with `Installer exited with code 255`, update the CLI with `codemie self-update` and run the installation again.

## Sources

- [CodeMie CLI](https://docs.codemie.ai/user-guide/codemie-cli/)
