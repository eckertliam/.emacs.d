;;; langload.el --- loads all the language support packages

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(load (get-fullpath "python.el"))
(load (get-fullpath "rust.el"))
(load (get-fullpath "lisp.el"))

;;; langload.el ends here
