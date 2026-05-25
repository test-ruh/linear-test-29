---
id: send-slack-dm
name: Send Slack DM
version: 1.0.0
description: Send a reminder or daily report to the requester by Slack DM.
user_invocable: false
always: false
requires:
  bins: [bash, python3, curl]
  env: [SLACK_BOT_TOKEN, RUN_ID]
primary_env: SLACK_BOT_TOKEN
input_path: /tmp/format-slack-reminder_${RUN_ID}.json
output_path: /tmp/send-slack-dm_${RUN_ID}.json
depends_on: [format-slack-reminder, format-slack-daily-report]
---

## Purpose

Send the prepared message to the requester using Slack DM only.

## I/O Contract

- **Input:** `/tmp/format-slack-reminder_${RUN_ID}.json` or `/tmp/format-slack-daily-report_${RUN_ID}.json`, with a JSON object like `{ "message_type": "reminder|daily_report", "text": "...", "ticket_count": 0, "send": true|false, "slack_user_id": "U123" }`.
- **Output:** `/tmp/send-slack-dm_${RUN_ID}.json`, with a JSON object like `{ "channel": "slack_dm", "attempted": true, "sent": true, "skipped_reason": null, "provider_message_id": "12345.6789", "message_type": "reminder" }`.
- **DB Write:** none.

## Notes

- Slack DM only.
- Expects a Slack user id for the requester in `slack_user_id`.
- Skips delivery when `send` is `false`.
