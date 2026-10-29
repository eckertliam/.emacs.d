# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Emacs config, cloned to `~/.emacs.d` on several machines. **Keep it portable:**
- No hard-coded absolute paths or OS-specific install steps.
- Optional fonts and external tools are detected at runtime, and the config falls back cleanly when they're missing.

It targets **Emacs 31**, using `treesit-enabled-modes`, `treesit-auto-install-grammar`, built-in `markdown-ts-mode`, and ls-lisp's `modes` verbosity.

Two files:

- `early-init.el`: GC threshold during startup, frame chrome off.
- `init.el`: everything else, split into `;;;;` sections (Packages, Housekeeping, Server, Behavior, Font, Editing UI, Minibuffer/completion/search, Theme and modeline, Key hints, Dired, Buffer list, Help, Keys, Magit, Languages, Terminal).

Packages come from `package.el` + `use-package`, with MELPA added and `use-package-always-ensure t`. So built-in features **and files shipped inside another package** need `:ensure nil` (e.g. `ghostel-project`, `ghostel-eshell`, `which-key`, `eglot`, `flymake`, `dired`), or `:ensure <parent>` (e.g. `difftastic-bindings` → `:ensure difftastic`). Otherwise use-package tries to download them from MELPA and fails.

## Verifying changes

**Never launch a GUI Emacs, and never kill Emacs processes by name** (`pkill`/`killall`). The user's own Emacs runs the same binary, so a name match kills their session. Use batch mode for checks and the user's live Emacs (server started from `init.el`) for anything that needs a display.

Batch load, which also installs any newly added packages:

```sh
emacs --batch -l early-init.el --eval '(package-activate-all)' -l init.el --eval '(setq kill-emacs-hook nil)'
```

- `(package-activate-all)` is required: batch mode doesn't activate packages, so without it every package reports "Cannot load".
- `(setq kill-emacs-hook nil)` stops batch runs from writing history, recentf, places, or desktop files.
- Settings in a `use-package` `:config` only exist after that package loads, so `require` it before inspecting them.
- Batch limits:
  - **Highlighting:** no font-lock; call `font-lock-ensure` first.
  - **Display:** no GUI display, so `display-graphic-p` and font checks are no-ops.
  - **Window hooks:** window-configuration hooks don't fire (popper status, for example).
  - **eglot:** `eglot-ensure` waits for `post-command-hook`.
  - **Saving:** `save-buffer` is a no-op on an unmodified buffer.
  - **Timers:** they run in an arbitrary current buffer.

Live session:

```sh
emacsclient -e '(progn (package-load-all-descriptors) (package-activate-all) (load-file user-init-file))'
```

- `package-load-all-descriptors` + `package-activate-all` are needed whenever packages were installed by a batch run. Without them, the live reload fails partway with use-package "Cannot load" errors.
- Use `dired-noselect`-style calls instead of anything that displays buffers.
- Kill any buffers you create, and leave the user's windows alone.

**State files** belong to the user: `history`, `places.eld`, `recentf.eld`, `projects.eld`, `.emacs.desktop`. They're gitignored. Never edit them with line-based tools, because entries span multiple lines and deleting a line corrupts the sexp (a corrupt `places.eld` breaks `find-file`). In test scripts, point `savehist-file`, `save-place-file`, `recentf-save-file` and `project-list-file` at a scratch location.

## Portability conventions

- **Fonts:**
  - The default font is the first installed family in `my/font-families`.
  - nerd-icons uses `JetBrainsMono Nerd Font Mono` only if it's installed; otherwise it uses its own font (`M-x nerd-icons-install-fonts`).
  - Under a daemon, the font is applied to the first GUI frame.
- **Optional tools:** gate them with `executable-find`. For example, `my/search-project` falls back from ripgrep to git grep, and `my/eglot-ensure-if-installed` only starts eglot when `rust-analyzer`/`clangd` exists.
- **Paths:** use `user-emacs-directory`/`locate-user-emacs-file`, never a literal home path.
- **`PATH` in GUI Emacs:** it may not include shell-profile entries, depending on how Emacs is launched (some macOS builds import a login-shell environment and others don't, and launchd or a daemon may not). If a tool isn't found, fix it with `exec-path-from-shell` rather than hard-coding a path.

## Emacs 31 quirks

- **compat backports:** `compat` skips its Emacs 31 backports on any 31.x, but 31.0.x development builds lack some 31 functions (e.g. `set-local`, which vertico calls). The vertico block requires `compat-31` when `emacs-version` < 31.1.
- **Tree-sitter:** built in. `treesit-enabled-modes` remaps major modes and `treesit-auto-install-grammar 'always` builds missing grammars (needs a C compiler and `git`) into `tree-sitter/`.
- **Dired listings:** dired uses `ls-lisp`, not the system `ls`, so listings are identical on every OS and directories come first. `ls-lisp-verbosity` must include `modes`, or permissions are cut down to the first four characters.

## Non-obvious decisions (don't "simplify" these away)

- **magit-todos** uses the `git grep` scanner with `--untracked`. Its rg scanner omits the search path, so rg reads Emacs's stdin pipe and finds nothing.
- **popper** needs `(require 'project)` before `popper-mode`, because `popper-group-by-project` checks `(fboundp 'project-root)`. Ghostel and difftastic are intentionally **not** popups: agents run in ghostel, and difftastic needs full width.
- **`my/project-find-file`** (`C-x p f`) is built on `consult--read` over `project-files`, giving fuzzy matching (hotfuzz) plus preview. `consult-fd` sends the input to `fd` as a regex, so it isn't fuzzy.
- **ibuffer** grouping requires `ibuf-ext`; without it, filter groups are silently ignored.
- **`my/git-commit-setup`** sets up commit messages via `auto-mode-alist`, so that `git commit` from a shell with `EDITOR=emacsclient` gets `C-c C-c` without loading magit at startup. `EDITOR` is set in each machine's shell profile, outside this repo.
- **Format on save:** always for Rust; for C/C++ only when the project has a `.clang-format`.
- **flymake** indicators are on the right fringe, because diff-hl owns the left.

## External tools (all optional; features degrade without them)

| Tool | Used for | Without it |
|---|---|---|
| `rg` (ripgrep) | `C-x p g` / `M-s r`, xref search | git grep / grep |
| `difft` (difftastic) | magit `d M-d` / `d M-c` | those commands error |
| `rust-analyzer`, `clangd` | eglot | no language server |
| C compiler + `git` | tree-sitter grammars | grammars don't build |
| JetBrainsMono Nerd Font | default font and icons | system font; nerd-icons' own font |

clangd needs a `compile_commands.json` in each C++ project, generated by that project's build system.

## User preferences

- Prefer built-in features over packages when the result is comparable.
- Standard Emacs keybindings: no evil, leader keys, or Helix-style bindings.
- Option stays Meta.
- Keep the modeline minimal (mood-line).
