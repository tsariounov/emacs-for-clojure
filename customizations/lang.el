;; golang-mode for go :) 
(setup (:package go-mode))
(add-hook 'go-mode-hook 'lsp-defferred)

;; python-mode for python :) 
(setup (:package python-mode))

;; json-mode for json...
(setup (:package json-mode))

;; add *.env files as sh-mode
(add-to-list 'auto-mode-alist '("\\.env$" . sh-mode))
