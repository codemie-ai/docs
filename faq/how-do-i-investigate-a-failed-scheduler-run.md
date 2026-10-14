# How do I investigate a failed scheduler run?

Open the **Schedulers** page, click **⋮** next to the scheduler, and choose **View details**. In the run history table, locate the failed run (shown with a red **Failed** badge) and click **⋮ → View run**. The Run Details page shows the error message in a highlighted box and a timestamped **Logs** section with error codes (e.g., `APIConnectionError`) to help identify the root cause. The **Result** section links directly to the affected resource (assistant, workflow, or data source) so the configuration can be inspected without leaving the page.

## Sources

- [Monitoring Scheduler Runs](https://docs.codemie.ai/user-guide/schedulers/monitor-runs)
