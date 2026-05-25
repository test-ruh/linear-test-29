# Step 4 of 5 — Triggers

## Active Triggers

### linear-todo-reminder — Runs every 30 minutes in UTC to check assigned Todo tickets and send a reminder DM when appropriate.

| Field       | Value                              |
|-------------|------------------------------------|
| **Type**    | schedule                     |
| **Status**  | active                   |
| **Channel** | Slack DM |
| **Frequency**   | Every 30 minutes                       |
| **Cron**        | `*/30 * * * *`                        |

---

### linear-todo-daily-report — Runs daily at 10:00 AM Asia/Kolkata to send the yesterday-created Todo ticket report.

| Field       | Value                              |
|-------------|------------------------------------|
| **Type**    | schedule                     |
| **Status**  | active                   |
| **Channel** | Slack DM |
| **Frequency**   | Daily at 10:00 AM IST                       |
| **Cron**        | `0 10 * * *`                        |

