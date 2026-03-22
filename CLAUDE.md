# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Emacs configuration for terminal-only use (no GUI frames). Uses Ghostty terminal with tmux. The config is a single `init.el` with `early-init.el` for pre-startup optimizations.

## Architecture

- **`early-init.el`** — GC threshold boost, disables package-enable-at-startup, strips menu bar
- **`init.el`** — all configuration, organized in labeled sections (`;;;; ---- Section ----`)
- **`banner.txt`** — ASCII art for the dashboard

All packages are installed via `package.el` from MELPA/GNU/NonGNU ELPA. No straight.el or Borg. `use-package` is used throughout for package configuration.

## Key stacks

- **Completion**: vertico + orderless + marginalia + consult + embark + embark-consult
- **In-buffer completion**: corfu + corfu-terminal + cape
- **LSP**: eglot (rust, c, c++)
- **Tree-sitter**: auto-installs grammars, remaps major modes to `-ts-mode` variants
- **Git**: magit + diff-hl (margin mode for terminal)
- **Theme**: doom-themes (challenger-deep) + doom-modeline + nerd-icons
- **GC**: gcmh (idle-only collection, replaces manual gc-cons-threshold restore)

## Terminal constraints

This config runs exclusively in terminal Emacs. Do not add packages or settings that require GUI frames (e.g., `ligature.el`, `spacious-padding`, pixel-level font sizing). Use `corfu-terminal` for popup menus, `diff-hl-margin-mode` instead of fringe indicators, and `xterm-mouse-mode` for mouse support.

## Languages

Rust (eglot + rust-analyzer, cargo minor mode) and C/C++ (eglot + clangd, bazel build).
