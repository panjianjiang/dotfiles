;;; lang-python.el --- Python setup -*- lexical-binding: t; -*-

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :custom
  (python-indent-guess-indent-offset-verbose nil)
  (python-shell-interpreter "python3")
  :hook
  ((python-mode . subword-mode)
   (python-ts-mode . subword-mode)
   (python-mode . electric-pair-local-mode)
   (python-ts-mode . electric-pair-local-mode))
  :bind
  ((:map python-mode-map
    ("C-c C-z" . my/lang-repl)
    ("C-c C-f" . my/lang-format-buffer)
    ("C-c C-o" . my/python-organize-imports))
   (:map python-ts-mode-map
    ("C-c C-z" . my/lang-repl)
    ("C-c C-f" . my/lang-format-buffer)
    ("C-c C-o" . my/python-organize-imports))))

(defun my/python-format-buffer ()
  "Format current Python buffer with Ruff if available, else Eglot."
  (interactive)
  (cond
   ((and (executable-find "ruff")
         buffer-file-name)
    (when (buffer-modified-p)
      (save-buffer))
    (call-process "ruff" nil "*Ruff Format*" nil
                  "format" buffer-file-name)
    (revert-buffer :ignore-auto :noconfirm))
   ((fboundp 'eglot-format-buffer)
    (eglot-format-buffer))
   (t
    (user-error "No formatter available"))))

(defun my/python-organize-imports ()
  "Organize Python imports with Ruff."
  (interactive)
  (if (and (executable-find "ruff")
           buffer-file-name)
      (progn
        (when (buffer-modified-p)
          (save-buffer))
        (call-process "ruff" nil "*Ruff Organize Imports*" nil
                      "check" "--select" "I" "--fix" buffer-file-name)
        (revert-buffer :ignore-auto :noconfirm))
    (user-error "ruff is not available")))

(provide 'lang-python)
;;; lang-python.el ends here
