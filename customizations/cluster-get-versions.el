;;; cluster-get-versions.el --- Query service versions across clusters -*- lexical-binding: t; -*-

(require 'url)
(require 'json)

(defvar cluster-services '("oauth-issuer" "service-identity" "sam" "signer"))
(defvar cluster-known-clusters '("gemini" "hoku" "polaris" "mira" "glcphf" "pavo" "aquila"))

(defun cluster-base-url (cluster)
  "Return the base API URL for CLUSTER."
  (if (member cluster '("pavo" "aquila"))
      (format "https://%s-org-api.common.cloud.hpe.com" cluster)
    (format "https://%s-default-org-api.ccs.arubathena.com" cluster)))

(defun cluster-get-version (cluster service)
  "Fetch the version of SERVICE on CLUSTER. Returns \"Unknown\" on failure."
  (let* ((url (format "%s/internal-platform/v1/service-versions/%s"
                      (cluster-base-url cluster) service))
         (url-request-method "GET")
         (response-buf (condition-case nil
                           (url-retrieve-synchronously url t nil 10)
                         (error nil))))
    (if response-buf
        (unwind-protect
            (with-current-buffer response-buf
              (condition-case nil
                  (progn
                    (goto-char (point-min))
                    (re-search-forward "\n\n")
                    (let* ((json-array-type 'list)
                           (data (json-read)))
                      (if (and data (listp data))
                          (let ((val (cdar data)))
                            (if (and val (stringp val))
                                val
                              "Unknown"))
                        "Unknown")))
                (error "Unknown")))
          (kill-buffer response-buf))
      "Unknown")))

(defun cluster-get-versions (&optional cluster)
  "Display service versions for CLUSTER, or all known clusters if nil.
When called interactively, prompts for an optional cluster name."
  (interactive
   (list (let ((input (completing-read "Cluster (empty for all): "
                                       (cons "ALL" cluster-known-clusters) nil nil)))
           (if (or (string-empty-p input) (string= input "ALL")) nil input))))
  (let ((clusters (cond
                   ((null cluster) cluster-known-clusters)
                   ((member cluster cluster-known-clusters) (list cluster))
                   (t (message "Unknown cluster: %s\nKnown clusters: %s"
                               cluster (string-join cluster-known-clusters ", "))
                      nil))))
    (when clusters
      (let ((buf (get-buffer-create "*cluster-versions*"))
            (total (length clusters))
            (count 0))
        (with-current-buffer buf
          (let ((inhibit-read-only t))
            (erase-buffer)
            (org-mode)
            ;; Header row + separator
            (insert "\n")
            (insert "| Cluster | Issuer | SIM | SAM | Signer |\n")
            (insert "|---+---+---+---+---|\n")
            (org-table-align)))
        (display-buffer buf)
        (dolist (c clusters)
          (setq count (1+ count))
          (message "Querying %s... (%d/%d)" c count total)
          (with-current-buffer buf
            (let ((inhibit-read-only t))
              (goto-char (point-max))
              (insert "| " c " ")
              (dolist (service cluster-services)
                (insert "| " (cluster-get-version c service) " "))
              (insert "|\n")
              (org-table-align)))
          (redisplay))
        (message "Done. (%d clusters)" total)))))

(provide 'cluster-get-versions)
;;; cluster-get-versions.el ends here
