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

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(add-to-list 'exec-path "/usr/local/bin")

(defun directory-files-no-directories (path)
  "Return the list of files in PATH excluding and directories"
  (seq-filter (lambda (item)
                (not (null item)))
              (mapcar (lambda (item)
                        (if (not (eq (nth 1 item) 't))
                            (car item)))
                      (directory-files-and-attributes path 't))))

(defun update-env-var (var list)
  "Prepend LIST to the specified environment variable"
  (mapc (lambda (dir)
          (when (not (string-equal dir ""))
            (if (or (null (getenv var)) (string-equal (getenv var) ""))
                (setenv var dir)
              (setenv var (format "%s:%s"
                                  dir
                                  (getenv var))))))
        list))

(if (eq system-type 'darwin)
    (update-env-var "PATH" (with-temp-buffer
                             (mapcar (lambda (item)
                                       (insert-file-contents item))
                                     (directory-files-no-directories "/etc/paths.d"))
                             (insert-file-contents "/etc/paths")
                             (split-string (buffer-string) "\n" t))))

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

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)
(setq-default truncate-lines t)
(setq-default truncate-partial-width-windows nil)

(setq-default scroll-conservatively 100)

(when (display-graphic-p) (progn
                            (global-hl-line-mode t)
                            (scroll-bar-mode -1)))

(global-whitespace-mode)
(setq whitespace-style '(face trailing tabs spaces lines-tail empty indentation
                              space-after-tab space-before-tab space-mark
                              tab-mark))
(setq-default fill-column 80)
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

(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (setq indent-tabs-mode nil)))
(add-hook 'ruby-mode-hook (lambda ()
                            (setq indent-tabs-mode nil)
                            (setq tab-width 2)))
(add-hook 'js-mode-hook (lambda ()
                          (setq indent-tabs-mode nil)
                          (setq js-indent-level 2)))
(add-hook 'css-mode-hook (lambda ()
                           (setq indent-tabs-mode nil)
                           (setq tab-width 2)
                           (setq css-indent-offset 2)))
(add-hook 'org-mode-hook (lambda ()
                           (setq indent-tabs-mode nil)
                           (setq tab-width 2)))
;; End text Formatting

;; Backup Files

(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))

;; End Backup Files

;; Plugins

;; Themes

(defun flip-background ()
  "Flip the frame and terminal background mode.
useful for alternating between light and dark themes"
  (interactive)
  (let ((mode (if (or (eq (frame-parameter nil 'background-mode) 'dark)
                      (eq (terminal-parameter nil 'background-mode) 'dark))
                  (setq mode 'light)
                (setq mode 'dark))))
    (set-frame-parameter nil 'background-mode mode)
    (set-terminal-parameter nil 'background-mode mode)
    (dolist (theme custom-enabled-themes)
      (enable-theme theme))))

(global-set-key (kbd "<f5>") 'flip-background)

;; Load directories in the .emacs.d/themes directory to the load path
;; TODO Only add directories
(mapcar (lambda (item)
          (add-to-list 'custom-theme-load-path item))
        (mapcar (lambda (item)
                  (format "%s/.emacs.d/themes/%s/" (getenv "HOME") item))
                (let (files '())
                  (dolist (val
                           (directory-files (format "%s/.emacs.d/themes/"
                                                    (getenv "HOME")))
                           files)
                    (let ((off (string-match "\\." val)))
                      (unless (and off (eq off 0))
                        (setq files (cons val files))))))))

(when (load-theme 'solarized t) (flip-background))

;; End themes

(use-package org
  :ensure t)

(use-package org-bullets
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook (lambda ()
                             (org-bullets-mode t))))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(use-package magit
  :ensure t)

(use-package projectile
  :ensure t)

(use-package helm
  :ensure t
  :config
  (helm-mode t)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(require 'mu4e)
(setq mu4e-maildir (concat (getenv "HOME") "/.mail"))
(setq mu4e-drafts-folder "/Drafts")
(setq mu4e-sent-folder "/Sent")
(setq mu4e-trash-folder "/Trash")
(setq mu4e-get-mail-command "offlineimap")

(setq mu4e-compose-reply-to-address "kevin@kevincotugno.com"
      user-mail-address "kevin@kevincotugno.com"
      user-full-name "Kevin Cotugno")
(setq
 message-send-mail-function 'smtpmail-send-it
 smtpmail-smtp-server "smtp.cotugno.family"
 smtpmail-stream-type 'ssl
 smtpmail-smtp-service 587)
(setq message-kill-buffer-on-exit t)

;; End Plugins
