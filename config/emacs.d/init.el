;; init.el
;;
;; Emacs Configuration
;;
;; Author: Kevin Cotugno git@kevincotugno.com
;; Date: 2/22/17

;; Package
(require 'package)
(package-initialize)

(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" .
                                 "https://stable.melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

;; Display
(set-default-font "Source Code Pro-12")
(line-number-mode t)
(global-linum-mode t)
(when 'display-graphic-p
  (global-hl-line-mode))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(setq-default truncate-lines t)
(setq-default truncate-partial-width-windows nil)

(setq-default scroll-conservatively 100)

(when 'display-graphic-p (lambda ()
                           (global-hl-line-mode t)))

(global-whitespace-mode)
(setq whitespace-style '(face trailing tabs spaces lines empty indentation
                              space-after-tab space-before-tab space-mark
                              tab-mark))
;; End display

;; Auto generated config
(setq custom-file (expand-file-name "auto.el" user-emacs-directory))
(load custom-file 'noerror)
;; End auto generated config

;; Text Formatting
(setq-default standard-indent 8)
(setq-default c-default-style "linux"
              c-basic-offset 8
              tab-width 8)

(add-hook 'emacs-lisp-mode-hook (setq indent-tabs-mode nil))
(add-hook 'ruby-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq indent-tabs-mode nil)
                            (setq tab-width 2)))
(add-hook 'js-mode-hook (lambda ()
                          (setq evil-shift-width 2)
                          (setq indent-tabs-mode nil)
                          (setq js-indent-level 2)))
(add-hook 'css-mode-hook (lambda ()
                           (setq evil-shift-width 2)
                           (setq indent-tabs-mode nil)
                           (setq tab-width 2)
                           (setq css-indent-offset 2)))
;; End text Formatting

;; Backup Files

(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))

;; End Backup Files

;; Plugins

;; Themes
(use-package dash)

(-each
    (-map
     (lambda (item)
       (format "~/.emacs.d/themes/%s" item))
     (-remove
      (lambda (item) (or (string= item ".") (string= item "..")))
      (directory-files ".emacs.d/themes/")))
  (lambda (item)
    (add-to-list 'custom-theme-load-path item)))

(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'dark)
(enable-theme 'solarized)

;; End themes

(use-package company
  :config
  (company-mode))

(use-package evil
  :config
  (evil-mode t)
  (define-key evil-normal-state-map "\C-k" 'evil-normal-state)
  (define-key evil-insert-state-map "\C-k" 'evil-normal-state)
  (define-key evil-visual-state-map "\C-k" 'evil-normal-state)
  (define-key evil-replace-state-map "\C-k" 'evil-normal-state)
  (define-key evil-insert-state-map "\C-c\C-c" 'evil-normal-state)
  (define-key evil-normal-state-map "\C-i" 'evil-scroll-up)
  (define-key evil-visual-state-map "\C-i" 'evil-scroll-up))

(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "\\"))

(use-package evil-surround)

(use-package evil-org)


(use-package powerline
  :config
  (powerline-default-theme))

(use-package org-bullets
 :config
 (add-hook 'org-mode-hook (lambda ()
                            (org-bullets-mode t))))
(use-package magit)

(use-package helm
  :config
  (helm-mode t))

(use-package helm-projectile
  :config
  (evil-leader/set-key "p" 'helm-projectile)
  (helm-projectile-on))

;; End Plugins
