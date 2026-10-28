# TJLog agent kit

Skill text and client configs for the MCP server built into [TJLog](https://tonyapps.org), the macOS log
viewer for this Mac, iPhones and iPads. The server reads what TJLog captured (sessions, apps, searches,
digests, crash reports, live tails) and, when you allow it, runs captures. This kit teaches an agent to use it
well — digests before rows, the exact app name, small pages, `tail_logs` while you reproduce — and gives each
client its config.

The tools are not defined here: the server advertises them. The guidance lives once, in
[`shared/SKILL.md`](shared/SKILL.md); `scripts/sync.sh` copies it into each pack.

Turn the server on in TJLog → Settings → MCP. **Connect to…** adds it to Claude Code, Codex, Cursor or VS Code
for you (every `~/.claude-*` / `~/.codex-*` account is listed on its own), and **Manual Setup** shows the
same commands to paste. The first time an agent connects, TJLog shows an Allow/Deny window. Examples below use
the default port, 9096.

Agents can only read until you turn on Settings → MCP → Agent Control and tick **Can control capture** for
them. Pairing never grants control.

## Claude Code

Add the server (or use Connect to… → Claude Code), then install the plugin for the skill and commands:

```bash
claude mcp add --scope user --transport http tjlog http://127.0.0.1:9096/mcp
claude plugin marketplace add nguyenhunga5/tjlog-agent-kit
claude plugin install tjlog@tjlog-agent-kit
```

Then `/mcp` → `tjlog` → Authenticate, and click Allow in TJLog. The plugin does not register the server
itself, so the tools are never listed twice and a custom port or account keeps working.

Commands: `/tj-capture <app> [iphone]`, `/tj-why-crashed [app]`, `/tj-errors [app] [minutes]`.

For another account, prefix the commands with `CLAUDE_CONFIG_DIR=~/.claude-<name>`.

## Codex

```bash
codex mcp add tjlog --url http://127.0.0.1:9096/mcp
```

Codex opens the sign-in itself; click Allow in TJLog. Or paste
[`codex/config.toml.snippet`](codex/config.toml.snippet) into `~/.codex/config.toml` and run
`codex mcp login tjlog`. Add [`codex/AGENTS.md`](codex/AGENTS.md) to your project's `AGENTS.md` for the skill
text. For another account, prefix with `CODEX_HOME=~/.codex-<name>`.

## Cursor

Merge [`cursor/mcp.json`](cursor/mcp.json) into `.cursor/mcp.json` (or Connect to… → Cursor) and copy
[`cursor/rules/tjlog.mdc`](cursor/rules/tjlog.mdc) into `.cursor/rules/`.

## VS Code

Merge [`vscode/mcp.json`](vscode/mcp.json) into `.vscode/mcp.json` (or Connect to… → VS Code), and give
Copilot the text of [`shared/SKILL.md`](shared/SKILL.md) as instructions.

## Other clients

```
MCP endpoint (streamable HTTP): http://127.0.0.1:9096/mcp
Auth: OAuth 2.1 with PKCE and dynamic client registration; metadata at http://127.0.0.1:9096/.well-known/oauth-protected-resource
Run your client's authorize step; TJLog shows an Allow/Deny window once.
```

Scripts can use a token from Settings → MCP → New Token for a Script…, sent as `Authorization: Bearer <token>`.

## Editing the guidance

Edit `shared/SKILL.md` only, then run `sh scripts/sync.sh` and commit the generated files with it.

Tested with TJLog 1.1.

## License

MIT — see [LICENSE](LICENSE).
