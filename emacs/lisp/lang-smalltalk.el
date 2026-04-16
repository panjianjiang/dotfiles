;;; lang-smalltalk.el --- Local Pharo/Smalltalk configuration -*- lexical-binding: t; -*-

(require 'pharo-smalltalk)

(defgroup my/lang-smalltalk nil
  "Local Pharo Smalltalk integration."
  :group 'languages)

(defcustom my/pharo-smalltalk-enable-org-babel t
  "Whether to enable Org src editing conveniences for Smalltalk blocks."
  :type 'boolean
  :group 'my/lang-smalltalk)

(defcustom my/pharo-smalltalk-server-url nil
  "Optional override for `pharo-smalltalk-server-url'.
When nil, keep the value defined by `pharo-smalltalk.el'."
  :type '(choice (const :tag "Use pharo-smalltalk default" nil)
                 string)
  :group 'my/lang-smalltalk)

(defcustom my/pharo-smalltalk-install-package t
  "Whether to call `pharo-smalltalk-install' during startup."
  :type 'boolean
  :group 'my/lang-smalltalk)

(defun my/pharo-smalltalk-setup ()
  "Local defaults for `pharo-smalltalk-mode'."
  (setq-local tab-width 2)
  (setq-local indent-tabs-mode nil)
  (setq-local comment-start "\"")
  (setq-local comment-end "\"")
  (setq-local fill-column 100)
  (electric-pair-local-mode 1))

(defun my/pharo-smalltalk-configure ()
  "Apply user-level configuration for Pharo Smalltalk integration."
  (when my/pharo-smalltalk-install-package
    (pharo-smalltalk-install))
  (when my/pharo-smalltalk-server-url
    (setq pharo-smalltalk-server-url my/pharo-smalltalk-server-url)))

(defun my/pharo-smalltalk-workspace ()
  "Open the default Pharo workspace."
  (interactive)
  (pharo-smalltalk-workspace))

(add-hook 'pharo-smalltalk-mode-hook #'my/pharo-smalltalk-setup)
(add-hook 'emacs-startup-hook #'my/pharo-smalltalk-configure)

(with-eval-after-load 'org
  (when my/pharo-smalltalk-enable-org-babel
    (add-to-list 'org-src-lang-modes '("smalltalk" . pharo-smalltalk))))

(provide 'lang-smalltalk)
;;; lang-smalltalk.el ends here
