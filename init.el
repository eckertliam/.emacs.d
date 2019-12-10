;;; init.el --- the initial package that leads to everything else

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

;; Set garbage collection threshold higher for init
(setq gc-cons-threshold 100000000)
;; Default garbage collection threshold
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

(defvar gc-timer
  (run-with-idle-timer 10 t
                       (lambda ()
			 (garbage-collect))))

(setq inhibit-startup-screen t)

(defun get-fullpath (file-relative-path)
  "Gets path relative to call location of FILE-RELATIVE-PATH."
  (concat (file-name-directory (or load-file-name buffer-file-name)) file-relative-path))

(load (get-fullpath "./core/loader.el"))

;;; init.el ends here
