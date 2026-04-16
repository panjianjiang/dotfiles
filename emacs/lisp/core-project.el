;;; core-project.el --- Project workflow -*- lexical-binding: t; -*-

(use-package project
  :ensure nil
  :bind-keymap ("C-x p" . project-prefix-map)
  :custom
  (project-switch-commands
   '((project-find-file "Find file")
     (consult-ripgrep "Ripgrep")
     (project-find-dir "Find dir")
     (project-switch-to-buffer "Buffer")
     (my/project-vterm "VTerm")
     (project-compile "Compile")
     (my/project-magit "Magit")
     (my/project-eshell "Eshell"))))

(defun my/project-root ()
  "Return current project root, or nil."
  (when-let ((pr (project-current nil)))
    (project-root pr)))

(defun my/project-vterm ()
  "Open vterm in current project root."
  (interactive)
  (let ((default-directory (or (my/project-root) default-directory)))
    (if (fboundp 'vterm)
        (vterm)
      (user-error "vterm is not available"))))

(defun my/project-magit ()
  "Open Magit status at current project root."
  (interactive)
  (let ((default-directory (or (my/project-root) default-directory)))
    (if (fboundp 'magit-status)
        (call-interactively #'magit-status)
      (user-error "magit is not available"))))

(defun my/project-eshell ()
  "Open eshell in current project root."
  (interactive)
  (let ((default-directory (or (my/project-root) default-directory)))
    (eshell t)))

(defun my/consult-ripgrep-project ()
  "Run consult-ripgrep from the current project root."
  (interactive)
  (if-let ((root (my/project-root)))
      (consult-ripgrep root)
    (call-interactively #'consult-ripgrep)))

(global-set-key (kbd "M-g r") #'my/consult-ripgrep-project)

(use-package magit
  :commands magit-status)

(provide 'core-project)
;;; core-project.el ends here
