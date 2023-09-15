;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(global-set-key [kp-subtract] 'undo) ; [Undo]
(global-set-key "\C-x\C-l" 'goto-line) ; [Ctrl]-[X] [Ctrl]-[L]
(global-set-key (kbd "<f2>") 'undo)
(global-set-key (kbd "<f5>") 'find-file)
(global-set-key (kbd "<f6>") 'kill-buffer)
(global-set-key (kbd "<f9>") 'compile)
(global-set-key (kbd "<f10>") 'ispell-word)
(global-set-key (kbd "<f11>") 'save-buffer)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-?" 'delete-backward-char)
(global-set-key "\C-xO" 'previous-multiframe-window)
(global-set-key "\C-cr" 'multi-occur)
(global-set-key "\C-cs" 'search-forward-regexp)
(global-set-key [delete] 'delete-char)

(global-subword-mode 1)
(setq-default indent-tabs-mode nil
              tab-always-indent t
              tab-width 2)

(setq user-full-name "Thomas Santanello"
      user-mail-address "tcsantanello@gmail.com"

      backup-directory-alist (quote ((".*" . "~/.emacs_backups/")))
      vc-diff-switches "-u"

      doom-theme 'doom-acario-dark

      default-major-mode 'c++-mode

      compilation-scroll-output t


      sh-basic-offset tab-width
      sh-indentation tab-width

      display-line-numbers-type t
      inhibit-startup-message t
      mouse-yank-at-point t

      transient-mark-mode t

      org-directory "~/.org/"

      whitespace-line-column 100

      read-process-output-max (* 1024 1024)
      company-idle-delay 2.0
      company-minimum-prefix-length 3

      undo-limit 80000000
      auto-save-default t
      password-cache-expiry nil
      scroll-preserve-screen-position 'always
      scroll-margin 2

      ispell-dictionary "en"

      host-custom-init (expand-file-name (concat (system-name) ".el") doom-private-dir)
      )

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(which-function-mode 1)

(load! "shell")
(load! "cmode")
(if (eq window-system 'x)
    (load! "xemacs"))

;; (remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;;(map! :map
;;      [C-c C-c] 'comment-region)

(map! :after smartparens
      :map smartparens-mode-map
      [C-right] nil
      [C-left] nil
      [M-right] nil
      [M-left] nil)

(if (file-exists-p host-custom-init)
    (load-file host-custom-init))

(use-package! poly-ansible-mode
  :mode "\\.ya?ml.j2\\'"
  :mode "playbook\\.ya?ml\\'"
  :mode "/\\(?:group\\|host\\)_vars/"
  :mode "/ansible/.*\\.ya?ml\\'"
  )

(use-package! company-ansible
  :after (company)
  :config
  (add-to-list 'company-backends 'company-ansible))

(use-package! ini-mode
  :mode "\\.co?nf\\'"
  :mode "\\.ini\\'"
  )

(use-package! powershell-mode
  :mode "\\.ps1\\'"
  )

(use-package! js2-mode
  :config
  (setq js2-basic-offset tab-width)
  (setq-hook! 'js2-mode-hook
    js-switch-indent-offset js2-basic-offset
    mode-name "JS2"))

(use-package! groovy-mode
  :config
  (setq groovy-indent-offset tab-width))

(use-package! lsp-mode
  :config
  (setq lsp-prefer-flymake nil
        lsp-eslint-auto-fix-on-save t
        lsp-idle-delay 1.0

        )
  (use-package! lsp-ui
    :requires lsp-mode flycheck
    :config
    (setq lsp-ui-dock-enable t
          lsp-ui-doc-use-childframe t
          lsp-ui-doc-position 'bottom
          lsp-ui-doc-include-signature t
          lsp-ui-sideline-enable nil
          lsp-ui-flycheck-enable t
          lsp-ui-flycheck-list-position 'right
          lsp-ui-flycheck-live-reporting t
          lsp-ui-peek-enable t
          lsp-ui-peek-list-width 60
          lsp-ui-peek-peek-height 25))

  (lsp-register-custom-settings
   '(("javascript.format.baseIndentSize" tab-width)
     ("javascript.format.convertTabsToSpaces" t t)
     ("javascript.indexSize" tab-width)))

  )

(use-package! dockerfile-mode
  :mode "Dockerfile.*\\'")

;(use-package! vlf-setup
;  :defer-incrementally vlf-tune vlf-base vlf-write vlf-search vlf-occur vlf-follow vlf-ediff vlf)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
