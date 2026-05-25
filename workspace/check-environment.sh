#!/usr/bin/env bash
# Check required environment variables are set.
set -euo pipefail

missing=0
if [ -z "${LINEAR_API_KEY:-}" ]; then echo "MISSING: LINEAR_API_KEY"; missing=$((missing+1)); fi
if [ -z "${SLACK_BOT_TOKEN:-}" ]; then echo "MISSING: SLACK_BOT_TOKEN"; missing=$((missing+1)); fi
if [ -z "${SLACK_USER_ID:-}" ]; then echo "MISSING: SLACK_USER_ID"; missing=$((missing+1)); fi
if [ -z "${SLACK_BOT_TOKEN:-}" ]; then echo "MISSING: SLACK_BOT_TOKEN"; missing=$((missing+1)); fi

if [ $missing -gt 0 ]; then
    echo "$missing required env var(s) missing"
    exit 1
fi
echo "OK: all required env vars set"
