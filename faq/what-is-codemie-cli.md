# What is CodeMie CLI? How to use CodeMie CLI for AI-assisted development? How to use CodeMie from the command line terminal? How to install Claude Code for command line usage?

CodeMie CLI (`@codemieai/code`) is a unified command-line interface for managing multiple AI coding assistants from a single terminal environment. It serves as an orchestration layer that allows developers to work with various AI agents (Claude Code, Google Gemini, OpenCode) and a built-in LangGraph-based assistant through standardized commands.

### Key Capabilities

**Multi-Agent Management:**

- Switch between different AI coding assistants (Claude Code, Gemini, OpenCode, built-in agent)
- Install and manage specific versions of external agents
- Version control for compatibility (automatic update prevention)

**Provider Flexibility:**

- Support for multiple AI providers: OpenAI, Azure OpenAI, AWS Bedrock, LiteLLM, Ollama
- Enterprise SSO authentication
- Profile-based configuration (work, personal, team profiles)

**Built-in Agent Features:**  
The native CodeMie agent includes:

- File operations (`read_file`, `write_file`, `list_directory`)
- Command execution with progress tracking
- Planning tools (todos, status tracking, progress management)
- Intelligent directory filtering (auto-excludes node_modules, .git)

**Developer Workflow Integration:**

- Interactive conversations with AI agents
- Single-task execution mode
- Code review automation
- CI/CD pipeline integration
- Usage analytics (tokens, costs, tool invocations)

### Installation

**Global Installation (Recommended):**

```bash
npm install -g @codemieai/code
codemie --help
```

**Project-Specific Installation:**

```bash
npm install @codemieai/code
npx @codemieai/code --help
```

Note: Agent shortcuts (`codemie-claude`, `codemie-code`, `codemie-gemini`) require global installation.

### Basic Usage

**Initial Setup:**

```bash
# Interactive configuration wizard
codemie setup

# System health check
codemie doctor
```

**Working with Agents:**

```bash
# Install Claude Code (latest supported version)
codemie install claude --supported

# Use Claude Code
codemie-claude "Review my API implementation"

# Use built-in agent
codemie-code "Analyze this codebase structure"

# Execute single task and exit
codemie --task "Generate unit tests for auth module"
```

**Profile Management:**

```bash
# Manage provider profiles (work, personal, team)
codemie profile

# View analytics
codemie analytics
```

### External Agent Integration

**Claude Code:**

```bash
# Install specific version
codemie install claude 2.1.22

# Install for IDE integration (ACP protocol)
codemie install claude-acp
# Configure in Zed, JetBrains, or Emacs
```

Claude Code includes specialized commands when used through CodeMie CLI:

- `/codemie:codemie-init` — Generate AI-optimized project documentation
- `/codemie:codemie-subagents` — Create project-specific specialized agents
- `/memory-add`, `/memory-refresh` — Capture and update project learnings

**Google Gemini:**

```bash
codemie install gemini
codemie-gemini "Implement REST API with error handling"
```

**OpenCode:**

```bash
codemie install opencode
codemie-opencode "Generate integration tests"

# Process session metrics
codemie opencode-metrics --discover --verbose
```

### Version Management

CodeMie CLI manages agent versions to ensure compatibility:

```bash
# Install latest supported version (recommended)
codemie install claude --supported

# Install specific version
codemie install claude 2.1.22

# Install latest available
codemie install claude
```

Auto-updates are disabled by default. The system notifies you when running a version different from the officially supported one.

### CI/CD Integration

```bash
# Manage automated workflows
codemie workflow \<command>

# Automated code review
# Implement features from issue trackers
# Apply automated fixes
```

### Analytics and Monitoring

```bash
# View comprehensive usage statistics
codemie analytics

# Session tracking
# Token consumption
# Cost analysis
# Tool usage patterns
```

### Comparison with Other CodeMie Tools

| Tool                  | Purpose                | Interface          | Use Case                                   |
| --------------------- | ---------------------- | ------------------ | ------------------------------------------ |
| **CodeMie CLI**       | AI agent orchestration | Terminal/CLI       | Multi-agent development workflows, CI/CD   |
| **codemie-plugins**   | Plugin management      | Python CLI         | MCP server management, development toolkit |
| **JetBrains Plugin**  | IDE integration        | GUI (sidebar)      | In-editor AI assistance                    |
| **VS Code Extension** | IDE integration        | GUI (Copilot Chat) | In-editor AI assistance                    |

### When to Use CodeMie CLI

- Working primarily in terminal environments
- Managing multiple AI agents for different tasks
- Automating development workflows in CI/CD
- Analyzing AI usage patterns across projects
- Profile-based configuration for different contexts
- Scripting and automation scenarios

### When to Use IDE Plugins Instead

- Prefer graphical interface within editor
- Need direct code highlighting and navigation
- Working exclusively in JetBrains or VS Code
- Require sidebar-based conversation history

### Additional Resources

- [GitHub Repository](https://github.com/codemie-ai/codemie-code)
- [NPM Package](https://www.npmjs.com/package/@codemieai/code)
- [Issue Tracker](<[https://github.com/codemie-ai/codemie-code/issues](https://github.com/codemie-ai/codemie-code/issues)>)
