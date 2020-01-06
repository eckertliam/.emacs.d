;;; visual.el --- all packages that effect the look of my Emacs

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-nord t))

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;;; visual.el ends here
