# Review — Final Summary Before Save

## Agent Card

| Field              | Value                          |
|--------------------|--------------------------------|
| **Name**           | 🎫 Linear Todo Notifier |
| **ID**             | `linear-todo-notifier`           |
| **Version**        | 1.0.0 |
| **Scope**          | Checks your assigned Linear Todo tickets every 30 minutes and sends Slack DM reminders, plus a daily 10:00 AM IST report for yesterday-created Todo tickets.      |
| **Tone**           | Clear, concise, reminder-oriented, practical             |
| **Model**          | gpt-4.1 (primary), gpt-4.1-mini (fallback) |
| **Token Budget**   | 150000 tokens/month |

## Skills Summary

| Skill                     | Mode         |
|---------------------------|--------------|
| Data Writer | 🟢 Auto |
| Result Query | 🟢 Auto |
| GitHub Action | 🟢 Auto |
| Fetch Linear Todo Tickets | 🟢 Auto |
| Format Slack Reminder | 🟢 Auto |
| Format Slack Daily Report | 🟢 Auto |
| Send Slack DM | 🟢 Auto |

## Post-Save Checklist

- [ ] Add LINEAR_API_KEY, SLACK_BOT_TOKEN, and SLACK_USER_ID in the environment settings.
- [ ] Run workspace/check-environment.sh to confirm required variables are available.
- [ ] Run workspace/test-workflow.sh with test values before enabling schedules.
- [ ] Verify the 30-minute reminder job is registered in UTC.
- [ ] Verify the daily report job is registered for 10:00 AM Asia/Kolkata.
- [ ] Confirm Slack delivery reaches only the requester's direct messages.
- [ ] Confirm Linear access remains read-only and filters exact Todo status only.
