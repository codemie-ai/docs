# What is chargeback in CodeMie and how do I enable it?

Chargeback marks a project's AI spend as billable so it can be recovered from the team that incurred it, rather than absorbed centrally. It does not block requests or change any limit — enforcement stays with the project budget's hard and soft limits. Chargeback only decides where the spend is attributed for internal billing.

To enable it:

1. Go to **Settings → Administration → Projects Management** and select the project.
2. Open the budget dialog — **Create Budget** for a new budget, or **Manage Budget** for an existing one.
3. Switch on **Enable chargeback**.
4. Optionally switch on **Attribute to a cost center**, which appears once chargeback is enabled.
5. Save the budget.

With chargeback on alone, spend is billed to the project's own billing code. With **Attribute to a cost center** also on, spend rolls up to the cost center assigned to the project instead. That second toggle only takes effect if the project actually has a cost center assigned through **Edit Project → Cost center**.

The project page information panel shows the current **Chargeback** state and the project's **Cost center** without opening the budget.

## Sources

- [Chargeback and Cost Centers](https://docs.codemie.ai/user-guide/budget-management/chargeback-cost-centers)
