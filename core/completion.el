;; displays possible key combos
(use-package which-key
  :straight t
  :config (which-key-mode t))

;; closes parens automatically and some other fancy stuff
(use-package smartparens
  :straight t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package company
  :straight t
  :config (global-company-mode t))

;; counsel pulls in ivy and swiper as dependencies
(use-package counsel
  :straight t
  :config
  (ivy-mode 1)
  (counsel-mode 1)
  (setq ivy-use-virtual-buffers t
		ivy-count-format "%d/%d "))


;; https://emacs-lsp.github.io/lsp-mode/page/installation/
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  ((rust-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
