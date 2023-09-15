;;; cmode.el -*- lexical-binding: t; -*-

(setq gdb-many-windows nil)

(defconst c-indent-level 2)

(after! cmake-mode
  (setq cmake-tab-width c-indent-level)
  )

(defun my-cc-mode()
  (setq c-tab-always-indent t
        c++-tab-always-indent t
        tab-width c-indent-level
        c-basic-offset c-indent-level
        c-label-offset c-indent-level
        c-continued-statement-offset c-indent-level
        standard-indent c-indent-level)
  (c-set-offset 'access-label '-)
  (c-set-offset 'case-label '+)
  (c-set-offset 'inclass '+)
  (c-set-offset 'statement-case-intro '+)
  (show-paren-mode t)
  )

(add-hook 'c-mode-common-hook 'my-cc-mode)

(after! groovy-mode
  (setq c-set-offset c-indent-level))
