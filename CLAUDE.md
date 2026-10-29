# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Emacs config that is **terminal-only**: it is never used in GUI frames, so there's no font, fringe, posframe or frame-parameter code. Keep it that way.

The main machine is `studio` (macOS, Homebrew Emacs 31.1, terminal-only build). There, Emacs runs permanently as a daemon. The user's coding agents run in ghostel buffers inside that daemon, so they survive disconnects. The user attaches from Ghostty on any machine with `ssh -t studio 'COLORTERM=truecolor emacsclient -t'` (aliased `es`).

The config is cloned to `~/.emacs.d` on several machines, so keep it portable:
- No hard-coded absolute paths.
- Optional external tools are detected at runtime, with a clean fallback when they're missing.

Two files:

- `early-init.el`: GC threshold during startup, no menu bar.
- `init.el`: everything else, split into `;;;;` sections (Packages, Housekeeping, Server, Behavior, Editing UI, Minibuffer/completion/search, Theme and modeline, Key hints, Dired, Buffer list, Help, Keys, Magit, Languages, Terminal UI, Terminal emulator).

Packages come from `package.el` + `use-package`, with MELPA added and `use-package-always-ensure t`. So built-in features **and files shipped inside another package** need `:ensure nil` (e.g. `ghostel-project`, `ghostel-eshell`, `which-key`, `eglot`, `flymake`, `dired`), or `:ensure <parent>` (e.g. `difftastic-bindings` → `:ensure difftastic`). Otherwise use-package tries to download them from MELPA and fails.

## The studio daemon

- **launchd:** a LaunchAgent (`~/Library/LaunchAgents/com.liameckert.emacs-daemon.plist`, `RunAtLoad` + `KeepAlive`) runs `~/.config/emacs-daemon/launch.sh`. That script is `#!/bin/zsh -l` → `exec emacs --fg-daemon`, so the daemon gets the login-shell `PATH`.
- **Logs:** `~/Library/Logs/emacs/daemon.{out,err}.log`.
- **Server socket:** studio's `~/.zshenv` exports `TMPDIR` (from `getconf DARWIN_USER_TEMP_DIR`) because ssh sessions leave it unset. Without that, `emacsclient` over ssh looks in `/tmp/emacs501` while the daemon listens under `/var/folders/...`.
- **Updating the config there:** `git -C ~/.emacs.d pull`, then reload in the daemon (below).
- **Restarting is a last resort:** it kills every running agent. Ask the user first. If it's unavoidable, kill the exact PID from `launchctl print gui/$(id -u)/com.liameckert.emacs-daemon`, and launchd restarts the daemon.

## Verifying changes

**Never kill Emacs processes by name** (`pkill`/`killall`). The user's Emacs runs the same binary.

Batch load, which also installs any newly added packages:

```sh
emacs --batch -l early-init.el --eval '(package-activate-all)' -l init.el --eval '(setq kill-emacs-hook nil)'
```

- `(package-activate-all)` is required: batch mode doesn't activate packages, so without it every package reports "Cannot load".
- `(setq kill-emacs-hook nil)` stops batch runs from writing history, recentf, places, or desktop files.
- Settings in a `use-package` `:config` only exist after that package loads, so `require` it before inspecting them.
- Batch limits:
  - **Highlighting:** no font-lock; call `font-lock-ensure` first.
  - **Window hooks:** window-configuration hooks don't fire.
  - **eglot:** `eglot-ensure` waits for `post-command-hook`.
  - **Saving:** `save-buffer` is a no-op on an unmodified buffer.
  - **Timers:** they run in an arbitrary current buffer.

Live daemon on studio (`ec` = `ssh studio /opt/homebrew/bin/emacsclient -e`; quote the form for the remote shell, e.g. zsh `${(q)form}`):

```elisp
(progn (package-load-all-descriptors) (package-activate-all) (load-file user-init-file))
```

- `package-load-all-descriptors` + `package-activate-all` are needed whenever packages were installed by a separate batch run. Without them, the reload fails partway with use-package "Cannot load" errors.
- **Never evaluate anything that can prompt** (`y-or-n-p`, killing a buffer with a live process, `kill-emacs` with unsaved buffers) while no client frame is connected. The prompt falls back to the daemon's stdin and blocks the whole daemon. To kill a ghostel buffer, bind `kill-buffer-query-functions` and `ghostel-query-before-killing` to nil and clear the process's query-on-exit flag first.
- Wrap remote `emacsclient` calls in a timeout (e.g. `perl -e 'alarm 15; exec @ARGV' ...`) so a blocked daemon can't hang the session.
- Kill any buffers you create.
- **Counting frames:** a daemon always has a hidden `initial_terminal` frame. Count client frames with `(frame-parameter f 'client)`.

**Testing terminal frames without a person:**
- Run `script -q LOG /bin/sh -c "stty cols 160 rows 48; exec ssh -tt studio '...emacsclient -t'"` with stdin held open (`sleep 600 | ...`).
- Without `stty` the frame is 2×2, and anything sized from it (like a ghostel shell) is useless.
- End the client with `pkill -f "script -q LOG"`. Never kill the process group, which also kills the calling shell.

**ghostel and hidden buffers:** a ghostel buffer that isn't displayed keeps reading its process (via the native PTY thread), so agents never block. But **its buffer text isn't redrawn until it's displayed**. Read terminal output only after showing the buffer in a client window, or check the process's own side effects.

**State files** belong to the user: `history`, `places.eld`, `recentf.eld`, `projects.eld`, `.emacs.desktop`. They're gitignored. Never edit them with line-based tools, because entries span multiple lines and deleting a line corrupts the sexp (a corrupt `places.eld` breaks `find-file`). In test scripts, point `savehist-file`, `save-place-file`, `recentf-save-file` and `project-list-file` at a scratch location.

## Terminal UI conventions

- **Keys:**
  - The terminal must speak the kitty keyboard protocol (`kkp` package) for keys like `C-.` and `` C-` ``.
  - Option must act as Meta: in Ghostty, `macos-option-as-alt = true`.
- **Colour:** depends on `COLORTERM=truecolor` in the client's environment (set in the `es` command), because ssh doesn't forward it.
- **Clipboard:** copying uses OSC 52 (`xterm-extra-capabilities '(setSelection)`), so kills land in the local machine's clipboard even over ssh.
- **Icons:** drawn by the terminal's font, which must be a Nerd Font.
- **Margins:** diff-hl uses the left margin and flymake the right (`flymake-indicator-type 'margins`).

## Emacs 31 quirks

- **compat backports:** `compat` skips its Emacs 31 backports on any 31.x, but 31.0.x development builds lack some 31 functions (e.g. `set-local`, which vertico calls). The vertico block requires `compat-31` when `emacs-version` < 31.1; on 31.1+ this does nothing.
- **Tree-sitter:** built in. `treesit-enabled-modes` remaps major modes and `treesit-auto-install-grammar 'always` builds missing grammars (needs a C compiler and `git`) into `tree-sitter/`.
- **Markdown:** 31.1 ships `markdown-ts-mode` but doesn't autoload it, map `.md` to it, or accept it in `treesit-enabled-modes` (it warns). The config autoloads it and maps `.md` explicitly.
- **Dired listings:** dired uses `ls-lisp`, not the system `ls`, so listings are identical on every OS and directories come first. `ls-lisp-verbosity` must include `modes`, or permissions are cut down to the first four characters. On macOS, `trash-directory` is set to `~/.Trash`, because terminal builds otherwise use the freedesktop trash.

## Non-obvious decisions (don't "simplify" these away)

- **magit-todos** uses the `git grep` scanner with `--untracked`. Its rg scanner omits the search path, so rg reads Emacs's stdin pipe and finds nothing.
- **popper** needs `(require 'project)` before `popper-mode`, because `popper-group-by-project` checks `(fboundp 'project-root)`. Ghostel and difftastic are intentionally **not** popups: agents run in ghostel, and difftastic needs full width.
- **`my/project-find-file`** (`C-x p f`) is built on `consult--read` over `project-files`, giving fuzzy matching (hotfuzz) plus preview. `consult-fd` sends the input to `fd` as a regex, so it isn't fuzzy.
- **ibuffer** grouping requires `ibuf-ext`; without it, filter groups are silently ignored.
- **`my/git-commit-setup`** sets up commit messages via `auto-mode-alist`, so that `git commit` from a shell with `EDITOR=emacsclient` gets `C-c C-c` without loading magit at startup.
- **Server:** `server-start` is skipped under `--daemon`, which starts its own server after init. `desktop-restore-frames` is nil, because a daemon has no frames at startup.
- **Format on save:** always for Rust; for C/C++ only when the project has a `.clang-format`.

## External tools (all optional; features degrade without them)

| Tool | Used for | Without it |
|---|---|---|
| `rg` (ripgrep) | `C-x p g` / `M-s r`, xref search | git grep / grep |
| `difft` (difftastic) | magit `d M-d` / `d M-c` | those commands error |
| `rust-analyzer`, `clangd` | eglot | no language server |
| C compiler + `git` | tree-sitter grammars | grammars don't build |

clangd needs a `compile_commands.json` in each C++ project, generated by that project's build system.

## User preferences

- Prefer built-in features over packages when the result is comparable.
- Standard Emacs keybindings: no evil, leader keys, or Helix-style bindings.
- Option stays Meta.
- Keep the modeline minimal (mood-line).
