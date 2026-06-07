# Browser Control

This repo supports two browser paths:

1. Dedicated MCP servers for sites that already expose structured tools.
2. A local Chrome session exposed over DevTools MCP for general browser work.

## Start the browser

```bash
./scripts/browser-start.sh
```

This launches a normal local Chrome window with a dedicated manual profile.

## Codex browser route

The project-scoped Codex config adds a `chrome_devtools` MCP server that
launches its own persistent Chrome profile for Codex-controlled browser work.

Use that server for normal browser work. For sensitive sites, stay in visible
Chrome and keep the user present for authentication and final confirmation.

## Policy

- Use a dedicated MCP server if the site already has one.
- Otherwise use Chrome DevTools MCP.
- Do not use headless mode for sensitive sites.
- Do not use stealth, proxy rotation, CAPTCHA bypass, or other anti-detection
  tactics.
