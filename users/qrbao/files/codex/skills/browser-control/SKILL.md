---
name: browser-control
description: Use when the user asks Codex to operate a website, inspect Chrome, browse pages, fill web forms, manage online accounts, or take actions in a browser. Prefer dedicated MCP/connectors when available; otherwise use Chrome DevTools MCP. Apply stricter visible-browser-only handling for sensitive financial, securities, payment, identity, or account-management sites.
---

# Browser Control

## Route selection

1. If the named site or service has a dedicated MCP server, app connector, or
   first-party tool available in the current session, use that structured path
   first.
2. If no dedicated structured path exists and the site is not sensitive, use
   the `chrome_devtools` MCP server.
3. If the site is sensitive, use visible Chrome only and keep the user present.

When tools are deferred, search for relevant tools before falling back to
Chrome. Typical structured routes include GitHub, Notion, OpenAI Platform,
Google workspace tools, Slack, Linear, or a service-specific MCP server.

## Sensitive-site policy

Treat these as sensitive:

- Securities, banking, brokerages, trading, crypto exchanges, tax, payroll,
  insurance, payment, identity, medical, government, and account-security
  pages.
- Any page involving credentials, MFA, KYC, funds movement, order placement,
  account recovery, permission changes, billing, or irreversible submissions.

For sensitive sites:

- Use visible Chrome, not headless mode.
- Do not use stealth/fingerprint spoofing, proxy rotation, CAPTCHA bypass,
  rate-limit bypass, or anti-bot evasion.
- Do not automate final confirmation for trades, transfers, payments, account
  recovery, security settings, or destructive actions.
- Stop at the final review screen and ask the user to confirm manually.
- Let the user type secrets, MFA codes, passwords, and final confirmations.

## Chrome DevTools MCP

The global Codex config should define:

```toml
[mcp_servers.chrome_devtools]
command = "npx"
args = [
  "-y",
  "chrome-devtools-mcp@latest",
  "--channel=stable",
  "--userDataDir=/home/qrbao/.local/share/codex-browser/mcp-profile",
  "--headless=false",
  "--redactNetworkHeaders=true",
  "--no-usage-statistics",
  "--no-performance-crux",
]
```

Use this MCP server for non-sensitive browsing tasks such as reading pages,
checking web apps, filling low-risk forms, downloading public documents, or
testing local sites.

If `chrome_devtools` tools are not available in the current Codex session,
check `/home/qrbao/.codex/config.toml`. If the config exists, explain that a
new Codex session may be needed for MCP discovery, and use available local
browser helpers only when the task does not require sensitive interaction.

## Local helper

In the NixOS setup repo, `/home/qrbao/nixos-setup/scripts/browser-start.sh`
opens a normal dedicated Chrome profile for manual inspection. It is not the
main automation path; Codex-controlled browsing should use `chrome_devtools`
when available.
