;;; packages.el --- chinese-fonts Layer packages File for Spacemacs

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq chinese-fonts-packages
    '(
      ;; package names go here

      ;; https://github.com/tumashu/chinese-fonts-setup
      chinese-fonts-setup
     ))

;; List of packages to exclude.
(setq chinese-fonts-excluded-packages '())

(defun chinese-fonts/init-chinese-fonts-setup()
  "Initialize chinese-fonts-setup package"
  (use-package chinese-fonts-setup
    ;; https://github.com/tumashu/chinese-fonts-setup
    :init
    :config
    (setq cfs-profiles-directory "~/.emacs.d/private/chinese-fonts/chinese-fonts-setup/")
    (setq cfs-profiles
          '("coding" "org-mode"))
  )
)
