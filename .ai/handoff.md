# Handoff

Updated: 2026-06-13

## Summary

This repository is the durable control plane for the machine's NixOS setup.
Repo-local `.ai/` files now hold the system memory that future sessions can
read before doing work.

## What Was Done

- Established a repo-local `.ai/` memory layer for the NixOS system.
- Added a project registry for future projects that join this repository.
- Linked the README to the system memory files so the entry point is obvious.
- Committed the scaffold as `788b109` and pushed it to `origin/main`.
- Parameterized the flake and shared modules with `hostName`, `userName`, and
  `homeDirectory` so the setup can be reused on another computer more easily.
- Added `docs/portable-first-version.md` as a short reuse guide.
- Verified the portable refactor with `nix eval` and
  `nix build /home/qrbao/nixos-setup#nixosConfigurations.nixos.config.system.build.toplevel --no-link`.
- Published the portable-first-version commit as `eafdae2` on `origin/main`.
- Moved the shared Home Manager logic to `users/common/home.nix` and passed
  `userFilesDir` from the flake so the login user can change without editing
  the reusable module.
- Verified the shared-user-module refactor with the same full NixOS build.
- Added `hosts/nixos/machine.nix` as the per-machine manifest and added
  `docs/new-machine-onboarding.md` plus `.ai/runbooks/new-machine-onboarding.md`
  to describe the repeatable next-computer flow.
- Recorded the per-machine-manifest entry point in `.ai/decisions/0004-per-machine-manifest-entry-point.md`.
- Published the onboarding-flow commit as `b6984a3` on `origin/main`.

## How To Resume

1. Read `AGENTS.md`.
2. Read `.ai/current-state.md`, `.ai/handoff.md`, and `.ai/verification.md`.
3. Check `.ai/decisions/` and `.ai/runbooks/` for policy and repeatable steps.
4. Run `git status --short --branch` before editing.
5. Keep future project onboarding in `.ai/projects/index.md`.

## What Remains

- Fill in the project registry with real project entries as they are added.
- Keep the memory files current whenever the system changes.
- Decide how future project repos will be linked into this registry.
- Decide whether to rename or generalize `users/qrbao/` for a later, more
  generic public template.
- If a future machine uses a different account layout, point `userFilesDir`
  at that machine's snapshot directory or create a new one.
- For the next computer, edit the machine manifest and hardware config first.
