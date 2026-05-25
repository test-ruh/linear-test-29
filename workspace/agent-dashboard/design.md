# Linear Todo Notifier Dashboard

## Agent

- **ID:** `linear-todo-notifier`
- **Name:** `Linear Todo Notifier`
- **Description:** A requester-focused Slack DM notifier that checks assigned Linear tickets in exact status `Todo` every 30 minutes and sends a daily 10:00 AM IST report for yesterday-created Todo tickets.

## Tabs

### Overview

The dashboard uses a single overview surface because this MVP has no application database tables and the operator mainly needs configuration clarity rather than analytics. The tab explains the notifier’s purpose, shows the two schedule cadences, summarizes the requester-only scope, previews the morning report format, and presents a realistic Linear Todo ticket list the reminder DM would be based on. This gives the operator a fast answer to: what runs, when it runs, what qualifies, and what kind of ticket payload the Slack DM includes.

## Triggers

- `linear-todo-reminder` — cron schedule `*/30 * * * *` in `UTC`; checks assigned Linear tickets whose status is exactly `Todo` and sends a Slack DM reminder when matches exist.
- `linear-todo-daily-report` — cron schedule `0 10 * * *` in `Asia/Kolkata`; sends a Slack DM report of assigned tickets created yesterday and still in exact status `Todo`, including count and list.

## Sidebar additions

- None. The dashboard stays focused on the single overview surface because the PRD does not require extra operator views beyond schedules, scope, and delivery-oriented context.

## Server endpoints

- None. `.openclaw/workspace/result-schema.yml` declares no `tables`, so this is a trigger-only agent and no agent-authored API routes are required.

## v2 Deferrals

- None noted in the approved PRD dashboard scope.
