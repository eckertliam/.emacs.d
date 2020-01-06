;;; commonlsp.el --- adds support for common lisp specifically sbcl

;;; Commentary:
;; Author: Liam Eckert


;;; Code:

(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

;;; commonlsp.el ends here
