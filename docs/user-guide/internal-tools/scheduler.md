---
id: scheduler
title: Scheduler
sidebar_label: Scheduler
---

# Scheduler

Schedule and automate assistant tasks and workflows.

The Scheduler tool in AI/Run CodeMie allows administrators to schedule and automate the execution of assistants and workflows at specified times or intervals. This enables automated task execution, periodic data processing, and scheduled operations without manual intervention.

:::warning Admin Role Required
The Scheduler functionality is available only for users with the **Admin** role.
:::

## Overview

The Scheduler provides capabilities to:

- **Schedule Assistant Execution**: Set up assistants to run automatically at specified times
- **Automate Workflows**: Configure workflows to execute on a recurring schedule
- **Define Time Intervals**: Specify execution frequency using cron expressions or predefined intervals
- **Manage Scheduled Tasks**: View, edit, and delete scheduled tasks from a centralized interface

## Key Features

### Automated Task Execution

Schedule assistants to run automatically without manual intervention, enabling:

- Regular data processing and analysis
- Periodic report generation
- Automated monitoring and alerting
- Scheduled data synchronization

### Flexible Scheduling Options

Configure schedules using various time patterns:

- One-time execution at a specific date and time
- Recurring execution (hourly, daily, weekly, monthly)
- Custom intervals using cron expressions
- Time zone support for global operations

### Centralized Management

Manage all scheduled tasks from a single interface:

- View all active and upcoming scheduled tasks
- Edit existing schedules
- Enable or disable schedules without deletion
- Monitor execution history and logs

## Use Cases

The Scheduler tool is particularly useful for:

- **Regular Reporting**: Generate and distribute reports daily, weekly, or monthly
- **Data Synchronization**: Keep data sources synchronized with periodic updates
- **Automated Monitoring**: Run health checks and monitoring tasks at regular intervals
- **Batch Processing**: Execute data processing tasks during off-peak hours
- **Compliance Checks**: Perform regular security and compliance audits

## Setup

Unlike integration-based tools, the Scheduler is a built-in feature that doesn't require external integration setup. However, it requires:

1. **Admin Role**: Only users with Admin privileges can create and manage schedules
2. **Configured Assistants or Workflows**: The assistant or workflow you want to schedule must be created beforehand

## Creating a Scheduled Task

To create a new scheduled task:

1. Navigate to the **Scheduler** section in the AI/Run CodeMie interface
2. Click **Create Schedule** or similar button
3. Configure the schedule parameters:
   - **Task Name**: Provide a descriptive name for the scheduled task
   - **Assistant/Workflow**: Select the assistant or workflow to execute
   - **Schedule Type**: Choose one-time or recurring execution
   - **Time Configuration**: Set the execution time and frequency
   - **Time Zone**: Specify the time zone for execution
4. Click **Save** or **Create** to activate the schedule

## Managing Scheduled Tasks

Once created, scheduled tasks can be managed through the Scheduler interface:

- **View**: See all scheduled tasks with their next execution time
- **Edit**: Modify schedule parameters, execution time, or frequency
- **Enable/Disable**: Temporarily pause a schedule without deletion
- **Delete**: Remove a schedule permanently
- **Execution History**: View logs of past executions and their results

:::tip
Use descriptive names for your scheduled tasks to easily identify their purpose when managing multiple schedules.
:::

## Best Practices

When using the Scheduler:

- **Test First**: Manually run your assistant or workflow before scheduling to ensure it works correctly
- **Monitor Execution**: Regularly check execution logs to identify any failures or issues
- **Set Appropriate Intervals**: Choose execution frequency based on actual needs to avoid unnecessary resource usage
- **Use Time Zones Wisely**: Ensure schedules use the correct time zone for your organization
- **Document Schedules**: Maintain documentation of what each scheduled task does and why it's needed

:::note
Scheduled tasks run in the background and may have different context or permissions than manual execution. Test thoroughly to ensure scheduled runs behave as expected.
:::
