;;; rust.el --- autocompletion and everything else for rust

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(use-package rust-mode
  :ensure t)

(use-package cargo
  :ensure t
  :bind
  ("C-c C-c C-r" . cargo-process-run)
  ("C-c C-c C-b" . cargo-process-build)
  ("C-c C-c C-t" . cargo-process-test)
  :config
  (add-hook 'rust-mode-hook #'cargo-minor-mode))

(use-package racer
  :ensure t
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode))

(use-package flycheck-rust
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;;; rust.el ends here
