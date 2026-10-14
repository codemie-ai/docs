# Why are images in assistant responses not displayed?

CodeMie checks every image in assistant output against a domain allow-list configured for your deployment. If the image comes from a domain that is not on the list, it is replaced with a badge reading `Image from ... blocked` instead of being loaded.

This is a security control. An assistant can be tricked into including an image from an attacker-controlled address — for example through instructions hidden in an indexed document or a ticket description. Loading such an image would silently reveal that the message was opened, along with your IP address, so the platform blocks the request before it is made.

Images uploaded as attachments and images served by the platform itself are always shown and are never affected. If a legitimate image is blocked, ask your platform administrator to add its domain to the `allowedImageDomains` setting.

## Sources

- [Image Allow-List for LLM Output](https://docs.codemie.ai/admin/security/llm-output-image-allow-list)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
