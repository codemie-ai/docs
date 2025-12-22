---
id: integration-capabilities
title: Integration Capabilities
sidebar_label: Integration Capabilities
sidebar_position: 9
---

# Integration Capabilities

## 9. Integration Capabilities

### 9.1 Data Source Integration

Data sources provide assistants with access to indexed knowledge bases, code repositories, documentation, and other structured information. Assistants can automatically search and retrieve relevant information from connected data sources.

#### How Data Source Integration Works

When a datasource is attached to an assistant:

1. **Automatic tool availability**: Assistant gains access to knowledge base search tools
2. **Semantic search**: Assistant can search datasource content using natural language
3. **Context retrieval**: Relevant documents/code are retrieved and provided to the LLM
4. **RAG pattern**: Retrieval-Augmented Generation for accurate, grounded responses

#### Supported Data Sources:

- **Code repositories (Git)**: Source code, documentation, README files
- **Confluence pages**: Wiki content, documentation, team knowledge
- **Jira issues**: Tickets, bugs, feature requests, project data
- **Google Docs**: Documents, spreadsheets, presentations
- **File uploads**: PDF, Word, Text files, images
- **Custom integrations**: API-based data sources

#### Data Source Integration Examples

**Example 1: Code Repository Analysis Workflow**

```yaml
enable_summarization_node: false
recursion_limit: 30

assistants:
  - id: code-expert
    model: gpt-4.1
    system_prompt: |
      You are a senior software engineer with deep knowledge of the codebase.
      Use the code repository datasource to find relevant code and documentation.
      Always reference specific files and line numbers.
    datasource_ids:
      - main-codebase-repo # Git repository indexed as datasource
      - api-documentation # API docs indexed separately
    # Automatic tools available:
    # - search_knowledge_base: Semantic search across code and docs
    # - get_document_by_id: Retrieve specific files

states:
  - id: analyze-bug-report
    assistant_id: code-expert
    task: |
      Analyze this bug report and identify the root cause:
      {{bug_description}}

      Steps:
      1. Search the codebase for relevant code
      2. Review recent changes in affected areas
      3. Identify the likely root cause
      4. Provide fix recommendations with specific file references
    # Assistant automatically uses search_knowledge_base tool
    # to find relevant code in main-codebase-repo
    next:
      state_id: generate-fix-plan

  - id: generate-fix-plan
    assistant_id: code-expert
    task: |
      Based on the root cause analysis, create a detailed fix plan:
      - Files to modify
      - Code changes needed
      - Testing strategy
      - Potential side effects

      Root cause: {{task}}
    next:
      state_id: end
```

**Example 2: Documentation-Powered Support Workflow**

```yaml
assistants:
  - id: support-agent
    model: gpt-4.1
    system_prompt: |
      You are a customer support specialist with access to all product documentation.
      Always cite specific documentation pages when answering questions.
      If information is not in the docs, clearly state that.
    datasource_ids:
      - product-documentation # User guides, API docs
      - confluence-kb # Internal knowledge base
      - faq-database # Frequently asked questions
    temperature: 0.5

states:
  - id: answer-question
    assistant_id: support-agent
    task: |
      Answer this customer question using documentation:
      {{customer_question}}

      Provide:
      1. Direct answer to the question
      2. References to relevant documentation
      3. Step-by-step instructions if applicable
      4. Links to additional resources
    # Assistant searches across all 3 datasources
    # Retrieves relevant documentation
    # Provides grounded, accurate answers
    next:
      state_id: end
```

**Example 3: Multi-Source Research Workflow**

```yaml
assistants:
  - id: research-analyst
    model: gpt-4.1
    system_prompt: |
      You are a research analyst combining information from multiple sources.
      Synthesize information and identify patterns across different data sources.
    datasource_ids:
      - jira-project-tickets # Project management data
      - confluence-requirements # Requirements documentation
      - code-repository # Implementation code
      - google-drive-specs # Technical specifications
    limit_tool_output_tokens: 15000 # Large datasource results

states:
  - id: gather-project-context
    assistant_id: research-analyst
    task: |
      Research project {{project_name}} across all available sources:

      1. Find all related Jira tickets (features, bugs, tasks)
      2. Locate requirements documentation in Confluence
      3. Identify implemented code in the repository
      4. Review technical specs from Google Drive

      Provide a comprehensive project overview with references.
    # Assistant automatically searches all 4 datasources
    # Combines information from different sources
    # Creates unified view
    next:
      state_id: analyze-status

  - id: analyze-status
    assistant_id: research-analyst
    task: |
      Based on the gathered information, analyze project status:

      - Completion percentage
      - Open vs. closed tickets
      - Code coverage of requirements
      - Gaps in implementation
      - Risk areas

      Context: {{task}}
    next:
      state_id: generate-report
```

**Example 4: Context-Aware Code Generation**

```yaml
assistants:
  - id: code-generator
    model: gpt-4.1
    system_prompt: |
      You are an expert code generator with knowledge of the existing codebase.
      Always follow existing patterns, naming conventions, and architectural styles.
      Reference similar existing code when generating new code.
    datasource_ids:
      - codebase-main
      - codebase-tests
      - coding-standards-doc
    temperature: 0.3

states:
  - id: research-existing-patterns
    assistant_id: code-generator
    task: |
      Research existing code patterns for: {{feature_type}}

      Find:
      1. Similar existing implementations
      2. Commonly used libraries/frameworks
      3. Architectural patterns in use
      4. Testing patterns from test codebase
      5. Relevant coding standards
    # Searches across codebase and standards
    next:
      state_id: generate-code

  - id: generate-code
    assistant_id: code-generator
    task: |
      Generate production-ready code for: {{feature_description}}

      Follow these existing patterns: {{task}}

      Requirements:
      - Match existing code style
      - Use same libraries as similar features
      - Include comprehensive tests
      - Add appropriate error handling
    next:
      state_id: end
```

**Example 5: Selective Datasource Access**

```yaml
assistants:
  # Different assistants with different datasource access
  - id: public-doc-assistant
    model: gpt-4.1-mini
    system_prompt: Handle public documentation queries
    datasource_ids:
      - public-docs
      - public-api-docs
    # Only sees public information

  - id: internal-assistant
    model: gpt-4.1
    system_prompt: Handle internal team queries
    datasource_ids:
      - internal-confluence
      - internal-jira
      - internal-code-repos
    # Sees sensitive internal information

states:
  - id: route-query
    assistant_id: classifier
    task: |
      Classify query: {{user_query}}
      Is this public or internal information?
    output_schema: |
      {
        "type": "object",
        "properties": {
          "query_type": {"type": "string", "enum": ["public", "internal"]}
        }
      }
    next:
      condition:
        expression: "query_type == 'public'"
        then: handle-public
        otherwise: handle-internal

  - id: handle-public
    assistant_id: public-doc-assistant
    task: 'Answer query: {{user_query}}'
    # Uses only public datasources
    next:
      state_id: end

  - id: handle-internal
    assistant_id: internal-assistant
    task: 'Answer query: {{user_query}}'
    # Uses internal datasources
    next:
      state_id: end
```

#### Data Source Best Practices

**1. Limit datasources to relevant content:**

```yaml
# Good: Specific, relevant datasources
datasource_ids:
  - backend-codebase      # For backend questions
  - backend-api-docs      # Supporting docs

# Avoid: Too many unrelated datasources
datasource_ids:
  - backend-codebase
  - frontend-codebase
  - mobile-codebase
  - design-docs
  - marketing-materials  # Not relevant for technical questions
```

**2. Use descriptive datasource names:**

- Clear naming helps with debugging and maintenance
- Include scope: `engineering-docs-2024`, `customer-facing-api-docs`

**3. Monitor search quality:**

- Review retrieved documents in workflow logs
- Adjust datasource indexing if results are poor
- Consider datasource size limits (very large repos may need filtering)

**4. Combine with explicit instructions:**

```yaml
system_prompt: |
  Search the {{datasource}} when you need information about:
  - API endpoints and parameters
  - Code implementation details
  - Historical decisions and context

  Do NOT search when:
  - Answering general knowledge questions
  - Providing coding best practices (use your training)
```

**5. Handle missing information gracefully:**

```yaml
system_prompt: |
  If you cannot find relevant information in the datasources, clearly state:
  "I searched the available documentation but couldn't find specific information about X."

  Do NOT make up information or hallucinate answers.
```

### 9.2 Tool Integration

CodeMie Workflows provides extensive built-in tools for cloud platforms, code manipulation, knowledge base integration, and custom plugin development. Tools extend assistant capabilities with specific actions and integrations.

#### Built-in Tool Categories

**Cloud Platform Tools:**

- **AWS**: EC2, ECS, Lambda, S3, CloudFormation, RDS, DynamoDB
- **Azure**: VMs, App Service, Functions, Storage, SQL Database
- **GCP**: Compute Engine, Cloud Functions, Cloud Storage, BigQuery
- **Kubernetes**: Deployments, Services, Pods, ConfigMaps

**Code Tools:**

- **Analysis**: AST parsing, complexity analysis, security scanning
- **Manipulation**: Code generation, refactoring, formatting
- **Testing**: Test generation, coverage analysis
- **Documentation**: Auto-documentation, API spec generation

**Knowledge Base Tools:**

- **Search**: Semantic search, keyword search, filtered search
- **Retrieval**: Document retrieval, code snippet extraction
- **Indexing**: Add/update documents in knowledge bases

**Integration Tools:**

- **IDE Integration**: File operations, navigation, code actions
- **NATS Plugin System**: Custom tool development via message broker
- **HTTP Tools**: REST API calls, webhooks, external service integration

#### Tool Integration Examples

**Example 1: AWS Infrastructure Management Workflow**

```yaml
enable_summarization_node: false
recursion_limit: 25

assistants:
  - id: aws-ops-engineer
    model: gpt-4.1
    system_prompt: |
      You are an AWS operations engineer. Use AWS tools to manage infrastructure.
      Always verify current state before making changes.
      Provide detailed status updates.
    tools:
      - name: aws_ec2_describe_instances
        integration_alias: aws-prod
      - name: aws_ec2_start_instances
        integration_alias: aws-prod
      - name: aws_ec2_stop_instances
        integration_alias: aws-prod
      - name: aws_ecs_list_services
        integration_alias: aws-prod
      - name: aws_ecs_update_service
        integration_alias: aws-prod

states:
  - id: check-current-status
    assistant_id: aws-ops-engineer
    task: |
      Check the current status of EC2 instances in region {{aws_region}}.
      Filter by tag: Environment={{environment}}

      Provide:
      - Total instance count
      - Running vs stopped instances
      - Instance types and sizes
      - Any issues or anomalies
    # Assistant uses aws_ec2_describe_instances tool
    next:
      state_id: scale-decision

  - id: scale-decision
    assistant_id: aws-ops-engineer
    task: |
      Based on current status: {{task}}

      Determine if scaling is needed for target capacity: {{target_capacity}} instances.

      Return JSON: {
        "action": "scale_up|scale_down|no_change",
        "instances_to_start": [],
        "instances_to_stop": []
      }
    output_schema: |
      {
        "type": "object",
        "properties": {
          "action": {"type": "string"},
          "instances_to_start": {"type": "array"},
          "instances_to_stop": {"type": "array"}
        }
      }
    next:
      condition:
        expression: "action != 'no_change'"
        then: execute-scaling
        otherwise: end

  - id: execute-scaling
    assistant_id: aws-ops-engineer
    task: |
      Execute the scaling action: {{action}}

      Start instances: {{instances_to_start}}
      Stop instances: {{instances_to_stop}}

      Verify the changes and report final status.
    # Assistant uses aws_ec2_start_instances and aws_ec2_stop_instances
    next:
      state_id: end
```

**Example 2: Code Analysis and Refactoring Workflow**

```yaml
assistants:
  - id: code-quality-expert
    model: gpt-4.1
    temperature: 0.3
    system_prompt: |
      You are a code quality expert. Use code analysis tools to identify issues.
      Provide specific, actionable refactoring recommendations.
    tools:
      - name: code_analyze_complexity
      - name: code_analyze_security
      - name: code_generate_tests
      - name: code_refactor_extract_method
      - name: code_format
    datasource_ids:
      - main-codebase
    mcp_servers:
      - name: mcp-server-filesystem
        description: File operations
        config:
          command: mcp-server-filesystem
          args:
            - '/workspace'

states:
  - id: analyze-file
    assistant_id: code-quality-expert
    task: |
      Analyze the code file: {{file_path}}

      Use tools to check:
      1. Cyclomatic complexity
      2. Security vulnerabilities
      3. Code smells
      4. Test coverage

      Provide a comprehensive report with severity ratings.
    # Uses: code_analyze_complexity, code_analyze_security
    next:
      state_id: generate-recommendations

  - id: generate-recommendations
    assistant_id: code-quality-expert
    task: |
      Based on analysis: {{task}}

      Generate specific refactoring recommendations:
      - High priority issues to fix
      - Suggested refactorings with code examples
      - Test cases to add
      - Security fixes required

      Rank by impact and effort.
    next:
      state_id: apply-auto-fixes

  - id: apply-auto-fixes
    assistant_id: code-quality-expert
    task: |
      Apply automatic fixes for:
      1. Code formatting
      2. Simple refactorings (extract method, rename variables)
      3. Generate missing tests

      Report what was changed.
    # Uses: code_format, code_refactor_extract_method, code_generate_tests
    next:
      state_id: end
```

**Example 3: Multi-Cloud Resource Discovery**

```yaml
assistants:
  - id: cloud-auditor
    model: gpt-4.1
    system_prompt: |
      You are a cloud infrastructure auditor working across multiple cloud providers.
      Gather resource information and create comprehensive inventory reports.
    tools:
      # AWS tools
      - name: aws_ec2_describe_instances
        integration_alias: aws-prod
      - name: aws_s3_list_buckets
        integration_alias: aws-prod
      # Azure tools
      - name: azure_vm_list
        integration_alias: azure-prod
      - name: azure_storage_list_accounts
        integration_alias: azure-prod
      # GCP tools
      - name: gcp_compute_list_instances
        integration_alias: gcp-prod
      - name: gcp_storage_list_buckets
        integration_alias: gcp-prod

states:
  - id: discover-aws-resources
    assistant_id: cloud-auditor
    task: |
      Discover all AWS resources:
      - EC2 instances
      - S3 buckets

      Collect metadata: names, IDs, regions, tags, sizes.
    next:
      state_id: discover-azure-resources

  - id: discover-azure-resources
    assistant_id: cloud-auditor
    task: |
      Discover all Azure resources:
      - Virtual machines
      - Storage accounts

      Collect metadata: names, IDs, regions, resource groups.
    next:
      state_id: discover-gcp-resources

  - id: discover-gcp-resources
    assistant_id: cloud-auditor
    task: |
      Discover all GCP resources:
      - Compute instances
      - Storage buckets

      Collect metadata: names, IDs, zones, labels.
    next:
      state_id: generate-inventory-report

  - id: generate-inventory-report
    assistant_id: cloud-auditor
    task: |
      Create unified inventory report across all clouds:

      AWS: {{task from discover-aws-resources}}
      Azure: {{task from discover-azure-resources}}
      GCP: {{task from discover-gcp-resources}}

      Provide:
      - Total resource counts by type and provider
      - Cost estimates (if available)
      - Potential optimization opportunities
      - Security concerns
    next:
      state_id: end
```

**Example 4: Knowledge Base Integration Workflow**

```yaml
assistants:
  - id: documentation-manager
    model: gpt-4.1
    system_prompt: |
      You manage documentation knowledge bases.
      Keep documentation up-to-date and well-organized.
    tools:
      - name: kb_search # Search knowledge base
      - name: kb_add_document # Add new documents
      - name: kb_update_document # Update existing docs
      - name: kb_delete_document # Remove outdated docs
    mcp_servers:
      - name: mcp-server-filesystem
        config:
          command: mcp-server-filesystem
          args:
            - '/docs'

states:
  - id: find-outdated-docs
    assistant_id: documentation-manager
    task: |
      Search knowledge base for documentation related to: {{topic}}

      Identify:
      - Outdated information (older than 6 months)
      - Conflicting information
      - Missing documentation
    # Uses kb_search tool
    next:
      state_id: generate-updates

  - id: generate-updates
    assistant_id: documentation-manager
    task: |
      Based on findings: {{task}}

      Generate updated documentation for {{topic}}.
      Include:
      - Current best practices
      - Updated code examples
      - Links to related documentation
    next:
      state_id: update-knowledge-base

  - id: update-knowledge-base
    assistant_id: documentation-manager
    task: |
      Update the knowledge base:

      1. Remove outdated documents (if any)
      2. Add new documentation: {{task}}
      3. Update indexes and cross-references

      Report what was changed.
    # Uses kb_update_document, kb_add_document
    next:
      state_id: end
```

**Example 5: Custom Plugin Integration via NATS**

```yaml
assistants:
  - id: custom-integration-agent
    model: gpt-4.1
    system_prompt: |
      You integrate with custom internal tools via NATS plugin system.
    tools:
      - name: custom_salesforce_query # Custom plugin tool
        integration_alias: salesforce-api
      - name: custom_slack_notify # Custom plugin tool
        integration_alias: slack-webhook
      - name: custom_datadog_metrics # Custom plugin tool
        integration_alias: datadog-api

states:
  - id: query-salesforce
    assistant_id: custom-integration-agent
    task: |
      Query Salesforce for customer: {{customer_id}}

      Retrieve:
      - Account information
      - Recent opportunities
      - Support tickets
    # Uses custom_salesforce_query tool via NATS plugin
    next:
      state_id: analyze-customer-health

  - id: analyze-customer-health
    assistant_id: custom-integration-agent
    task: |
      Analyze customer health based on Salesforce data: {{task}}

      Calculate health score (0-100) based on:
      - Opportunity pipeline
      - Support ticket volume
      - Account age and size
    next:
      state_id: send-alert

  - id: send-alert
    assistant_id: custom-integration-agent
    task: |
      If health score < 60, send alert:

      1. Notify account team via Slack (custom_slack_notify)
      2. Log metric to Datadog (custom_datadog_metrics)
      3. Create follow-up task

      Health score: {{health_score}}
      Customer: {{customer_id}}
    # Uses custom plugin tools
    next:
      state_id: end
```

#### Tool Integration Best Practices

**1. Use integration aliases for credentials:**

```yaml
tools:
  - name: aws_s3_upload
    integration_alias: aws-prod # Credentials managed centrally
  # Avoids hardcoding AWS keys in workflow
```

**2. Limit tool access per assistant:**

```yaml
# Security: Only give necessary tools
assistants:
  - id: read-only-auditor
    tools:
      - name: aws_ec2_describe_instances # ✓ Read-only
      # NO write operations like aws_ec2_terminate_instances
```

**3. Validate tool outputs:**

```yaml
states:
  - id: deploy-with-validation
    assistant_id: deployer
    task: 'Deploy service and verify health checks pass'
    retry_policy:
      max_attempts: 3 # Retry if deployment fails
    next:
      condition:
        expression: "deployment_status == 'healthy'"
        then: success
        otherwise: rollback
```

**4. Use tool result JSON pointers:**

```yaml
tools:
  - id: large-api-response
    tool: http_request
    tool_result_json_pointer: /data/items # Extract only needed data
    # Reduces context size and token usage
```

**5. Combine built-in and custom tools:**

```yaml
tools:
  - name: aws_s3_upload # Built-in AWS tool
  - name: custom_virus_scan # Custom plugin via NATS
  - name: slack_notify # Custom notification plugin


# Workflow: Upload file → Scan for viruses → Notify team
```

### 9.3 MCP (Model Context Protocol) Integration

MCP servers can be integrated with assistants to provide additional tools and capabilities. See Section 3.6 for complete MCP server configuration reference.

```yaml
assistants:
  - id: assistant-1
    mcp_servers:
      - name: filesystem
        enabled: true
        config:
          command: npx
          args: ['-y', '@modelcontextprotocol/server-filesystem', '{{project_root_folder}}']

      - name: database
        enabled: true
        config:
          command: uvx
          args: ['mcp-server-postgres']
          env:
            DATABASE_URL: '{{db_connection_string}}'
        integration_alias: postgres-prod
        resolve_dynamic_values_in_arguments: true
```

For detailed MCP server configuration including HTTP servers, transport types, and all available options, refer to **Section 3.6: MCP Server Configuration**.

---
