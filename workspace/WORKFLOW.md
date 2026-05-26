# Workflow — End-to-End Process Flow

Executed by the [Lobster runtime](https://github.com/openclaw/lobster) via `lobster run workflows/main.yaml`.
Steps run **sequentially** in the order shown below.

## Workflow Steps

1. **provision-schema** → `run: python3 scripts/data_writer.py provision` (timeout_ms=30000)
2. **fetch_linear_todo_tickets_reminder** → skill `fetch-linear-todo-tickets` (stdin={"trigger_id":"linear-todo-reminder","run_type":"reminder","scope":"requester_only","status":"Todo","channel":"slack_dm","slack_user_id":"${SLACK_USER_ID}"}, when=${trigger.name == 'linear-todo-reminder'})
3. **format_slack_reminder** → skill `compose-slack-reminder-message` (stdin=$fetch_linear_todo_tickets_reminder, when=${trigger.name == 'linear-todo-reminder'})
4. **send_slack_dm_reminder** → skill `send-slack-dm` (stdin=$format_slack_reminder, when=${trigger.name == 'linear-todo-reminder'})
5. **fetch_linear_todo_tickets_daily_report** → skill `fetch-linear-todo-tickets` (stdin={"trigger_id":"linear-todo-daily-report","run_type":"daily_report","scope":"requester_only","status":"Todo","channel":"slack_dm","date_window":"yesterday","slack_user_id":"${SLACK_USER_ID}"}, when=${trigger.name == 'linear-todo-daily-report'})
6. **format_slack_daily_report** → skill `format-slack-daily-report` (stdin=$fetch_linear_todo_tickets_daily_report, when=${trigger.name == 'linear-todo-daily-report'})
7. **send_slack_dm_daily_report** → skill `send-slack-dm` (stdin=$format_slack_daily_report, when=${trigger.name == 'linear-todo-daily-report'})


## Diagram

```
provision-schema → fetch_linear_todo_tickets_reminder → format_slack_reminder → send_slack_dm_reminder → fetch_linear_todo_tickets_daily_report → format_slack_daily_report → send_slack_dm_daily_report
```
