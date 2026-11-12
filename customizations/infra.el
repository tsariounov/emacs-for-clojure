;;-*- lexical-binding: t; -*-
;; Infrastructure modes

;; ripgrep!!
(setup (:package rg))

;; dockerfile mode
(setup (:package dockerfile-mode))

;; docker compose mode
;; it's dead, jim
;;(setup (:package docker-compose-mode))

;; terraform
(setup (:package terraform-mode))
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

;; auto revert all buffers mode
(global-auto-revert-mode)

