;;; early-init.el --- Loaded before the GUI and package system -*- lexical-binding: t; -*-

;; Raise the GC threshold during startup, then restore a sane value.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;; Drop UI chrome before the first frame is drawn, avoiding a flash.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

(setq frame-inhibit-implied-resize t
      inhibit-startup-screen t
      initial-scratch-message nil)

;;; early-init.el ends here
