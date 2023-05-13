(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package racket-mode
  :ensure t
  :bind-keymap
  ("C-c C-r" . 'racket-run-and-switch-to-repl)
  ("C-c C-n" . 'racket-run)
  ("C-c C-d" . 'racket-run-with-debugging)
  :config
  (setq tab-always-indent 'complete)
  (add-hook 'racket-mode-hook #'racket-xp-mode))

(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'smartparens-strict-mode))

(use-package cider
  :ensure t)
