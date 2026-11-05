---
id: custom-applications
title: Custom Applications
sidebar_label: Custom Applications
sidebar_position: 3
description: Upload a static web application, share it with colleagues, and open it inside AI/Run CodeMie
pagination_prev: user-guide/applications/index
pagination_next: null
---

# Custom Applications

Custom Applications let you upload a small web application to CodeMie, keep it private or share it, and open it from the **Applications** page without hosting it anywhere else.

:::info Availability
The feature is turned on by your CodeMie administrator. If you see only Platform apps on the Applications page, the feature is off for your deployment. See [Custom Applications configuration](../../admin/configuration/codemie/hosted-applications.md).
:::

## What You Can Upload

| Upload type | Limits                                                                                   |
| ----------- | ---------------------------------------------------------------------------------------- |
| HTML file   | One `.html` file up to 20 MiB.                                                           |
| ZIP archive | A prebuilt static web app up to 100 MiB, 500 MiB unpacked, 5,000 files, 50 MiB per file. |

Only static content is supported: HTML, CSS, JavaScript, images, fonts, and similar files. CodeMie does not build your project and does not run server-side code. Run your build locally or in CI and upload the output folder as a ZIP.

Each person can keep up to 500 applications and 500 folders, and has a storage quota (2 GiB by default) shared by all versions, card covers, and uploads in progress.

## Create an Application

1. Open **Applications** and start a new application (the create dialog is also available at `/apps/new`).
2. Enter a name and description, optionally choose a folder, and add the file.
3. Submit the form. CodeMie uploads the file and checks it.

Every upload is validated before it can be opened. The check inspects the archive structure, paths, file types, and size limits, and scans the content for malware. A version that fails is marked as rejected with a reason, and nobody can open it. Fix the problem and upload a new version.

## Open an Application

Select the application card. It opens inside the CodeMie page. The viewer header names the publisher, because the content is provided by the publisher and not by CodeMie. If the embedded view does not work in your browser, use **Open in new tab**.

:::caution Treat applications like any web page
CodeMie never asks for your password or token inside an application. Do not enter credentials into a form shown inside the viewer. Report suspicious applications to your CodeMie administrator.
:::

## Share an Application

New applications are private. The owner can change who can open an application:

| Audience        | Who can open it                                    |
| --------------- | -------------------------------------------------- |
| Private         | Only the owner.                                    |
| Selected people | The people the owner picked in the sharing dialog. |
| Organization    | Every active CodeMie user of your organization.    |

Applications shared with you appear under **Shared**. An organization-wide application can also be made discoverable, so it appears under **Explore** for everyone. You can copy the application link and send it to a colleague who has access.

## Versions

Each upload creates a new version of the application.

- Choose which accepted version is live. Owners can preview any version before making it live.
- CodeMie keeps the 10 newest accepted versions, plus the live and selected versions.
- Rejected, failed, or canceled versions are removed after 30 days.

## Folders, Trash, and Covers

- Organize your applications in **My folders**, including nested folders.
- Removing an application moves it to **Trash**. You can restore it for 30 days. After that it is deleted permanently, and you can also delete it permanently yourself.
- Set a card cover image (PNG, JPEG, or WebP, up to 1 MiB) to make your application easy to find. The cover counts toward your quota.

## Sign-out and Sessions

An open application session lasts up to 15 minutes at a time and ends immediately when you sign out of CodeMie. If a session ends, reopen the application from the Applications page.

## Troubleshooting

| Problem                                | What to do                                                                                                            |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| The version was rejected               | Open the version details to read the reason. Remove unsupported files or reduce the size and upload again.            |
| Upload is stuck in validation          | Validation is queued. If it stays queued for several minutes, contact your CodeMie administrator.                     |
| The viewer frame is empty              | Use **Open in new tab**. Some browsers block third-party storage in embedded frames.                                  |
| You cannot create or open applications | Your account type may not support the feature (for example service or external accounts). Contact your administrator. |
| Quota exceeded                         | Move unneeded applications to Trash and delete them permanently, or ask your administrator to raise the quota.        |
