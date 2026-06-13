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

## How To Resume

1. Read `AGENTS.md`.
2. Read `.ai/current-state.md`, `.ai/handoff.md`, and `.ai/verification.md`.
3. Check `.ai/decisions/` and `.ai/runbooks/` for policy and repeatable steps.
4. Run `git status --short --branch` before editing.
5. Keep future project onboarding in `.ai/projects/index.md`.

## What Remains

- Fill in the project registry with real project entries as they are added.
- Keep the memory files current whenever the system changes.
