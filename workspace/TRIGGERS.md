# Step 4 of 5 — Triggers

## Active Triggers

### linear-todo-reminder — Runs every 30 minutes and sends a Slack DM reminder when assigned Todo tickets exist.

| Field       | Value                              |
|-------------|------------------------------------|
| **Type**    | schedule                     |
| **Status**  | active                   |
| **Channel** | slack_dm |
| **Frequency**   | Every 30 minutes                       |
| **Cron**        | `*/30 * * * *`                        |

---

### linear-todo-daily-report — Runs daily at 10:00 AM Asia/Kolkata and sends a Slack DM report for yesterday-created assigned Todo tickets.

| Field       | Value                              |
|-------------|------------------------------------|
| **Type**    | schedule                     |
| **Status**  | active                   |
| **Channel** | slack_dm |
| **Frequency**   | Daily at 10:00 AM Asia/Kolkata                       |
| **Cron**        | `0 10 * * *`                        |

