# ADR-0004: Use A Per-Machine Manifest As The Entry Point

Date: 2026-06-13
Status: Accepted

## Context

The system was already parameterized for host name, user name, home directory,
and account-specific snapshot paths. The remaining problem was edit surface:
there were still too many places a new machine could accidentally need to
touch.

For a reusable first version, the repo should have one obvious place to edit
for a new computer.

## Decision

Use `hosts/<host>/machine.nix` as the per-machine manifest.

That manifest is the single place to set:

- `hostName`
- `userName`
- `homeDirectory`
- `userFilesDir`

The flake imports the manifest and passes the values into the shared NixOS and
Home Manager modules.

## Consequences

- Onboarding a new machine becomes a small, explicit change set.
- The machine-specific surface is easy to explain and document.
- The repo is closer to a reusable template that can be copied to a second
  computer without searching through unrelated files.

## Follow-Up

- Keep the onboarding runbook aligned with the manifest format.
- If the repo grows to multiple machines, give each host its own directory and
  machine manifest.
