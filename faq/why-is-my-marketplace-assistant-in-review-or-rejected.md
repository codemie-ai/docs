# Why is my Marketplace assistant in review or rejected? What do the REVIEW, VERIFIED, and REJECTED badges mean?

When a platform administrator has turned on the Marketplace approval gate (off by default), assistants published to the Marketplace pass automated quality checks and then wait for a manual review by a platform administrator. Without the approval gate, publishing goes straight to the Marketplace. A status badge next to the author name on the assistant card shows the result:

- **REVIEW**: The assistant passed the checks and is waiting for an administrator's decision. It is not visible in the Marketplace yet.
- **VERIFIED**: An administrator approved the assistant, and it is published in the Marketplace.
- **REJECTED**: An administrator rejected the assistant. Hover over the badge to see the reason, update the assistant accordingly, and publish it again.

Editing a published (**VERIFIED**) assistant in a way that changes its configuration removes it from the Marketplace and sends it back to **REVIEW**. An assistant that is already in review stays in the queue, and a save without configuration changes keeps the **VERIFIED** status. To withdraw an assistant from review, select **Remove from Marketplace review queue** in its actions menu.

## Sources

- [Publish to Marketplace](https://docs.codemie.ai/user-guide/assistants/marketplace-publishing)
