---
id: fetch-linear-todo-tickets
name: Fetch Linear Todo Tickets
version: 1.0.0
description: Read the requester's assigned Linear tickets with status exactly Todo.
user_invocable: false
always: false
requires:
  bins: [bash, python3, curl]
  env: [LINEAR_API_KEY, RUN_ID]
primary_env: LINEAR_API_KEY
input_path: /tmp/trigger_context_${RUN_ID}.json
output_path: /tmp/fetch-linear-todo-tickets_${RUN_ID}.json
depends_on: []
---

## Purpose

Read Linear in a read-only way and return the requester's assigned tickets whose status is exactly `Todo`.

## I/O Contract

- **Input:** `/tmp/trigger_context_${RUN_ID}.json`, with a JSON object like `{ "trigger_id": "linear-todo-reminder|linear-todo-daily-report", "run_type": "reminder|daily_report", "scope": "requester_only", "status": "Todo", "channel": "slack_dm", "date_window": "yesterday|null", "today_ist": "optional YYYY-MM-DD override for tests", "slack_user_id": "U123 optional passthrough" }`.
- **Output:** `/tmp/fetch-linear-todo-tickets_${RUN_ID}.json`, with a JSON object like `{ "trigger_id": "...", "run_type": "...", "scope": "requester_only", "channel": "slack_dm", "status": "Todo", "date_window": null|"yesterday", "ticket_count": 0, "tickets": [{ "identifier": "ENG-123", "title": "Example", "url": "https://linear.app/...", "status": "Todo", "team": "Platform", "project": "Notifier", "created_at": "2026-05-24T08:00:00.000Z" }], "slack_user_id": "U123 optional passthrough" }`.
- **DB Write:** none.

## Notes

- Reads only tickets assigned to the requester using the Linear viewer identity.
- Matches status exactly `Todo`.
- For the daily report flow, filters to tickets created yesterday in Asia/Kolkata and still currently in `Todo`.
- Produces deterministic ordering by `created_at` ascending, then `identifier` ascending.
