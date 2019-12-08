(defun get-fullpath (@file-relative-path)
  (concat (file-name-directory (or load-file-name buffer-file-name)) @file-relative-path))

(if (file-exists-p (get-fullpath "user-settings.el"))
    (load (get-fullpath "/core/loader.el"))
  (load (get-fullpath "setup.el")))
		   
