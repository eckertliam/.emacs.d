;;; c-packs.el --- C utilities

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(use-package irony
  :ensure t
  :config
  (progn
    (unless (irony--find-server-executable) (call-interactively #'irony-install-server))

    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)

    (setq-default irony-cdb-compilation-databases '(irony-cdb-libclang
                                                      irony-cdb-clang-complete))

    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  ))

  (use-package company-irony
    :ensure t
    :config
    (progn
      (eval-after-load 'company '(add-to-list 'company-backends 'company-irony))))

  (use-package flycheck-irony
    :ensure t
    :config
    (progn
      (eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))

  (use-package irony-eldoc
    :ensure t
    :config
    (progn
      (add-hook 'irony-mode-hook #'irony-eldoc)))

;;; c-packs.el ends here
