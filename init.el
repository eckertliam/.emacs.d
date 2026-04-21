;; -*- lexical-binding: t; -*-

;;;; ---- Package setup (straight.el) ----

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         (or (bound-and-true-p straight-base-dir) user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;;; ---- General settings ----

;; Ghostty terminal support
(unless (display-graphic-p)
  (add-to-list 'term-file-aliases '("ghostty" . "xterm-256color")))

;; Clipboard in terminal
(use-package clipetty

  :unless (display-graphic-p)
  :hook (after-init . global-clipetty-mode))

;; Basics
(setq-default indent-tabs-mode nil
              tab-width 4)
(setq create-lockfiles nil
      make-backup-files nil
      auto-save-default nil
      ring-bell-function 'ignore
      use-short-answers t
      confirm-kill-emacs 'y-or-n-p
      scroll-margin 3
      scroll-conservatively 101)

(global-auto-revert-mode 1)
(setq auto-revert-interval 1)
(setq auto-revert-use-notify t)
(savehist-mode 1)
(recentf-mode 1)
(save-place-mode 1)
(electric-pair-mode 1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)

;; Mouse support in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 3)))
  (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 3))))

;; Smart GC — only collect when idle
(use-package gcmh

  :hook (after-init . gcmh-mode)
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024)))

;;;; ---- Theme ----

(use-package doom-themes

  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-challenger-deep t))

;;;; ---- Icons ----

(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion

  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu

  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired

  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-ibuffer

  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

;;;; ---- Modeline ----

(use-package doom-modeline

  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-file-name-style 'truncate-upto-project
        doom-modeline-buffer-state-icon t
        doom-modeline-vcs-max-length 20
        doom-modeline-height 1))

;;;; ---- Dashboard ----

(use-package dashboard

  :config
  (setq dashboard-banner-logo-title "Welcome back, Liam"
        dashboard-startup-banner (concat user-emacs-directory "banner.txt")
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-items nil
        dashboard-set-init-info t
        dashboard-set-navigator nil)
  (dashboard-setup-startup-hook))

;;;; ---- Which-key ----

(use-package which-key

  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.5))

;;;; ---- Minibuffer completion (vertico stack) ----

(use-package vertico

  :init (vertico-mode))

(use-package orderless

  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia

  :init (marginalia-mode))

(use-package consult

  :bind (("C-x b"   . consult-buffer)
         ("C-x r b" . consult-bookmark)
         ("M-g g"   . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-s r"   . consult-ripgrep)
         ("M-s l"   . consult-line)
         ("M-s f"   . consult-find)))

(use-package embark

  :bind (("C-."   . embark-act)
         ("C-;"   . embark-dwim)
         ("C-h B" . embark-bindings))
  :config
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult

  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package wgrep

  :config
  (setq wgrep-auto-save-buffer t))

;;;; ---- In-buffer completion (corfu) ----

(use-package corfu

  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :init (global-corfu-mode))

(use-package corfu-terminal
  :if (and (not (display-graphic-p)) (version< emacs-version "31"))
  :after corfu
  :config (corfu-terminal-mode 1))

(use-package cape

  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;;;; ---- LSP (eglot) ----

(use-package eglot
  :straight nil
  :hook ((rust-ts-mode . eglot-ensure)
         (c++-ts-mode  . eglot-ensure)
         (c-ts-mode    . eglot-ensure))
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0))

;;;; ---- Tree-sitter grammars ----

(setq treesit-language-source-alist
      '((rust   "https://github.com/tree-sitter/tree-sitter-rust")
        (cpp    "https://github.com/tree-sitter/tree-sitter-cpp")
        (c      "https://github.com/tree-sitter/tree-sitter-c")
        (toml   "https://github.com/tree-sitter/tree-sitter-toml")
        (json   "https://github.com/tree-sitter/tree-sitter-json")
        (yaml   "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
        (bash   "https://github.com/tree-sitter/tree-sitter-bash")
        (cmake  "https://github.com/uyha/tree-sitter-cmake")))

;; Auto-install missing grammars
(dolist (grammar treesit-language-source-alist)
  (unless (treesit-language-available-p (car grammar))
    (treesit-install-language-grammar (car grammar))))

;; Remap to tree-sitter modes
(setq major-mode-remap-alist
      '((rust-mode  . rust-ts-mode)
        (c++-mode   . c++-ts-mode)
        (c-mode     . c-ts-mode)
        (json-mode  . json-ts-mode)
        (yaml-mode  . yaml-ts-mode)
        (bash-mode  . bash-ts-mode)
        (toml-mode  . toml-ts-mode)
        (cmake-mode . cmake-ts-mode)))

;;;; ---- Rust ----

(use-package rust-mode
  :ensure t)

(use-package cargo

  :hook (rust-ts-mode . cargo-minor-mode))

;;;; ---- C++ ----

;; c++-ts-mode is built-in, just configure style
(add-hook 'c++-ts-mode-hook
          (lambda () (setq c-ts-mode-indent-offset 4)))
(add-hook 'c-ts-mode-hook
          (lambda () (setq c-ts-mode-indent-offset 4)))

;;;; ---- Git ----

(use-package magit

  :bind ("C-x g" . magit-status))

(use-package diff-hl

  :hook ((after-init . global-diff-hl-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1))
  (diff-hl-flydiff-mode 1))

;;;; ---- File management ----

(use-package dirvish

  :init (dirvish-override-dired-mode)
  :bind (("C-x d" . dirvish)
         :map dirvish-mode-map
         ("TAB" . dirvish-subtree-toggle)
         ("q"   . dirvish-quit))
  :config
  (setq dirvish-attributes '(nerd-icons file-size collapse subtree-state)
        dirvish-default-layout '(0 0.4 0.6)))

;;;; ---- Help ----

(use-package helpful

  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)))

;;;; ---- Navigation ----

(use-package avy

  :bind ("M-j" . avy-goto-char-timer))

;;;; ---- Undo ----

(use-package vundo

  :bind ("C-x u" . vundo))

;;;; ---- Visual extras ----

(use-package pulsar

  :hook (after-init . pulsar-global-mode)
  :config
  (setq pulsar-pulse t
        pulsar-delay 0.05
        pulsar-iterations 10))

(use-package lin

  :hook (after-init . lin-global-mode)
  :config
  (setq lin-mode-hooks
        '(dired-mode-hook
          magit-status-mode-hook
          magit-log-mode-hook
          occur-mode-hook
          org-agenda-mode-hook
          tabulated-list-mode-hook)))

(use-package rainbow-delimiters

  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-indent-guides

  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method (if (display-graphic-p) 'bitmap 'character)
        highlight-indent-guides-responsive 'top))

(use-package hl-todo

  :hook (prog-mode . hl-todo-mode))

;;;; ---- Popups ----

(use-package popper

  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "\\*Warnings\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode
          flymake-diagnostics-buffer-mode))
  :hook (emacs-startup . popper-mode))

;;;; ---- Writing ----

(use-package olivetti

  :hook ((markdown-mode . olivetti-mode)
         (org-mode . olivetti-mode))
  :config
  (setq olivetti-body-width 80))

;;;; ---- Eldoc ----

(use-package eldoc
  :straight nil
  :config
  (setq eldoc-echo-area-use-multiline-p t
        eldoc-echo-area-display-truncation-message nil))

;;;; ---- Compile ----

(use-package compile
  :straight nil
  :bind ("C-c c" . compile)
  :config
  (setq compilation-scroll-output t
        compilation-ask-about-save nil))

;; Auto-detect compile command per mode
(add-hook 'rust-ts-mode-hook
          (lambda () (setq-local compile-command "cargo build")))
(add-hook 'c++-ts-mode-hook
          (lambda () (setq-local compile-command "bazel build //...")))

;;;; ---- Terminal (eat) ----

(use-package eat
  :bind ("C-c t" . eat)
  :hook ((eshell-load . eat-eshell-mode)
         (eshell-load . eat-eshell-visual-command-mode))
  :config
  (setq eat-term-name "xterm-256color"))

;;;; ---- AI (hob) ----

(use-package hob
  :straight (:host github :repo "eckertliam/hob"
             :files ("lisp/*.el")
             :pre-build ("cargo" "build" "--release" "--manifest-path" "agent/Cargo.toml"))
  :config
  (setq hob-model "claude-opus-4-6"))

;;;; ---- GUI extras ----

(when (display-graphic-p)
  ;; Font — install JetBrains Mono / SF Pro for best results,
  ;; falls back to Menlo / Helvetica Neue
  (set-face-attribute 'default nil
                      :family (if (member "JetBrains Mono" (font-family-list))
                                  "JetBrains Mono" "Menlo")
                      :height 150
                      :weight 'normal)
  (set-face-attribute 'variable-pitch nil
                      :family (if (member "SF Pro" (font-family-list))
                                  "SF Pro" "Helvetica Neue")
                      :height 1.0)
  (setq-default line-spacing 2))

(use-package ligature
  :if (display-graphic-p)

  :config
  (ligature-set-ligatures 'prog-mode
                          '("==" "!=" ">=" "<=" "&&" "||"
                            "->" "=>" "::" "++" "--"
                            "<<" ">>" "/*" "*/" "//"
                            "#{" "#(" "#_" "#!" "#="
                            "<|" "|>" "||=" "&&="))
  (global-ligature-mode t))

(use-package spacious-padding
  :if (display-graphic-p)

  :hook (after-init . spacious-padding-mode)
  :config
  (setq spacious-padding-widths
        '(:internal-border-width 15
          :header-line-width 4
          :mode-line-width 6
          :tab-width 4
          :right-divider-width 20
          :scroll-bar-width 8
          :fringe-width 8)))

;;;; ---- Diagnostics (flymake, built-in, used by eglot) ----

(use-package flymake
  :straight nil
  :hook ((rust-ts-mode c++-ts-mode c-ts-mode) . flymake-mode)
  :bind (:map flymake-mode-map
         ("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))
(custom-set-variables)
(custom-set-faces)
