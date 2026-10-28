# TJLog

To connect Codex to TJLog, run `codex mcp add tjlog --url http://127.0.0.1:9096/mcp` (or use TJLog → Settings → MCP → Connect to… → Codex) and click Allow in the window TJLog shows. Change the port if you changed it in TJLog's Settings → MCP.

<!-- tjlog-skill:start -->
## When to call what

TJLog is a macOS log viewer: this Mac's unified log, iPhones and iPads over a cable or Wi-Fi, and apps that
send their own logs. Its MCP server reads what TJLog captured and, when the user allows it, runs captures.
Sessions hold millions of rows, so start from summaries and narrow before you read rows.

- `tjlog_status` — once per conversation. Lists running captures and, under `control`, whether you may use
  the control tools. If `howToEnable` is present, tell the user that sentence before you try to capture.
- `list_sessions` — when the user did not say which session. Without `sessionId` every tool uses the only
  running capture, else the newest session.
- `list_processes` — before you filter by app. App names are matched exactly (any case), and the real name
  is often not what the user said: "tonyproxy" may log as `TonyProxy-iOS-Dev`. Use the name from this list, or
  a glob such as `*TonyProxy*`.
- `session_digest` — before listing rows. Restarts (with `crashReportId` when a crash report explains one),
  error and log bursts, loops, top error patterns with how earlier sessions saw them (`new`, `spiking ×N`,
  `occasional`, `usual`), busiest minutes and apps. Pass `processes` and a time to focus it.
- `search_logs` — always with an app or a level, and a time (`lastMinutes` or `since`/`until`); `limit` ≤ 50.
  `text` matches message words (any one of them). Page with `nextCursor`. `scanLimitReached` means the search
  stopped early: narrow the time or the apps rather than paging on.
- `get_context` — the rows around one `seq` from a search; `sameProcess: true` keeps to that app.
- `list_crash_reports` / `get_crash_report` — iPhone and iPad sessions. Read `frames` (the crashed thread)
  first; `raw` is the `.ips` text, cut at `maxChars`.
- `symbolicate_crash_report` — when a report's `symbols.needsDSYM` is true (a release build's frames show only
  offsets). Call it once without `dsymPaths`: TJLog searches Spotlight like Xcode does. If it still needs a
  dSYM, tell the user `symbols.howTo` — it names the app, version and UUID to fetch from their CI build — and
  wait. When they give a path (a `.dSYM`, folder, `.xcarchive` or the CI `.zip`), call it again with
  `dsymPaths`. A dSYM from another build is refused by UUID; relay that and ask for the right one.
- `list_alerts` — what TJLog flagged during a capture: new error patterns, restarts of watched apps, bursts.
- `export` — `markdownReport` for a write-up the user can keep; `log`/`jsonl`/`csv` for rows. Large exports
  come back as a file path.

## Running a capture (needs the user's permission)

- `start_capture`
  - `source: "device"` needs a `udid` from `list_devices`.
  - `source: "systemLog"` needs `filters.processRules` naming the apps. Only their rows are kept, and macOS
    drops the rest before TJLog reads them, so name exact apps (`"match": "glob"` with a plain name, or a
    trailing `*`).
  - Leave `captureDebug` off unless the user needs Debug rows.
- `tail_logs` — while the user reproduces a problem. Call it once without `cursor` to mark the start, then
  repeat with `nextCursor` and `waitSeconds: 20`; rows come oldest first.
- `set_filters` (`mode: "add"` to widen) and `apply_preset` change what a running capture keeps.
- `watch_process` raises restart alerts for an app.
- `stop_capture` when you are done. An iPhone capture then fetches its crash reports; `fetch_crash_reports`
  does it without stopping.
- `reveal_in_tjlog` scrolls TJLog to a row. macOS may keep another app in front, so tell the user to look at
  TJLog.

Every control action shows a notice in TJLog. Do not start captures the user did not ask for, and stop the
ones you started.

## Reading the answers

- Messages may contain `«redacted»` (tokens, passwords, emails, home folder names): TJLog hid them on purpose.
- `truncated: true` with `messageLength` means the message was cut; ask `get_context` for that row.
- Times are UTC (`Z`); say the user's local time when you can.
- When you report "no errors", say over which rows and time span, and mention errors outside it, such as at
  the app's launch.
- If a call says the user must turn something on in TJLog, relay that sentence and wait.
<!-- tjlog-skill:end -->
