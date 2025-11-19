---
id: sonarqube
title: SonarQube
sidebar_label: SonarQube
---

# SonarQube

Code quality and security analysis tool integration.

AI/Run™ CodeMie supports SonarQube integration mainly for retrieving data through a generic approach, focusing on API requests (GET requests, specifically). This will allow users to get SonarQube projects' data directly from AI/Run™ CodeMie. Consider the case when you ask an AI/Run™ CodeMie assistant to pull information about bugs in a particular project. It displays all the bugs, code vulnerabilities, code smells and suggests solutions to remediate the issues.

To integrate SonarQube with AI/Run™ CodeMie, follow the steps below:

## 1. Generate SonarQube Token

### 1.1 Open SonarQube Account Settings

Open your SonarQube instance. Click your user account icon and select **My account**:

![SonarQube My Account](./images/sonarqube-my-account.png)

### 1.2 Create Security Token

In the account menu, select the Security tab. Specify token parameters and click **Generate**:

- **Name**: Specify your token's name.
- **Type**: Project Analysis Token
- **Project**: Select a SonarQube project that you want an AI assistant to analyze.
- **Expires**: Set appropriate expiry date.

![SonarQube Security Tab](./images/sonarqube-security-tab.png)

### 1.3 Copy Token

Copy the generated token and navigate to the Integrations tab.

## 2. Create Integration in AI/Run™ CodeMie

### 2.1 Navigate to Integrations

In the **User/Project** tab, click **+ Create**:

![Create Integration](./images/sonarqube-create-integration.png)

### 2.2 Specify Integration Parameters

Specify the integration parameters and click **+ Create**:

- **Project**: enter your AI/Run™ CodeMie project name.
- **Credential tool**: Sonar
- **Alias**: Enter integration name
- **SonarQube Server URL**: Specify the URL of your public SonarQube endpoint.
- **Token**: Enter the token data copied earlier.
- **Project name inside Sonar**: Enter the SonarQube project name you want your assistant to analyze. Must be the same as specified when creating your SonarQube token.

![SonarQube Integration Form](./images/sonarqube-integration-form.png)

## 3. Configure Assistant

### 3.1 Enable Sonar Tool

Edit your assistant by enabling the Sonar tool integration and click **Create/Save**:

![SonarQube Assistant Configuration](./images/sonarqube-assistant-config.png)

## 4. Verify Integration

### 4.1 Test Assistant

Verify that your assistant can work with your SonarQube project:

![SonarQube Verification](./images/sonarqube-verification.png)

### 4.2 Get Solutions

Ask the assistant to provide you with solutions to the detected issues.

![SonarQube Solutions](./images/sonarqube-solutions.png)
