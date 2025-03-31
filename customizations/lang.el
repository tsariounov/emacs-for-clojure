;; golang-mode for go :) 
(setup (:package go-mode))
(add-hook 'go-mode-hook 'lsp-deferred)

;; python-mode for python :) 
(setup (:package python-mode))
(add-hook 'python-mode-hook 'lsp-deferred)

;; json-mode for json...
(setup (:package json-mode))

;; add *.env files as sh-mode
(add-to-list 'auto-mode-alist '("\\.env$" . sh-mode))
