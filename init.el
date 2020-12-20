;;; init.el --- the initial package that leads to everything else

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

;; Set garbage collection threshold higher for init

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
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
(load (get-fullpath "langs/rust.el"))

;; Default garbage collection threshold
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rustic lsp-mode lsp-ui go-mode haskell-mode cider racket-mode merlin tuareg irony-eldoc flycheck-irony company-irony irony doom-modeline all-the-icons doom-themes magit smartparens flycheck company helm use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
