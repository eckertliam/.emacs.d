;;; custom-init.el --- Loads up Emacs

;;; Commentary:
;; An optimized Emacs config
;; Author: Liam Eckert <liameckert17@gmail.com>


;;; Code:

(defun get-fullpath (@file-relative-path)
  (concat (file-name-directory (or load-file-name buffer-file-name)) @file-relative-path))

(load (get-fullpath "init-settings.el"))
(load (get-fullpath "package-settings.el"))
(load (get-fullpath "visual-packs.el"))
(load (get-fullpath "devel-packs.el"))
(load (get-fullpath "rust-packs.el"))
(load (get-fullpath "python-packs.el"))
(load (get-fullpath "org-settings.el"))
(load (get-fullpath "base-settings.el"))
(load (get-fullpath "commonlisp.el"))

(provide 'init-el)

;;; custom-init.el ends here
