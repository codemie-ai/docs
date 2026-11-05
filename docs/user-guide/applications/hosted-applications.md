---
id: hosted-applications
title: Hosted Applications
sidebar_label: Hosted Applications
sidebar_position: 3
description: Upload a small static web page for presentations, share it with colleagues, and open it inside AI/Run CodeMie
pagination_prev: user-guide/applications/index
pagination_next: null
---

# Hosted Applications

A hosted application is a **small, static web page** that you upload to CodeMie and open from the **Applications** page. It is meant for **presentations**: slides, reports, demos, and visual walkthroughs. It is not an interactive application.

:::info Availability
Your CodeMie administrator turns this feature on. If you see only Platform apps, it is off for your deployment. See [Hosted Applications configuration](../../admin/configuration/codemie/hosted-applications.md).
:::

## What You Can Upload

| Upload type | Limits                                                                                 |
| ----------- | -------------------------------------------------------------------------------------- |
| HTML file   | One `.html` file up to 20 MiB.                                                         |
| ZIP archive | A prebuilt static build up to 100 MiB, 500 MiB unpacked, 5,000 files, 50 MiB per file. |

Use HTML, CSS, JavaScript for display and animation, images, SVG, fonts, audio and video, and bundled JSON or CSV data. CodeMie does not build your project, so run your build locally and upload the output. Bundle every file you need, because nothing is loaded from other sites.

## What It Cannot Do

For security, the page runs in a restricted sandbox:

- no network requests, and no files from CDNs or other sites;
- no forms or data input, because nothing can be submitted;
- no `alert`, `confirm`, or `prompt` dialogs;
- no popups, no navigation away from the page, and no downloads;
- no camera, microphone, location, payments, or full screen;
- no server-side code. Server files, `node_modules`, source maps, and credentials in files are rejected.

## Create and Open

1. Open **Applications** and start a new application.
2. Enter a name and description, optionally choose a folder, and add the file.
3. CodeMie validates the upload and scans it for malware. A rejected version shows the reason. Fix it and upload a new version.
4. Select the application card to open it inside CodeMie. If the embedded view does not work in your browser, use **Open in new tab**.

The viewer header names the publisher, because the content is provided by them and not by CodeMie. CodeMie never asks for your password inside an application.

## Share

New applications are private. The owner can share an application with selected people or with the whole organization. Applications shared with you appear under **Shared**. You can copy the application link and send it to a colleague who has access.

## Versions, Folders, and Trash

- Each upload creates a new version. The owner chooses which accepted version is live.
- Organize applications in folders. Removed applications stay in **Trash** for 30 days.
- Each person can keep up to 500 applications and has a storage quota (2 GiB by default).
