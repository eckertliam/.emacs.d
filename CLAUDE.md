# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Emacs configuration that works in both terminal and GUI. Primary use is terminal (Ghostty + tmux), with GUI-specific extras that activate automatically. The config is a single `init.el` with `early-init.el` for pre-startup optimizations.

## Architecture

- **`early-init.el`** — startup-time GC threshold boost (50MB), disables `package-enable-at-startup`, strips menu/tool/scroll bars, suppresses startup screen.
- **`init.el`** — all configuration, organized in labeled sections (`;;;; ---- Section ----`).

All packages are installed via `straight.el` (bootstrapped at the top of `init.el`). `use-package` is used throughout with `straight-use-package-by-default t`, so no `:ensure t` is needed. Built-in packages use `:straight nil`.

## Key stacks

- **Minibuffer completion**: vertico + orderless + marginalia + consult + embark + embark-consult + wgrep
- **In-buffer completion**: corfu + corfu-terminal (terminal + Emacs <31 only) + cape
- **LSP**: eglot for rust-ts-mode, c-ts-mode, c++-ts-mode
- **Diagnostics**: flymake (built-in, driven by eglot)
- **Tree-sitter**: grammars auto-installed at startup; `major-mode-remap-alist` swaps in `-ts-mode` variants for rust/c/c++/json/yaml/bash/toml/cmake
- **Git**: magit + diff-hl (margin mode in terminal, fringe mode in GUI; flydiff always on)
- **File management**: dirvish (overrides dired)
- **Terminal**: eat (`C-c t`), with eshell integration via `eat-eshell-mode`
- **Help**: helpful (replaces `C-h f/v/k/x`), which-key
- **Navigation**: avy (`M-j`), consult-line/ripgrep/find
- **Undo**: vundo (`C-x u`)
- **Popups**: popper (`C-`` toggle, `M-`` cycle) for *Messages*, *Warnings*, output, help, compilation, flymake
- **Theme**: doom-themes (challenger-deep) + doom-modeline + nerd-icons (+ completion/corfu/dired/ibuffer integrations)
- **Visual**: pulsar (cursor pulse), lin (contextual hl-line in dired/magit/etc.), rainbow-delimiters, highlight-indent-guides, hl-todo, spacious-padding (GUI), ligature (GUI)
- **Writing**: olivetti (auto-enabled in markdown-mode and org-mode)
- **Compiler explorer**: rmsbolt (on-demand)
- **GC**: gcmh (idle-only collection at runtime, complementing the early-init startup boost)

## Languages

- **Rust** — eglot + rust-analyzer, `cargo-minor-mode`, default `compile-command` set to `cargo build`.
- **C/C++** — eglot + clangd via `c-ts-mode`/`c++-ts-mode`, indent offset 4, default `compile-command` set to `bazel build //...`.

## Display-aware design

The config uses `(display-graphic-p)` to branch between terminal and GUI at load time. This assumes standalone `emacs` instances (not `emacs --daemon` serving mixed clients).

**Terminal path**: clipetty (clipboard), xterm-mouse-mode + wheel scroll bindings, corfu-terminal (Emacs <31 only — Emacs 31+ has native child-frame popups in TTY), diff-hl-margin-mode, highlight-indent-guides with `'character` method.

**GUI path**: font setup (JetBrainsMono Nerd Font / JetBrains Mono / Menlo fallback; height 180 on Linux, 150 elsewhere), variable-pitch face (SF Pro / Helvetica Neue / Adwaita Sans / Noto Sans fallback), ligature.el, spacious-padding, diff-hl fringe mode (default), highlight-indent-guides with `'bitmap` method, `line-spacing` 2, box cursor.

## Conventions / gotchas

- **`popper-mode` is deferred to `emacs-startup`** — activating it during init causes its `display-buffer-alist` rules to intercept early `*Messages*`/`*Warnings*` display in unwanted ways.
- **Ghostty terminal** is aliased to `xterm-256color` via `term-file-aliases` (terminal only).
- **eat buffers** disable `display-line-numbers-mode` and `hl-line-mode` locally; `global-display-line-numbers-mode` is on everywhere else.
- **Auto-revert** is aggressive (1s interval, file-notify enabled).
- **No backup/lock/auto-save files** — `make-backup-files`, `create-lockfiles`, `auto-save-default` all disabled.
