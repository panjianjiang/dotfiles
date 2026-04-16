;;; core-lsp.el --- LSP / xref / structural editing -*- lexical-binding: t; -*-

(defvar my/python-eglot-server-preference
  '(basedpyright pyright pylsp)
  "Preferred order of Python Eglot servers.")

(defun my/python-eglot-server ()
  "Return the preferred Python Eglot server command, or nil."
  (catch 'server
    (dolist (candidate my/python-eglot-server-preference)
      (pcase candidate
        ('basedpyright
         (when (executable-find "basedpyright-langserver")
           (throw 'server '("basedpyright-langserver" "--stdio"))))
        ('pyright
         (when (executable-find "pyright-langserver")
           (throw 'server '("pyright-langserver" "--stdio"))))
        ('pylsp
         (when (executable-find "pylsp")
           (throw 'server '("pylsp"))))))
    nil))

(defun my/shell-eglot-server ()
  "Return the preferred shell Eglot server command, or nil."
  (when (executable-find "bash-language-server")
    '("bash-language-server" "start")))

(use-package eglot
  :commands (eglot eglot-ensure eglot-format-buffer)
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect 1))

(with-eval-after-load 'eglot
  (let ((py-server (my/python-eglot-server))
        (shell-server (my/shell-eglot-server)))
    (when py-server
      (add-to-list 'eglot-server-programs
                   `((python-mode python-ts-mode) . ,py-server))
      (add-hook 'python-mode-hook #'eglot-ensure)
      (add-hook 'python-ts-mode-hook #'eglot-ensure))
    (when shell-server
      (add-to-list 'eglot-server-programs
                   `((sh-mode bash-ts-mode) . ,shell-server))
      (add-hook 'sh-mode-hook #'eglot-ensure)
      (add-hook 'bash-ts-mode-hook #'eglot-ensure))))

(setq xref-show-definitions-function #'xref-show-definitions-completing-read
      xref-show-xrefs-function #'xref-show-definitions-completing-read)

(with-eval-after-load 'eglot
  (global-set-key (kbd "C-c e") #'eglot)
  (global-set-key (kbd "C-c C-f") #'eglot-format-buffer))

(use-package paredit
  :hook ((emacs-lisp-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          racket-mode) . paredit-mode))

(provide 'core-lsp)
;;; core-lsp.el ends here
