---
id: assistants-evaluation
sidebar_position: 3
title: Assistants Evaluation
description: Tool for evaluating and benchmarking AI assistant performance
---

# AI/Run CodeMie Assistants Evaluation

Tool for evaluating and benchmarking AI assistant performance.

## Features

- Automated assistant testing
- Performance metrics collection
- Comparative analysis
- Report generation
- Custom evaluation criteria

## Prerequisites

- AI/Run CodeMie deployment
- Access to test datasets
- Evaluation criteria defined
- Storage for evaluation results

## Use Cases

### Quality Assurance

- Test assistant responses for accuracy
- Verify consistency across similar queries
- Validate model performance

### Benchmarking

- Compare different LLM models
- Evaluate prompt engineering changes
- Measure performance improvements

### Regression Testing

- Detect quality degradation
- Monitor performance over time
- Validate updates before deployment

## Installation

Installation instructions and detailed configuration available in the codemie-helm-charts repository.

## Configuration

### Evaluation Criteria

Define custom evaluation criteria:

```yaml
evaluation:
  criteria:
    - name: accuracy
      weight: 0.4
    - name: relevance
      weight: 0.3
    - name: completeness
      weight: 0.3
```

### Test Datasets

Configure test datasets for evaluation:

```yaml
evaluation:
  datasets:
    - name: standard-queries
      path: /data/test-queries.json
    - name: edge-cases
      path: /data/edge-cases.json
```

## Running Evaluations

### Manual Evaluation

Run evaluation manually via UI or CLI.

### Automated Evaluation

Schedule regular evaluations:

```yaml
evaluation:
  schedule: "0 2 * * *"  # Daily at 2 AM
  enabled: true
```

## Reports

Evaluation reports include:

- Overall performance scores
- Detailed metrics per query
- Comparison with baseline
- Recommendations for improvement

## Next Steps

- Return to [Extensions Overview](./)
- Configure other extensions
