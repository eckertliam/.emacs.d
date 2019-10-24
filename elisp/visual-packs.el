;;; visual-packs.el --- Settings effecting the aesthetic of Emacs

;;; Commentary:
;; An optimized Emacs config
;; Author: Liam Eckert <liameckert17@gmail.com>


;;; Code:

(use-package nord-theme
  :ensure t
  :config (load-theme 'nord t))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-major-mode-color-icon nil)
  (setq doom-modeline-env-version nil))


(use-package all-the-icons
  :ensure t)

(use-package golden-ratio
  :ensure t
  :config (golden-ratio-mode 1))


(provide 'visual-packs)

;;; visual-packs.el ends here
