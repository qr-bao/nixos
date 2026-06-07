# Repo Instructions

This repository tracks the machine's reproducible NixOS setup and the live-state
snapshots used to recover it.

Browser automation rules:

- If a target site already has a dedicated MCP server or connector, use that
  first.
- If there is no dedicated MCP path and the site is not sensitive, use the
  Chrome DevTools MCP server defined in `.codex/config.toml`.
- For sensitive sites such as banking, securities, payments, or account
  management, use visible Chrome UI automation only. Do not use headless mode,
  stealth/fingerprint spoofing, proxy rotation, CAPTCHA bypass, or other
  anti-detection techniques.
- Keep the user present for authentication, confirmation, and any high-risk
  action.

Local browser entry point:

- Start the manual Chrome helper with `./scripts/browser-start.sh` when you want
  a normal local browser window for inspection.
- The Codex-controlled browser session comes from the Chrome DevTools MCP
  server, which launches Chrome with a dedicated persistent profile.
- Use the browser only through the configured MCP path or the visible UI.

Repository maintenance rules:

- Keep live-state snapshots redacted before committing.
- Keep browser profiles, cookies, secrets, and other mutable private data out
  of Git.
