;;; early-init.el --- Loaded before the package system -*- lexical-binding: t; -*-

;; Raise the GC threshold during startup, then restore a sane value.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;; Terminal-only config: no menu bar row at the top of the frame.
(setq menu-bar-mode nil
      inhibit-startup-screen t
      initial-scratch-message nil)

;;; early-init.el ends here
