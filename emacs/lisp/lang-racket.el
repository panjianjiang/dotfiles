;;; lang-racket.el --- Racket setup -*- lexical-binding: t; -*-

(use-package racket-mode
  :mode "\\.rkt\\'"
  :custom
  (racket-repl-buffer-name "*Racket REPL*")
  (racket-repl-display-context 'window)
  (racket-repl-window-height 0.3)
  :hook
  ((racket-mode . subword-mode)
   (racket-mode . electric-pair-local-mode))
  :bind (:map racket-mode-map
              ("C-c C-z" . my/lang-repl)
              ("C-c C-c" . racket-run)
              ("C-c C-b" . my/lang-run-buffer)
              ("C-c C-r" . my/lang-run-region)
              ("C-c C-d" . my/lang-doc)))

(provide 'lang-racket)
;;; lang-racket.el ends here
