;;; rust-packs.el --- Packages that support rust ide

;;; Commentary:
;; An optimized Emacs config
;; Author: Liam Eckert <liameckert17@gmail.com>


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

(provide 'rust-packs)

;;; rust-packs.el ends here
