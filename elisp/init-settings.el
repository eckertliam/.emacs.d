;;; init-settings.el --- Init settings independent of any packages

;;; Commentary:
;; An optimized Emacs config
;; Author: Liam Eckert <liameckert17@gmail.com>

;;; Code:

;;; Garbage collection:

;; Set garbage collection threshold higher for init
(setq gc-cons-threshold 100000000)
;; Default garbage collection threshold
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

(defmacro k-time (&rest body)
  "Measure and return the time it takes evaluating BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))

;; When idle for 10s run the GC no matter what
(defvar k-gc-timer
  (run-with-idle-timer 10 t
                       (lambda ()
                         (message "Garbage Collector has run for %.06fsec"
                                  (k-time (garbage-collect))))))

(setq inhibit-startup-screen t)

(provide 'init-settings)

;;; init-settings.el ends here
