;;; loader.el --- responsible for loading major packages and basic visual settings

;;; Commentary:
;; Author: Liam Eckert

;;; Code:



;; Variables for optional languages mark true if used

(let ((use-core t))
  (if use-core
      (load (get-fullpath "core/coreload.el"))))

(let ((use-rust nil))
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

;;; loader.el ends here
