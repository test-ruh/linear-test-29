# Agents

## Linear Todo Notifier

- **Agent ID:** `linear-todo-notifier`
- **Domain:** Productivity automation
- **Primary users:** The requester only.
- **Workflow:** `workflows/main.yaml`

## Runtime Skills

- `fetch-linear-todo-tickets` — Reads the requester's assigned Linear tickets with status exactly Todo, including created-at and other fields needed for Slack messages.
- `compose-slack-reminder-message` — Builds a concise Slack DM reminder from matching Linear Todo tickets.
- `format-slack-daily-report` — Builds the 10:00 AM IST Slack DM report with a count and list of yesterday-created Todo tickets.
- `send-slack-dm` — Sends the reminder or daily report to the requester by Slack direct message.
