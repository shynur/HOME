;; -*- lexical-binding: t; -*-

(require 'package)
(setopt package-archives
        '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
          ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
          ("melpa-stable" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/stable-melpa/")))
(package-initialize)

(setopt custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
(add-hook 'kill-emacs-query-functions
          #'custom-prompt-customize-unsaved-options)
