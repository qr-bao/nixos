# ADR-0003: Shared User Module And Pluggable Snapshot Directory

Date: 2026-06-13
Status: Accepted

## Context

The setup needed to support a different username, not just a different
computer. The earlier portable version still kept the reusable Home Manager
logic under `users/qrbao/home.nix`, which made the module path itself look
account-specific.

The user-specific live snapshots in `users/qrbao/files/` are also still useful
as machine/account state, but they should not be embedded into the shared
module as a fixed relative path.

## Decision

Move the reusable Home Manager module to `users/common/home.nix`.

Pass `userFilesDir` from the flake into that module so the shared logic can
install account-specific snapshots from a configurable directory.

Keep `userName` and `homeDirectory` as flake-level parameters.

## Consequences

- The reusable module no longer looks tied to one username.
- Another machine can change the login name and point at a different snapshot
  directory without rewriting the shared module.
- The repo now separates reusable system behavior from account-specific
  snapshots more clearly.

## Follow-Up

- If a future machine uses a different account layout, point `userFilesDir` at
  that machine's snapshot directory or create a new one.
- Keep the current `users/qrbao/files/` snapshots documented as account
  material, not as the reusable module itself.
