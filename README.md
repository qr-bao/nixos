# NixOS Trace Repo

This repository is the audit and rollback companion for the machine.

## What is tracked

- `system/current/`: system-level NixOS configuration snapshots
- `user/current/`: user-level config snapshots for important apps
- `trace/raw-history.jsonl`: raw Codex prompt history export
- `trace/session-*.md`: human-readable session notes

## How to use it

1. Make a change in the live system or user config.
2. Refresh the matching snapshot files in this repo.
3. Review the diff with `git diff`.
4. Commit the change.

## Rollback model

- System config rollback: restore `system/current/configuration.nix` to an older commit, copy it back to `/etc/nixos/configuration.nix`, then run `nixos-rebuild switch`.
- User config rollback: restore the relevant file in `user/current/` from an older commit, copy it back to `~/.config/...`, then restart the affected app or log out/in.
- Data rollback: use backups, not Nix generations.

## Notes

- Keep runtime databases, caches, and large mutable data out of Git unless they are specifically needed for recovery.
- The raw history file is there so you can trace prompts and actions after the fact.
