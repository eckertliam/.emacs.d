(use-package jedi
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup))
