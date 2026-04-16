;;; init.el --- Main init -*- lexical-binding: t; -*-

(setq native-comp-async-report-warnings-errors nil)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(setq initial-scratch-message nil
      ring-bell-function #'ignore
      use-short-answers t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(require 'use-package)

(require 'core-ui)
(require 'core-completion)
(require 'core-project)
(require 'core-lsp)
(require 'core-remote)
(require 'core-keys)

(require 'lang-python)
(require 'lang-shell)
(require 'lang-racket)
(require 'lang-elisp)
(require 'lang-smalltalk)

;; Optional machine-local / private config.
(load (expand-file-name "init-local.el" user-emacs-directory) 'noerror)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d GCs."
                     (emacs-init-time)
                     gcs-done)))

(provide 'init)
;;; init.el ends here
