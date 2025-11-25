---
id: ai-code-explorer
sidebar_position: 4
title: AI Code Explorer (AICE)
description: Advanced code analysis and exploration tool
---

# AI Code Explorer (AICE)

Advanced code analysis and exploration tool.

## Features

- Deep code analysis
- Dependency visualization
- Code quality metrics
- Search and navigation enhancement
- Architecture insights

## Use Cases

### Code Understanding

- Analyze complex codebases
- Understand dependency relationships
- Identify architectural patterns

### Quality Assessment

- Measure code complexity
- Identify potential issues
- Track technical debt

### Refactoring Support

- Find refactoring opportunities
- Visualize impact of changes
- Plan code improvements

## Installation

Installation instructions available in the extensions documentation.

## Configuration

### Analysis Scope

Configure what to analyze:

```yaml
aice:
  scope:
    - src/**/*.ts
    - src/**/*.js
  exclude:
    - node_modules
    - dist
    - build
```

### Metrics Collection

Enable specific metrics:

```yaml
aice:
  metrics:
    complexity: true
    coverage: true
    dependencies: true
```

## Using AICE

### Code Analysis

1. Navigate to AICE in the UI
2. Select project or codebase
3. Run analysis
4. Review results and insights

### Dependency Visualization

- Interactive dependency graphs
- Identify circular dependencies
- Track external dependencies

### Search Enhancement

- Semantic code search
- Find similar code patterns
- Navigate by concepts

## Next Steps

- Return to [Extensions Overview](./)
- Configure other extensions
