;;; rust.el --- autocompletion and everything else for rust

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(use-package rust-mode
  :ensure t
  :bind
  ("C-c <tab>" . rust-format-buffer))

(use-package cargo
  :ensure t
  :defer
  :bind
  ("C-c C-c C-r" . cargo-process-run)
  ("C-c C-c C-b" . cargo-process-build)
  ("C-c C-c C-t" . cargo-process-test)
  :hook (cargo-minor-mode))

(use-package racer
  :ensure t
  :defer
  :hook
  (rust-mode-hook . racer-mode)
  (racer-mode-hook . eldoc-mode)
  (racer-mode-hook . company-mode))

(use-package flycheck-rust
  :ensure t
  :defer
  :hook
  (flycheck-mode-hook . flycheck-rust-setup))

;;; rust.el ends here
