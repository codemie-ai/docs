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

1. Open **Applications** and select **Create application**.
2. Choose a project, enter a name and a description, and optionally add a cover image. Turn on **Shared with project** if project members should open it. Add the file.
3. CodeMie validates the upload and scans it for malware. A version moves through **Uploading**, **Queued**, **Checking**, and then **Ready**. A **Rejected** or **Failed** version shows the reason. Fix the problem and upload a new version.
4. A ZIP can stop at **Needs setup**. Confirm the site root, the HTML entry point, and the navigation mode (static pages with hash routing, or a single-page app with history routing), and the version becomes **Ready**.
5. Select the application card to open it inside CodeMie. If the embedded view does not work in your browser, use **Open in new tab**.

The viewer header names the publisher, because the content is provided by them and not by CodeMie. CodeMie never asks for your password inside an application.

## Share

New applications are private. The owner chooses who can open the active version:

- **Project.** Turn on **Shared with project** to let members of the application's project open it. They find it on the **Project** tab.
- **People.** Add colleagues by name in **Share**. They find it on the **Shared with me** tab.
- **Link.** Create a share link in **Share**. Signed-in colleagues who open it get access until the owner revokes the link.
- **Marketplace.** **Publish to Marketplace** lets anyone in your organization open it from the **Marketplace** tab.

People you share with can open the application but cannot edit it. Only internal, signed-in users can open hosted applications.

A platform administrator can suspend an application. While it is suspended, only its owner, project administrators, and platform administrators see it, and it cannot be activated, published, or shared. Sharing is kept and applies again after the application is reinstated.

## Versions and Deletion

- Each upload creates a new version. The owner previews a version and chooses which accepted version is live (**Active version**).
- CodeMie keeps the live version, the version you are working on, and the 10 newest accepted versions. Rejected, failed, and canceled versions are removed after 30 days.
- **My apps** can be filtered by sharing (private, people, project) and by status (draft, published, unpublished).
- Deleting an application removes it and its stored files for good. There is no Trash.
- Each person can keep up to 500 applications and has a storage quota (2 GiB by default) for all versions and covers of the applications they created.
