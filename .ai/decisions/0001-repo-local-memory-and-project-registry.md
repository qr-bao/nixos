# ADR-0001: Repo-Local Memory and Project Registry

Date: 2026-06-13
Status: Accepted

## Context

This repository already tracks the machine's NixOS configuration, live-state
snapshots, and recovery notes. The user wants a stable place where Codex can
open the system, understand the current state quickly, and later add separate
projects without losing clarity.

## Decision

Use repo-local Markdown under `.ai/` as the canonical memory for this NixOS
system.

The required baseline is:

- `.ai/current-state.md`
- `.ai/handoff.md`
- `.ai/verification.md`
- `.ai/decisions/`
- `.ai/runbooks/`
- `.ai/projects/index.md`

Future projects should be registered in the project index rather than mixed
into unrelated system notes.

## Consequences

- A fresh Codex session can recover the system state without depending on chat
  history.
- Project additions stay visible in Git history and review diffs.
- The NixOS system stays the top-level control plane while still allowing
  multiple projects to join later.
- Project memory remains simple enough to maintain from the terminal.

## Follow-Up

- Expand the project registry as new projects are added.
- Keep the memory files updated whenever the system changes.
