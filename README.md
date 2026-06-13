# qrbao NixOS Setup

This repository is the reproducible NixOS desktop configuration for this
machine, plus an audit trail of user-facing changes made during setup.

Repo-local memory for the system lives in `.ai/`. Start with:

- `.ai/current-state.md`
- `.ai/handoff.md`
- `.ai/verification.md`
- `.ai/projects/index.md`

For a first reusable cross-machine version, see
[`docs/portable-first-version.md`](docs/portable-first-version.md).

For the next-computer flow, see
[`docs/new-machine-onboarding.md`](docs/new-machine-onboarding.md).

The main entry point is `flake.nix`. A clean NixOS install can clone this repo
and build the `nixos` host to get the same system packages, desktop input
method setup, screenshot shortcut, and clipboard history shortcut.

## What is tracked

- `flake.nix` and `flake.lock`: pinned NixOS and Home Manager inputs
- `hosts/nixos/`: host-level NixOS configuration and hardware profile
- `hosts/nixos/machine.nix`: machine-specific host, user, and snapshot
  settings for this computer
- `users/common/home.nix`: shared Home Manager configuration applied to the
  selected login user
- `users/qrbao/files/`: account-specific mutable app config copied into place
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

## Browser Control

Start the shared Chrome session with:

```bash
./scripts/browser-start.sh
```

The browser automation policy and Codex MCP wiring live in
[`AGENTS.md`](AGENTS.md) and [`docs/browser-control.md`](docs/browser-control.md).
Home Manager also installs the global `browser-control` Codex skill and adds
the `chrome_devtools` MCP server if it is missing from `~/.codex/config.toml`.

## Remote Access

SSH and Tailscale setup notes live in
[`docs/remote-access.md`](docs/remote-access.md).

## Neovim

The default Neovim setup and keymap guide live in
[`docs/neovim.md`](docs/neovim.md).

## Terminal

The default terminal setup and pane/session guide live in
[`docs/terminal.md`](docs/terminal.md).

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
- Register future projects in `.ai/projects/index.md` so the system stays
  organized as more repos join this workflow.
