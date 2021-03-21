;;; org-config.el --- customizations for org-mode

;;; Commentary:
;; Author: Liam Eckert

;;; Code:

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)


(defun open-journal-file ()
  (let* ((today (format-time-string "%Y-%m-%d"))
         (path (concat (getenv "HOME") "/.emacs.d/org/journal" today ".org"))
         (hdr-list (list (concat "#+TITLE: [" today "]")))
         (hdr (apply 'concat
                     (mapcar (lambda (s) (concat s "\n"))
                             hdr-list)))
         (has-hdr (lambda ()
                    (save-excursion
                      (goto-char (point-min))
                      (search-forward "#+TITLE" nil t)))))
    (message (concat "opening " path " ..."))
    (find-file path)
    (unless (funcall has-hdr)
      (save-excursion
        (goto-char (point-min))
        (insert hdr)))
    (message "Have a good day!")))

(global-set-key "\C-c\C-j"
                (lambda ()
                  (interactive)
                  (open-journal-file)))



;;; org-config.el ends here
