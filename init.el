;;; init.el --- the initial package that leads to everything else

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

;; Set garbage collection threshold higher for init
(setq gc-cons-threshold 100000000)

(defvar gc-timer
  (run-with-idle-timer 10 t
                       (lambda ()
             (garbage-collect))))

(setq inhibit-startup-screen t)

(defun get-fullpath (file-relative-path)
  "Gets path relative to call location of FILE-RELATIVE-PATH."
  (concat (file-name-directory (or load-file-name buffer-file-name)) file-relative-path))

(load (get-fullpath "core/coreload.el"))
(load (get-fullpath "languages/langload.el"))

;; Default garbage collection threshold
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7546a14373f1f2da6896830e7a73674ef274b3da313f8a2c4a79842e8a93953e" "e27556a94bd02099248b888555a6458d897e8a7919fd64278d1f1e8784448941" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "fce3524887a0994f8b9b047aef9cc4cc017c5a93a5fb1f84d300391fba313743" default))
 '(package-selected-packages
   '(clojure-mode tern py-autopep8 elpy flycheck-rust racer cargo rust-mode rustic lsp-mode lsp-ui go-mode haskell-mode cider racket-mode merlin tuareg irony-eldoc flycheck-irony company-irony irony doom-modeline all-the-icons doom-themes magit smartparens flycheck company helm use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
