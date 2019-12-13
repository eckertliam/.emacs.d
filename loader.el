;;; loader.el --- responsible for loading major packages and basic visual settings

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(load (get-fullpath "core/package.el"))
(load (get-fullpath "core/base.el"))
(load (get-fullpath "core/completion.el"))
(load (get-fullpath "core/visual.el"))

;; Variables for optional languages mark true if used

(defvar use-rust t)

(if use-rust
    (load (get-fullpath "languages/rust.el")))


;;; loader.el ends here
