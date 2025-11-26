# 3.1 Assistant Templates

AI/Run CodeMie offers a predefined set of assistants tailored to specific roles. It is highly recommended to use these templates for creating relevant prompts, as they will improve the quality of responses and increase the probability of achieving satisfactory results. Additionally, these templates help users familiarize themselves with assistant functionality.

![Assistant Templates](../images/image101.png)

## Available Assistant Templates

### Development Assistants

#### Epic/User Story Compose

Analyzes and generates requirements for projects.

:::note
This assistant uses the deprecated Jira tool. It may not work properly. You can uncheck the tool and select **Project Management** → **Generic Jira** in the assistant's settings instead.
:::

**Tools:**

- Jira: Create Issue, Search Issue, Get Projects, Update Issue, Add Comment

---

#### Release Manager Assistant

Supports users in the release process, generates release notes, closes necessary tickets in Jira, and creates releases.

**Tools:**

- Git: Set Active Branch, Update File, Create Pull Request, Create Branch, List Branches
- VCS: GitLab
- Project Management: Generic Jira

---

#### Junior Python LangChain Developer

Contributes to the development of applications and tools within the LangChain framework for creating efficient, reliable language chain applications, incorporating frameworks such as LangChain, Pydantic, and Tiktoken.

**Tools:**

- Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches
- Project Management: Generic Jira

---

#### Junior Javascript Vue Developer

Develops high-quality, dynamic, and responsive web applications using Vue.js.

**Tools:**

- Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches
- Project Management: Generic Jira

---

#### Junior Python LangChain Developer with Local File System

Contributes to the development of applications and tools within the LangChain framework.

:::note
Designed solely for local usage.
:::

**Tools:**

- VCS: GitLab
- Project Management: Generic Jira
- File Management: Read file, Write file, List directory, Run command line

---

#### Junior Javascript Vue Developer with Local File System

Develops high-quality, dynamic, and responsive web applications using Vue.js.

:::note
Designed solely for local usage.
:::

**Tools:**

- VCS: GitLab
- Project Management: Generic Jira
- File Management: Read file, Write file, List directory, Run command line

---

#### Design to Code Developer

Frontend Developer and design-to-code expert responsible for developing high-quality, dynamic, and responsive web applications. Translates designs into real-world applications, optimizing performance to adhere to best practices.

**Tools:**

- VCS: GitLab
- Project Management: Generic Jira
- File Management: Read file, Write file, List directory, Run command line

---

#### Code Reviewer

Reviews changes in Pull Requests and creates comments on findings.

**Tools:**

- Git: Get Changes of a Pull Request, Create Pull Request Change Comment

---

#### Local Developer via Plugin Engine

Implements changes on local machines via AI/Run CodeMie Plugin Engine.

**Tools:**

- Plugin: Plugin

---

#### Local Developer via Plugin Engine (Diff)

Implements changes on local machines via CodeMie Plugin Engine using a diff approach.

**Tools:**

- Plugin: Plugin

---

#### CodeMie Back-end Local Developer

Helps with back-end development.

:::note
Designed solely for local usage.
:::

**Tools:**

- File Management: Read file, Write file, List directory, Run command line

---

#### CodeMie UI Local Developer

Vue.js and front-end software engineer and developer for UI development.

:::note
Designed solely for local usage.
:::

**Tools:**

- File Management: Read file, Write file, List directory, Run command line

---

### Quality Assurance Assistants

#### QA Checklist Assistant

Generates checklists for QA activities.

**Tools:**

- Project Management: Generic Confluence, Generic Jira

---

#### QA Test Case Assistant

Generates test cases for QA activities.

**Tools:**

- Project Management: Generic Confluence, Generic Jira

---

#### CodeMie AQA Test Case Assistant

Analyzes backend applications to write test cases in autotest repository.

**Tools:**

- Git: Create Branch, Set Active Branch, List Branches, Create/Update/Delete File, Create Pull Request
- VCS: GitLab

---

#### CodeMie AQA Test Case Assistant (With BE Code)

Analyzes backend (BE) applications to write test cases in autotest repositories.

**Tools:**

- Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches
- VCS: GitLab

---

#### CodeMie AQA Test Case Assistant (With OpenAPI Spec.)

Analyzes OpenAPI specifications to write test cases in the autotest repository.

**Tools:**

- Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches
- VCS: GitLab

---

#### CodeMie AQA UI Automation Test Creator

Creates complex solutions for building UI automation tests using context from the repository.

**Tools:**

- Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches
- VCS: GitLab
- Project Management: Generic Jira

---

#### CodeMie Test Automation Based On AC Workflow

Converts acceptance criteria from tickets to BDD autotest scenarios.

**Tools:**

- Git: Set Active Branch, Create/Update/Delete File, Create Pull Request, Create Branch, List Branches
- VCS: GitLab
- Project Management: Generic Jira

---

#### Unit Tester

Requires "LangGraph Unit Test" included in name.

**Tools:**

- Project Management: Generic Jira
- File Management: Read file, Write file, List directory, Run command line

---

#### CodeMie Back-end Local Unit Tester

Unit Test Assistant for testing code.

:::note
Designed solely for local usage.
:::

**Tools:**

- File Management: Read file, Write file, List directory, Run command line

---

#### CodeMie Front-end Local Unit Tester

Unit Test Assistant for testing code.

:::note
Designed solely for local usage.
:::

**Tools:**

- File Management: Read file, Write file, List directory, Run command line

---

### DevOps & Cloud Assistants

#### Cloud Assistant

Prebuilt Cloud Assistant to help with cloud systems development and interactions.

**Tools:**

- Cloud: Kubernetes, AWS, GCP, Azure

---

#### GitLab CI/CD Assistant

Helps with generating YAML configuration for GitLab CI/CD. For more details, see the video tutorial.

**Tools:**

- Plugin: Plugin

---

### Code Analysis Assistants

#### Sonar Issues Retriever

Retrieves SonarQube scanner results and provides descriptive and readable output.

**Tools:**

- Codebase Tools: Sonar

---

### Research & Information Assistants

#### Google Search Assistant

Powerful Internet searcher using Google, Wikipedia, Web Scraper, and Tavily search tools. Optimal for searching the most recent data on the Internet.

**Tools:**

- Research: Google Search, Tavily Search, Wikipedia, Web Scraper

---

#### ChatGPT

Simple chatbot - an alternative to ChatGPT.

**Tools:** None

---

#### Project Onboarding Assistant

Simple chatbot for your project-specific knowledge base or code repository. Useful for asking questions about your codebase, knowledge base, or project-specific questions.

:::note
Requires adding a data source for proper work.
:::

**Tools:** None

---

#### CodeMie FAQ

Smart AI/Run CodeMie assistant for the onboarding process. Answers questions about capabilities, usage, and more.

**Tools:** None

---

### Project Management Assistants

#### Confluence Assistant

Helps with Confluence operations, like smart search and page creation.

**Tools:**

- Project Management: Generic Confluence

---

### Data Analysis Assistants

#### CSV Analyst

Analyzes and extracts data from attached CSV files.

**Tools:** None

---

### Communication Assistants

#### HTML Generating Assistant

Generates HTML responsive format for newsletter emails using provided text, following best marketing techniques.

**Tools:**

- Project Management: Generic Jira

---

#### Email Sending Assistant

Specializes in sending emails, such as release updates newsletters, to provide timely communication to users about the latest AI/Run CodeMie updates.

**Tools:**

- Notification: Email

---

#### Hotfix Summarizer

Generates summaries of updates made within hotfixes delivered in addition to the main AI/Run CodeMie product release.

**Tools:**

- Project Management: Generic Jira

---

#### Release Summary Writer

Generates summaries of AI/Run CodeMie product releases to prepare newsletters for users.

**Tools:**

- Project Management: Generic Jira

---

### AI/Run CodeMie Platform Assistants

#### AI/Run Feedback

Reports bugs and improvements into AI/Run CodeMie Jira.

**Tools:**

- Project Management: Generic Jira
