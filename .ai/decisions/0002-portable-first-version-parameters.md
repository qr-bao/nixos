# ADR-0002: Parameterize Host And Home Values For A Portable First Version

Date: 2026-06-13
Status: Accepted

## Context

The repository started as a single-machine NixOS setup. To test the same
environment on another computer, the obvious machine-specific values needed to
be concentrated instead of repeated in several modules:

- the host name
- the login username
- the home directory
- browser profile paths that assumed `/home/qrbao`

The repo still needs a hardware-specific config for each machine, but the
shared environment should be easy to carry over.

## Decision

Pass `hostName`, `userName`, and `homeDirectory` from the flake into the NixOS
and Home Manager modules.

Use those values anywhere the config previously hard-coded `/home/qrbao` or
`nixos` in the shared shell wrappers and browser profile paths.

Keep the machine hardware file and live-state snapshots separate from the
portable logic.

## Consequences

- The same configuration modules can be reused on another computer with a
  small number of explicit edits.
- The code is easier to review because the machine-specific values are now
  visible in one place.
- The repo is a better first public template, even though a new machine still
  needs its own hardware config.
- The user directory path under `users/qrbao/` still reflects the current
  account layout and can be generalized later if needed.

## Follow-Up

- Document the reuse steps in `docs/portable-first-version.md`.
- Keep machine-specific snapshots clearly labeled as such.
