;;; early-init.el --- Early init -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024)
                  gc-cons-percentage 0.1)))

(setq frame-inhibit-implied-resize t)

(defun my/gui-p (&optional frame)
  "Return non-nil when FRAME, or the current frame, is graphical."
  (display-graphic-p frame))

;; Hide menu bar everywhere, GUI and TUI.
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; GUI-only chrome.
(when (my/gui-p)
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1)))

;; Future frames should inherit these defaults.
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

(provide 'early-init)
;;; early-init.el ends here
