;; org-mode customizations
(require 'org)

;; treat all files in ~/org as org files
(defun set-org-mode-for-org-directory ()
  "Set org-mode for any file in ~/org directory."
  (when (string-prefix-p (expand-file-name "~/org") (buffer-file-name))
    (org-mode)))

;; add the function to find-file-hook
(add-hook 'find-file-hook 'set-org-mode-for-org-directory)
