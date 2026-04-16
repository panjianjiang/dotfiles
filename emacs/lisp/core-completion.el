;;; core-completion.el --- Completion stack -*- lexical-binding: t; -*-

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (("C-s"     . consult-line)
         ("C-x b"   . consult-buffer)
         ("M-y"     . consult-yank-pop)
         ("C-x r b" . consult-bookmark)
         ("M-g g"   . consult-goto-line)
         ("M-g i"   . consult-imenu)
         ("M-g f"   . consult-find)
         ("M-g o"   . consult-outline)
         ("M-g s"   . consult-imenu-multi)))

(use-package embark
  :bind (("C-."   . embark-act)
         ("C-;"   . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package which-key
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.5))

(use-package embark-consult
  :after (embark consult))

(with-eval-after-load 'embark
  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode))

(with-eval-after-load 'which-key
  (setq which-key-show-early-on-C-h t))

(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  (tab-always-indent 'complete)
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)))

(provide 'core-completion)
;;; core-completion.el ends here
