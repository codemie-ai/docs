# How do I schedule automatic test generation runs with TestMate? What is the TestMate identifier and why should I preserve it in generated tests? How can I customize TestMate prompts for better test generation results? What configuration options are available for TestMate test generation? How do I set up automated test generation in CodeMie using TestMate?

## TestMate - Automated Test Generation Tool

What is TestMate?  
TestMate is an LLM-powered automated test generation tool integrated into CodeMie as a standalone application. It connects to your project Git repository, analyzes the codebase, and uses advanced LLM models to generate comprehensive unit tests automatically.

Key Benefits

- **Automated Test Coverage**: Increases test coverage automatically
- **Enhanced Productivity**: Reduces manual test writing workload
- **Safe Refactoring**: Enables secure refactoring of legacy codebases
- **Accelerated Testing Phase**: Speeds up the overall testing process

How to Access TestMate

1. Navigate to the top menu in CodeMie
2. Look for the new application labeled "TestMate"
3. Click on TestMate to access the tool

Configuration Setup  
TestMate requires several configuration parameters:

Repository Settings

- **Git Repository Location**: Specify your project's Git repository
- **Target Branch**: Select the branch where tests will be generated
- **File Type Exclusions**: Define project paths to exclude from test generation
- **Code Style Guidelines**: Configure your coding standards and guidelines

Test Generation Parameters

- **Initial Parameters**: Set baseline parameters for test generation
- **Unit Test Configuration**: Define unit test, build, and runtime parameters
- **Custom Prompts**: Customize prompts for different phases of test generation

Test Generation Process

1. **Automatic Scheduling**: TestMate runs automatically on scheduled intervals
2. **Manual Execution**: Click the "Run" button for immediate test generation
3. **Processing Time**: Generation time varies based on codebase size (can take several hours for large repositories)
4. **Review Process**: Generated tests appear in a review interface where you can approve, reject, or modify them

Important Guidelines

- **Unique Identifier**: TestMate adds a unique "TestMate" identifier to each test comment - preserve this for tracking and quality purposes
- **Test Review**: Always review generated tests before integration
- **Custom Prompts**: Use the custom prompt feature to refine test generation according to your specific needs

Custom Prompt Configuration  
TestMate supports custom prompt engineering through:

- **Structured Directory System**: Prompts organized in "General", "Generator", and "Planner" directories
- **Phase-specific Customization**: Different prompts for different generation phases
- **Incremental Customization**: Modify only the prompts relevant to your needs

Getting Started

1. Configure your Git repository connection
2. Set up test generation parameters
3. Define exclusion patterns if needed
4. Run your first test generation
5. Review and integrate approved tests
6. Schedule regular automated runs

TestMate represents a significant advancement in automated testing, making high-quality test generation both accessible and efficient for development teams.

## Sources

- [Ai Testmate](https://docs.codemie.ai/user-guide/applications/ai-testmate)
