(use-package js2-mode
  :mode
  (("\\.js\\'" . js2-mode))
  :config
  (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append))

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)
		 (js2-mode . setup-tide-mode)))

(use-package indium
  :hook ((js2-mode . indium-interaction-mode))) 
