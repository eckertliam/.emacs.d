;;; init.el --- Main configuration -*- lexical-binding: t; -*-

;;;; Packages

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(require 'use-package)
(setq use-package-always-ensure t)

;;;; Housekeeping

;; Keep Customize's writes out of init.el.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;; Put backups and auto-saves in one place instead of next to every file.
(let ((backup-dir (locate-user-emacs-file "backups/"))
      (auto-save-dir (locate-user-emacs-file "auto-save/")))
  (make-directory backup-dir t)
  (make-directory auto-save-dir t)
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-save-dir t))
        backup-by-copying t
        delete-old-versions t
        version-control t
        kept-new-versions 6
        kept-old-versions 2))
(setq create-lockfiles nil)

;;;; Server

;; Lets emacsclient (and tools) talk to this Emacs.  A daemon starts its
;; own server after init.
(require 'server)
(unless (or (daemonp) (server-running-p))
  (server-start))

;;;; Behavior

(setq use-short-answers t
      ring-bell-function #'ignore
      confirm-kill-processes nil
      require-final-newline t
      sentence-end-double-space nil
      kill-do-not-save-duplicates t
      save-interprogram-paste-before-kill t
      help-window-select t
      vc-follow-symlinks t)

(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 80)

(prefer-coding-system 'utf-8)

(delete-selection-mode 1)        ; typing replaces the active region
(electric-pair-mode 1)           ; auto-close brackets and quotes
(global-auto-revert-mode 1)      ; reload files changed on disk
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

;; Remember things across sessions.
(recentf-mode 1)
(setq recentf-max-saved-items 200)
(savehist-mode 1)
(save-place-mode 1)

;; Reopen buffers and window layout from last time.
(setq desktop-dirname user-emacs-directory
      desktop-path (list user-emacs-directory)
      desktop-save t                            ; save without asking
      desktop-load-locked-desktop 'check-pid    ; ignore stale locks after a crash
      desktop-restore-frames nil                ; a daemon has no frames at startup
      desktop-restore-eager 8)                  ; restore the rest lazily
(desktop-save-mode 1)

(editorconfig-mode 1)                   ; follow each repo's .editorconfig

;; Windows: Shift+arrows to move between them, C-c left/right to undo layout changes.
(windmove-default-keybindings)
(winner-mode 1)

;; Repeat the last key of a command without its prefix: C-x o o o, M-g n n n.
(repeat-mode 1)

;; Language servers send big JSON replies; read them in 1MB chunks, not 64KB.
(setq read-process-output-max (* 1024 1024))

;; Help, compilation, grep and similar buffers open as a popup at the bottom.
;; C-` toggles the latest popup, M-` cycles them, C-M-` turns a buffer into
;; a popup (or back).  Popups are grouped per project.
(use-package popper
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*" "\\*Warnings\\*" "\\*Backtrace\\*"
          "Output\\*$" "\\*Async Shell Command\\*" "\\*xref\\*"
          "\\*Embark Export"
          help-mode helpful-mode compilation-mode grep-mode
          flymake-diagnostics-buffer-mode eldoc-mode)
        popper-group-function #'popper-group-by-project)
  (require 'project)                    ; grouping needs `project-root' loaded
  (popper-mode 1)
  (popper-echo-mode 1))

;; Trim trailing whitespace only on lines you edit, so diffs stay clean.
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

;;;; Editing UI

(column-number-mode 1)
(global-hl-line-mode 1)
(show-paren-mode 1)
(setq show-paren-context-when-offscreen 'overlay)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq-default display-line-numbers-width 3)   ; buffer-local, so set the default

(setq scroll-conservatively 101
      scroll-margin 2
      mouse-wheel-progressive-speed nil)

;;;; Minibuffer, completion and search

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t
      enable-recursive-minibuffers t)

(use-package vertico
  :demand t
  :bind ("M-R" . vertico-repeat)        ; reopen the last picker where you left it
  :hook (minibuffer-setup . vertico-repeat-save)
  :init
  ;; This 31.0.x dev build predates some Emacs 31 functions (e.g.
  ;; `set-local'), and compat skips its 31 backports on any 31.x.
  (when (version< emacs-version "31.1")
    (require 'compat-31 nil t))
  :config
  (setq vertico-cycle t)
  (vertico-mode 1))

;; fzf-style fuzzy matching, best match first ("mnrs" -> src/main.rs).
(use-package hotfuzz
  :demand t
  :config
  (setq completion-styles '(hotfuzz basic)))

;; Annotations beside candidates (file info, docstrings, buffer modes).
(use-package marginalia
  :demand t
  :config
  (marginalia-mode 1))

;; The dired icons, in file and buffer pickers too.
(use-package nerd-icons-completion
  :after marginalia
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode 1))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("C-x p b" . consult-project-buffer)
         ("C-x p f" . my/project-find-file)
         ("C-x p g" . my/search-project)
         ("M-s r"   . my/search-project)
         ("M-s l"   . consult-line)
         ("M-g i"   . consult-imenu)
         ("M-g f"   . consult-flymake)
         ("M-g g"   . consult-goto-line)
         ("M-y"     . consult-yank-pop))
  :init
  ;; Show definitions and references (M-., M-?) in a previewing picker.
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  (when (executable-find "rg")
    (setq xref-search-program 'ripgrep))
  :config
  (defun my/search-project ()
    "Live project search: ripgrep if installed, else git grep."
    (interactive)
    (call-interactively (if (executable-find "rg") #'consult-ripgrep #'consult-git-grep)))

  ;; Previewing files means opening them, so wait for a pause in typing.
  (consult-customize consult-ripgrep consult-xref consult-recent-file
                     :preview-key '(:debounce 0.3 any))

  (defun my/project-find-file ()
    "Fuzzy-pick a project file with live preview."
    (interactive)
    (let* ((project (project-current t))
           (default-directory (project-root project))
           (files (mapcar #'file-relative-name (project-files project))))
      (find-file (consult--read files
                                :prompt "Find file: "
                                :category 'file
                                :state (consult--file-preview)
                                :require-match t
                                :history 'file-name-history)))))

;; Act on the candidate at point (C-.); E exports results to a buffer.
(use-package embark
  :bind (("C-." . embark-act)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Edit an exported ripgrep buffer: e to start, C-c C-c to write to all files.
(use-package wgrep
  :config
  (setq wgrep-enable-key "e"
        wgrep-auto-save-buffer t))

;; Flash the line you land on after a jump.
(defun my/pulse-line (&rest _)
  (pulse-momentary-highlight-one-line))
(dolist (hook '(xref-after-jump-hook xref-after-return-hook consult-after-jump-hook))
  (add-hook hook #'my/pulse-line))

;; Workspace-wide symbol search through the language server.
(use-package consult-eglot
  :after (consult eglot)
  :bind (:map eglot-mode-map ("M-s s" . consult-eglot-symbols)))

;;;; Theme and modeline

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

;; Slightly darker background for non-file buffers (magit, help, terminals),
;; so the windows holding real code stand out.
(use-package solaire-mode
  :config
  (solaire-global-mode 1))

(use-package mood-line
  :config
  (setq mood-line-glyph-alist mood-line-glyphs-unicode)
  ;; The default format, plus the project name in front of the buffer name.
  (setq mood-line-format
        (mood-line-defformat
         :left
         (((mood-line-segment-modal)                  . " ")
          ((or (mood-line-segment-buffer-status) " ") . " ")
          ((when-let* ((name (mood-line-segment-project)))
             (propertize name 'face 'mood-line-status-info)) . " / ")
          ((mood-line-segment-buffer-name)            . "  ")
          ((mood-line-segment-cursor-position)        . " ")
          (mood-line-segment-scroll))
         :right
         (((mood-line-segment-vc)         . "  ")
          ((mood-line-segment-major-mode) . "  ")
          ((mood-line-segment-misc-info)  . "  ")
          ((mood-line-segment-checker)    . "  ")
          ((mood-line-segment-process)    . "  "))))
  (mood-line-mode 1))

;;;; Key hints

;; which-key is built in since Emacs 30; hints appear in a bottom window.
(use-package which-key
  :ensure nil
  :config
  (setq which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.05
        which-key-separator " → "
        which-key-add-column-padding 2
        which-key-max-display-columns 4
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil)
  (which-key-mode 1))

;;;; Dired

(use-package dired
  :ensure nil
  :hook ((dired-mode . dired-hide-details-mode) ; ( toggles details
         (dired-mode . (lambda () (setq truncate-lines t))))
  :config
  ;; Emacs's own ls: identical on every OS (macOS ls can't list dirs first).
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil
        ls-lisp-dirs-first t
        ls-lisp-verbosity '(modes)      ; full perms; no link count, owner, group
        ls-lisp-use-localized-time-format t
        ls-lisp-format-time-list '("%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M")
        dired-listing-switches "-Alh"   ; no . and .., human sizes
        dired-free-space nil
        dired-kill-when-opening-new-dired-buffer t
        dired-auto-revert-buffer t
        dired-dwim-target t             ; copy/move to the other dired window
        dired-recursive-copies 'always
        dired-recursive-deletes 'top
        delete-by-moving-to-trash t)
  ;; Terminal builds on macOS would otherwise use the freedesktop trash.
  (when (eq system-type 'darwin)
    (setq trash-directory "~/.Trash")))

(defun my/dired-hide-symlink-arrows ()
  "Hide \" -> \" along with the symlink target it points at.
Dired leaves the arrow visible; the nerd-icons link icon already says it."
  (save-excursion
    (goto-char (point-min))
    (let ((inhibit-read-only t))
      (while (search-forward " -> " nil t)
        (when (eq (get-text-property (point) 'invisible) 'dired-hide-details-link)
          (put-text-property (match-beginning 0) (point)
                             'invisible 'dired-hide-details-link))))))
(add-hook 'dired-after-readin-hook #'my/dired-hide-symlink-arrows)

;; Icons are drawn by the terminal's font, so it must be a Nerd Font.
(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

;;;; Buffer list, grouped by project

(defun my/ibuffer-project-groups ()
  "Return ibuffer filter groups, one per project with live buffers."
  (let (groups)
    (dolist (buf (buffer-list))
      (let ((dir (buffer-local-value 'default-directory buf)))
        (when-let* (((and dir (not (file-remote-p dir))))
                    (project (project-current nil dir))
                    (root (expand-file-name (project-root project))))
          (unless (assoc (project-name project) groups)
            (push `(,(project-name project)
                    (predicate . (and default-directory
                                      (string-prefix-p
                                       ,root (expand-file-name default-directory)))))
                  groups)))))
    (sort groups (lambda (a b) (string< (car a) (car b))))))

(defun my/ibuffer-group-by-project ()
  (setq ibuffer-filter-groups (my/ibuffer-project-groups))
  (ibuffer-update nil t))

(with-eval-after-load 'ibuffer
  (require 'ibuf-ext)                   ; filter groups are ignored without it
  (add-hook 'ibuffer-hook #'my/ibuffer-group-by-project)
  (add-to-list 'ibuffer-never-show-predicates "\\`\\*Ibuffer")
  (setq ibuffer-show-empty-filter-groups nil
        ibuffer-expert t                ; don't confirm killing buffers
        ibuffer-formats
        '((mark modified read-only locked " "
                (name 30 30 :left :elide) " "
                (mode 16 16 :left :elide) " "
                filename-and-process))))

;; C-x p C-b: the same view, narrowed to the current project.
(setq project-buffers-viewer #'project-list-buffers-ibuffer)

;;;; Help

(use-package helpful
  :bind (([remap describe-function] . helpful-callable)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-key]      . helpful-key)
         ([remap describe-command]  . helpful-command)))

;;;; Keys

(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-x C-r") #'recentf-open)

;;;; Magit

(use-package magit
  :bind ("C-x g" . magit-status)
  :init
  (setq magit-diff-refine-hunk 'all))   ; word-level highlights in every hunk

;; TODO/FIXME/HACK in code: highlighted, and listed in magit-status.
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :bind (:map hl-todo-mode-map
         ("M-g t" . hl-todo-next)
         ("M-g T" . hl-todo-previous)))

(use-package magit-todos
  :after magit
  :config
  ;; The rg scanner omits the search path, so rg reads Emacs's stdin pipe
  ;; and finds nothing.  git grep is reliable; --untracked also covers new
  ;; files an agent hasn't committed (still honouring .gitignore).
  (setq magit-todos-scanner #'magit-todos--scan-with-git-grep
        magit-todos-git-grep-extra-args '("--untracked"))
  (magit-todos-mode 1))

;; `git commit' from a shell opens COMMIT_EDITMSG via emacsclient; set it up
;; as magit would (C-c C-c to commit, C-c C-k to abort) without loading magit
;; at startup.
(defun my/git-commit-setup ()
  (require 'git-commit)
  (git-commit-setup))
(add-to-list 'auto-mode-alist
             '("/\\(?:\\(?:COMMIT\\|NOTES\\|TAG\\)_EDIT\\|MERGE_\\)MSG\\'"
               . my/git-commit-setup))

;; Structural diffs; needs the difft binary (difftastic) on PATH.
;; In magit's diff menu (d): M-d diff, M-c show commit.
(use-package difftastic
  :defer t)

(use-package difftastic-bindings
  :ensure difftastic
  :config
  (difftastic-bindings-mode 1))

;; Changed-line markers in the left margin of file buffers (terminals have no
;; fringe), kept in sync with magit.
(use-package diff-hl
  :demand t
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (dired-mode . diff-hl-dired-mode))
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1)            ; update before saving, not just on save
  (diff-hl-margin-mode 1))

;;;; Languages: Rust and C++

;; Use tree-sitter modes, building grammars on first use (needs cc and git).
(setopt treesit-enabled-modes '(rust-ts-mode c-ts-mode c++-ts-mode
                                c-or-c++-ts-mode toml-ts-mode)
        treesit-auto-install-grammar 'always
        treesit-font-lock-level 4)

;; Emacs 31.1 ships markdown-ts-mode but neither autoloads it nor maps .md.
(autoload 'markdown-ts-mode "markdown-ts-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-ts-mode))

(defun my/eglot-format-on-save ()
  "Format with the language server on save.
Rust always (rustfmt is the convention); C/C++ only when the project
has a .clang-format, so other people's code isn't reformatted."
  (when (or (derived-mode-p 'rust-ts-mode)
            (locate-dominating-file default-directory ".clang-format"))
    (add-hook 'before-save-hook #'eglot-format-buffer nil t)))

(defun my/eglot-ensure-if-installed ()
  "Start eglot only when this mode's language server is on PATH."
  (when (executable-find (if (derived-mode-p 'rust-ts-mode) "rust-analyzer" "clangd"))
    (eglot-ensure)))

(use-package eglot
  :ensure nil
  :hook (((rust-ts-mode c-ts-mode c++-ts-mode) . my/eglot-ensure-if-installed)
         (eglot-managed-mode . my/eglot-format-on-save))
  :bind (:map eglot-mode-map
         ("C-c r" . eglot-rename)
         ("C-c a" . eglot-code-actions)
         ("C-c f" . eglot-format-buffer))
  :config
  (setq eglot-autoshutdown t            ; stop the server with its last buffer
        eglot-events-buffer-config '(:size 0 :format full)) ; no event log
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c++-ts-mode c-or-c++-ts-mode)
                 "clangd" "--background-index" "--clang-tidy"
                 "--header-insertion=never"))
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer (:check (:command "clippy")))))

(use-package flymake
  :ensure nil
  :config
  ;; Error markers in the right margin; the left one belongs to diff-hl.
  (setq flymake-indicator-type 'margins
        flymake-margin-indicator-position 'right-margin)
  :bind (:map flymake-mode-map
         ("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

;; project › file › impl Foo › fn bar, in the header line.
(use-package breadcrumb
  :hook (prog-mode . breadcrumb-local-mode))

;; Keep eldoc to one line in the echo area; C-h . shows the full doc.
(setq eldoc-echo-area-use-multiline-p nil)

;; Inline completion preview as you type (TAB accepts).
(add-hook 'prog-mode-hook #'completion-preview-mode)

;; M-x compile / C-x p c: follow output, render cargo's colours.
(setq compilation-scroll-output 'first-error
      compilation-ask-about-save nil)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;;;; Terminal UI

;; Kitty keyboard protocol: lets terminals that support it (Ghostty, kitty,
;; WezTerm) send keys like C-. and C-` that plain terminals can't.
(use-package kkp
  :config
  (global-kkp-mode 1))

(xterm-mouse-mode 1)
;; Copy to the local clipboard, even over ssh, with OSC 52.
(setq xterm-extra-capabilities '(setSelection))

;; A solid line between side-by-side windows instead of "|".
(unless standard-display-table
  (setq standard-display-table (make-display-table)))
(set-display-table-slot standard-display-table 'vertical-border ?│)

;;;; Terminal emulator (ghostel)

(use-package ghostel
  :bind (("C-x m" . ghostel)
         :map ghostel-semi-char-mode-map
         ;; Shell history on M-p/M-n, like eshell and comint.
         ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
         ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl"))))
  :init
  ;; Fetch the prebuilt native module without asking (re-fetched after upgrades).
  (setq ghostel-module-auto-install 'download)
  :hook (ghostel-mode . (lambda () (setq-local global-hl-line-mode nil)))
  :config
  ;; Lets `gst' in the shell open magit (see shell setup notes).
  (add-to-list 'ghostel-eval-cmds
               '("magit-status-setup-buffer" magit-status-setup-buffer))
  (add-to-list 'ghostel-eval-cmds
               '("find-file-other-window" find-file-other-window)))

;; The ghostel-* extensions ship inside the ghostel package.
(use-package ghostel-project
  :ensure nil
  :bind (:map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :init
  (with-eval-after-load 'project
    (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)))

(use-package ghostel-eshell
  :ensure nil
  :hook (eshell-load . ghostel-eshell-visual-command-mode))

;;; init.el ends here
