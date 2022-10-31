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
