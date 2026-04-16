;;; core-ui.el --- UI and basic behavior -*- lexical-binding: t; -*-

(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

(when (display-graphic-p)
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1)))

(column-number-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)

(column-number-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)

(dolist (hook '(prog-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

(dolist (hook '(text-mode-hook
                term-mode-hook
                vterm-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

(use-package perspective
  :demand t
  :bind (("C-x C-b" . persp-list-buffers)
         ("C-x k"   . persp-kill-buffer*)
         ("C-x x s" . persp-switch)
         ("C-x x k" . persp-remove-buffer))
  :custom
  (persp-mode-prefix-key (kbd "C-x x"))
  :config
  (persp-mode 1))

(use-package vterm
  :commands vterm
  :custom
  (vterm-max-scrollback 10000))

(use-package compile
  :ensure nil
  :custom
  (compilation-scroll-output 'first-error)
  (compile-command "make -k"))

(provide 'core-ui)
;;; core-ui.el ends here
