;;; visual.el --- all packages that effect the look of my Emacs

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(use-package nord-theme
  :ensure t
  :config (load-theme 'nord t))

(use-package mood-line
  :ensure t
  :config
  (mood-line-mode 1))

;;; visual.el ends here
