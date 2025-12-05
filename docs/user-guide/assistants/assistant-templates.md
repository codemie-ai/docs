---
id: assistant-templates
sidebar_position: 1
title: Assistant Templates
description: Pre-built assistant templates for common development and project management tasks
---

# Assistant Templates

AI/Run CodeMie offers a predefined set of assistants tailored to specific roles. These templates are highly recommended for creating effective prompts, as they improve response quality and increase the probability of achieving desired results. Additionally, these templates help users familiarize themselves with assistant functionality.

![Assistant Templates Library](../images/image101.png)

## Available Templates

| Name | Description/Integrated Tools | Assistant's Tools |  
---|---|---  
Epic/User story Compose| The main purpose of this assistant is to analyze and generate requirements for the project.Note: This assistant uses the deprecated Jira tool. It means that it might not work properly. You can uncheck the tool and select the Project Management -> Generic Jira tool in the assistant’s settings instead.| Jira:

  * Create Jira Issue
  * Search Jira Issue
  * Get Jira Projects
  * Update Jira Issue
  * Add Comment to a Jira Issue

  
Release Manager Assistant| The main role is to support users in the release process, generate release notes, close necessary tickets in Jira, and create releases in Jira.| Git:

  * Set Active Branch
  * Update File
  * Create Pull Request
  * Create Branch
  * List Branches In Repo

VCS: 

  * GitLab

Project Management:

  * Generic Jira

  
Junior Python Langchain Developer| The assistant is responsible for contributing to the development of applications and tools within the Langchain framework for creating efficient, reliable language chain applications, incorporating frameworks such as Langchain, Pydantic, and Tiktoken for enhanced functionality and performance.| Git:

  * Set Active Branch
  * Create File
  * Update File
  * Delete File
  * Create Pull Request
  * Create Branch
  * List Branches In Repo

Project Management:

  * Generic Jira

  
Junior Javascript Vue Developer| The assistant is responsible for developing high-quality, dynamic, and responsive web applications using Vue.js.| Git:

  * Set Active Branch
  * Create File
  * Update File
  * Delete File
  * Create Pull Request
  * Create Branch
  * List Branches In Repo

Project Management:

  * Generic Jira

  
Design to Code Developer| The Frontend Developer, design to code expert is responsible for developing high-quality, dynamic, and responsive web applications. This role involves translating designs into real-world applications, optimizing performance to adhere to best practices in frontend development.| VCS: 

  * GitLab

Project Management:

  * Generic Jira

File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
Code Reviewer| The main role of the code reviewer is to review changes in Pull Requests and create comments on its findings.| Git:

  * Get Changes of a Pull Request
  * Create Pull Request Change Comment

  
Google Search Assistant| This assistant is a powerful Internet searcher. It is allowed to use Google, Wikipedia, Web Scrapper, and Tavily search tools. This assistant is optimal for searching the most recent data around the Internet.| Research:

  * Google Search
  * Tavily Search
  * Wikipedia
  * Web Scraper

  
ChatGPT| This is a simple chatbot. This is an alternative to ChatGPT.| No assistant tools included.  
Project Onboarding Assistant| This is a simple chatbot over your own project specific knowledge base, e.g. knowledge base or code repository. This is useful when you want to ask questions about your codebase, knowledge base or project specific questions.| No assistant tools included. Requires adding a data source for proper work.  
Cloud Assistant| Prebuilt Cloud Assistant. The main role is to help with cloud systems development and interactions.| Cloud:

  * Kubernetes
  * AWS
  * GCP
  * Azure

  
Confluence Assistant| This one can help with Confluence operations, like smart search, page creation, etc.| Project Management:

  * Generic Confluence

  
CSV Analyst| This assistant can help you to analyze and get data from attached CSV files.| No assistant tools included.  
Local Developer via Plugin Engine| Developer who can implement changes on local machines via AI/Run CodeMie Plugin Engine.| Plugin:

  * Plugin

  
Local Developer via Plugin Engine(Diff)| Developer who can implement changes on local machines via CodeMie Plugin Engine. Uses a diff approach. Local| Plugin:

  * Plugin

  
Sonar Issues Retriever| CodeMie Sonar Assistant. This assistant can help you to retrieve sonar scanner results and give descriptive and readable output.| Codebase Tools:

  * Sonar

  
QA Checklist Assistant| Checklist generator for QA activities.| Project Management:

  * Generic Confluence
  * Generic Jira

  
QA Test Case Assistant| Test case generator for QA activities.| Project Management:

  * Generic Confluence
  * Generic Jira

  
CodeMie AQA Test Case Assistant| Can analyze backend applications in order to write test cases in autotest repository.| Git:

  * Create Branch
  * Set Active Branch
  * List Branches In Repo
  * Create File
  * Update File
  * Delete File
  * Create Pull Request

VCS: 

  * GitLab

  
CodeMie FAQ| This is a smart AI/Run CodeMie assistant which can help you with the onboarding process. AI/Run CodeMie can answer all your questions about capabilities, usage and so on.| No assistant tools included.  
CodeMie AQA UI Automation Test Creator| This assistant is created for complex solutions for building UI automation tests. It took context from the repository and continue to cover other test cases.| Git:

  * Create Branch
  * Set Active Branch
  * List Branches In Repo
  * Create File
  * Update File
  * Delete File
  * Create Pull Request

VCS: 

  * GitLab

Project Management:

  * Generic Jira

  
GitLab CI/CD Assistant| The main role is to help with generating YAML configuration for GitLab CI/CD. For more details, familiarize yourself with the [video tutorial](https://www.google.com/url?q=https://videoportal.epam.com/video/mYR34dBJ&sa=D&source=editors&ust=1764354749040655&usg=AOvVaw3iFGx35hzhTr2DQPhIqsvr) on how the assistant works.| Plugin:

  * Plugin

  
AI/Run Feedback| AI/Run CodeMie assistant to report bugs and improvements into AI/Run CodeMie Jira.| Project Management:

  * Generic Jira

  
CodeMie Back-end Local Unit Tester| Unit Test Assistant for AI/Run CodeMie. This assistant can help you to test your code. Please note that this assistant is designed solely for local usage.| File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
CodeMie Front-end Local Unit Tester| Unit Test Assistant for AI/Run CodeMie. This assistant can help you to test your code. Please note that this assistant is designed solely for local usage.| File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
CodeMie UI Local Developer| This assistant is a Vue.js and front-end software engineer and developer who can help you develop your UI. Please note that this assistant is designed solely for local usage. | File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
Junior Python Langchain Developer with Local File System| This one is responsible for contributing to the development of applications and tools within the Langchain framework. Please note that this assistant is designed solely for local usage.| VCS: 

  * GitLab

Project Management:

  * Generic Jira

File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
Junior Javascript Vue Developer with Local File System| This one is responsible for developing high-quality, dynamic, and responsive web applications using Vue.js. Please note that this assistant is designed solely for local usage.| VCS: 

  * GitLab

Project Management:

  * Generic Jira

File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
CodeMie Back-end Local Developer| This assistant can help you to develop your back end. Please note that this assistant is designed solely for local usage.| File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
Unit Tester| It's required to have "LangGraph Unit Test" included to name.| Project Management:

  * Generic Jira

File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

  
CodeMie AQA Test Case Assistant (With BE Code)| This assistant can analyze backend (BE) applications in order to write test cases in autotest repositories.| Git:

  * Set Active Branch
  * Create File
  * Update File
  * Delete File
  * Create Pull Request
  * Create Branch
  * List Branches In Repo

VCS: 

  * GitLab

  
CodeMie AQA Test Case Assistant (With OpenAPI Spec.)| This assistant can analyze OpenAPI specifications in order to write test cases in the autotest repository.| Git:

  * Set Active Branch
  * Create File
  * Update File
  * Delete File
  * Create Pull Request
  * Create Branch
  * List Branches In Repo

VCS:

  * GitLab

  
CodeMie AQA UI Automation Test Creator| This assistant is created for complex solutions for building UI automation tests. It took context from the repository and continued to cover other test cases.| Git:

  * Set Active Branch
  * Create File
  * Update File
  * Delete File
  * Create Pull Request
  * Create Branch
  * List Branches In Repo

VCS: 

  * GitLab

Project Management:

  * Generic Jira

  
CodeMie Test Automation Based On AC Workflow| This assistant is aimed to create solutions converting acceptance criteria from ticket to BDD autotest scenarios.| Git:

  * Set Active Branch
  * Create File
  * Update File
  * Delete File
  * Create Pull Request
  * Create Branch
  * List Branches In Repo

VCS: 

  * GitLab

Project Management:

  * Generic Jira

  
HTML Generating Assistant| The main role is to generate an HTML responsive format for a newsletter email using the provided text from the user and following best marketing techniques.| Project Management:

  * Generic Jira

  
Design to Code Developer| The Frontend Developer, design to code expert is responsible for developing high-quality, dynamic, and responsive web applications. This role involves translating designs into real-world applications, optimizing performance to adhere to best practices in frontend development.| VCS: 

  * GitLab

File Management:

  * Read file
  * Write file
  * List directory
  * Run command line

Project Management:

  * Generic Jira

  
Email Sending Assistant| Specializes in sending emails, as e.g. release updates newsletters to provide a timely communication to the users on the latest AI/Run CodeMie updates.| Notification: 

  * Email

  
Hotfix Summarizer| The main role is to generate a summary of the updates made within hotfixes delivered in addition to the main AI/Run CodeMie product release.| Project Management:

  * Generic Jira

  
Release Summary Writer| The main role is to generate a summary of the AI/Run CodeMie product release to prepare a newsletter for the users.| Project Management:

  * Generic Jira