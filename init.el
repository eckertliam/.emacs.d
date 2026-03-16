;; -*- lexical-binding: t; -*-

;;;; ---- Package setup ----

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;;; ---- General settings ----

;; Ghostty terminal support
(add-to-list 'term-file-aliases '("ghostty" . "xterm-256color"))

;; Clipboard in terminal
(use-package clipetty
  :ensure t
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
(savehist-mode 1)
(recentf-mode 1)
(save-place-mode 1)
(electric-pair-mode 1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)

;; Restore GC after startup
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;;;; ---- Theme ----

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-challenger-deep t))

;;;; ---- Icons ----

(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

;;;; ---- Modeline ----

(use-package doom-modeline
  :ensure t
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
  :ensure t
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
  :ensure t
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.5))

;;;; ---- Minibuffer completion (vertico stack) ----

(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init (marginalia-mode))

(use-package consult
  :ensure t
  :bind (("C-x b"   . consult-buffer)
         ("C-x r b" . consult-bookmark)
         ("M-g g"   . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-s r"   . consult-ripgrep)
         ("M-s l"   . consult-line)
         ("M-s f"   . consult-find)))

;;;; ---- In-buffer completion (corfu) ----

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :init (global-corfu-mode))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;;;; ---- LSP (eglot) ----

(use-package eglot
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
  :ensure t
  :hook (rust-ts-mode . cargo-minor-mode))

;;;; ---- C++ ----

;; c++-ts-mode is built-in, just configure style
(add-hook 'c++-ts-mode-hook
          (lambda () (setq c-ts-mode-indent-offset 4)))
(add-hook 'c-ts-mode-hook
          (lambda () (setq c-ts-mode-indent-offset 4)))

;;;; ---- Git ----

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package diff-hl
  :ensure t
  :hook ((after-init . global-diff-hl-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

;;;; ---- Navigation ----

(use-package avy
  :ensure t
  :bind ("M-j" . avy-goto-char-timer))

;;;; ---- Undo ----

(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo))

;;;; ---- Visual extras ----

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-responsive 'top))

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode))

;;;; ---- Diagnostics (flymake, built-in, used by eglot) ----

(use-package flymake
  :hook ((rust-ts-mode c++-ts-mode c-ts-mode) . flymake-mode)
  :bind (:map flymake-mode-map
         ("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
