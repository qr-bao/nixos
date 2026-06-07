# Browser Control

This repo supports three browser paths:

1. Dedicated MCP servers for sites that already expose structured tools.
2. A local Chrome session exposed over DevTools MCP for general browser work.
3. Chawan for terminal-first text browsing and pager workflows.

## Start the browser

```bash
./scripts/browser-start.sh
```

This launches a normal local Chrome window with a dedicated manual profile.

For current sessions where MCP tools were not loaded at startup, use the local
CDP fallback:

```bash
./scripts/browser-cdp.mjs open https://example.com
./scripts/browser-cdp.mjs title
./scripts/browser-cdp.mjs screenshot /tmp/page.png
```

## Codex browser route

The project-scoped Codex config adds a `chrome_devtools` MCP server that
launches its own persistent Chrome profile for Codex-controlled browser work.
Home Manager also installs the global `browser-control` skill and manages the
same MCP server in `~/.codex/config.toml`.

Use that server for normal browser work. For sensitive sites, stay in visible
Chrome and keep the user present for authentication and final confirmation.

## Terminal browser route

Home Manager installs Chawan and text helpers:

```bash
cha https://example.com
cha -d https://example.com
ddgr query words
rdrview -Hu https://example.com
www-browser https://example.com
pcha file.txt
```

`www-browser` wraps `cha`; `pcha` wraps `cha -T text/x-ansi`. New login shells
receive `BROWSER=www-browser`, `PAGER=pcha`, and `MANPAGER=mancha`.

Use Chawan for documentation, article text, simple search-result reading, and
terminal-native browsing. Use Chrome/DevTools when JavaScript interaction,
login flows, screenshots, media playback, or visual layout matter.

## Policy

- Use a dedicated MCP server if the site already has one.
- Otherwise use Chrome DevTools MCP.
- Use Chawan for low-interaction text browsing and pager tasks.
- Do not use headless mode for sensitive sites.
- Do not use stealth, proxy rotation, CAPTCHA bypass, or other anti-detection
  tactics.
- Do not automate final confirmations for trades, transfers, payments, account
  recovery, or destructive account changes.
