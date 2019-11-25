;;; haskell.el --- all haskell packages

;;; Commentary:
;; Author: Liam Eckert

;;; Code:


(use-package haskell-mode
  :ensure t
  :config
  (add-hook 'haskell-mode-hook
            (lambda ()
              (set (make-local-variable 'company-backends)
                   (append '((company-capf company-dabbrev-code))
                           company-backends))))
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indent))

;;; haskell.el ends here
