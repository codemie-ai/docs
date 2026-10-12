# Screenshot Guidelines

Rules for every screenshot of the platform UI that goes into the documentation. The `tech-writer` skill checks screenshots against them in Phase 2.5 and again in the QA checklist.

## Capture

- **Show the full screen.** Do not crop. The whole browser or application window is visible, so the reader sees where in the application they are, which page or section is open, and what surrounds the feature, not an isolated fragment of the UI.
- **Use 100% zoom.** No browser or OS display zoom.
- **Use a standard aspect ratio:** 4:3, 16:9, or 16:10. Avoid very wide formats (21:9, 43:18, and similar), which make content hard to read.

## Sensitive data

Blur everything that identifies a person or exposes internal infrastructure before the file is committed:

- names, surnames, usernames, email addresses, avatars
- IP addresses, hostnames, internal URLs, API endpoints
- tokens and any other credentials

A free tool with a built-in blur is [Awesome Screenshot & Screen Recorder](https://chromewebstore.google.com/detail/awesome-screen-recorder-s/nlipoenfbbikpbjkfpfillcgkoblgpmj). Prefer test data (test users, integration aliases such as `jira-a`) where possible, so there is less to blur.

## Highlighting

- To draw attention to a UI element, use an outline with a **2px** stroke.
- Use the brand accent color `#f6823d` for outlines, callouts, and other highlights.

## Files and references

- Store the file in the `images/` folder next to the page, with a descriptive kebab-case name of 3–5 words (`assistant-creation-form.png`, not `screenshot1.png`). Use numbers only for steps in a sequence.
- Reference it with a relative path and meaningful alt text: `![Credential review with the integrations of a script step](./images/publish-script-step-aliases.png)`.
- When a UI change makes a screenshot wrong, retake it under the same file name, or remove it together with its reference. Do not leave a screenshot that shows behavior the page no longer describes.

## What the skill does with them

- Reads each file in `screenshots/` (Phase 2.5) and notes every violation of the rules above next to the screenshot.
- Reports violations to the user in the approach proposal. A screenshot with a violation is not placed until the user decides to retake it or accepts the exception.
- Never crops, blurs, or edits an image itself.
