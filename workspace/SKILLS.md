# Step 3 of 5 — Skills

## Added Skills

| #    | Skill ID                  | Skill Name               | Mode   | Risk Level | Description                |
|------|---------------------------|--------------------------|--------|------------|----------------------------|
| S1   | `data-writer` | Data Writer | Auto | Low | Provision, write, and query the agent database schema via scripts/data_writer.py. Use for all PostgreSQL operations and any result-table persistence. |
| S2   | `result-query` | Result Query | Auto | Low | Read stored records from the agent result tables for inspection and follow-up questions. |
| S3   | `github-action` | GitHub Action | Auto | Low | Git branch + PR workflow for syncing agent changes to GitHub. Creates feature branches, commits changes, and opens pull requests against main. NEVER pushes to main directly. MANDATORY for every agent. |
| S4   | `fetch-linear-todo-tickets` | Fetch Linear Todo Tickets | Auto | Low | Reads the requester's assigned Linear tickets with status exactly Todo, including created-at and other fields needed for Slack messages. |
| S5   | `format-slack-reminder` | Format Slack Reminder | Auto | Low | Builds a concise Slack DM reminder from matching Linear Todo tickets. |
| S6   | `format-slack-daily-report` | Format Slack Daily Report | Auto | Low | Builds the 10:00 AM IST Slack DM report with a count and list of yesterday-created Todo tickets. |
| S7   | `send-slack-dm` | Send Slack DM | Auto | Low | Sends the reminder or daily report to the requester by Slack direct message. |

## Skill Dependencies (Execution Order)

```
data-writer
result-query
github-action
fetch-linear-todo-tickets
format-slack-reminder ← depends on fetch-linear-todo-tickets
format-slack-daily-report ← depends on fetch-linear-todo-tickets
send-slack-dm ← depends on format-slack-reminder, format-slack-daily-report
```

## Execution Mode Summary

| Mode  | Count          |
|-------|----------------|
| HiTL  | 0              |
| Auto  | 7 |
