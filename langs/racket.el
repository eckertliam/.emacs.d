;; https://www.racket-mode.com/#Install-Update-and-Uninstall
(use-package racket-mode
  :bind-keymap
  ("C-c C-r" . 'racket-run-and-switch-to-repl)
  ("C-c C-n" . 'racket-run)
  ("C-c C-d" . 'racket-run-with-debugging)
  :config
  (setq tab-always-indent 'complete))

