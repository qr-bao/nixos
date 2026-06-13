# Portable First Version

This repository is now arranged as a first reusable NixOS system template.
It still has machine-specific hardware data, but the main user and host values
are concentrated in a small set of parameters.

## Shared Parts

- system packages and desktop defaults
- Home Manager setup for the primary user
- Codex, GitHub, browser, terminal, and editor workflow defaults
- repo-local memory under `.ai/`

## Machine-Specific Parts

- `hosts/nixos/hardware-configuration.nix`
- `networking.hostName`
- the login username and home directory
- bootloader and disk details
- live-state snapshots under `system/current/` and `user/current/`

## Reuse On Another Computer

1. Clone the repo.
2. Generate or copy a hardware configuration for the new machine.
3. Set `hostName`, `userName`, and `homeDirectory` in the flake/module args.
4. Update the host-specific hardware file.
5. Build and then switch if the build succeeds.

The current flake already passes `hostName`, `userName`, and `homeDirectory`
into the system and Home Manager modules so the environment can be reused with
small machine-specific changes.
