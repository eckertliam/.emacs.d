;;; python.el --- adds support for python

;;; Commentary:
;; Author: Liam Eckert


;;; Code:

(use-package elpy
  :ensure t
  :defer
  :config
  (elpy-enable)
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(use-package py-autopep8
  :ensure t
  :defer
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

;;; python.el ends here
