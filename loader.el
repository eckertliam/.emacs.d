;;; loader.el --- responsible for loading major packages and basic visual settings

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(load (get-fullpath "core/package.el"))
(load (get-fullpath "core/base.el"))
(load (get-fullpath "core/completion.el"))
(load (get-fullpath "core/visual.el"))

;; Variables for optional languages mark true if used

(let ((use-rust t))
  (if use-rust
      (load (get-fullpath "languages/rust.el"))))

(let ((use-ocaml t))
  (if use-ocaml
      (load (get-fullpath "languages/ocaml.el"))))

(let ((use-racket t))
  (if use-racket
      (load (get-fullpath "languages/racket.el"))))

;;; loader.el ends here
