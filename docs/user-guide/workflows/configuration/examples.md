---
id: examples
title: Complete Examples
sidebar_label: Examples
sidebar_position: 11
---

# Complete Examples

## 11. Complete Examples

### 11.1 Example: Code Review Workflow

This workflow demonstrates an automated code review process that fetches Git changes, analyzes each modified file in parallel, and generates a comprehensive review report.

---

**Complete YAML Configuration:**

```yaml
enable_summarization_node: true
recursion_limit: 100
max_concurrency: 5
messages_limit_before_summarization: 30
tokens_limit_before_summarization: 60000

tools: []

assistants:
  - id: git-analyzer
    system_prompt: |
      You are a Git expert. Use Git MCP tools to analyze repository changes.

      Use git_diff_unstaged or git_log to get change information.
      Parse the diff output and return JSON:
      {
        "changed_files": [
          {"path": "file1.py", "change_type": "modified", "additions": 10, "deletions": 5},
          {"path": "file2.js", "change_type": "added", "additions": 50, "deletions": 0}
        ]
      }
    model: gpt-4.1
    temperature: 0.2
    limit_tool_output_tokens: 70000
    mcp_servers:
      - name: git
        description: Git repository operations
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-git"
            - "--repository"
            - "/workspace/{{repository_path}}"
      - name: mcp-server-filesystem
        description: Filesystem access
        config:
          command: mcp-server-filesystem
          args:
            - "/workspace"

  - id: code-reviewer
    system_prompt: |
      You are an expert code reviewer. Analyze code changes and provide detailed feedback.

      Review criteria:
      - Code quality and maintainability
      - Security vulnerabilities
      - Performance concerns
      - Best practices adherence
      - Test coverage

      Return JSON:
      {
        "file_path": "path/to/file",
        "severity": "high/medium/low",
        "issues": [
          {"type": "security", "line": 42, "description": "...", "recommendation": "..."}
        ],
        "approval_status": "approved/changes_requested/needs_discussion",
        "summary": "brief review summary"
      }
    model: gpt-4.1
    temperature: 0.3
    limit_tool_output_tokens: 70000
    mcp_servers:
      - name: mcp-server-filesystem
        description: Filesystem access
        config:
          command: mcp-server-filesystem
          args:
            - "/workspace"
      - name: sequential-thinking
        description: Sequential thinking for complex analysis
        config:
          command: mcp-server-sequential-thinking

  - id: review-aggregator
    system_prompt: |
      You are a senior engineer aggregating code review results. Create a comprehensive review summary.
    model: gpt-4.1-mini
    temperature: 0.5

  - id: github-commenter
    system_prompt: |
      You are a GitHub integration assistant. Post code review results as PR comments.

      Use GitHub MCP tools to create review comments on the pull request.
    model: gpt-4.1-mini
    temperature: 0.3
    mcp_servers:
      - name: github
        description: GitHub API integration
        config:
          command: /codemie/additional-tools/github-mcp-server/github-mcp-server
          env:
            GITHUB_PERSONAL_ACCESS_TOKEN: "$GITHUB_TOKEN"

states:
  - id: fetch-git-changes
    assistant_id: git-analyzer
    task: |
      Use Git MCP tools to analyze changes between {{base_branch}} and HEAD.

      Get the diff and list of changed files with their modification statistics.
      Return structured JSON with changed_files array.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "changed_files": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "path": {"type": "string"},
                "change_type": {"type": "string"},
                "additions": {"type": "number"},
                "deletions": {"type": "number"}
              }
            }
          }
        },
        "required": ["changed_files"]
      }
    next:
      state_id: review-file
      iter_key: changed_files
      store_in_context: true
      include_in_llm_history: true

  - id: review-file
    assistant_id: code-reviewer
    resolve_dynamic_values_in_prompt: true
    task: |
      Review the code changes in file: {{path}}

      Change type: {{change_type}}
      Lines added: {{additions}}
      Lines deleted: {{deletions}}

      Read the file, analyze the changes, and provide detailed review feedback.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "file_path": {"type": "string"},
          "severity": {"type": "string", "enum": ["high", "medium", "low"]},
          "issues": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "type": {"type": "string"},
                "line": {"type": "number"},
                "description": {"type": "string"},
                "recommendation": {"type": "string"}
              }
            }
          },
          "approval_status": {"type": "string", "enum": ["approved", "changes_requested", "needs_discussion"]},
          "summary": {"type": "string"}
        },
        "required": ["file_path", "severity", "approval_status", "summary"]
      }
    next:
      state_id: generate-final-report
      store_in_context: true
      include_in_llm_history: true

  - id: generate-final-report
    assistant_id: review-aggregator
    task: |
      Generate a comprehensive code review report based on all individual file reviews.

      Include:
      1. Executive summary
      2. Overall approval recommendation
      3. Critical issues requiring immediate attention
      4. Files with changes requested
      5. Approved files
      6. Recommendations for next steps

      Format as a clear, well-structured markdown report.
    next:
      state_id: post-to-github
      store_in_context: true

  - id: post-to-github
    assistant_id: github-commenter
    resolve_dynamic_values_in_prompt: true
    task: |
      Post the code review summary as a comment on GitHub PR #{{pr_number}}

      Repository: {{repository_owner}}/{{repository_name}}

      Review Report:
      {{task}}

      Use GitHub MCP tools to create a PR review comment with this content.
    next:
      state_id: end
```

**Usage:**

```json
{
  "repository_path": "my-project",
  "repository_owner": "acme-corp",
  "repository_name": "backend-api",
  "base_branch": "main",
  "pr_number": "123"
}
```

**Key Features Demonstrated:**

- **Git MCP Server** - Native Git operations instead of shell commands (`git_diff`, `git_log`)
- **GitHub MCP Server** - Automated PR comment posting with review results
- **Iterative processing** with `iter_key: changed_files` for parallel file reviews
- **Dynamic value resolution** with `resolve_dynamic_values_in_prompt: true`
- **Structured output** using `output_schema` for reliable JSON parsing
- **Context flow** from git analysis → file review → report generation → GitHub posting
- **Multiple MCP servers** (Git, GitHub, filesystem, sequential-thinking)
- **Memory management** with summarization enabled for long reviews
- **Real-world integration** demonstrating end-to-end GitHub workflow automation

---

### 11.2 Example: Document Processing Pipeline

This workflow demonstrates a document processing pipeline that extracts text from documents, analyzes content, classifies documents, and generates structured summaries.

---

**Complete YAML Configuration:**

```yaml
enable_summarization_node: true
recursion_limit: 100
messages_limit_before_summarization: 25
tokens_limit_before_summarization: 50000

tools:
  - id: read_file
    tool: read_file
    tool_args:
      path: 'n/a'
    mcp_server:
      name: mcp-server-filesystem
      description: Filesystem operations for reading documents
      config:
        command: npx
        args:
          - "-y"
          - "@modelcontextprotocol/server-filesystem"
          - "/documents"

  - id: store_result
    tool: write_file
    tool_args:
      path: 'n/a'
      content: 'n/a'
    mcp_server:
      name: mcp-server-filesystem
      description: Filesystem operations for writing results
      config:
        command: npx
        args:
          - "-y"
          - "@modelcontextprotocol/server-filesystem"
          - "/documents/output"

assistants:
  - id: content-extractor
    system_prompt: |
      You are a document content extractor. Extract and structure content from documents.

      Return JSON:
      {
        "document_title": "title",
        "document_type": "report/article/manual/other",
        "content_sections": [
          {"heading": "Introduction", "content": "..."},
          {"heading": "Methods", "content": "..."}
        ],
        "metadata": {
          "page_count": 10,
          "word_count": 5000,
          "has_images": true,
          "has_tables": true
        }
      }
    model: gpt-4.1
    temperature: 0.3
    limit_tool_output_tokens: 100000
    mcp_servers:
      - name: google-drive
        description: Google Drive file operations
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-google-drive"
          env:
            GOOGLE_DRIVE_API_KEY: "$GDRIVE_API_KEY"
            GOOGLE_DRIVE_CREDENTIALS: "$GDRIVE_CREDENTIALS"
      - name: mcp-server-filesystem
        description: Local filesystem fallback
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-filesystem"
            - "/documents"

  - id: content-analyzer
    system_prompt: |
      You are a content analysis expert. Analyze document content and extract insights.

      Focus on:
      - Main topics and themes
      - Key findings or conclusions
      - Technical complexity level
      - Target audience
      - Sentiment and tone

      Return JSON with structured analysis results.
    model: gpt-4.1
    temperature: 0.4
    mcp_servers:
      - name: sequential-thinking
        description: Sequential thinking for deep analysis
        config:
          command: mcp-server-sequential-thinking

  - id: document-classifier
    system_prompt: |
      You are a document classification specialist. Classify documents into predefined categories.

      Before classifying, check Memory MCP for similar documents to maintain consistency.

      Categories:
      - Technical Documentation
      - Business Report
      - Research Paper
      - Policy Document
      - User Manual
      - Marketing Material
      - Legal Document

      After classification, store the classification pattern in Memory for future reference.

      Return JSON:
      {
        "primary_category": "category name",
        "confidence": 0.95,
        "secondary_categories": ["category1", "category2"],
        "classification_reasoning": "brief explanation"
      }
    model: gpt-4.1-mini
    temperature: 0.2
    mcp_servers:
      - name: memory
        description: Persistent memory for classification patterns
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-memory"

  - id: summary-generator
    system_prompt: |
      You are an expert technical writer. Generate clear, concise summaries of document analysis.

      Create:
      - Executive summary (2-3 sentences)
      - Key points (bullet list)
      - Detailed summary (1-2 paragraphs)
      - Actionable insights
    model: gpt-4.1-mini
    temperature: 0.6

states:
  - id: extract-content
    assistant_id: content-extractor
    task: |
      Read and extract content from the document at: {{document_path}}

      Parse the document structure, identify sections, and extract all text content.
      Return structured JSON with document metadata and content sections.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "document_title": {"type": "string"},
          "document_type": {"type": "string"},
          "content_sections": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "heading": {"type": "string"},
                "content": {"type": "string"}
              }
            }
          },
          "metadata": {
            "type": "object",
            "properties": {
              "page_count": {"type": "number"},
              "word_count": {"type": "number"},
              "has_images": {"type": "boolean"},
              "has_tables": {"type": "boolean"}
            }
          }
        },
        "required": ["document_title", "document_type", "content_sections", "metadata"]
      }
    next:
      state_id: analyze-content
      store_in_context: true
      include_in_llm_history: true

  - id: analyze-content
    assistant_id: content-analyzer
    task: |
      Analyze the extracted document content.

      Document: {{document_title}}
      Type: {{document_type}}

      Examine all content sections and identify:
      - Main topics and themes
      - Key findings or conclusions
      - Technical complexity (beginner/intermediate/advanced)
      - Target audience
      - Overall sentiment and tone

      Return structured JSON with your analysis.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "main_topics": {"type": "array", "items": {"type": "string"}},
          "key_findings": {"type": "array", "items": {"type": "string"}},
          "complexity_level": {"type": "string", "enum": ["beginner", "intermediate", "advanced"]},
          "target_audience": {"type": "string"},
          "sentiment": {"type": "string", "enum": ["positive", "neutral", "negative", "mixed"]},
          "tone": {"type": "string"}
        },
        "required": ["main_topics", "key_findings", "complexity_level", "target_audience"]
      }
    next:
      state_id: classify-document
      store_in_context: true
      include_in_llm_history: true

  - id: classify-document
    assistant_id: document-classifier
    task: |
      Classify the document based on its content and structure.

      Document: {{document_title}}
      Type: {{document_type}}
      Main topics: {{main_topics}}

      Determine the primary category and any secondary categories.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "primary_category": {"type": "string"},
          "confidence": {"type": "number", "minimum": 0, "maximum": 1},
          "secondary_categories": {"type": "array", "items": {"type": "string"}},
          "classification_reasoning": {"type": "string"}
        },
        "required": ["primary_category", "confidence"]
      }
    next:
      state_id: generate-summary
      store_in_context: true
      include_in_llm_history: true

  - id: generate-summary
    assistant_id: summary-generator
    task: |
      Generate a comprehensive summary based on the document analysis.

      Document Title: {{document_title}}
      Primary Category: {{primary_category}}
      Complexity: {{complexity_level}}
      Main Topics: {{main_topics}}
      Key Findings: {{key_findings}}

      Create a structured summary with:
      1. Executive summary (2-3 sentences)
      2. Key points (bullet list)
      3. Detailed summary (1-2 paragraphs)
      4. Actionable insights or recommendations
    next:
      state_id: save-results
      store_in_context: true

  - id: save-results
    tool_id: store_result
    tool_args:
      path: '/documents/output/{{document_title}}_analysis.json'
      content: |
        {
          "document": "{{document_title}}",
          "category": "{{primary_category}}",
          "confidence": {{confidence}},
          "complexity": "{{complexity_level}}",
          "topics": {{main_topics}},
          "summary": "{{task}}"
        }
    next:
      state_id: end
      store_in_context: false
      include_in_llm_history: false
```

**Usage:**

```json
{
  "document_path": "gdrive://folder_id/technical_report_2025.pdf"
}
```

**Alternative (Local Files):**

```json
{
  "document_path": "/documents/technical_report_2025.pdf"
}
```

**Key Features Demonstrated:**

- **Google Drive MCP** - Read documents directly from Google Drive cloud storage
- **Memory MCP** - Maintain consistent classification patterns across document processing runs
- **Tool states** for file reading and writing operations
- **Agent states** for intelligent content analysis
- **Structured output** using `output_schema` for all analysis states
- **Multi-stage processing** (extract → analyze → classify → summarize)
- **Context flow** with structured data passed between states
- **Sequential thinking MCP** for deep content analysis
- **Persistent learning** using Memory to improve classification accuracy over time
- **JSON schema validation** ensuring reliable data structure
- **Hybrid storage** supporting both cloud (Google Drive) and local filesystem

---

### 11.3 Example: Multi-Branch Processing

This workflow demonstrates a competitive analysis process where multiple competitors are researched in parallel, with results aggregated into a comprehensive comparison report.

---

**Complete YAML Configuration:**

```yaml
enable_summarization_node: true
recursion_limit: 100
max_concurrency: 5
messages_limit_before_summarization: 30
tokens_limit_before_summarization: 60000

tools: []

assistants:
  - id: competitor-identifier
    system_prompt: |
      You are a market research analyst specializing in competitive intelligence.

      Given a company and industry, identify the top competitors.

      Return JSON:
      {
        "competitors": [
          {
            "name": "Company A",
            "website": "https://example.com",
            "market_position": "leader/challenger/niche"
          }
        ]
      }
    model: gpt-4.1
    temperature: 0.4
    mcp_servers:
      - name: brave-search
        description: Privacy-focused web search
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-brave-search"
          env:
            BRAVE_API_KEY: "$BRAVE_API_KEY"

  - id: competitor-researcher
    system_prompt: |
      You are a competitive analyst. Research a competitor and gather detailed intelligence.

      Use Brave Search MCP to find information, then use Puppeteer MCP to scrape competitor websites for:
      - Product offerings and features
      - Pricing strategy
      - Market positioning
      - Strengths and weaknesses
      - Recent news and developments
      - Customer reviews and sentiment

      Return comprehensive JSON with all findings.
    model: gpt-4.1
    temperature: 0.5
    limit_tool_output_tokens: 100000
    mcp_servers:
      - name: brave-search
        description: Web search for competitor information
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-brave-search"
          env:
            BRAVE_API_KEY: "$BRAVE_API_KEY"
      - name: puppeteer
        description: Web scraping for competitor websites
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-puppeteer"
      - name: sequential-thinking
        description: Deep analysis capability
        config:
          command: mcp-server-sequential-thinking
      - name: memory
        description: Track competitive changes over time
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-memory"

  - id: swot-analyzer
    system_prompt: |
      You are a strategic business analyst. Perform SWOT analysis on competitor data.

      For each competitor, analyze:
      - Strengths
      - Weaknesses
      - Opportunities
      - Threats

      Return structured JSON with SWOT analysis.
    model: gpt-4.1
    temperature: 0.3

  - id: comparison-synthesizer
    system_prompt: |
      You are a senior strategy consultant. Synthesize competitive analysis into actionable insights.

      Create:
      - Executive summary
      - Competitive landscape overview
      - Feature comparison matrix
      - Market positioning map
      - Strategic recommendations
      - Risk assessment

      Format as comprehensive markdown report.
    model: gpt-4.1
    temperature: 0.6

states:
  - id: identify-competitors
    assistant_id: competitor-identifier
    task: |
      Identify the top competitors for {{company_name}} in the {{industry}} industry.

      Focus on direct competitors offering similar products/services.
      Include approximately 3-5 main competitors.

      Return JSON with competitor list including name, website, and market position.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "competitors": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "name": {"type": "string"},
                "website": {"type": "string"},
                "market_position": {"type": "string", "enum": ["leader", "challenger", "niche", "emerging"]}
              },
              "required": ["name", "website", "market_position"]
            }
          }
        },
        "required": ["competitors"]
      }
    next:
      state_id: research-competitor
      iter_key: competitors
      store_in_context: true
      include_in_llm_history: true

  - id: research-competitor
    assistant_id: competitor-researcher
    resolve_dynamic_values_in_prompt: true
    task: |
      Conduct comprehensive research on competitor: {{name}}
      Website: {{website}}
      Market Position: {{market_position}}

      Gather intelligence on:
      1. Product portfolio and key features
      2. Pricing strategy and models
      3. Target market and customer segments
      4. Unique value propositions
      5. Strengths and competitive advantages
      6. Weaknesses and vulnerabilities
      7. Recent news, funding, or product launches
      8. Customer reviews and satisfaction

      Use web search extensively to gather current information.
      Return comprehensive JSON with all findings.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "competitor_name": {"type": "string"},
          "products": {"type": "array", "items": {"type": "string"}},
          "pricing": {"type": "object"},
          "market_segment": {"type": "string"},
          "value_propositions": {"type": "array", "items": {"type": "string"}},
          "strengths": {"type": "array", "items": {"type": "string"}},
          "weaknesses": {"type": "array", "items": {"type": "string"}},
          "recent_developments": {"type": "array", "items": {"type": "string"}},
          "customer_sentiment": {"type": "string", "enum": ["very positive", "positive", "neutral", "negative", "very negative"]}
        },
        "required": ["competitor_name", "products", "strengths", "weaknesses"]
      }
    next:
      state_id: perform-swot
      iter_key: competitors
      store_in_context: true
      include_in_llm_history: true

  - id: perform-swot
    assistant_id: swot-analyzer
    resolve_dynamic_values_in_prompt: true
    task: |
      Perform SWOT analysis for: {{competitor_name}}

      Based on research findings:
      Products: {{products}}
      Strengths: {{strengths}}
      Weaknesses: {{weaknesses}}
      Recent Developments: {{recent_developments}}
      Customer Sentiment: {{customer_sentiment}}

      Analyze and return structured SWOT analysis.
    output_schema: |
      {
        "type": "object",
        "properties": {
          "competitor": {"type": "string"},
          "swot": {
            "type": "object",
            "properties": {
              "strengths": {"type": "array", "items": {"type": "string"}},
              "weaknesses": {"type": "array", "items": {"type": "string"}},
              "opportunities": {"type": "array", "items": {"type": "string"}},
              "threats": {"type": "array", "items": {"type": "string"}}
            },
            "required": ["strengths", "weaknesses", "opportunities", "threats"]
          },
          "strategic_notes": {"type": "string"}
        },
        "required": ["competitor", "swot"]
      }
    next:
      state_id: synthesize-comparison
      store_in_context: true
      include_in_llm_history: true

  - id: synthesize-comparison
    assistant_id: comparison-synthesizer
    task: |
      Create a comprehensive competitive analysis report for {{company_name}}.

      You have analyzed multiple competitors with full research, SWOT analysis, and market positioning.

      Synthesize all competitor intelligence into a strategic report including:

      1. Executive Summary
         - Key findings
         - Market landscape overview
         - Competitive intensity assessment

      2. Competitor Profiles
         - Summary of each competitor analyzed
         - Market positioning
         - Key differentiators

      3. Comparative Analysis
         - Feature/capability comparison matrix
         - Pricing comparison
         - Strengths and weaknesses comparison

      4. Market Positioning
         - Competitive positioning map
         - Market gaps and opportunities

      5. Strategic Recommendations
         - Areas for competitive advantage
         - Potential partnership or acquisition targets
         - Market entry or expansion strategies
         - Product/feature development priorities

      6. Risk Assessment
         - Competitive threats
         - Market disruption risks
         - Mitigation strategies

      Format as comprehensive markdown report with clear sections and tables.
    next:
      state_id: save-report
      store_in_context: true

  - id: save-report
    assistant_id: comparison-synthesizer
    task: |
      Save the competitive analysis report to filesystem.

      Report content: {{task}}

      Use mcp-server-filesystem to write the file to /reports/{{company_name}}_competitive_analysis.md
    mcp_servers:
      - name: mcp-server-filesystem
        description: Filesystem for saving reports
        config:
          command: npx
          args:
            - "-y"
            - "@modelcontextprotocol/server-filesystem"
            - "/reports"
    next:
      state_id: end
```

**Usage:**

```json
{
  "company_name": "Acme Corp",
  "industry": "SaaS Project Management"
}
```

**Key Features Demonstrated:**

- **Brave Search MCP** - Privacy-focused web search with structured results
- **Puppeteer MCP** - Automated website scraping for real-time competitor data extraction
- **Memory MCP** - Track competitive changes over time and build intelligence history
- **Parallel competitor analysis** using `iter_key: competitors` for fan-out across multiple competitors
- **Multi-stage iteration** where each competitor goes through research → SWOT → aggregation
- **Context isolation** during parallel processing (each competitor analyzed independently)
- **Context merging** after all parallel branches complete
- **Dynamic value resolution** with `resolve_dynamic_values_in_prompt: true`
- **Sequential thinking** for deep competitive analysis
- **Structured output schemas** ensuring reliable JSON parsing at each stage
- **Memory management** with summarization for long research sessions
- **Persistent intelligence** using Memory to track competitor changes across workflow runs
- **Real-world web automation** demonstrating browser-based data extraction

---

### 11.4 Example: GitHub Webhook Processing with Transform Node

This workflow demonstrates how to process GitHub PR webhook events using Transform Node for fast, deterministic data transformation without LLM calls.

**Complete YAML Configuration:**

```yaml
name: GitHub PR Webhook Processor
description: Process GitHub PR webhooks and route based on labels
mode: Sequential

execution_config:
  custom_nodes:
    - id: transform_pr_event
      custom_node_id: transform_node
      name: Extract PR Labels and Metadata
      config:
        input_source: "context_store"
        input_key: "github_event"

        mappings:
          # Extract basic PR information
          - output_field: "pr_number"
            type: "extract"
            source_path: "number"

          - output_field: "pr_title"
            type: "extract"
            source_path: "pull_request.title"

          - output_field: "pr_author"
            type: "extract"
            source_path: "pull_request.user.login"

          - output_field: "pr_url"
            type: "extract"
            source_path: "pull_request.html_url"

          - output_field: "action"
            type: "extract"
            source_path: "action"

          # Extract all label names from labels array
          - output_field: "label_names"
            type: "array_map"
            source_path: "pull_request.labels"
            item_field: "name"

          # Extract only target branch labels
          - output_field: "target_labels"
            type: "array_map"
            source_path: "pull_request.labels"
            item_field: "name"
            filter_condition: "item.get('name', '').startswith('target-')"

          # Check if WS label exists (references label_names from above)
          - output_field: "has_ws_label"
            type: "condition"
            condition: "'WS' in label_names"
            then_value: true
            else_value: false

          # Check if any target label exists
          - output_field: "has_target_label"
            type: "condition"
            condition: "len(target_labels) > 0"
            then_value: true
            else_value: false

          # Check if PR action is actionable
          - output_field: "is_actionable"
            type: "condition"
            condition: "action in ['opened', 'updated', 'reopened', 'edited']"
            then_value: true
            else_value: false

          # Count total labels
          - output_field: "label_count"
            type: "script"
            script: "len(label_names)"

          # Determine priority
          - output_field: "priority"
            type: "condition"
            condition: "has_ws_label or 'critical' in label_names"
            then_value: "high"
            else_value: "normal"

          # Create human-readable summary
          - output_field: "summary"
            type: "template"
            template: >
              PR #{{ pr_number }}: {{ pr_title }}
              Author: @{{ pr_author }}
              Action: {{ action }}
              Labels: {{ label_names | join(', ') if label_names else 'none' }}
              Priority: {{ priority }}

        # Validate output structure
        output_schema:
          type: "object"
          properties:
            pr_number:
              type: "integer"
            pr_title:
              type: "string"
            pr_author:
              type: "string"
            label_names:
              type: "array"
            has_ws_label:
              type: "boolean"
            has_target_label:
              type: "boolean"
            is_actionable:
              type: "boolean"
            priority:
              type: "string"
            summary:
              type: "string"
          required: ["pr_number", "has_ws_label", "is_actionable"]

        on_error: "fail"

  assistants:
    - id: ws_processor
      system_prompt: |
        You are a specialist in processing PRs with WS label.
        Review the PR changes and ensure compliance with workspace standards.
      model: gpt-4.1
      mcp_servers:
        - name: git
          config:
            command: npx
            args:
              - "-y"
              - "@modelcontextprotocol/server-git"
              - "--repository"
              - "/workspace"

    - id: target_processor
      system_prompt: |
        You are a deployment specialist.
        Review the PR for the target branch and prepare deployment checklist.
      model: gpt-4.1
      mcp_servers:
        - name: git
          config:
            command: npx
            args:
              - "-y"
              - "@modelcontextprotocol/server-git"
              - "--repository"
              - "/workspace"

    - id: default_processor
      system_prompt: |
        You are a code reviewer.
        Review the PR changes and provide feedback.
      model: gpt-4.1-mini
      mcp_servers:
        - name: git
          config:
            command: npx
            args:
              - "-y"
              - "@modelcontextprotocol/server-git"
              - "--repository"
              - "/workspace"

  states:
    # Step 1: Transform webhook event
    - id: transform_event
      custom_node_id: transform_pr_event
      task: "Extract and transform PR event data"
      next:
        state_id: check_actionable
        output_key: "pr_info"
        store_in_context: true

    # Step 2: Check if event is actionable
    - id: check_actionable
      custom_node_id: transform_pr_event
      task: "Verify if PR event requires processing"
      next:
        condition:
          expression: "is_actionable == True"
          then: route_by_labels
          otherwise: skip_processing

    # Step 3: Route based on labels
    - id: route_by_labels
      custom_node_id: transform_pr_event
      task: "Determine processing path based on labels"
      next:
        switch:
          cases:
            # High priority: WS label
            - condition: "has_ws_label == True and priority == 'high'"
              state_id: process_ws_pr

            # Target branch deployments
            - condition: "has_target_label == True"
              state_id: process_target_pr

          # Default processing
          default: process_standard_pr

    # Step 4a: Process WS-labeled PR
    - id: process_ws_pr
      assistant_id: ws_processor
      task: |
        Process PR with WS label:
        {{ summary }}

        Review the changes for workspace compliance.
      next:
        state_id: end

    # Step 4b: Process target-labeled PR
    - id: process_target_pr
      assistant_id: target_processor
      task: |
        Process PR targeting: {{ target_labels | join(', ') }}

        {{ summary }}

        Prepare deployment checklist for target branches.
      next:
        state_id: end

    # Step 4c: Process standard PR
    - id: process_standard_pr
      assistant_id: default_processor
      task: |
        Review PR:
        {{ summary }}

        Provide code review feedback.
      next:
        state_id: end

    # Step 4d: Skip non-actionable events
    - id: skip_processing
      custom_node_id: transform_node
      config:
        input_source: "context_store"
        mappings:
          - output_field: "message"
            type: "constant"
            value: "Event skipped - not actionable"
          - output_field: "action"
            type: "extract"
            source_path: "action"
      next:
        state_id: end
```

**Input Example (GitHub Webhook Payload):**

```json
{
  "action": "opened",
  "number": 15102,
  "pull_request": {
    "html_url": "https://github.com/company/repo/pull/15102",
    "title": "feat(dba): Add Linux support",
    "user": {
      "login": "developer123"
    },
    "labels": [
      {
        "id": 6690698115,
        "name": "target-dev/current",
        "color": "ededed"
      },
      {
        "id": 7347581264,
        "name": "WS",
        "color": "D93F0B"
      }
    ]
  }
}
```

**Transform Node Output:**

```json
{
  "pr_number": 15102,
  "pr_title": "feat(dba): Add Linux support",
  "pr_author": "developer123",
  "pr_url": "https://github.com/company/repo/pull/15102",
  "action": "opened",
  "label_names": ["target-dev/current", "WS"],
  "target_labels": ["target-dev/current"],
  "has_ws_label": true,
  "has_target_label": true,
  "is_actionable": true,
  "label_count": 2,
  "priority": "high",
  "summary": "PR #15102: feat(dba): Add Linux support\nAuthor: @developer123\nAction: opened\nLabels: target-dev/current, WS\nPriority: high"
}
```

**Workflow Execution Flow:**

1. **transform_event**: Transform Node extracts all relevant data
   - Parses PR metadata
   - Extracts label names from array
   - Applies conditional logic
   - Generates summary

2. **check_actionable**: Validates if action requires processing
   - Routes to processing if `is_actionable == true`
   - Skips if action is not relevant (e.g., "closed", "assigned")

3. **route_by_labels**: Routes based on labels
   - High priority → `process_ws_pr` (WS label present)
   - Target deployment → `process_target_pr` (target-\* label)
   - Default → `process_standard_pr`

4. **process\_\*\_pr**: Specialized processing
   - Each processor handles specific PR type
   - Uses Git MCP for repository access
   - Provides targeted feedback

**Key Features Demonstrated:**

- **Transform Node** for fast, deterministic data transformation (no LLM calls)
- **Array processing** with `array_map` to extract label names
- **Filtered array extraction** to get only target labels
- **Sequential field references** - later mappings use earlier results
- **Conditional logic** for boolean checks (has_ws_label, is_actionable)
- **Python expressions** for calculations (label_count)
- **Jinja2 templates** for formatted output (summary)
- **JSON schema validation** to ensure output structure
- **Multi-level routing** with condition → switch for complex decision trees
- **Context preservation** with `store_in_context: true`
- **Dynamic value resolution** in tasks using `{{ }}` syntax
- **Specialized assistants** for different PR types

**Benefits of This Approach:**

1. **Fast Processing**: Transform Node executes in milliseconds (no LLM calls)
2. **Deterministic**: Same input always produces same output
3. **Cost-Effective**: No tokens used for data transformation
4. **Type-Safe**: Output validation ensures correct structure
5. **Maintainable**: Clear, declarative transformation rules
6. **Flexible Routing**: Complex decision trees with conditions and switches

**Use Cases:**

- GitHub/GitLab webhook processing
- Jira webhook handling
- API response transformation
- Event-driven workflow automation
- Multi-condition routing logic
- Data validation and enrichment

---
