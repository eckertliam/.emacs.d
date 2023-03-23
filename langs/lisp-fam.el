(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package racket-mode
  :bind-keymap
  ("C-c C-r" . 'racket-run-and-switch-to-repl)
  ("C-c C-n" . 'racket-run)
  ("C-c C-d" . 'racket-run-with-debugging)
  :config
  (setq tab-always-indent 'complete))
