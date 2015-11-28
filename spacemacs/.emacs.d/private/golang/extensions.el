;;; extensions.el --- golang Layer extensions File for Spacemacs
;;
;; Copyright (c) 2015 Sky Jia
;;
;; Author: Sky Jia <me@skyjia.com>
;; URL: https://github.com/skyjia/dotfiles
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq golang-pre-extensions
      '(
        ;; pre extension names go here
        preload
        ))

(setq golang-post-extensions
      '(
        ;; post extension names go here
        ))

;; For each extension, define a function golang/init-<extension-name>
;;
;; (defun golang/init-my-extension ()
;;   "Initialize my extension"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defun golang/preload ()
  "Initialize my extension"
  )

