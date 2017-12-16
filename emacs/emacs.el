(require 'cl)
(require 'package)
(package-initialize)

; Package repositories
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

; Install packages if not present
(let* ((package--builtins nil)
       (packages
        '(elixir-mode       ; Emacs major mode for Elixir
          evil              ; Evil is an extensible vi layer for Emacs
          flx-ido           ; 
          material-theme))) ; A Theme based on Google Material Design
  (ignore-errors
    (let ((packages (remove-if 'package-installed-p packages)))
      (when packages
        (package-refresh-contents)
        (mapc 'package-install packages)))))

; Sane defaults
(setq auto-revert-interval 1            ; Refresh buffers fast
      echo-keystrokes 0.1               ; Show keystrokes asap
      inhibit-startup-message t         ; No splash screen please
      initial-scratch-message nil       ; Clean scratch buffer
      recentf-max-saved-items 100       ; Show more recent files
      ring-bell-function 'ignore        ; Quiet
      sentence-end-double-space nil     ; No double space
      ns-right-alternate-modifier nil)  ; Unbind right ALT key

(setq-default fill-column 79                    ; Maximum line width
              truncate-lines t                  ; Don't fold lines
              indent-tabs-mode nil              ; Use spaces instead of tabs
              split-width-threshold 160         ; Split verticly by default
              split-height-threshold nil        ; Split verticly by default
              auto-fill-function 'do-auto-fill) ; Auto-fill-mode everywhere

(set-language-environment "UTF-8")

(global-auto-revert-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defvar emacs-autosave-directory
  (concat user-emacs-directory "autosaves/")
  "This variable dictates where to put auto saves. It is set to a
  directory called autosaves located wherever your .emacs.d/ is
  located.")

;; Sets all files to be backed up and auto saved in a single directory.
(setq backup-directory-alist
      `((".*" . ,emacs-autosave-directory))
      auto-save-file-name-transforms
      `((".*" ,emacs-autosave-directory t)))

; Modes

(dolist (mode
         '(tool-bar-mode                ; No toolbars, more room for text
           blink-cursor-mode))          ; The blinking cursor gets old
  (funcall mode 0))

(dolist (mode
         '(global-linum-mode))
  (funcall mode 1))

; Themes

(load-theme 'material t)

(cond ((member "Hasklig" (font-family-list))
       (set-face-attribute 'default nil :font "Hasklig-14"))
      ((member "Inconsolata" (font-family-list))
       (set-face-attribute 'default nil :font "Inconsolata-14")))

; ido
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)

; evil package config
(require 'evil)
(evil-mode 1)

; flx package config
(require 'flx-ido)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
