;;; core-keys.el --- Unified language action conventions -*- lexical-binding: t; -*-

(defun my/lang-not-supported (action)
  "Fallback helper for unsupported ACTION."
  (user-error "Current mode does not support %s" action))

(defun my/lang-format-buffer ()
  "Unified entry for formatting current buffer."
  (interactive)
  (cond
   ((derived-mode-p 'python-mode 'python-ts-mode)
    (call-interactively #'my/python-format-buffer))
   ((derived-mode-p 'sh-mode 'bash-ts-mode)
    (call-interactively #'my/sh-format-buffer))
   ((fboundp 'eglot-format-buffer)
    (call-interactively #'eglot-format-buffer))
   (t
    (my/lang-not-supported "formatting"))))

(defun my/lang-run-buffer ()
  "Unified entry for running current buffer."
  (interactive)
  (cond
   ((derived-mode-p 'pharo-smalltalk-mode)
    (call-interactively #'pharo-smalltalk-send-buffer))
   ((derived-mode-p 'racket-mode)
    (call-interactively #'racket-run))
   ((derived-mode-p 'emacs-lisp-mode)
    (call-interactively #'eval-buffer))
   (t
    (my/lang-not-supported "running current buffer"))))

(defun my/lang-run-region ()
  "Unified entry for running current region."
  (interactive)
  (cond
   ((derived-mode-p 'pharo-smalltalk-mode)
    (if (use-region-p)
        (call-interactively #'pharo-smalltalk-send-region)
      (call-interactively #'pharo-smalltalk-send-chunk)))
   ((derived-mode-p 'racket-mode)
    (call-interactively #'racket-send-region))
   ((derived-mode-p 'emacs-lisp-mode)
    (call-interactively #'eval-region))
   (t
    (my/lang-not-supported "running region"))))

(defun my/lang-repl ()
  "Unified entry for entering a REPL / interactive environment."
  (interactive)
  (cond
   ((derived-mode-p 'pharo-smalltalk-mode)
    (call-interactively #'pharo-smalltalk-workspace))
   ((derived-mode-p 'python-mode 'python-ts-mode)
    (call-interactively #'run-python))
   ((derived-mode-p 'racket-mode)
    (call-interactively #'racket-repl))
   ((derived-mode-p 'emacs-lisp-mode)
    (call-interactively #'ielm))
   ((derived-mode-p 'sh-mode 'bash-ts-mode)
    (if (fboundp 'my/project-vterm)
        (call-interactively #'my/project-vterm)
      (shell)))
   (t
    (my/lang-not-supported "REPL"))))

(defun my/lang-doc ()
  "Unified entry for docs / describe."
  (interactive)
  (cond
   ((derived-mode-p 'pharo-smalltalk-mode)
    (call-interactively #'pharo-smalltalk-inspect-class-at-point))
   ((derived-mode-p 'racket-mode)
    (call-interactively #'racket-doc))
   ((derived-mode-p 'emacs-lisp-mode)
    (call-interactively #'describe-function))
   (t
    (my/lang-not-supported "documentation"))))

(provide 'core-keys)
;;; core-keys.el ends here
