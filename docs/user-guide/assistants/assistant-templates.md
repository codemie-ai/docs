---
id: assistant-templates
sidebar_position: 1
title: Assistant Templates
---

# Assistant Templates

AI/Run CodeMie offers a predefined set of assistants tailored to specific roles. It is highly recommended to use these templates for creating relevant prompts, as they will improve the quality of responses and increase the probability of achieving satisfactory results. Additionally, these templates help users familiarize themselves with assistant functionality.

![Assistant Templates](../images/image101.png)

## Available Assistant Templates

The following table provides an overview of all available assistant templates, their purposes, and the integrated tools they use:

| Name | Description / Integrated Tools |
|------|-------------------------------|
| **Epic/User Story Compose** | Analyzes and generates requirements for projects.<br/>**Note:** This assistant uses the deprecated Jira tool. It may not work properly. You can uncheck the tool and select **Project Management** → **Generic Jira** in the assistant's settings instead.<br/>**Tools:** Jira: Create Issue, Search Issue, Get Projects, Update Issue, Add Comment |
| **Release Manager Assistant** | Supports users in the release process, generates release notes, closes necessary tickets in Jira, and creates releases.<br/>**Tools:** Git: Set Active Branch, Update File, Create Pull Request, Create Branch, List Branches; VCS: GitLab; Project Management: Generic Jira |
| **Junior Python Langchain Developer** | Contributes to the development of applications and tools within the Langchain framework for creating efficient, reliable language chain applications, incorporating frameworks such as Langchain, Pydantic, and Tiktoken.<br/>**Tools:** Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches; Project Management: Generic Jira |
| **Junior Javascript Vue Developer** | Develops high-quality, dynamic, and responsive web applications using Vue.js.<br/>**Tools:** Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches; Project Management: Generic Jira |
| **Junior Python Langchain Developer with Local File System** | Contributes to the development of applications and tools within the Langchain framework.<br/>**Note:** Designed solely for local usage.<br/>**Tools:** VCS: GitLab; Project Management: Generic Jira; File Management: Read file, Write file, List directory, Run command line |
| **Junior Javascript Vue Developer with Local File System** | Develops high-quality, dynamic, and responsive web applications using Vue.js.<br/>**Note:** Designed solely for local usage.<br/>**Tools:** VCS: GitLab; Project Management: Generic Jira; File Management: Read file, Write file, List directory, Run command line |
| **Design to Code Developer** | Frontend Developer and design-to-code expert responsible for developing high-quality, dynamic, and responsive web applications. Translates designs into real-world applications, optimizing performance to adhere to best practices in frontend development.<br/>**Tools:** VCS: GitLab; Project Management: Generic Jira; File Management: Read file, Write file, List directory, Run command line |
| **Code Reviewer** | Reviews changes in Pull Requests and creates comments on findings.<br/>**Tools:** Git: Get Changes of a Pull Request, Create Pull Request Change Comment |
| **Local Developer via Plugin Engine** | Implements changes on local machines via AI/Run CodeMie Plugin Engine.<br/>**Tools:** Plugin: Plugin |
| **Local Developer via Plugin Engine (Diff)** | Implements changes on local machines via CodeMie Plugin Engine using a diff approach.<br/>**Tools:** Plugin: Plugin |
| **CodeMie Back-end Local Developer** | Helps with back-end development.<br/>**Note:** Designed solely for local usage.<br/>**Tools:** File Management: Read file, Write file, List directory, Run command line |
| **CodeMie UI Local Developer** | Vue.js and front-end software engineer and developer for UI development.<br/>**Note:** Designed solely for local usage.<br/>**Tools:** File Management: Read file, Write file, List directory, Run command line |
| **QA Checklist Assistant** | Generates checklists for QA activities.<br/>**Tools:** Project Management: Generic Confluence, Generic Jira |
| **QA Test Case Assistant** | Generates test cases for QA activities.<br/>**Tools:** Project Management: Generic Confluence, Generic Jira |
| **CodeMie AQA Test Case Assistant** | Analyzes backend applications to write test cases in autotest repository.<br/>**Tools:** Git: Create Branch, Set Active Branch, List Branches, Create/Update/Delete File, Create Pull Request; VCS: GitLab |
| **CodeMie AQA Test Case Assistant (With BE Code)** | Analyzes backend (BE) applications to write test cases in autotest repositories.<br/>**Tools:** Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches; VCS: GitLab |
| **CodeMie AQA Test Case Assistant (With OpenAPI Spec.)** | Analyzes OpenAPI specifications to write test cases in the autotest repository.<br/>**Tools:** Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches; VCS: GitLab |
| **CodeMie AQA UI Automation Test Creator** | Creates complex solutions for building UI automation tests using context from the repository.<br/>**Tools:** Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches; VCS: GitLab; Project Management: Generic Jira |
| **CodeMie Test Automation Based On AC Workflow** | Converts acceptance criteria from tickets to BDD autotest scenarios.<br/>**Tools:** Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches; VCS: GitLab; Project Management: Generic Jira |
| **Unit Tester** | Requires "LangGraph Unit Test" included in name.<br/>**Tools:** Project Management: Generic Jira; File Management: Read file, Write file, List directory, Run command line |
| **CodeMie Back-end Local Unit Tester** | Unit Test Assistant for testing code.<br/>**Note:** Designed solely for local usage.<br/>**Tools:** File Management: Read file, Write file, List directory, Run command line |
| **CodeMie Front-end Local Unit Tester** | Unit Test Assistant for testing code.<br/>**Note:** Designed solely for local usage.<br/>**Tools:** File Management: Read file, Write file, List directory, Run command line |
| **Cloud Assistant** | Prebuilt Cloud Assistant to help with cloud systems development and interactions.<br/>**Tools:** Cloud: Kubernetes, AWS, GCP, Azure |
| **GitLab CI/CD Assistant** | Helps with generating YAML configuration for GitLab CI/CD. For more details, see the video tutorial.<br/>**Tools:** Plugin: Plugin |
| **Sonar Issues Retriever** | Retrieves SonarQube scanner results and provides descriptive and readable output.<br/>**Tools:** Codebase Tools: Sonar |
| **Google Search Assistant** | Powerful Internet searcher using Google, Wikipedia, Web Scraper, and Tavily search tools. Optimal for searching the most recent data on the Internet.<br/>**Tools:** Research: Google Search, Tavily Search, Wikipedia, Web Scraper |
| **ChatGPT** | Simple chatbot - an alternative to ChatGPT.<br/>**Tools:** None |
| **Project Onboarding Assistant** | Simple chatbot for your project-specific knowledge base or code repository. Useful for asking questions about your codebase, knowledge base, or project-specific questions.<br/>**Note:** Requires adding a data source for proper work.<br/>**Tools:** None |
| **CodeMie FAQ** | Smart AI/Run CodeMie assistant for the onboarding process. Answers questions about capabilities, usage, and more.<br/>**Tools:** None |
| **Confluence Assistant** | Helps with Confluence operations, like smart search and page creation.<br/>**Tools:** Project Management: Generic Confluence |
| **CSV Analyst** | Analyzes and extracts data from attached CSV files.<br/>**Tools:** None |
| **HTML Generating Assistant** | Generates HTML responsive format for newsletter emails using provided text, following best marketing techniques.<br/>**Tools:** Project Management: Generic Jira |
| **Email Sending Assistant** | Specializes in sending emails, such as release updates newsletters, to provide timely communication to users about the latest AI/Run CodeMie updates.<br/>**Tools:** Notification: Email |
| **Hotfix Summarizer** | Generates summaries of updates made within hotfixes delivered in addition to the main AI/Run CodeMie product release.<br/>**Tools:** Project Management: Generic Jira |
| **Release Summary Writer** | Generates summaries of AI/Run CodeMie product releases to prepare newsletters for users.<br/>**Tools:** Project Management: Generic Jira |
| **AI/Run Feedback** | Reports bugs and improvements into AI/Run CodeMie Jira.<br/>**Tools:** Project Management: Generic Jira |

## Create Assistant From a Template

To create an assistant from a template, follow the steps below:

### Step 1: Navigate to Templates

On the main page, click the **Assistants** > **Templates** button:

![Templates Navigation](../images/image101.png)

### Step 2: Select a Template

Choose the desired assistant and click the **+** button.

### Step 3: Review Assistant Details

In the Assistant Details menu, you can check:

- **About Assistant**: General information about the assistant
- **System Instructions**: Pre-configured instructions

Click **+ Create Assistant** to proceed.

![Assistant Details](../images/image223.png)

### Step 4: Configure the Assistant

Type the name of the assistant, align System Instructions, and choose necessary integration:

![Configure Assistant](../images/image161.png)

### Step 5: Verify Creation

As soon as the assistant is created, expect it to appear in the Project Assistants menu.

### Step 6: Start a Conversation

Click the assistant's name to start a conversation. Ask something that requires it to leverage the tools it is integrated with.

### Step 7: Manage the Assistant

To edit or delete an assistant, use the dedicated buttons:

![Manage Assistant](../images/image70.png)
