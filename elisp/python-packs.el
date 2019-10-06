;;; python-packs.el --- Packages that support python ide

;;; Commentary:
;; An optimized Emacs config
;; Author: Liam Eckert <liameckert17@gmail.com>


;;; Code:


(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(use-package py-autopep8
  :ensure t
  :config (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))


(provide 'python-packs)

;;; python-packs.el ends here
