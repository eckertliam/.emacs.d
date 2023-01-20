;; displays possible key combos
(use-package which-key
  :ensure t
  :straight t
  :config (which-key-mode t))

;; closes parens automatically and some other fancy stuff
(use-package smartparens
  :ensure t
  :straight t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package company
  :ensure t
  :straight t
  :config (global-company-mode t))

;; counsel pulls in ivy and swiper as dependencies
(use-package counsel
  :ensure t
  :straight t
  :config
  (ivy-mode 1)
  (counsel-mode 1)
  (setq ivy-use-virtual-buffers t
		ivy-count-format "%d/%d "))


;; https://emacs-lsp.github.io/lsp-mode/page/installation/
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (setq rustic-analyzer-command '("~/.cargo/bin/rust-analyzer"))
  :hook
  ((rustic-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)


