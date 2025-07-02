;; Bootstrap Straight (https://github.com/radian-software/straight.el)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Turn off annoying defaults
;; and set basics 
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(global-display-line-numbers-mode)
(setq ring-bell-function 'ignore)

(require 'which-key)

;; setup ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
