#!/usr/bin/env bash
set -euo pipefail

profile_dir="${CODEX_BROWSER_PROFILE_DIR:-$HOME/.local/share/codex-browser/manual-profile}"
log_dir="${CODEX_BROWSER_LOG_DIR:-$HOME/.local/share/codex-browser}"
log_file="$log_dir/chrome.log"

mkdir -p "$profile_dir" "$log_dir"

if pgrep -af "google-chrome.*user-data-dir=${profile_dir}" >/dev/null 2>&1; then
  echo "Chrome already running for profile ${profile_dir}"
  exit 0
fi

nohup google-chrome \
  --user-data-dir="$profile_dir" \
  --no-first-run \
  --no-default-browser-check \
  --new-window \
  about:blank \
  >/dev/null 2>"$log_file" &

sleep 1
echo "Chrome started for profile ${profile_dir}"
