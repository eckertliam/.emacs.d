;;; ocaml.el --- adds support for ocaml

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(use-package tuareg
  :defer
  :ensure t)

(use-package merlin
  :ensure t
  :defer
  :config
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'merlin-company-backend))
  (add-hook 'merlin-mode-hook 'company-mode))

;;; ocaml.el ends here
