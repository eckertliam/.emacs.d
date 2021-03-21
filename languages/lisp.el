;;; lisp.el --- adds support for lisp family variants

;;; Commentary:
;; Author: Liam Eckert

;;; Code:


;; All that is needed for CL
(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

;; All that is needed for Clojure
(use-package cider
  :ensure t
  :defer)

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))


;; All that is needed for Racket
(use-package racket-mode
  :ensure t
  :defer)

;;; lisp.el ends here
