;;; loader.el --- responsible for loading major packages and basic visual settings

;;; Commentary:
;; Author: Liam Eckert

;;; Code:



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

(let ((use-commonlsp t))
  (if use-commonlsp
      (load (get-fullpath "languages/commonlsp.el"))))

;;; loader.el ends here
