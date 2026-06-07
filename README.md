# qrbao NixOS Setup

This repository is the reproducible NixOS desktop configuration for this
machine, plus an audit trail of user-facing changes made during setup.

The main entry point is `flake.nix`. A clean NixOS install can clone this repo
and build the `nixos` host to get the same system packages, desktop input
method setup, screenshot shortcut, and clipboard history shortcut.

## What is tracked

- `flake.nix` and `flake.lock`: pinned NixOS and Home Manager inputs
- `hosts/nixos/`: host-level NixOS configuration and hardware profile
- `users/qrbao/home.nix`: tracked user configuration applied by Home Manager
- `users/qrbao/files/`: selected mutable app config copied into place
- `system/current/` and `user/current/`: live-state snapshots for audit
- `trace/`: redacted Codex prompt/action history and human-readable notes

## Rebuild

Build without switching:

```bash
nix build .#nixosConfigurations.nixos.config.system.build.toplevel --no-link
```

Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Roll back to the previous NixOS generation:

```bash
sudo nixos-rebuild switch --rollback
```

## Update From Live State

1. Make a change in the live system or user config.
2. Run `./scripts/sync-live-state.sh`.
3. Review the diff with `git diff`.
4. Commit the change.

## Rollback model

- Full config rollback: checkout an older Git commit and run
  `sudo nixos-rebuild switch --flake .#nixos`.
- System generation rollback: run `sudo nixos-rebuild switch --rollback`.
- User config rollback: restore the relevant file from `users/qrbao/files/` or
  `user/current/`, then rebuild or restart the affected app.
- Data rollback: use backups, not Nix generations.

## Notes

- Keep runtime databases, caches, and large mutable data out of Git unless they are specifically needed for recovery.
- The history file is redacted before syncing so prompts and actions remain
  traceable without publishing known credential text.
- Review diffs before publishing. Do not commit SSH private keys, browser
  profiles, API tokens, password stores, clipboard history databases, or large
  personal files.
