# Current State

Updated: 2026-06-13

## Active Goal

Keep this NixOS system reproducible, documented, and ready to absorb future
projects in a controlled way.

## Current State

- This repository is the GitHub-backed source of truth for the machine's NixOS
  configuration and recovery notes.
- `system/current/` and `user/current/` hold live-state snapshots that help
  recover the current machine state.
- `.ai/` is now the repo-local memory layer for durable status, handoff, and
  verification notes.
- Future projects should be registered in `.ai/projects/index.md` instead of
  being mixed into unrelated notes.
- The repo-local memory scaffold was committed as `788b109` and pushed to
  `origin/main`.
- The NixOS config is being shaped into a portable first version by
  parameterizing `hostName`, `userName`, and `homeDirectory` in the flake.
- The reusable Home Manager logic now lives in `users/common/home.nix` and
  receives `userFilesDir` from the flake so the login user can change more
  cleanly.
- `nix build /home/qrbao/nixos-setup#nixosConfigurations.nixos.config.system.build.toplevel --no-link`
  completed successfully after the portability refactor.
- The portable-first-version commit was published as `eafdae2` and pushed to
  `origin/main`.
- The shared-user-module refactor built successfully after moving the reusable
  module to `users/common/home.nix` and parameterizing `userFilesDir`.

## Known Risks

- The worktree already contains unrelated local edits in existing files.
- Future project onboarding needs a consistent registration pattern, not ad hoc
  notes scattered across the repo.
- The unrelated edits in `.codex/config.toml`, `docs/remote-access.md`,
  `hosts/nixos/configuration.nix`, `users/qrbao/home.nix`, `docs/neovim.md`,
  and `docs/terminal.md` were left untouched.
- The portable first version still assumes the current hardware file and the
  existing `users/qrbao/` layout; a fully generic multi-user template can come
  later.
- The repo still has account-specific snapshot material in `users/qrbao/files/`
  for this machine.

## Next Steps

1. Keep updating `.ai/current-state.md`, `.ai/handoff.md`, and
   `.ai/verification.md` alongside system changes.
2. Add new projects to `.ai/projects/index.md` when they join this system.
3. Keep the GitHub remote as the durable backup and review history.
4. Decide whether to generalize the user directory layout after the first
   cross-machine test.
5. Keep `users/common/home.nix` as the shared module and pass account-specific
   snapshot paths explicitly.
