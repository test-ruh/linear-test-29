#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/fetch-linear-todo-tickets_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"

python3 - "$INPUT_FILE" "$OUTPUT_FILE" <<'PY'
import json
import os
import sys
import urllib.error
import urllib.request
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

LINEAR_URL = 'https://api.linear.app/graphql'
PAGE_SIZE = 100
USER_AGENT = 'linear-todo-notifier/fetch-linear-todo-tickets'

input_file, output_file = sys.argv[1], sys.argv[2]
with open(input_file, 'r', encoding='utf-8') as f:
    payload = json.load(f)

api_key = os.environ['LINEAR_API_KEY']
run_type = payload.get('run_type', 'reminder')
trigger_id = payload.get('trigger_id', '')
date_window = payload.get('date_window')
slack_user_id = payload.get('slack_user_id')
status_name = payload.get('status', 'Todo')
if status_name != 'Todo':
    raise SystemExit('Only exact status Todo is supported')

QUERY = '''
query ViewerTodoIssues($first: Int!, $after: String) {
  viewer {
    id
    issues(
      first: $first
      after: $after
      filter: { assignee: { isMe: { eq: true } }, state: { name: { eq: "Todo" } } }
    ) {
      pageInfo {
        hasNextPage
        endCursor
      }
      nodes {
        identifier
        title
        url
        createdAt
        state { name }
        team { name }
        project { name }
      }
    }
  }
}
'''


def redacted_snippet(text: str) -> str:
    return (text or '')[:500].replace(api_key, '[REDACTED]')


def linear_query(query: str, variables: dict) -> dict:
    body = json.dumps({"query": query, "variables": variables}).encode('utf-8')
    req = urllib.request.Request(
        LINEAR_URL,
        data=body,
        headers={
            'Authorization': api_key,
            'Content-Type': 'application/json',
            'User-Agent': USER_AGENT,
        },
        method='POST'
    )

    raw = ''
    status = None
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            status = getattr(resp, 'status', 200)
            raw = resp.read().decode('utf-8')
    except urllib.error.HTTPError as exc:
        status = exc.code
        raw = exc.read().decode('utf-8', errors='replace') if exc.fp else ''
    except Exception as exc:
        raise SystemExit(f'Linear request failed: {exc}')

    if status != 200:
        print(f'Linear error body: {redacted_snippet(raw)}', file=sys.stderr)
        raise SystemExit(f'Linear request returned HTTP {status}')

    try:
        data = json.loads(raw)
    except json.JSONDecodeError as exc:
        raise SystemExit(f'Linear response was not valid JSON: {exc}')

    if data.get('errors'):
        print(f'Linear GraphQL errors: {redacted_snippet(json.dumps(data.get("errors"), ensure_ascii=False))}', file=sys.stderr)
        raise SystemExit('Linear GraphQL returned errors')

    return data


def fetch_all_todo_issues() -> list[dict]:
    all_nodes = []
    after = None

    while True:
        data = linear_query(QUERY, {'first': PAGE_SIZE, 'after': after})
        issues = (((data.get('data') or {}).get('viewer') or {}).get('issues') or {})
        nodes = issues.get('nodes') or []
        page_info = issues.get('pageInfo') or {}

        all_nodes.extend(nodes)

        if not page_info.get('hasNextPage'):
            break

        after = page_info.get('endCursor')
        if not after:
            raise SystemExit('Linear pagination ended without an endCursor')

    return all_nodes


nodes = fetch_all_todo_issues()


def parse_dt(value: str) -> datetime:
    return datetime.fromisoformat(value.replace('Z', '+00:00'))


if run_type == 'daily_report' or date_window == 'yesterday':
    ist = ZoneInfo('Asia/Kolkata')
    if payload.get('today_ist'):
        today_ist = datetime.strptime(payload['today_ist'], '%Y-%m-%d').date()
    else:
        today_ist = datetime.now(ist).date()
    yesterday_ist = today_ist - timedelta(days=1)
else:
    yesterday_ist = None

filtered = []
for item in nodes:
    status = (((item.get('state') or {}).get('name')) or '')
    if status != 'Todo':
        continue
    created_at = item.get('createdAt')
    if yesterday_ist is not None:
        created_date_ist = parse_dt(created_at).astimezone(ZoneInfo('Asia/Kolkata')).date()
        if created_date_ist != yesterday_ist:
            continue
    filtered.append({
        'identifier': item.get('identifier'),
        'title': item.get('title'),
        'url': item.get('url'),
        'status': status,
        'team': ((item.get('team') or {}).get('name')),
        'project': ((item.get('project') or {}).get('name')),
        'created_at': created_at,
    })

filtered.sort(key=lambda x: ((x.get('created_at') or ''), (x.get('identifier') or '')))
output = {
    'trigger_id': trigger_id,
    'run_type': run_type,
    'scope': payload.get('scope', 'requester_only'),
    'channel': payload.get('channel', 'slack_dm'),
    'status': 'Todo',
    'date_window': 'yesterday' if yesterday_ist is not None else None,
    'ticket_count': len(filtered),
    'tickets': filtered,
}
if slack_user_id:
    output['slack_user_id'] = slack_user_id

with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(output, f, ensure_ascii=False, sort_keys=True)
    f.write('\n')
PY
