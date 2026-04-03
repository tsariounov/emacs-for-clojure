;; Custom theme mini switcher, only shows faves

(defun my/theme-selector ()
  "Show a menu of my favorite themes and apply the selection."
  (interactive)
  (let* ((my-favorites '("doom-pine"
                         "modus-vivendi-tinted"
                         "doom-acario-dark"
                         "doom-tokyo-night"
                         "doom-dracula"
                         "doom-solarized-dark"
                         "misterioso"))
         (choice (completing-read "Switch to theme: " my-favorites nil t)))
    (when (and choice (not (string-empty-p choice)))
      ;; Disable all current themes to prevent color clashing
      (mapc #'disable-theme custom-enabled-themes)
      ;; Load selection; 't' skips the "really load this?" security prompt
      (load-theme (intern choice) t)
      (message "Theme switched to %s" choice))))

(global-set-key (kbd "C-c t") 'my/theme-selector)
