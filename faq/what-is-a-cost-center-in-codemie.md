# What is a cost center in CodeMie?

A cost center groups several projects — a program, a department, or a client engagement — so their combined AI spend settles on a single bill.

A cost center holds **no budget of its own**. Limits live on the projects; the cost center simply adds up what those projects spend. This keeps the two concerns separate: a project budget controls consumption, while a cost center controls reporting and billing.

Cost centers are managed at **Settings → Administration → Cost centers management**, where the list shows each one's description, the number of projects assigned to it, and creation details. Click **Create** to add one with a name and description.

To route a project's spend to a cost center, two things are required:

1. Assign the cost center to the project through **Edit Project → Cost center**. A project belongs to at most one cost center at a time.
2. On the project's budget, switch on both **Enable chargeback** and **Attribute to a cost center**.

Assigning a cost center alone does not redirect billing — both budget toggles must also be on.

Cost center names must match the pattern set by `COST_CENTER_NAME_PATTERN`, which defaults to two lowercase alphanumeric segments joined by a hyphen (for example, `platform-core`).

## Sources

- [Chargeback and Cost Centers](https://docs.codemie.ai/user-guide/budget-management/chargeback-cost-centers)
- [API Configuration Reference](https://docs.codemie.ai/admin/configuration/codemie/api-configuration#cost-center)
