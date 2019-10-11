;;; org-settings.el --- Org config

;;; Commentary:
;; Author: Liam Eckert <liameckert17@gmail.com>

;;; Code:

(require 'org)
(require 'org-capture)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)



(setq org-capture-templates
      '(
        ("t" "todo" entry (file+headline "~/org/todo.org" "Tasks")
         "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n")
        ("j" "Journal Entry" entry (file+datetree "~/org/journal.org")
         "* %?"
         :empty-lines 1)))


;;; org-settings.el ends here
