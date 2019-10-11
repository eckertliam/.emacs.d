;;; base-settings.el --- Basic settings independent of any packages

;;; Commentary:
;; An optimized Emacs config
;; Author: Liam Eckert <liameckert17@gmail.com>


;;; Code:

(setq large-file-warning-threshold 10000000)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
           (abbreviate-file-name (buffer-file-name))
           "%b"))))

(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)
(setq-default tab-width 4
              indent-tabs-mode nil)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(add-hook 'before-save-hook 'whitespace-cleanup)

(setq backup-directory-alist `(("." . "~/.emacs.d/saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

(if (y-or-n-p "Would you like to make a journal entry?")
    (progn
      (org-capture)
    )
  (progn
    (print "Enjoy your day!")
  )
)

(provide 'base-settings)

;;; base-settings.el ends here
