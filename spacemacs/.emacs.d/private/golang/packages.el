;;; packages.el --- golang Layer packages File for Spacemacs
;;
;; Copyright (c) 2015 Sky Jia
;;
;; Author: Sky Jia <me@skyjia.com>
;; URL: https://github.com/skyjia/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq golang-packages
    '(
      ;; package names go here
      go-mode
      ))

;; List of packages to exclude.
(setq golang-excluded-packages '())

;; For each package, define a function golang/init-<package-name>
;;
;; (defun golang/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defun golang/init-go-mode ()
  "Initialize my package"
  :config
  ;; Setting up the right environment variables 
  (when (memq window-system '(mac ns))
        (exec-path-from-shell-copy-env "GOPATH"))

  ;; Using autocomplete-mode
  ;;
  ;; Load gocode source
  (load-file "$GOPATH/src/github.com/nsf/gocode/emacs/go-autocomplete.el")
  ;; Load go-oracle
  (load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")
  ;; Set up go-autocomplete
  (require 'go-autocomplete)
  (require 'auto-complete-config)
  (ac-config-default)

  ;; Using company-mode
  ;;
  ;;(add-to-list 'load-path (concat (getenv "GOPATH") "/src/github.com/nsf/gocode/emacs-company"))
  ;;(require 'company)                                   ; load company mode
  ;;(require 'company-go)                                ; load company mode go backend

  ;;(setq company-tooltip-limit 20)                      ; bigger popup window
  ;;(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
  ;;(setq company-echo-delay 0)                          ; remove annoying blinking
  ;;(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

  ;;(add-hook 'go-mode-hook (lambda ()
  ;;                         (set (make-local-variable 'company-backends) '(company-go))
  ;;                          (company-mode)))
  )
