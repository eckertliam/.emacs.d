;;; visual-packs.el --- Settings effecting the aesthetic of Emacs

;;; Commentary:
;; An optimized Emacs config
;; Author: Liam Eckert <liameckert17@gmail.com>


;;; Code:

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-challenger-deep t)
  (doom-themes-visual-bell-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))


(use-package all-the-icons
  :ensure t)

(use-package golden-ratio
  :ensure t
  :config (golden-ratio-mode 1))

(provide 'visual-packs)

;;; visual-packs.el ends here
