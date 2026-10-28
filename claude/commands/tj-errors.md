---
description: Summarise an app's errors in the last few minutes from TJLog
argument-hint: "[app] [minutes]"
---

Use the TJLog MCP tools to summarise recent errors. "$ARGUMENTS" may hold an app name and a number of minutes (default 10).

1. Call `session_digest` with `lastMinutes` and, when an app was given, `processes` (check the exact name with `list_processes`).
2. Call `search_logs` with `levels: ["error", "fault"]`, the same app and time, and `limit: 50`.
3. Group the errors by pattern, give counts and first/last times, and say which patterns the digest marks `new` or `spiking`. Note anything `«redacted»`.
