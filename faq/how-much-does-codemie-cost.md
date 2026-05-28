# How much does CodeMie cost? How is CodeMie licensed?

CodeMie pricing has two independent cost components: **infrastructure** and **LLM usage**. Both depend on your cloud provider and team profile.

For full details, see the official materials:

- Codemie GenAI-X HUB — [https://epa.ms/codemie-about](https://epa.ms/codemie-about)
- Codemie Offering — [https://epa.ms/codemie-offering](https://epa.ms/codemie-offering)
- OnePager — [https://epa.ms/codemie-onepager](https://epa.ms/codemie-onepager)

## Infrastructure Costs

The platform infrastructure (compute, storage, networking — excluding LLM API costs) runs approximately:

- **~$700/month** on AWS
- Similar range on GCP and Azure

These costs cover the core platform services and scale modestly with the number of projects and active users.

## LLM Usage Costs

LLM costs depend heavily on how users interact with the platform. Typical estimates per active user per day:

| Role                     | Usage pattern                               | Estimated cost/user/day |
| ------------------------ | ------------------------------------------- | ----------------------- |
| Business / non-technical | Chat interface, Q&A, document summarization | $4–$10                  |
| Developer / technical    | CLI tools, code generation, IDE integration | $10–$15                 |

These are estimates based on typical usage profiles. Actual costs vary with model choice, prompt length, and usage intensity. Use the built-in [Spending](https://docs.codemie.ai/user-guide/analytics/) analytics to track real consumption.

## Planning a Discussion

To prepare for a cost estimation call, have the following ready:

- Planned infrastructure setup (cloud provider, region)
- Expected number of users and their roles (technical vs. non-technical)
- Preferred LLM models

For questions and assistance, use the **Help Center** accessible from the bottom-left corner of the platform — the **AI/Run FAQ** assistant can answer questions about capabilities, and **AI/Run Feedback** lets you reach the team directly.

## Sources

- [What Is Codemie](https://docs.codemie.ai/user-guide/getting-started/what-is-codemie)
