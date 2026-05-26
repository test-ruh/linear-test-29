---
id: compose-slack-reminder-message
name: Compose Slack Reminder Message
version: 1.0.0
description: Build a short Slack DM reminder from current Linear Todo tickets.
user_invocable: false
always: false
requires:
  bins: [bash, python3]
  env: [RUN_ID]
primary_env: RUN_ID
input_path: /tmp/fetch-linear-todo-tickets_${RUN_ID}.json
output_path: /tmp/compose-slack-reminder-message_${RUN_ID}.json
depends_on: [fetch-linear-todo-tickets]
---

## Purpose

Turn the current matching Linear Todo tickets into a short Slack DM reminder.

## I/O Contract

- **Input:** `/tmp/fetch-linear-todo-tickets_${RUN_ID}.json`, with fetch output containing `ticket_count`, `tickets`, and optional `slack_user_id`.
- **Output:** `/tmp/compose-slack-reminder-message_${RUN_ID}.json`, with a JSON object like `{ "message_type": "reminder", "ticket_count": 2, "text": "You have 2 Linear Todo tickets...", "tickets": [...], "slack_user_id": "U123 optional passthrough" }`.
- **DB Write:** none.

## Notes

- Keeps the message clear and concise.
- Returns an empty-send signal when `ticket_count` is `0` so downstream delivery can skip sending.
