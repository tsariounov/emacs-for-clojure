;; Infrastructure modes

;; ripgrep!!
(setup (:package rg))

;; dockerfile mode
(setup (:package dockerfile-mode))

;; docker compose mode
(setup (:package docker-compose-mode))

;; terraform
(setup (:package terraform-mode))
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

