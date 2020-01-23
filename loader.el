;;; loader.el --- responsible for loading major packages and basic visual settings

;;; Commentary:
;; Author: Liam Eckert

;;; Code:



;; Variables for optional languages mark true if used

(let ((use-core t))
  (if use-core
      (load (get-fullpath "core/coreload.el"))))

(let ((use-rust t))
  (if use-rust
      (load (get-fullpath "languages/rust.el"))))

(let ((use-ocaml nil))
  (if use-ocaml
      (load (get-fullpath "languages/ocaml.el"))))

(let ((use-racket nil))
  (if use-racket
      (load (get-fullpath "languages/racket.el"))))

(let ((use-commonlsp nil))
  (if use-commonlsp
      (load (get-fullpath "languages/commonlsp.el"))))

(let ((use-c-lang nil))
  (if use-c-lang
      (load (get-fullpath "languages/c-lang.el"))))

(let ((use-clojure nil))
  (if use-clojure
      (load (get-fullpath "languages/clojure.el"))))

(let ((use-python t))
  (if use-python
      (load (get-fullpath "languages/python.el"))))

;;; loader.el ends here
