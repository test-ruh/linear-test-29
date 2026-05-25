---
id: format-slack-daily-report
name: Format Slack Daily Report
version: 1.0.0
description: Build the 10 AM IST Slack DM report for yesterday's Todo tickets.
user_invocable: false
always: false
requires:
  bins: [bash, python3]
  env: [RUN_ID]
primary_env: RUN_ID
input_path: /tmp/fetch-linear-todo-tickets_${RUN_ID}.json
output_path: /tmp/format-slack-daily-report_${RUN_ID}.json
depends_on: [fetch-linear-todo-tickets]
---

## Purpose

Turn the yesterday-filtered Linear Todo tickets into the daily Slack DM report with a count and list.

## I/O Contract

- **Input:** `/tmp/fetch-linear-todo-tickets_${RUN_ID}.json`, with fetch output containing `date_window: "yesterday"`, `ticket_count`, `tickets`, and optional `slack_user_id`.
- **Output:** `/tmp/format-slack-daily-report_${RUN_ID}.json`, with a JSON object like `{ "message_type": "daily_report", "ticket_count": 1, "text": "Yesterday's Linear Todo report: 1 ticket...", "tickets": [...], "slack_user_id": "U123 optional passthrough" }`.
- **DB Write:** none.

## Notes

- The report contains the count and a simple list only.
- The empty case still returns a valid report message so the daily run has a deterministic output.
