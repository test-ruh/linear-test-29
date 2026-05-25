#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/send-slack-dm_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"

python3 - "$INPUT_FILE" "$OUTPUT_FILE" <<'PY'
import json
import os
import sys
import urllib.request
import urllib.error

input_file, output_file = sys.argv[1], sys.argv[2]
with open(input_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

message_type = data.get('message_type', 'reminder')
send = bool(data.get('send', True))
slack_user_id = data.get('slack_user_id')
if send and not slack_user_id:
    raise SystemExit('slack_user_id is required for Slack DM delivery')

result = {
    'channel': 'slack_dm',
    'attempted': False,
    'sent': False,
    'skipped_reason': None,
    'provider_message_id': None,
    'message_type': message_type,
}

if not send:
    result['skipped_reason'] = 'no_matching_tickets'
else:
    token = os.environ['SLACK_BOT_TOKEN']

    def post(url, payload):
        body = json.dumps(payload).encode('utf-8')
        req = urllib.request.Request(
            url,
            data=body,
            headers={
                'Authorization': f'Bearer {token}',
                'Content-Type': 'application/json; charset=utf-8',
                'User-Agent': 'linear-todo-notifier/send-slack-dm'
            },
            method='POST'
        )
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                status = getattr(resp, 'status', 200)
                raw = resp.read().decode('utf-8')
        except urllib.error.HTTPError as e:
            raw = e.read().decode('utf-8', errors='replace')
            snippet = raw[:500].replace(token, '[REDACTED]')
            print(f'Slack error body: {snippet}', file=sys.stderr)
            raise SystemExit(f'Slack request returned HTTP {e.code}')
        except Exception as e:
            raise SystemExit(f'Slack request failed: {e}')
        if status != 200:
            snippet = raw[:500].replace(token, '[REDACTED]')
            print(f'Slack error body: {snippet}', file=sys.stderr)
            raise SystemExit(f'Slack request returned HTTP {status}')
        parsed = json.loads(raw)
        if not parsed.get('ok'):
            snippet = raw[:500].replace(token, '[REDACTED]')
            print(f'Slack error body: {snippet}', file=sys.stderr)
            raise SystemExit('Slack API returned ok=false')
        return parsed

    result['attempted'] = True
    open_resp = post('https://slack.com/api/conversations.open', {'users': slack_user_id})
    channel_id = open_resp['channel']['id']
    msg_resp = post('https://slack.com/api/chat.postMessage', {'channel': channel_id, 'text': data.get('text', '')})
    result['sent'] = True
    result['provider_message_id'] = msg_resp.get('ts')

with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(result, f, ensure_ascii=False, sort_keys=True)
    f.write('\n')
PY
