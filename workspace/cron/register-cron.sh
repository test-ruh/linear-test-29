#!/usr/bin/env bash
# Register this workspace's cron jobs through the OpenClaw CLI.
# The canonical package metadata lives in cron/jobs.json; OpenClaw itself
# persists registered jobs under ~/.openclaw/cron/jobs.json.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REGISTRY_FILE="${SCRIPT_DIR}/registered-jobs.jsonl"
cd "${WORKSPACE_DIR}"

log()  { printf "▸ %s\n" "$*"; }
ok()   { printf "✓ %s\n" "$*"; }
warn() { printf "! %s\n" "$*"; }
err()  { printf "✗ %s\n" "$*" >&2; }

if ! command -v openclaw >/dev/null 2>&1; then
  err "openclaw CLI not found. Install OpenClaw, then rerun: bash cron/register-cron.sh"
  exit 127
fi

find_registered_job_id() {
  local name="$1"
  local raw
  raw="$(openclaw cron list --all --json 2>/dev/null || true)"
  CRON_LIST_JSON="${raw}" python3 - "$name" <<'PY'
import json
import os
import sys

target = sys.argv[1]
raw = os.environ.get("CRON_LIST_JSON", "")
try:
    data = json.loads(raw) if raw.strip() else []
except Exception:
    data = []

def walk(value):
    if isinstance(value, dict):
        if value.get("name") == target and (value.get("id") or value.get("jobId")):
            print(value.get("id") or value.get("jobId"))
            raise SystemExit(0)
        for child in value.values():
            walk(child)
    elif isinstance(value, list):
        for child in value:
            walk(child)

walk(data)
PY
}

register_job() {
  local name="$1"
  local expr="$2"
  local tz="$3"
  local session_target="$4"
  local wake_mode="$5"
  local message="$6"
  local timeout_seconds="$7"
  shift 7

  local existing_id
  existing_id="$(find_registered_job_id "${name}")"
  if [[ -n "${existing_id}" ]]; then
    ok "cron '${name}' already registered as ${existing_id}"
    return
  fi

  local cmd=(
    openclaw cron add
    --json
    --name "${name}"
    --cron "${expr}"
    --tz "${tz}"
    --session "${session_target}"
    --wake "${wake_mode}"
    --message "${message}"
    --timeout-seconds "${timeout_seconds}"
    --no-deliver
  )
  if [[ -n "${AGENT_ID:-}" ]]; then
    cmd+=(--agent "${AGENT_ID}")
  fi
  if [[ "$#" -gt 0 ]]; then
    cmd+=("$@")
  fi

  log "registering cron '${name}'"
  "${cmd[@]}" | tee -a "${REGISTRY_FILE}" >/dev/null
  ok "registered cron '${name}'"
}

register_job 'linear-todo-reminder' '*/30 * * * *' 'UTC' 'isolated' 'now' 'Check assigned Linear tickets with status exactly Todo and send a Slack DM reminder when any exist.' 600
register_job 'linear-todo-daily-report' '0 10 * * *' 'Asia/Kolkata' 'isolated' 'now' 'Send a Slack DM report of assigned Linear tickets created yesterday and currently in status exactly Todo, including count and list.' 600
