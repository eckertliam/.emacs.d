;;; loader.el --- responsible for loading major packages and basic visual settings

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(load (get-fullpath "package.el"))
(load (get-fullpath "base.el"))
(load (get-fullpath "completion.el"))
(load (get-fullpath "visual.el"))

;;; loader.el ends here
