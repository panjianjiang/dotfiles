;;; lang-elisp.el --- Emacs Lisp setup -*- lexical-binding: t; -*-

(use-package emacs
  :ensure nil
  :hook
  ((emacs-lisp-mode . eldoc-mode)
   (emacs-lisp-mode . electric-pair-local-mode)
   (emacs-lisp-mode . subword-mode))
  :bind (:map emacs-lisp-mode-map
              ("C-c C-z" . my/lang-repl)
              ("C-c C-c" . eval-defun)
              ("C-c C-b" . my/lang-run-buffer)
              ("C-c C-r" . my/lang-run-region)
              ("C-c C-d" . describe-function)
              ("C-c C-v" . describe-variable)
              ("C-c C-f" . my/lang-format-buffer)))

(provide 'lang-elisp)
;;; lang-elisp.el ends here
