---
description: Capture an app's logs with TJLog and follow them while you reproduce a problem
argument-hint: "<app> [iphone]"
---

Use the TJLog MCP tools to capture "$ARGUMENTS" and follow it live.

1. Call `tjlog_status`. If `control.howToEnable` is present, tell the user that sentence and stop.
2. If the user mentioned an iPhone or iPad, call `list_devices` and use its `udid` with `source: "device"`; otherwise use `source: "systemLog"`.
3. Find the app's exact process name: for a device, `list_processes` on the newest session from that device; on the Mac, ask if unsure. Fall back to a glob such as `*Name*`.
4. Call `start_capture` with `filters.processRules: [{ pattern, match: "glob", mode: "include" }]` and `saveOnlyFiltered: true`.
5. Call `tail_logs` once without `cursor`, tell the user to reproduce the problem, then call `tail_logs` with `nextCursor` and `waitSeconds: 20` until they say they are done. Summarise errors and faults as they arrive.
6. Ask before calling `stop_capture`.
