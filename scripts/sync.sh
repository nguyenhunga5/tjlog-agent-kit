#!/bin/sh
# Copies shared/SKILL.md into every pack; the only hand-edited guidance is shared/.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
src="$root/shared/SKILL.md"

{
  printf '%s\n' '---' 'name: tjlog' \
    'description: Use when the user asks about logs TJLog captured or should capture — app errors, crashes, restarts, iPhone or Mac logs, following a repro live.' \
    '---' ''
  cat "$src"
} > "$root/claude/skills/tjlog/SKILL.md"

{
  printf '%s\n' '---' 'description: TJLog captured logs via MCP' 'alwaysApply: false' 'globs:' '---' ''
  cat "$src"
} > "$root/cursor/rules/tjlog.mdc"

agents="$root/codex/AGENTS.md"
tmp="$agents.tmp"
awk -v src="$src" '
  /<!-- tjlog-skill:start -->/ { print; while ((getline line < src) > 0) print line; close(src); skip = 1; next }
  /<!-- tjlog-skill:end -->/ { skip = 0 }
  !skip { print }
' "$agents" > "$tmp"
mv "$tmp" "$agents"
