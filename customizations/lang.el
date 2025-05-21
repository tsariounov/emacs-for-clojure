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
(defun er-conditionally-enable-paredit-mode ()
  "Enable `paredit-mode' in the minibuffer, during `eval-expression'."
  (if (eq this-command 'eval-expression)
      (paredit-mode 1)))

(add-hook 'minibuffer-setup-hook 'er-conditionally-enable-paredit-mode)
