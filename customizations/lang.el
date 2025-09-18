;; activate yas minor mode in all modes that support it so
;; arg subst works
(yas-global-mode 1)

;; golang-mode for go :) 
(setup (:package go-mode)
       (:local-hook before-save-hook gofmt-before-save))
(add-hook 'go-mode-hook 'lsp-deferred)

;; python-mode for python :) 
(setup (:package python-mode))
(add-hook 'python-mode-hook 'lsp-deferred)

;; json-mode for json...
(setup (:package json-mode))

;; add *.env files as sh-mode
(add-to-list 'auto-mode-alist '("\\.env$" . sh-mode))

;; fix up paredit mode in M-: evals
(defun my-eval-minibuffer-enable-paredit-hook ()
  "Enable paredit-mode and fix RET in eval-expression minibuffer."
  (enable-paredit-mode)
  (unbind-key (kbd "RET") paredit-mode-map))

(add-hook 'eval-expression-minibuffer-setup-hook #'my-eval-minibuffer-enable-paredit-hook)

