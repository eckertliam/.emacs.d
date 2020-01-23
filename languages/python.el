;;; python.el --- adds support for python

;;; Commentary:
;; Author: Liam Eckert


;;; Code:

(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(use-package py-autopep8
  :ensure t
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

;;; python.el ends here
