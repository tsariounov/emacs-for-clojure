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

;; default notes (ie journal) file
(setq org-default-notes-file "~/org/journal.org")

;; create quick note journal template (for use with <C-c c>
(setq org-capture-templates
      '(("j" "Journal Entry" entry
         (file+olp+datetree org-default-notes-file)
         "* %<%H:%M> %?\n"
         :empty-lines 1)))
