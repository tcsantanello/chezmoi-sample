;;; shell.el -*- lexical-binding: t; -*-

(setq multi-term-program-switches "--login")
(setq shell-command-switch "-lc")

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on  )

(defun clear-shell( )
  (interactive)
  (comint-clear-buffer)
  (comint-send-string proc "\n"))

(defun new-shell( )
  (interactive)
  (shell)
  (rename-uniquely))

(global-set-key "\C-xs"    'new-shell)
(global-set-key "\C-c\C-k" 'clear-shell)

(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "12Jan2002 - sailor, shell mode customizations."
  (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
  (setq comint-input-sender 'n-shell-simple-send))

(defun n-shell-simple-send (proc command)
  "17Jan02 - sailor. Various commands pre-processing before sending to shell."
  (cond
   ((string-match "^[ \t]*clear[ \t]*$" command)
    (clear-shell))
   ((string-match "^[ \t]*man[ \t]*" command)
    (comint-send-string proc "\n")
    (setq command (replace-regexp-in-string "^[ \t]*man[ \t]*" "" command))
    (setq command (replace-regexp-in-string "[ \t]+$" "" command))
    (funcall 'man command))
   (t (comint-simple-send proc command))))

;;(new-shell)
