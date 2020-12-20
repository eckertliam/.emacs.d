;;; langload.el --- loads all the language support packages

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(load (get-fullpath "rust.el"))
(load (get-fullpath "c-lang.el"))
(load (get-fullpath "clojure.el"))
(load (get-fullpath "commonlsp.el"))
(load (get-fullpath "go-lang.el"))
(load (get-fullpath "haskell.el"))
(load (get-fullpath "ocaml.el"))
(load (get-fullpath "python.el"))
(load (get-fullpath "racket.el"))

;;; langload.el ends here
