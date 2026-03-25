;;; jwt-decode.el --- Decode JWT claims from a region -*- lexical-binding: t; -*-

(require 'json)

(defun jwt--base64url-decode (str)
  "Decode a base64url-encoded STR to a unibyte string."
  (let* ((s (replace-regexp-in-string "-" "+" (replace-regexp-in-string "_" "/" str)))
         ;; Pad to a multiple of 4
         (padded (pcase (mod (length s) 4)
                   (2 (concat s "=="))
                   (3 (concat s "="))
                   (_ s))))
    (base64-decode-string padded)))

(defun jwt--decode-payload (token)
  "Decode the claims payload from a JWT TOKEN string.
Returns the parsed JSON as an alist."
  (let* ((parts (split-string (string-trim token) "\\."))
         (payload (nth 1 parts)))
    (unless (and parts (>= (length parts) 3))
      (error "Not a valid JWT token (expected 3 dot-separated parts)"))
    (unless payload
      (error "JWT token has no payload section"))
    (let ((decoded (jwt--base64url-decode payload)))
      (json-read-from-string decoded))))

(defun jwt--pp-json (alist)
  "Pretty-print an ALIST as indented JSON."
  (if (fboundp 'json-serialize)
      ;; Emacs 27+ native JSON
      (with-temp-buffer
        (insert (json-serialize alist :null-object nil :false-object :json-false))
        (json-pretty-print-buffer)
        (buffer-string))
    ;; Fallback: use json-encode + pretty-print
    (with-temp-buffer
      (insert (json-encode alist))
      (json-pretty-print-buffer)
      (buffer-string))))

;;;###autoload
(defun jwt-decode-region (beg end)
  "Decode the JWT token in the region between BEG and END.
Displays the decoded claims in a *JWT Claims* buffer."
  (interactive "r")
  (let* ((token (buffer-substring-no-properties beg end))
         (claims (jwt--decode-payload token))
         (buf (get-buffer-create "*JWT Claims*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (jwt--pp-json claims))
        (goto-char (point-min))
        (when (fboundp 'js-mode) (js-mode))
        (special-mode)))
    (display-buffer buf)))

;;;###autoload
(defun jwt-decode-at-point ()
  "Decode a JWT token at point (whitespace-delimited)."
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'filename)))
    (unless bounds
      (error "No token found at point"))
    (jwt-decode-region (car bounds) (cdr bounds))))

(provide 'jwt-decode)
;;; jwt-decode.el ends here
