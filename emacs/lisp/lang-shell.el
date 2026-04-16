;;; lang-shell.el --- Shell setup -*- lexical-binding: t; -*-

(use-package sh-script
  :ensure nil
  :hook
  ((sh-mode . my/sh-mode-setup)
   (bash-ts-mode . my/sh-mode-setup))
  :bind (:map sh-mode-map
              ("C-c C-z" . my/lang-repl)
              ("C-c C-f" . my/lang-format-buffer))
  :config
  (when (boundp 'bash-ts-mode-map)
    (define-key bash-ts-mode-map (kbd "C-c C-z") #'my/lang-repl)
    (define-key bash-ts-mode-map (kbd "C-c C-f") #'my/lang-format-buffer)))

(defun my/sh-mode-setup ()
  "Common shell editing setup."
  (setq sh-basic-offset 2
        sh-indentation 2)
  (electric-pair-local-mode 1)
  (subword-mode 1))

(defun my/sh-format-buffer ()
  "Format current shell buffer with shfmt."
  (interactive)
  (if (executable-find "shfmt")
      (let ((p (point)))
        (shell-command-on-region (point-min) (point-max) "shfmt" (current-buffer) t)
        (goto-char (min p (point-max))))
    (user-error "shfmt is not available")))

(provide 'lang-shell)
;;; lang-shell.el ends here
