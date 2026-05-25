# 🎫 Linear Todo Notifier

Checks your assigned Linear Todo tickets every 30 minutes and sends Slack DM reminders, plus a daily 10:00 AM IST report for yesterday-created Todo tickets.

## Quick Start

```bash
git clone git@github.com:${GITHUB_OWNER}/linear-todo-notifier.git
cd linear-todo-notifier
cd workspace

# 1. Configure
cp .env.example .env
# Edit .env with your credentials (see "Required Environment Variables" below)

# 2. One-shot setup: validates env, installs deps, provisions DB, registers cron
chmod +x setup.sh
./setup.sh
```

## Manual Setup (if you prefer step-by-step)

```bash
cp .env.example .env             # then edit it
set -a; source .env; set +a       # load vars into the current shell
bash check-environment.sh         # verify everything required is set
bash install-dependencies.sh      # pip install psycopg2-binary, pyyaml
python3 scripts/data_writer.py provision   # create tables in your schema
bash cron/register-cron.sh         # register cron/jobs.json through OpenClaw
```

## Running

```bash
bash test-workflow.sh             # run every skill in order locally (smoke test)
openclaw cron list --all                # find job ids
openclaw cron run <job-id>              # trigger manually
openclaw cron list                # see registered jobs
openclaw cron runs                # see run history
```

## Required Environment Variables

| Variable | Description |
|----------|-------------|
| `LINEAR_API_KEY` | Linear API key |
| `SLACK_BOT_TOKEN` | Slack bot token |
| `SLACK_USER_ID` | Slack user ID |
| `SLACK_BOT_TOKEN` | Slack DM bot token |

## Skills

| Skill | Mode | Description |
|-------|------|-------------|
| `data-writer` | Auto | Provision, write, and query the agent database schema via scripts/data_writer.py. Use for all PostgreSQL operations and any result-table persistence. |
| `result-query` | User-invocable | Read stored records from the agent result tables for inspection and follow-up questions. |
| `github-action` | User-invocable | Git branch + PR workflow for syncing agent changes to GitHub. Creates feature branches, commits changes, and opens pull requests against main. NEVER pushes to main directly. MANDATORY for every agent. |
| `fetch-linear-todo-tickets` | Auto | Reads the requester's assigned Linear tickets with status exactly Todo, including created-at and other fields needed for Slack messages. |
| `format-slack-reminder` | Auto | Builds a concise Slack DM reminder from matching Linear Todo tickets. |
| `format-slack-daily-report` | Auto | Builds the 10:00 AM IST Slack DM report with a count and list of yesterday-created Todo tickets. |
| `send-slack-dm` | Auto | Sends the reminder or daily report to the requester by Slack direct message. |

## Scheduled Jobs

| Job Name | Schedule | Notes |
|----------|----------|-------|
| `linear-todo-reminder` | `*/30 * * * *` | Timezone: UTC |
| `linear-todo-daily-report` | `0 10 * * *` | Timezone: Asia/Kolkata |


## Architecture

- **Runtime**: OpenClaw AI agent framework
- **Data Layer**: PostgreSQL via `scripts/data_writer.py`
- **Scheduling**: `cron/jobs.json` package metadata registered with OpenClaw cron
- **Schema**: `org_{org_id}_a_linear_todo_notifier`

## Directory Structure

```
linear-todo-notifier/
├── README.md
├── openclaw.json
├── .gitignore
└── workspace/
    ├── SOUL.md
    ├── IDENTITY.md
    ├── AGENTS.md
    ├── TOOLS.md
    ├── result-schema.yml
    ├── env-manifest.yml
    ├── .env.example
    ├── requirements.txt
    ├── setup.sh
    ├── check-environment.sh
    ├── install-dependencies.sh
    ├── test-workflow.sh
    ├── cron/
    │   ├── jobs.json
    │   └── register-cron.sh
    ├── workflows/
    ├── scripts/
    │   ├── data_writer.py
    │   └── github_action.py
    ├── skills/
    └── agent-dashboard/
```
