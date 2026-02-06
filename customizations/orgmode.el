;; org-mode customizations
(require 'org)

;; treat all files in ~/org as org files
(defun set-org-mode-for-org-directory ()
  "Set org-mode for any file in ~/org directory."
  (when (string-prefix-p (expand-file-name "~/org") (buffer-file-name))
    (org-mode)))

;; add the function to find-file-hook
(add-hook 'find-file-hook 'set-org-mode-for-org-directory)

;; default to /not/ truncate lines...
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

;; bind <C-c c> to org-capture
(global-set-key (kbd "C-c c") #'org-capture)

;; add timestamp automatically to done tasks (C-c C-t)
(setq org-log-done 'time)

;; move done tasks to archive when: C-c C-x C-a
(setq org-archive-location "~/org/todo-done.org::* Finished Tasks")


;; capture templates for use with C-c c

;; create quick note journal template
(setq org-capture-templates
      '(("j" "Journal Entry" entry
         (file+olp+datetree "~/org/journal.org")
         "* %<%H:%M> %?\n"
         :empty-lines 1)))

;; create global todo list
(add-to-list  'org-capture-templates
              '("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
                "\n* TODO %?\n  - Captured on: %U\n  %i\n  %a\n"))
