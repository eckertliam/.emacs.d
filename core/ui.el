;; be gone ugly tool bar!
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)
(global-auto-revert-mode t)
(global-visual-line-mode t)

;; Make the beeps stop
(setq ring-bell-function 'ignore)

;; replaces yes or no with y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; stop ugly dumps on my init
(setq custom-file (make-temp-file "dump"))

;; treat all themes as safe because if you are installing an Emacs package you should trust it
(setq custom-safe-themes t)

;; stop large file warning
(setq large-file-warning-threshold 100000000)

;; stop splash screen
(setq inhibit-splash-screen t)

;; tab settings
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)

(setq scroll-step            1
      scroll-conservatively  10000)

;; makes current tile larger
(use-package golden-ratio
  :config (golden-ratio-mode 1))

(use-package doom-themes
  :config
  (load-theme 'doom-one))

(use-package mood-line
  :config (mood-line-mode))
