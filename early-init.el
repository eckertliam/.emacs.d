;; Performance oriented changes for the init

;; Raise the gc threshold during startup
(setq gc-cons-threshold most-positive-fixnum)

(setq load-prefer-newer noninteractive)

;; Return to a normal gc threshold
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (expt 2 23))))

;; Setup for straight package manager
(setq package-enable-at-startup nil)
(setq straight-use-package-by-default t)
