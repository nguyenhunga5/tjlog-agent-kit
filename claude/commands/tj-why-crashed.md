---
description: Explain why an app crashed or restarted, from TJLog's logs and crash reports
argument-hint: "[app]"
---

Use the TJLog MCP tools to explain the most recent crash or restart (of "$ARGUMENTS" when given).

1. Call `session_digest` (with `processes: ["$ARGUMENTS"]` when an app was given; use `list_processes` first if the name may differ).
2. Take the newest `restart` finding. If it has `crashReportId`, call `get_crash_report` and read `frames` first. On an iPhone session with no report, call `list_crash_reports`; if still none and you may control capture, `fetch_crash_reports`.
3. Call `get_context` around the restart's `seq` with `sameProcess: true`, and read the finding's `precursors`.
4. Explain: what killed the app (crash, jetsam, watchdog), the crashing thread and frames, and what the app logged just before. Say which rows you looked at.
