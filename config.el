;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Eric Lake")

(setq auth-sources
      '((:source "~/.doom.d/secrets/.authinfo.gpg"))
      send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t
      )

;; Personl email
;; Each path is relative to `+mu4e-mu4e-mail-path', which is ~/.mail by default
(set-email-account! "personal"
  '((mu4e-sent-folder       . "/personal/[Gmail]/Sent Mail")
    (mu4e-drafts-folder     . "/personal/[Gmail]/Drafts")
    (mu4e-trash-folder      . "/personal/[Gmail]/Trash")
    (mu4e-refile-folder     . "/personal/[Gmail]/All Mail")
    (smtpmail-smtp-user     . "ericlake@gmail.com")
    (user-mail-address      . "ericlake@gmail.com")    ;; only needed for mu < 1.4
    (mu4e-compose-signature . "\nRegards,\n\nEric Lake"))
  t)

;; Work email
;; Each path is relative to `+mu4e-mu4e-mail-path', which is ~/.mail by default
(set-email-account! "logdna"
  '((mu4e-sent-folder       . "/logdna/[Gmail]/Sent Mail")
    (mu4e-drafts-folder     . "/logdna/[Gmail]/Drafts")
    (mu4e-trash-folder      . "/logdna/[Gmail]/Trash")
    (mu4e-refile-folder     . "/logdna/[Gmail]/All Mail")
    (smtpmail-smtp-user     . "eric.lake@logdna.com")
    (user-mail-address      . "eric.lake@logdna.com")    ;; only needed for mu < 1.4
    (mu4e-compose-signature . "\nRegards,\n\nEric Lake"))
  t)

(after! mu4e
  (setq mu4e-context-policy "ask"
        mu4e-update-interval (* 10 60)
        mu4e-get-mail-command "mbsync -a"))

(setq epg-gpg-program "gpg2")

;; Customize the splash screen image
(setq fancy-splash-image (concat doom-private-dir "etank.png"))

(setq doom-modeline-major-mode-icon t
      doom-modeline-major-mode-color-icon t)

(set-fringe-mode 10)        ; Give some breathing room

(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes input-method buffer-encoding major-mode process vcs checker "  "))) ; <-- added padding here

(defun display-workspaces-in-minibuffer ()
  (with-current-buffer " *Minibuf-0*"
    (erase-buffer)
    (insert (+workspace--tabline))))
(run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
(+workspace/display)

;; Use the PATH set in bash profile
(require 'exec-path-from-shell)
(when (display-graphic-p)
  (exec-path-from-shell-initialize))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Hack" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Hack") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "Hack" :size 14)
      doom-big-font (font-spec :family "Hack" :size 19))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;;(setq doom-theme 'vscode-dark-plus)

;; Python bits
(setq python-shell-completion-native-enable nil
      python-shell-interpreter "python3")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; Set default dir to look for files
(setq default-directory "~/")

;; Set dir to find projects
(setq projectile-project-search-path '("~/src/logdna/"))

;; Configure elfeed. This will use the elfeed.org file to configure feeds.
(after! elfeed
  (setq elfeed-search-filter "@1-month-ago +unread")
  (add-hook! 'elfeed-search-mode-hook 'elfeed-update))

(map! :leader
      (:prefix-map ("a" . "applications")
       (:prefix ("e" . "elfeed")
        :desc "Read mews" "r" #'elfeed
        :desc "Update feeds" "u" #'elfeed-update)))

;; Set up some yaml defaults
(setq yaml-indent-level 2)
(add-to-list 'auto-mode-alist '("\\.envsubst\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))

;; Set up some json defaults
(setq js-indent-level 2)
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))

;; Load the customized org-mode settings
(load! "org-config.el")

(use-package! ansible-vault)

(add-to-list 'auto-mode-alist '(".yaml.vault$" . yaml-mode))

(defun ansible-vault-mode-maybe ()
    (when (ansible-vault--is-vault-file)
      (ansible-vault-mode 1)))

(add-hook 'yaml-mode-hook 'ansible-vault-mode-maybe)

;;(use-package! edwina
;;  :config
;;  (setq display-buffer-base-action '(display-buffer-below-selected))
;;  (edwina-setup-dwm-keys)
;;  (edwina-mode 1))

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
