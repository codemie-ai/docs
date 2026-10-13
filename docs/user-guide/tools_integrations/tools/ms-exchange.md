---
id: ms-exchange
title: Microsoft Exchange
sidebar_label: Microsoft Exchange
pagination_prev: user-guide/tools_integrations/tools/overview
pagination_next: null
sidebar_position: 28
---

# Microsoft Exchange

## Overview

The Microsoft Exchange toolkit gives AI/Run CodeMie assistants **read-only** access to a mailbox. Assistants can list folders, read messages, open a single message and extract text from its attachments. They cannot send, move or delete mail.

The toolkit connects to Exchange in one of two ways. You choose the mode explicitly when you create the integration:

| Authentication type                          | Transport                   | Use it for                                                                                   |
| -------------------------------------------- | --------------------------- | -------------------------------------------------------------------------------------------- |
| **OAuth via Microsoft Entra ID Application** | Microsoft Graph             | Exchange Online                                                                              |
| **NTLM**                                     | Exchange Web Services (EWS) | On-premises Exchange, air-gapped environments, or tenants where Entra ID apps are restricted |

In both modes, an identity (an Entra ID application or a service account) authenticates, and the toolkit opens the separate target mailbox that you set in the integration.

## Prerequisites

:::note Required Integration
This tool requires you to have at least one Microsoft Exchange integration configured in AI/Run CodeMie. For more details, please refer to the [Integrations Overview](../integrations/index.md) guidelines.
:::

### OAuth via Microsoft Entra ID Application (Microsoft Graph)

- An app registration in Microsoft Entra ID with a client secret.
- The **application** permission `Mail.Read` on Microsoft Graph, with admin consent granted.

:::warning Mailbox scope
An application-level `Mail.Read` permission grants access to **every mailbox in the tenant**. To restrict the application to specific mailboxes, your Exchange administrator must configure an Exchange **Application Access Policy**.
:::

### NTLM (Exchange Web Services)

- A service account that has the **Full Access** mailbox permission on the target mailbox. The toolkit lists folders from the mailbox root, so Full Access is what it needs. Folder-level delegate rights in Outlook have not been verified to be enough.
- EWS enabled for the service account and for the target mailbox.
- NTLM (Windows authentication) enabled on the EWS virtual directory of the Exchange server.
- Network access from the CodeMie cluster to the Exchange server. See [On-premises Notes (EWS)](#on-premises-notes-ews).

Your Exchange administrator can set up the server side in the Exchange Management Shell:

```powershell
# Full Access for the service account on the target mailbox
Add-MailboxPermission -Identity <mailbox> -User <service-account> -AccessRights FullAccess -InheritanceType All

# EWS enabled for the mailbox
Set-CASMailbox -Identity <mailbox> -EWSEnabled $true

# NTLM (Windows authentication) enabled on the EWS virtual directory
Set-WebServicesVirtualDirectory -Identity "<server>\EWS (Default Web Site)" -WindowsAuthentication $true
```

If EWS or NTLM is turned off, the toolkit reports rejected credentials or denied access. See [Troubleshooting](#troubleshooting).

:::note
If your Exchange server is on an internal network, ask the platform administrator to add its host name or subnet to `EXCHANGE_EWS_ALLOWED_HOSTS`. See [Microsoft Exchange (EWS)](../../../admin/configuration/codemie/api-configuration.md#microsoft-exchange-ews) in the API configuration guide. Until then, the EWS URL is rejected.
:::

## Setting Up Integration

### 1. Navigate to Integrations

- Go to **Integrations**
- Select **User Integrations** or **Project Integrations** based on your needs:
  - **User Integrations**: Available only to you across all projects
  - **Project Integrations**: Shared with all members of the selected project
- Click **+ Create**

### 2. Configure Integration Settings

- **Credential Type**: Select **Microsoft Exchange**
- **Alias**: Provide a descriptive name (e.g., "Support Inbox")
- **Authentication Type**: Select **OAuth via Microsoft Entra ID Application** or **NTLM**
- **Mailbox**: The address of the target mailbox (e.g., `user@example.com`). Required in both modes.

### 3. Set Up Authentication

The form shows only the fields of the selected authentication type, and only those fields are required.

**OAuth via Microsoft Entra ID Application:**

| Field                                        | Description                                         |
| -------------------------------------------- | --------------------------------------------------- |
| **Microsoft Entra ID Tenant**                | The tenant ID of your Microsoft Entra ID directory  |
| **Microsoft Entra ID Application Client ID** | The application (client) ID of the app registration |
| **Microsoft Entra ID Application Secret**    | A client secret of the app registration             |

![Microsoft Exchange integration form with OAuth via Microsoft Entra ID Application](./images/ms-exchange-integration-oauth.png)

**NTLM:**

| Field                        | Description                                                                                                  |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **EWS URL**                  | The direct EWS endpoint, for example `https://mail.contoso.local/EWS/Exchange.asmx`. See [EWS URL](#ews-url) |
| **Service Account Username** | The service account with Full Access to the mailbox, as `DOMAIN\username`, for example `DOMAIN\svc-codemie`  |
| **Service Account Password** | The password of the service account                                                                          |

![Microsoft Exchange integration form with NTLM](./images/ms-exchange-integration-ntlm.png)

:::info Authentication Details
Your sensitive information (the application secret and the service account password) is encrypted for security and displayed in a masked format. When updating non-sensitive information, masked values remain unchanged and secure.
:::

### 4. Save Integration

- Click **+ Save** to store the integration

## Testing the Connection

Use the **Test** button on the integration to check the settings. The test signs in and checks that the Inbox of the target mailbox can be read. An empty Inbox passes the test.

- On success, the message is "Connection and Inbox access verified."

  ![Microsoft Exchange integration test succeeded](./images/ms-exchange-test-connection.png)

- If required fields for the selected authentication type are missing or invalid, the message is "The Exchange connection settings are invalid. Check the required fields for the selected authentication type."
- For any other failure, the test shows one of the fixed messages listed in [Troubleshooting](#troubleshooting).

## Using in Assistants

### 1. Add the Toolkit

When creating or editing an assistant:

- Navigate to **Assistants** section
- Click **+ Create Assistant** or edit an existing one
- In **Available tools**, add **Microsoft Exchange**
- Select your Microsoft Exchange integration from the dropdown

The integration is selected once for the whole toolkit. All four tools use it.

![Available Tools panel with the four Microsoft Exchange tools](./images/ms-exchange-assistant-tools.png)

### 2. Available Tools

All tools are read-only.

| Tool                                 | What it does                                                                                                                                                            |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Exchange: Retrieve folders**       | Lists the mailbox folders with their ID, name, total item count and unread count.                                                                                       |
| **Exchange: Read messages**          | Lists messages in a folder, newest first. Returns ID, subject, sender, received time, read state and whether the message has attachments. Never marks messages as read. |
| **Exchange: Retrieve message by id** | Returns one message by its ID: the summary fields plus To, Cc and the body as plain text.                                                                               |
| **Exchange: Enrich message body**    | Returns the message body plus text extracted from its attachments.                                                                                                      |

**Exchange: Read messages** parameters:

- **folder**: defaults to **Inbox**. Both modes accept:
  - a well-known folder name: `inbox`, `drafts`, `sentitems`, `deleteditems`, `junkemail`, `outbox`, `msgfolderroot` and a few system folders. `archive` (also `clutter` and `scheduled`) works in OAuth mode only;
  - a folder ID, as returned by **Exchange: Retrieve folders**;
  - a folder name, matched case-insensitively.

  The folder list includes subfolders. It is flattened and carries no path, so two folders with the same name are ambiguous: the first match wins. Use the folder ID to pick a specific one.

- **start**: the offset to start from, default `0`.
- **count**: the number of messages to return, default `10`, maximum `50`.

**Exchange: Enrich message body** details:

- Images are processed with OCR. Text is extracted from PDF and DOCX files.
- Only PDF files with a text layer are extracted. A scanned PDF is not OCR-ed, so it returns little or no text and is listed as "text extraction failed".
- Other attachment types, such as XLSX, TXT or EML, are skipped as "unsupported attachment type".
- Limits: at most 10 attachments per message, 10 MB per attachment and 25 MB in total.
- An optional OCR model can be set. If it is not set, the assistant's chat model performs the OCR. That model must be multimodal. If it is not, images are skipped with "text extraction failed".
- Attachments that are not extracted are listed with a short note that explains why they were skipped.

Each request times out after 60 seconds. Temporary failures are retried automatically up to 3 times, and all retries of one call share a 90-second budget:

| Mode  | What is retried                                                                                                                                                         |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| OAuth | Rate limiting (HTTP 429) and server errors (HTTP 5xx). A request that times out after 60 seconds is not retried.                                                        |
| NTLM  | Server-busy and temporary server errors, and timeouts or dropped connections. After a 60-second timeout, the 90-second budget leaves room for at most one more attempt. |

### 3. Example Prompts

```text
List the folders in the mailbox and show how many unread messages each one has.
```

```text
Summarize the 20 newest messages in the Inbox.
```

```text
Open the latest message from billing@example.com and extract the text of its PDF attachments.
```

```text
Find unread messages in the Inbox that have attachments and list their subjects.
```

For a request such as "List the folders of this mailbox, then show the newest 5 messages in the Inbox and classify each one.", the assistant calls **Exchange: Retrieve folders** and then **Exchange: Read messages**:

![Chat with Microsoft Exchange tool calls](./images/ms-exchange-chat-example.png)

## Using in Workflows

A workflow refers to the tools by their technical names, not by the labels shown in the assistant form. Set `integration_alias` to the alias of your Microsoft Exchange integration.

| Technical name              | Arguments                                                                                  |
| --------------------------- | ------------------------------------------------------------------------------------------ |
| `exchange_retrieve_folders` | None                                                                                       |
| `exchange_read`             | `folder` (default `Inbox`), `start` (default `0`), `count` (default `10`, maximum `50`)    |
| `exchange_retrieve_by_id`   | `message_id` (required)                                                                    |
| `exchange_enrich_body`      | `message_id` (required), `ocr_model` (optional name of a multimodal model used for images) |

Example of a tool that reads the newest messages of a folder:

```yaml
tools:
  - id: read-inbox
    tool: exchange_read
    tool_args:
      folder: Inbox
      count: 20
    integration_alias: support-inbox

states:
  - id: fetch-messages
    tool_id: read-inbox
    next:
      state_id: summarize
```

An assistant in a workflow lists the tools under `tools` with `name` and `integration_alias`:

```yaml
assistants:
  - id: mail-assistant
    model: gpt-4.1-mini
    system_prompt: |
      You summarize the mailbox.
    tools:
      - name: exchange_read
        integration_alias: support-inbox
      - name: exchange_enrich_body
        integration_alias: support-inbox
```

For the full workflow syntax, see the [Workflow Configuration Reference](../../workflows/configuration/configuration-reference.md).

## On-premises Notes (EWS)

### EWS URL

- Only `https` is supported. If you enter a bare host name, the connection is made over https.
- URLs that contain embedded credentials are rejected.
- Example: `https://mail.contoso.local/EWS/Exchange.asmx`.
- Autodiscover is not used. Enter the direct EWS endpoint. If the endpoint redirects the request, the toolkit stops with the message "The Exchange endpoint redirected the request. Configure the direct EWS endpoint URL."
- The default placeholder in the form shows the Exchange Online EWS URL. For on-premises Exchange, replace it with your own server's endpoint.

**Address rules.** Before connecting, the toolkit checks where the EWS URL points:

- A host name is resolved (A and AAAA records), and **every** address it resolves to must pass the rules below.
- Loopback, link-local (including `169.254.169.254`), unspecified and multicast addresses are always rejected, and so is `localhost`. The allowlist does not override this.
- Private and other non-public addresses (RFC 1918 ranges, IPv6 ULA, CGNAT and reserved ranges) are rejected unless the platform administrator lists the host name or a matching CIDR in `EXCHANGE_EWS_ALLOWED_HOSTS`. This applies to host names and to IP addresses, so an on-premises server entered by IP address works once its address is covered by a listed CIDR.
- Public addresses are always allowed.
- A rejected address returns "The configured Exchange EWS endpoint is not usable. Check the endpoint URL."
- A host name that does not resolve, or a lookup that takes longer than 5 seconds, returns "The Exchange service is unreachable. Try again later."

Platform administrators must make sure that:

- the EWS host name resolves from the CodeMie cluster;
- egress and firewall rules allow HTTPS from the CodeMie backend pods to the Exchange host, on the port in the EWS URL (443 by default; for example `https://mail.contoso.local:8443/EWS/Exchange.asmx` uses port 8443);
- an Exchange server on a private address is listed in `EXCHANGE_EWS_ALLOWED_HOSTS`. See [Microsoft Exchange (EWS)](../../../admin/configuration/codemie/api-configuration.md#microsoft-exchange-ews).

### TLS / CA Certificate

The certificate of the Exchange server must chain to a CA that the CodeMie backend trusts. There is no field in the integration to upload a certificate or to turn off certificate verification. If the certificate cannot be verified, the toolkit shows "The TLS certificate of the Exchange service could not be verified. Check the endpoint certificate configuration."

If your Exchange server uses a self-signed certificate or one issued by an internal or corporate CA, the platform administrator adds that CA to the `codemie-api` Helm chart:

1. Store the CA certificate (PEM) in a ConfigMap.
2. Mount it into the container with `extraVolumes` and `extraVolumeMounts`.
3. Point the HTTP clients at it with `extraEnv`:
   - `REQUESTS_CA_BUNDLE` is used by `requests`-based clients: EWS (exchangelib), azure-identity and most toolkits.
   - `SSL_CERT_FILE` is used by `httpx`-based clients: the Microsoft Graph SDK, A2A and the OpenAPI tool.

Add these values to the `values.yaml` of the `codemie-api` chart:

```yaml
# 1. ConfigMap — stores the CA certificate
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: exchange-ca-cert
    data:
      exchange-ca.pem: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----

# 2. Volume — exposes the ConfigMap as a volume
extraVolumes: |
  - name: exchange-ca-cert
    configMap:
      name: exchange-ca-cert

# 3. Volume mount — places the certificate next to the system certificates
extraVolumeMounts: |
  - name: exchange-ca-cert
    mountPath: /etc/ssl/certs/exchange-ca.pem
    subPath: exchange-ca.pem
    readOnly: true

# 4. Environment variables — make the HTTP clients trust the certificate
extraEnv:
  - name: REQUESTS_CA_BUNDLE # requests: exchangelib, azure-identity, most toolkits
    value: /etc/ssl/certs/exchange-ca.pem
  - name: SSL_CERT_FILE # httpx: Microsoft Graph SDK, A2A, OpenAPI tool
    value: /etc/ssl/certs/exchange-ca.pem
```

Apply the change with `helm upgrade` and wait for the `codemie-api` pods to restart. The [Customer Feature Configuration](../../../admin/configuration/codemie/customer-feature-configuration.md#how-it-works) guide uses the same ConfigMap and volume pattern.

:::warning The bundle replaces the default trust store
Both variables replace the CA list that the clients trust by default, so they are not added to it. The file must also contain every public CA that the backend needs for its other outbound HTTPS calls, such as LLM providers, Microsoft Entra ID and other integrations. Otherwise those calls fail TLS verification. Put the internal CA and the public CA bundle into the same PEM file.
:::

## Troubleshooting

The toolkit and the **Test** button show fixed messages. Error text from Microsoft is never shown. Search this table for the exact text of the message.

| Message                                                                                                                                                                                                     | Likely cause                                                                                                                                                              | Fix                                                                                                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "The Exchange service account credentials were rejected. Check the configured username and password." (NTLM)                                                                                                | Wrong service account username or password, a username that is not in the `DOMAIN\username` format, or NTLM (Windows authentication) is off on the EWS virtual directory  | Check **Service Account Username** and **Service Account Password**. Ask your Exchange administrator to enable NTLM on the EWS virtual directory. See [NTLM (Exchange Web Services)](#ntlm-exchange-web-services) |
| "Delegate access to the mailbox is denied or the mailbox does not exist." (NTLM)                                                                                                                            | The service account has no Full Access permission on the mailbox, EWS is disabled for the mailbox, or the mailbox is wrong                                                | Grant the **Full Access** mailbox permission to the service account, enable EWS for the mailbox, or correct **Mailbox**. See [NTLM (Exchange Web Services)](#ntlm-exchange-web-services)                          |
| "The configured Exchange EWS endpoint is not usable. Check the endpoint URL."                                                                                                                               | The **EWS URL** is not https or contains credentials, points to `localhost` or a loopback or link-local address, or resolves to a private address that is not allowlisted | Enter the https EWS endpoint. For a private address, ask the platform administrator to add the host name or subnet to `EXCHANGE_EWS_ALLOWED_HOSTS`. See [EWS URL](#ews-url)                                       |
| "The Exchange endpoint redirected the request. Configure the direct EWS endpoint URL."                                                                                                                      | The URL points to a page that redirects, not to the EWS endpoint                                                                                                          | Enter the direct EWS endpoint, for example `https://mail.contoso.local/EWS/Exchange.asmx`                                                                                                                         |
| "The TLS certificate of the Exchange service could not be verified. Check the endpoint certificate configuration."                                                                                          | The server certificate does not chain to a CA the backend trusts                                                                                                          | Ask a platform administrator to add the CA. See [TLS / CA Certificate](#tls--ca-certificate)                                                                                                                      |
| "Administrator consent is missing or was revoked for the required Microsoft Graph permissions." (OAuth)                                                                                                     | Admin consent was not granted for `Mail.Read`, or it was revoked                                                                                                          | Grant admin consent for the application permission in Microsoft Entra ID                                                                                                                                          |
| "The Microsoft Graph client secret has expired. Ask an administrator to issue a new secret." (OAuth)                                                                                                        | The value in **Microsoft Entra ID Application Secret** has expired                                                                                                        | Create a new client secret and update the integration                                                                                                                                                             |
| "The Microsoft Graph client secret is invalid. Check the configured client secret." (OAuth)                                                                                                                 | The value in **Microsoft Entra ID Application Secret** is wrong                                                                                                           | Check that you copied the secret **value**, not the secret ID, and update the integration                                                                                                                         |
| "Access to this mailbox was denied. Check that the app registration has the Mail.Read application permission with administrator consent, and that no Application Access Policy blocks the mailbox." (OAuth) | Microsoft Graph returns the same error when administrator consent for `Mail.Read` is missing and when an Exchange Application Access Policy does not include the mailbox  | Grant admin consent for the `Mail.Read` application permission, and ask your Exchange administrator to add the mailbox to the Application Access Policy                                                           |
| "Microsoft Graph rejected the access token. Retry the request or check the app registration." (OAuth)                                                                                                       | The access token was rejected, for example because of a temporary problem or a misconfigured app registration                                                             | Retry the request. If it keeps failing, check the app registration                                                                                                                                                |
| "The requested OCR model is not available. Omit ocr_model to use the assistant's default model."                                                                                                            | The `ocr_model` argument of **Exchange: Enrich message body** names a model that does not exist or that the project cannot use                                            | Omit `ocr_model`, or use the name of a multimodal model that is available in the project                                                                                                                          |
| "The Exchange service is unreachable. Try again later."                                                                                                                                                     | The host name does not resolve from the cluster, the lookup takes longer than 5 seconds, or DNS, firewall or egress rules block the connection                            | Check that the host resolves from the cluster and that HTTPS egress is allowed on the port of the EWS URL (443 by default)                                                                                        |

Other fixed messages cover an unknown tenant or application, a mailbox that is not found or not enabled for REST, rate limiting, a server that does not respond in time, temporary server errors, and folders or messages that do not exist.

## Limitations

- The toolkit is read-only. It cannot send, move or delete messages.
- IMAP and POP3 are not supported.
- Certificate-based authentication for the Entra ID application is not supported. Use a client secret.
- Autodiscover is not supported. Enter the direct EWS endpoint.
