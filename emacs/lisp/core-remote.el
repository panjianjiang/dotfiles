;;; core-remote.el --- WSL2 / Wayland / X11 clipboard integration -*- lexical-binding: t; -*-

(require 'subr-x)

(defconst my/is-linux (eq system-type 'gnu/linux))

(defun my/wsl-p ()
  "Return non-nil when running inside WSL/WSL2."
  (and my/is-linux
       (with-temp-buffer
         (ignore-errors
           (insert-file-contents "/proc/version")
           (goto-char (point-min))
           (re-search-forward "microsoft\\|wsl" nil t)))))

(defun my/executable-path (name)
  "Return absolute path of executable NAME, or nil."
  (executable-find name))

(defvar my/clip-exe (my/executable-path "clip.exe"))
(defvar my/powershell-exe
  (or (my/executable-path "powershell.exe")
      (my/executable-path "pwsh.exe")))
(defvar my/xclip-exe (my/executable-path "xclip"))
(defvar my/wl-copy-exe (my/executable-path "wl-copy"))
(defvar my/wl-paste-exe (my/executable-path "wl-paste"))

(defun my/wayland-session-p ()
  "Return non-nil when current GUI session is Wayland."
  (let ((wd (getenv "WAYLAND_DISPLAY")))
    (and wd (not (string-empty-p wd)))))

(defun my/gui-session-p ()
  "Return non-nil when Emacs has a GUI display."
  (display-graphic-p))

(defun my/start-process-send-string (program input &rest args)
  "Run PROGRAM with ARGS and send INPUT to its stdin asynchronously."
  (let ((process-connection-type nil))
    (let ((proc (apply #'start-process program nil program args)))
      (process-send-string proc input)
      (process-send-eof proc)
      proc)))

(defun my/shell-command-output (cmd)
  "Return shell command output trimmed on the right."
  (string-trim-right (shell-command-to-string cmd)))

(defun my/non-empty-string-p (s)
  (and (stringp s) (not (string-empty-p s))))

(defun my/read-command-output-first-non-empty (&rest cmds)
  "Run shell CMDS in order and return the first non-empty output."
  (catch 'result
    (dolist (cmd cmds)
      (let ((out (my/shell-command-output cmd)))
        (when (my/non-empty-string-p out)
          (throw 'result out))))
    nil))

;;;; WSL2
(defun my/setup-wsl-clipboard ()
  "Integrate Emacs clipboard with Windows clipboard inside WSL2."
  (when (and (my/wsl-p) my/clip-exe my/powershell-exe)
    ;; Keep WSL2 behavior unchanged.
    (setq interprogram-cut-function
          (lambda (text)
            (my/start-process-send-string my/clip-exe text)))
    (setq interprogram-paste-function
          (lambda ()
            (my/shell-command-output
             (format "%s -NoProfile -Command Get-Clipboard"
                     (shell-quote-argument my/powershell-exe)))))))

;;;; Native Linux Wayland/X11
(defun my/linux-copy-to-wayland-clipboard (text)
  "Write TEXT to Wayland regular clipboard."
  (when (and my/wl-copy-exe (my/non-empty-string-p text))
    (my/start-process-send-string my/wl-copy-exe text)))

(defun my/linux-copy-to-wayland-primary (text)
  "Write TEXT to Wayland primary selection."
  (when (and my/wl-copy-exe (my/non-empty-string-p text))
    (my/start-process-send-string my/wl-copy-exe text "-p")))

(defun my/linux-copy-to-x11-clipboard (text)
  "Write TEXT to X11 clipboard selection."
  (when (and my/xclip-exe (my/non-empty-string-p text))
    (my/start-process-send-string my/xclip-exe text "-selection" "clipboard" "-in")))

(defun my/linux-copy-to-x11-primary (text)
  "Write TEXT to X11 primary selection."
  (when (and my/xclip-exe (my/non-empty-string-p text))
    (my/start-process-send-string my/xclip-exe text "-selection" "primary" "-in")))

(defun my/linux-copy-to-all-clipboards (text)
  "Mirror TEXT into both X11/Wayland clipboard and primary."
  (when (my/non-empty-string-p text)
    ;; regular clipboard
    (my/linux-copy-to-wayland-clipboard text)
    (my/linux-copy-to-x11-clipboard text)
    ;; primary selection
    (my/linux-copy-to-wayland-primary text)
    (my/linux-copy-to-x11-primary text)))

(defun my/linux-copy-to-all-primary (text)
  "Mirror TEXT into both X11/Wayland primary selections only."
  (when (my/non-empty-string-p text)
    (my/linux-copy-to-wayland-primary text)
    (my/linux-copy-to-x11-primary text)))

(defun my/linux-read-external-selection ()
  "Read text from external clipboard/selection.
Preference order:
  1. Wayland clipboard
  2. X11 clipboard
  3. Wayland primary
  4. X11 primary"
  (my/read-command-output-first-non-empty
   (when my/wl-paste-exe
     (format "%s --no-newline 2>/dev/null"
             (shell-quote-argument my/wl-paste-exe)))
   (when my/xclip-exe
     (format "%s -selection clipboard -o 2>/dev/null"
             (shell-quote-argument my/xclip-exe)))
   (when my/wl-paste-exe
     (format "%s -p --no-newline 2>/dev/null"
             (shell-quote-argument my/wl-paste-exe)))
   (when my/xclip-exe
     (format "%s -selection primary -o 2>/dev/null"
             (shell-quote-argument my/xclip-exe)))))

(defun my/emacs-active-region-string ()
  "Return current active region as plain text, or nil."
  (when (use-region-p)
    (buffer-substring-no-properties (region-beginning) (region-end))))

(defun my/mirror-emacs-region-to-primary (&rest _)
  "When region becomes active, mirror it to both X11 and Wayland primary.
This keeps 'selection' semantics separate from explicit copy."
  (when (and my/is-linux
             (not (my/wsl-p))
             (my/gui-session-p)
             (my/wayland-session-p)
             (use-region-p))
    (let ((text (my/emacs-active-region-string)))
      (when (my/non-empty-string-p text)
        (my/linux-copy-to-all-primary text)))))

(defun my/setup-linux-wayland-x11-clipboard ()
  "Configure clipboard/selection integration on native Linux Wayland."
  (when (and my/is-linux
             (not (my/wsl-p))
             (my/gui-session-p)
             (my/wayland-session-p)
             my/wl-copy-exe
             my/wl-paste-exe
             my/xclip-exe)
    ;; Let Emacs own both clipboard and primary when selecting in GUI.
    ;; We keep clipboard/primary semantics distinct:
    ;; - selection -> primary
    ;; - explicit copy/kill -> clipboard (plus we mirror to all via cut fn)
    (setq select-enable-clipboard t)
    (setq select-enable-primary t)
    (setq select-active-regions t)

    ;; Explicit copy/kill from Emacs goes everywhere.
    (setq interprogram-cut-function
          (lambda (text)
            (my/linux-copy-to-all-clipboards text)))

    ;; Paste prefers Wayland clipboard, then X11 clipboard, then primarys.
    (setq interprogram-paste-function
          (lambda ()
            (my/linux-read-external-selection)))

    ;; Extra safeguard:
    ;; when merely selecting with mouse/region, also mirror region text
    ;; into both X11 and Wayland primary selections.
    (add-hook 'activate-mark-hook #'my/mirror-emacs-region-to-primary)))

;;;; Entry points
(my/setup-wsl-clipboard)
(my/setup-linux-wayland-x11-clipboard)

(provide 'core-remote)
;;; core-remote.el ends here
