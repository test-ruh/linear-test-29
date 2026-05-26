# Review — Final Summary Before Save

## Agent Card

| Field              | Value                          |
|--------------------|--------------------------------|
| **Name**           | 🎫 Linear Todo Notifier |
| **ID**             | `linear-todo-notifier`           |
| **Version**        | 1.0.0 |
| **Scope**          | Checks your assigned Linear Todo tickets every 30 minutes and sends Slack DM reminders, plus a daily 10 AM IST report of the previous day’s Todo tickets.      |
| **Tone**           | Clear, concise, reminder-oriented, and practical.             |
| **Model**          | gpt-5 (primary), gpt-4.1 (fallback) |
| **Token Budget**   | 250000 tokens/month |

## Skills Summary

| Skill                     | Mode         |
|---------------------------|--------------|
| Data Writer | 🟢 Auto |
| Result Query | 🟢 Auto |
| GitHub Action | 🟢 Auto |
| Fetch Linear Todo Tickets | 🟢 Auto |
| Compose Slack Reminder Message | 🟢 Auto |
| Format Slack Daily Report | 🟢 Auto |
| Send Slack DM | 🟢 Auto |

## Post-Save Checklist

- [ ] Add LINEAR_API_KEY, SLACK_BOT_TOKEN, and SLACK_USER_ID in the environment settings.
- [ ] Run workspace/check-environment.sh to confirm all required values are present.
- [ ] Run workspace/test-workflow.sh with test values before enabling schedules.
- [ ] Verify both cron jobs are registered with the correct timezone settings.
- [ ] Confirm the requester receives a reminder DM and a daily report DM in Slack.
