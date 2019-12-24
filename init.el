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

(load (get-fullpath "loader.el"))

;; Default garbage collection threshold
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (racket-mode merlin tuareg mood-line nord-theme magit smartparens flycheck company helm use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
