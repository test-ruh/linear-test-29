# Workflow — End-to-End Process Flow

Executed by the [Lobster runtime](https://github.com/openclaw/lobster) via `lobster run workflows/main.yaml`.
Steps run **sequentially** in the order shown below.

## Workflow Steps

1. **provision-schema** → `run: python3 scripts/data_writer.py provision` (timeout_ms=30000)
2. **fetch_linear_todo_tickets** → skill `fetch-linear-todo-tickets` (stdin={"scope":"requester_only","status":"Todo","channel":"slack_dm","trigger":"${trigger.name}"})
3. **format_slack_reminder** → skill `format-slack-reminder` (stdin=$fetch_linear_todo_tickets, when=${trigger.name == 'linear-todo-reminder'})
4. **send_slack_dm_reminder** → skill `send-slack-dm` (stdin=$format_slack_reminder, when=${trigger.name == 'linear-todo-reminder'})
5. **format_slack_daily_report** → skill `format-slack-daily-report` (stdin=$fetch_linear_todo_tickets, when=${trigger.name == 'linear-todo-daily-report'})
6. **send_slack_dm_daily_report** → skill `send-slack-dm` (stdin=$format_slack_daily_report, when=${trigger.name == 'linear-todo-daily-report'})


## Diagram

```
provision-schema → fetch_linear_todo_tickets → format_slack_reminder → send_slack_dm_reminder → format_slack_daily_report → send_slack_dm_daily_report
```
