;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Eric Lake"
      user-mail-address "ericlake@gmail.com")

;; Customize the splash screen image
(setq fancy-splash-image (concat doom-private-dir "etank.png"))

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
  (setq elfeed-search-filter "@1-month-ago +unread"))
(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

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
