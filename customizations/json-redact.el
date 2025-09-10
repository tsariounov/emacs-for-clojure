;;; json-redact.el --- Redact sensitive keys in JSON files -*- lexical-binding: t; -*-

;; Author: GitHub Copilot
;; Version: 1.0.0
;; Package-Requires: ((emacs "24.3"))
;; Keywords: json, security

;;; Commentary:

;; Simple package to redact sensitive JSON values like passwords, tokens, etc.
;; Written with copilot agent mode, clause sonnet 4 model, and a few iterations...

;;; Code:

(require 'cl-lib)

(defvar json-redact-sensitive-keys
  '("secret" "password" "pwd" "token" "key" "credential" "pat")
  "List of regex patterns that should be redacted in JSON files.
Each pattern will match keys containing these substrings.")

(defvar json-redact-replacement-text "***REDACTED***"
  "Text to show instead of sensitive values.")

(defvar-local json-redact-overlays nil
  "List of overlays used for redaction in the current buffer.")

(defvar-local json-redact-active nil
  "Whether redaction is currently active in this buffer.")

(defun json-redact--key-matches-p (key)
  "Check if KEY matches any of the sensitive key patterns."
  (let ((key-lower (downcase key)))
    (cl-some (lambda (pattern)
               (string-match-p (downcase pattern) key-lower))
             json-redact-sensitive-keys)))

(defun json-redact--find-json-values ()
  "Find all JSON key-value pairs in the current buffer.
Returns a list of (start end key value) tuples."
  (let ((results '()))
    (save-excursion
      (goto-char (point-min))
      ;; Look for JSON key-value patterns: "key": "value" or "key": value
      (while (re-search-forward
              "\"\\([^\"]+\\)\"\\s-*:\\s-*\\(\"[^\"]*\"\\|[^,}\n]+\\)"
              nil t)
        (let* ((key (match-string 1))
               (value-start (match-beginning 2))
               (value-end (match-end 2))
               (value (match-string 2)))
          (when (json-redact--key-matches-p key)
            (push (list value-start value-end key value) results)))))
    (nreverse results)))

(defun json-redact--create-overlays ()
  "Create overlays for all sensitive values in the buffer."
  (json-redact--remove-overlays)
  (let ((values (json-redact--find-json-values)))
    (dolist (value-info values)
      (let* ((start (nth 0 value-info))
             (end (nth 1 value-info))
             (key (nth 2 value-info))
             (original-value (nth 3 value-info))
             (overlay (make-overlay start end)))
        (overlay-put overlay 'display json-redact-replacement-text)
        (overlay-put overlay 'face '(:foreground "red" :weight bold))
        (push overlay json-redact-overlays)))))

(defun json-redact--remove-overlays ()
  "Remove all redaction overlays from the current buffer."
  (dolist (overlay json-redact-overlays)
    (delete-overlay overlay))
  (setq json-redact-overlays nil))

;;;###autoload
(defun json-redact-toggle ()
  "Toggle redaction of sensitive keys in the current JSON buffer."
  (interactive)
  (if json-redact-active
      (progn
        (json-redact--remove-overlays)
        (setq json-redact-active nil)
        (message "JSON redaction disabled"))
    (progn
      (json-redact--create-overlays)
      (setq json-redact-active t)
      (message "JSON redaction enabled (%d values redacted)"
               (length json-redact-overlays)))))



(defvar json-redact-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c r") 'json-redact-toggle)
    map)
  "Keymap for `json-redact-mode'.")

;;;###autoload
(define-minor-mode json-redact-mode
  "Minor mode for redacting sensitive keys in JSON files."
  :lighter " Redact"
  :keymap json-redact-mode-map
  (if json-redact-mode
      (message "JSON Redact mode enabled. Press C-c r to toggle redaction.")
    (when json-redact-active
      (json-redact--remove-overlays)
      (setq json-redact-active nil))))

;; Auto-enable for JSON files
;;;###autoload
(defun json-redact-setup ()
  "Setup json-redact-mode for JSON files and automatically enable redaction."
  (json-redact-mode 1)
  (json-redact-toggle))

;;;###autoload
(add-hook 'json-mode-hook 'json-redact-setup)
;;;###autoload
(add-hook 'json-ts-mode-hook 'json-redact-setup)
;;;###autoload
(add-hook 'js-json-mode-hook 'json-redact-setup)

(provide 'json-redact)

;;; json-redact.el ends here
