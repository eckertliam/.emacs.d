(use-package js2-mode
  :ensure t
  :mode
  (("\\.js\\'" . js2-mode))
  :config
  (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append))

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))


(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)
		 (js2-mode . setup-tide-mode)))

(use-package indium
  :ensure t
  :hook ((js2-mode . indium-interaction-mode))) 

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook  'emmet-mode))
