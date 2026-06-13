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

## Known Risks

- The worktree already contains unrelated local edits in existing files.
- Future project onboarding needs a consistent registration pattern, not ad hoc
  notes scattered across the repo.

## Next Steps

1. Keep updating `.ai/current-state.md`, `.ai/handoff.md`, and
   `.ai/verification.md` alongside system changes.
2. Add new projects to `.ai/projects/index.md` when they join this system.
3. Keep the GitHub remote as the durable backup and review history.
