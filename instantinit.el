;;; init.el --- Initialization file for Emacs

;; Copyright (C) 2020 Cid0rz (cid.kampeador@gmail.com)
;;     ____           __              __
;;    /  _/___  _____/ /_____ _____  / /_
;;    / // __ \/ ___/ __/ __ `/ __ \/ __/
;;  _/ // / / (__  ) /_/ /_/ / / / / /_
;; /___/_/ /_/____/\__/\__,_/_/ /_/\__/
;;       EEEEEEE MM    MM   AAA    CCCCC  SSSSS
;;       EE      MMM  MMM  AAAAA  CC     SS
;;       EEEEE   MM MM MM AA   AA CC      SSSSS
;;       EE      MM    MM AAAAAAA CC          SS
;;       EEEEEEE MM    MM AA   AA  CCCCC  SSSSS

;;; Commentary:
;;; Emacs Startup File --- initialization for Emacs in InstantOS.
;;; 

;;This configuration has been tailored to run Emacs as a daemon
;;on the background and connect clients to it.  An easy way to achieve
;;that is to activate the oh-my-zsh plug-in for Emacs in the .zshrc file
;;as described in https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/emacs



;;; Code:

;;GLOBAL CONFIGURATION

;;(menu-bar-mode -1) ;; to disable the mebu bar (included in better defaults)
(setq inhibit-startup-message t) ;;disable start screen(not needed for daemon)
;;(global-display-line-numbers-mode 1) ;; if you want line numbers
;;(global-set-key "\C-x\C-m" 'execute-extended-command) ;; add binding for M-x
;;(global-set-key "\C-c\C-m" 'execute-extended-command) ;; add binding for M-x
(global-auto-revert-mode t) ;;update changes made on disk
(setq vc-follow-symlinks t) ;;follow symlinks to edit the files
;;(desktop-save-mode 1) ;;to save frame configuration between sessions
(add-hook 'prog-mode-hook 'flyspell-prog-mode) ;;enable spellchecking only in
                                 ;;comments and strings for programming modes

;;choose the default font for the frame, you can easily zoom buffer text with
;;Ctrl and mouse wheel
;(add-to-list 'default-frame-alist
;             '(font . "FiraCode Nerd Font-12:style=Regular"))



;; Straight package manager setup
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(use-package bind-key
	     :ensure t)


;; LISP CONFIGURATION

(add-hook 'emacs-lisp-mode-hook
              (lambda ()
                ;; Use spaces, not tabs.
                (setq indent-tabs-mode nil)
                ;; Keep M-TAB for `completion-at-point'
                (define-key flyspell-mode-map "\M-\t" nil)
                ;; Pretty-print eval'd expressions.
                (define-key emacs-lisp-mode-map
                            "\C-x\C-e" 'pp-eval-last-sexp)
                ;; Recompile if .elc exists.
                (add-hook (make-local-variable 'after-save-hook)
                          (lambda ()
                            (byte-force-recompile default-directory)))
                (define-key emacs-lisp-mode-map
                            "\r" 'reindent-then-newline-and-indent)))
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)


;; THEME

(use-package vscode-dark-plus-theme
  :ensure t
  :config
  (load-theme 'vscode-dark-plus t))

;; PACKAGES

(use-package better-defaults
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  :bind
  ("C-M-a" . sp-beginning-of-sexp)
  ("C-M-e" . sp-end-of-sexp)

  ("C-<down>" . sp-down-sexp)
  ("C-<up>"   . sp-up-sexp)
  ("M-<down>" . sp-backward-down-sexp)
  ("M-<up>"   . sp-backward-up-sexp)

  ("C-M-f" . sp-forward-sexp)
  ("C-M-b" . sp-backward-sexp)

  ("C-M-n" . sp-next-sexp)
  ("C-M-p" . sp-previous-sexp)

  ("C-S-f" . sp-forward-symbol)
  ("C-S-b" . sp-backward-symbol)

  ("C-<right>" . sp-forward-slurp-sexp)
  ("M-<right>" . sp-forward-barf-sexp)
  ("C-<left>"  . sp-backward-slurp-sexp)
  ("M-<left>"  . sp-backward-barf-sexp)

  ("C-M-t" . sp-transpose-sexp)
  ("C-M-k" . sp-kill-sexp)
  ("C-k"   . sp-kill-hybrid-sexp)
  ("M-k"   . sp-backward-kill-sexp)
  ("C-M-w" . sp-copy-sexp)
  ("C-M-d" . delete-sexp)

  ("M-<backspace>" . backward-kill-word)
  ("C-<backspace>" . sp-backward-kill-word)
  ([remap sp-backward-kill-word] . backward-kill-word)

  ("M-[" . sp-backward-unwrap-sexp)
  ("M-]" . sp-unwrap-sexp)

  ("C-x C-t" . sp-transpose-hybrid-sexp)

  ("C-c ("  . wrap-with-parens)
  ("C-c ["  . wrap-with-brackets)
  ("C-c {"  . wrap-with-braces)
  ("C-c '"  . wrap-with-single-quotes)
  ("C-c \"" . wrap-with-double-quotes)
  ("C-c _"  . wrap-with-underscores)
  ("C-c `"  . wrap-with-back-quotes)
  :hook (prog-mode . smartparens-mode))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (require 'company-elisp)
  (push 'company-elisp company-backends))

(use-package company-jedi
  :ensure t
  :config
  (push 'company-jedy company-backends))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status))
  (("C-x M-g" . magit-dispatch-popup)))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package git-timemachine
  :ensure t
  :bind ("M-g M-t" . git-timemachine))

(use-package ace-window
  :ensure t
  :init
  (setq aw-scope 'global) ;; was frame
  (global-set-key (kbd "C-x O") 'other-frame)
  (global-set-key [remap other-window] 'ace-window)
  (custom-set-faces
   '(aw-leading-char-face
     ((t (:inherit ace-jump-face-foreground :height 3.0))))))


;;; init.el ends here

