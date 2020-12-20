;;; rust.el --- autocompletion and everything else for rust

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(use-package toml-mode)

(use-package rust-mode
  :defer
  :ensure t
  :hook (rust-mode . lsp))

(use-package cargo
  :ensure t
  :defer
  :bind
  ("C-c C-c C-r" . cargo-process-run)
  ("C-c C-c C-b" . cargo-process-build)
  ("C-c C-c C-t" . cargo-process-test)
  :hook (rust-mode . cargo-minor-mode))

(use-package racer
  :ensure t
  :defer
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode))

(use-package flycheck-rust
  :ensure t
  :defer
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;;; rust.el ends here
