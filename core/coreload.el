;;; coreload.el --- responsible for loading core

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(load (get-fullpath "package.el"))
(load (get-fullpath "base.el"))
(load (get-fullpath "completion.el"))
(load (get-fullpath "visual.el"))
(load (get-fullpath "org-config.el"))

;;; coreload.el ends here
