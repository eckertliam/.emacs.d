# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Emacs configuration that works in both terminal and GUI. Primary use is terminal (Ghostty + tmux), with GUI-specific extras that activate automatically. The config is a single `init.el` with `early-init.el` for pre-startup optimizations.

## Architecture

- **`early-init.el`** — GC threshold boost, disables package-enable-at-startup, strips menu/tool/scroll bars
- **`init.el`** — all configuration, organized in labeled sections (`;;;; ---- Section ----`)
- **`banner.txt`** — ASCII art for the dashboard

All packages are installed via `straight.el` (bootstrapped in `init.el`). `use-package` is used throughout with `straight-use-package-by-default t`, so no `:ensure t` is needed. Built-in packages use `:straight nil`.

## Key stacks

- **Completion**: vertico + orderless + marginalia + consult + embark + embark-consult
- **In-buffer completion**: corfu + corfu-terminal (terminal only) + cape
- **LSP**: eglot (rust, c, c++)
- **Tree-sitter**: auto-installs grammars, remaps major modes to `-ts-mode` variants
- **Git**: magit + diff-hl (margin mode in terminal, fringe mode in GUI)
- **Theme**: doom-themes (challenger-deep) + doom-modeline + nerd-icons
- **GC**: gcmh (idle-only collection, replaces manual gc-cons-threshold restore)

## Display-aware design

The config uses `(display-graphic-p)` to branch between terminal and GUI at load time. This assumes standalone `emacs` instances (not `emacs --daemon` serving mixed clients).

**Terminal path**: clipetty, xterm-mouse-mode, corfu-terminal, diff-hl-margin-mode, highlight-indent-guides with `'character` method.

**GUI path**: font configuration (JetBrains Mono), ligature.el, spacious-padding, diff-hl fringe mode (default), highlight-indent-guides with `'bitmap` method.

## Languages

Rust (eglot + rust-analyzer, cargo minor mode) and C/C++ (eglot + clangd, bazel build).
