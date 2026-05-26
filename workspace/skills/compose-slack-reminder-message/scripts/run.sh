#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/compose-slack-reminder-message_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"

python3 - "$INPUT_FILE" "$OUTPUT_FILE" <<'PY'
import json
import sys

input_file, output_file = sys.argv[1], sys.argv[2]
with open(input_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

tickets = data.get('tickets', [])
count = int(data.get('ticket_count', len(tickets)))
if count > 0:
    lines = [f"You have {count} Linear Todo ticket{'s' if count != 1 else ''}:"]
    for t in tickets:
        lines.append(f"- {t['identifier']}: {t['title']} ({t['url']})")
    text = "\n".join(lines)
    send = True
else:
    text = "No Linear Todo tickets right now."
    send = False

output = {
    'message_type': 'reminder',
    'ticket_count': count,
    'text': text,
    'send': send,
    'tickets': tickets,
}
if data.get('slack_user_id'):
    output['slack_user_id'] = data['slack_user_id']

with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(output, f, ensure_ascii=False, sort_keys=True)
    f.write('\n')
PY
