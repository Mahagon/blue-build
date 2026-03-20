# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal BlueBuild repository producing custom Fedora Atomic OCI images via declarative YAML recipes. Builds two images published to GHCR (`ghcr.io/mahagon/`):

- **work-cosmic-desktop**: Fedora COSMIC Atomic 43 — development/work environment with cloud and infrastructure tooling
- **gaming-desktop**: Bazzite (stable) with KDE Plasma — lighter stack for gaming

## Architecture

### Recipe-driven builds

Each image is defined by a recipe YAML in `recipes/` (`work.yml`, `gaming.yml`). Recipes declare:

1. Base image and version
2. **modules** applied in order: `files` (copy config), `rpm-ostree` (packages/repos), `script` (custom installers), `default-flatpaks`, `signing`

### File overlay structure

`files/` mirrors the filesystem root and is copied into the image:

- `files/shared/` — config files included in both images (profile.d scripts, systemd presets, chezmoi config)
- `files/work/` and `files/gaming/` — image-specific config overlays
- `files/scripts/shared/` — installation scripts run by both images
- `files/scripts/work/` — work-only installation scripts

Installation scripts in `files/scripts/` install tools not available in rpm repos. They use pinned version variables tracked by Renovate via `# renovate: datasource=... depName=...` comments.

### CI/CD

GitHub Actions workflow (`.github/workflows/build.yml`):

- Triggers on push to `main` and daily at 04:15 UTC
- Uses `dorny/paths-filter` for path-based change detection — only rebuilds affected images
- Builds via `blue-build/github-action@v1.11`
- Signs images with cosign (public key in `cosign.pub`)
- Cleans up images older than 7 days

Renovate (`.github/renovate.json`) auto-merges dependency updates including GitHub Action digests and version variables in shell scripts.

## Conventions

- **Commits**: conventional commits (`chore:`, `feat:`, `fix:`)
- **Script versions**: pin versions in shell variables with Renovate tracking comments
- **Profile.d scripts**: shell functions/aliases in `files/*/etc/profile.d/` are sourced on login
