# What is the Skills Marketplace? How to publish Skills to Marketplace? How to unpublish Skills? How to browse Marketplace Skills? How to use Marketplace Skills? What are Skill categories?

The Skills Marketplace is a community-driven repository where users can discover, share, and reuse pre-built skills for common use cases.

## Overview

**What is the Marketplace?**

A central hub for:

- **Discovering** public skills created by the community
- **Publishing** your own skills to share with others
- **Reusing** proven patterns and best practices
- **Collaborating** on standardized procedures

**Benefits:**

- ✅ **Faster setup** - Use existing skills instead of creating from scratch
- ✅ **Best practices** - Learn from community expertise
- ✅ **Consistency** - Adopt standardized approaches across organizations
- ✅ **Knowledge sharing** - Contribute your expertise to help others

## Browsing the Marketplace

### Access the Marketplace

1. Navigate to **Skills** in the left panel
2. Select the **Marketplace** tab
3. Browse available public skills

### Skill Categories

Skills in the marketplace are organized by category:

| Category               | Examples                                                       |
| ---------------------- | -------------------------------------------------------------- |
| **Business Analysis**  | JIRA workflows, requirements gathering, stakeholder management |
| **Development**        | Code review, testing, documentation, API design                |
| **DevOps**             | Infrastructure provisioning, deployment, monitoring            |
| **Support**            | Customer communication, troubleshooting, escalation            |
| **Project Management** | Sprint planning, release management, reporting                 |
| **Data Analysis**      | SQL queries, data validation, reporting templates              |
| **Security**           | Security review checklists, compliance procedures              |

> **Note:** Categories are managed at the platform level. Users with admin permissions can create, edit, and delete categories. The category management process is similar to Assistant Categories Management, where administrators can define which categories are available for organizing marketplace content.

### Search and Filter

**Search by name:**

- Enter keywords in the search box
- Example: "JIRA", "AWS", "deployment"

**Filter by category:**

- Select one or more categories
- View only skills matching your domain

## Using Marketplace Skills

### Add Marketplace Skill to Assistant

**Option 1: Clone to Project**

1. Browse Marketplace
2. Find the skill you want
3. Click on the skill to view details
4. Click **Clone to Project**
5. Skill is copied to your Project Skills
6. Attach to assistants as needed

**Option 2: Direct Attach (if supported)**

Some marketplace skills can be attached directly to assistants without cloning.

1. Edit your assistant
2. In Skills section, click **Browse Marketplace**
3. Select marketplace skill
4. Attach to assistant

### Customize Marketplace Skills

After cloning a marketplace skill to your project:

1. Navigate to **Project Skills**
2. Find the cloned skill
3. Click **Edit**
4. Customize:
   - Instructions for your context
   - Required tools
   - Project-specific procedures
5. Save changes

The customized skill is now yours and won't affect the original marketplace skill.

> **Tip:** Marketplace skills provide a starting point. Customize them to fit your organization's specific needs.

## Publishing Skills to Marketplace

### Preparation

Before publishing, ensure your skill:

- ✅ Has a clear, descriptive name
- ✅ Provides detailed description explaining when to use it
- ✅ Includes comprehensive, step-by-step instructions
- ✅ Declares all required tools
- ✅ Uses generic examples (not company-specific secrets)
- ✅ Follows best practices and coding standards

### Publishing Process

**Step 1: Open Publish Dialog**

1. Navigate to **Skills** → **Project Skills**
2. Find the skill to publish
3. Click the **three dots menu** (⋮)
4. Select **Publish to Marketplace**

**Step 2: Select Categories**

In the **Publish to Marketplace** dialog, select at least one category.

**Step 3: Confirm Publication**

1. Click **Publish** in the modal
2. The skill is published to the marketplace

The skill now appears in Project Skills with marketplace visibility and is available for other users to discover and clone.

### Publishing Best Practices

**Clear Documentation:**

```markdown
# AWS Cost Optimization Skill

## Description

Use this skill to analyze and optimize AWS costs by identifying unused
resources, right-sizing instances, and recommending savings opportunities.

## When to Use

- Monthly cost reviews
- Budget overrun investigations
- Infrastructure optimization projects
- Pre-deployment cost estimates

## Instructions

### 1. Analyze Current Spending

Use the AWS tool to retrieve cost and usage data...

(Detailed step-by-step instructions)
```

**Complete Tool Declarations:**

```yaml
Required Tools:
  - AWS # For cost analysis
  - Elasticsearch # For log aggregation
  - Slack # For notifications
```

**Test Before Publishing:**

1. Create test assistant
2. Attach the skill
3. Verify it works as expected
4. Ensure instructions are clear

## Marketplace Skill Quality

### Rating and Feedback

## Users can:

- **Rate skills** (if rating feature enabled)
- **Provide feedback** via comments
- **Report issues** with skills

### Updating Published Skills

To update a marketplace skill you published:

1. Edit the skill in your Project Skills
2. Make changes
3. Save

Changes are reflected in the marketplace immediately.

> **Warning:** Updates to published skills affect all users who have cloned or are using the skill. Make changes carefully and consider versioning strategies.

### Unpublishing Skills

To remove a skill from the marketplace:

**Step 1: Open Remove Menu**

1. Navigate to **Skills** → **Project Skills**
2. Find the published skill
3. Click the **three dots menu** (⋮)
4. Select **Remove from Marketplace**

**Step 2: Confirm Removal**

A confirmation modal will appear explaining that:

- The skill will be removed from the marketplace
- It will still be available in your personal skills

Click **UNPUBLISH** to confirm.

**Result:** The skill is removed from the marketplace but remains in your Project Skills for personal use.

## Contributing to the Community

### Types of Contributions

**1. Foundational Skills**

Basic, widely applicable skills:

- Git workflow procedures
- Documentation templates
- Testing checklists

**2. Domain-Specific Skills**

## Specialized knowledge:

- Healthcare compliance procedures
- Financial data validation
- E-commerce workflows

**3. Tool-Specific Skills**

Focused on particular tools:

- JIRA project setup
- AWS security audit
- Kubernetes troubleshooting

### Contribution Guidelines

**Do:**

- ✅ Create skills with broad applicability
- ✅ Provide clear, detailed instructions
- ✅ Test thoroughly before publishing
- ✅ Use generic examples
- ✅ Declare all required tools

**Don't:**

- ❌ Include company secrets or credentials
- ❌ Publish incomplete or untested skills
- ❌ Use organization-specific terminology
- ❌ Omit tool dependencies

## Sources

- [Marketplace Skills](https://docs.codemie.ai/user-guide/skills/marketplace-skills)
