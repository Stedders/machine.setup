# Machine Setup

Agnostic machine provisioning playbook. Guides a system from bare OS to a stable, configured development environment.

## Repo structure

- `bootstrap.md` — Phase 1: manual steps from fresh OS to Claude Code + GitHub access
- `phase2.md` — Phase 2: system stabilization playbook (GPU drivers, system errors, common fixes)
- `scripts/<system>/` — Numbered executable scripts per system (e.g., `scripts/fedora-43-nvidia/`)

## Phases

1. **Bootstrap** (manual) — User follows `bootstrap.md` to get credentials, update OS, install Homebrew, Claude Code, and GitHub access
2. **Stabilization** (semi-automated) — Claude Code follows `phase2.md` to detect and fix system issues (GPU, errors, usability)
3. **Dotfiles** (future) — Deploy personal config from the separate dotfiles repo

## Key principles

- **Agnostic first:** Phases describe generic steps with detection hints. System-specific implementations go in scripts.
- **Scripts over inline commands:** Sudo and multi-part commands go in numbered scripts under `scripts/<system>/`. Never paste multi-line commands inline.
- **Detection before action:** Always detect OS, GPU vendor, display manager, DE, etc. before prescribing fixes.
- **Docs = playbook, memory = context:** This repo is the generic playbook. User-specific preferences and machine state live in Claude Code memory.
- **Public repo:** No secrets, credentials, or private workflow details.

## Related repos

- `stedders/dotfiles` (private) — Personal dev environment config (shell, editor, prompt), managed with GNU Stow
