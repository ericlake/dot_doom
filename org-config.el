;;; org-config.el -*- lexical-binding: t; -*-

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org
  (setq org-directory "~/Dropbox/org"
        org-enforce-todo-checkbox-dependencies nil
        org-enforce-todo-dependencies t
        org-habit-show-habits t
        org-log-done-with-time t
        org-use-speed-commands t
        org-ellipsis " ▾"))

(custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
(custom-declare-face '+org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
(custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
(custom-declare-face '+org-todo-next '((t (:inherit (bold font-lock-keyword-face org-todo)))) "")
(custom-declare-face 'org-checkbox-statistics-todo '((t (:inherit (bold font-lock-constant-face org-todo)))) "")

(after! org
    (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJECT(p)"  ; Project with multiple task items.
           "IN_PROGRESS(i)" ; A task that has been started
           "NEXT(n)"  ; Task is next to be worked on.
           "WAIT(w)"  ; Something external is holding up this task
           "BLOCKED(b)" ; A task that is blocked externally
           "|"
           "DONE(d)"  ; Task successfully completed
           "CANCLED(c)" ; Task was cancelled, aborted or is no longer applicable
           "DELEGATED(D)")) ; Task was delegated to someone else
        org-todo-keyword-faces
        '(("TODO" . org-warning)
          ("PROJECT" . +org-todo-project)
          ("IN_PROGRESS" . +org-todo-active)
          ("NEXT" . +org-todo-next)
          ("WAIT" . +org-todo-onhold)
          ("BLOCKED" . +org-todo-onhold)
          ("PROJECT" . (:foreground "blue" :weight bold))
          ("CANCELED" . (:foreground "red" :weight bold)))))

(after! org
  (setq org-capture-templates
        '(("p" "Personal Templates")
          ("ph" "Personal habit" entry
           (file+headline "~/Dropbox/org/habits.org" "Habit Tracker")
           "\n** TODO %?\n%i\n"
           :prepend nil
           :unnarrowed t
           :kill-buffer t)
          ("pt" "Personal todo" entry
           (file+headline "~/Dropbox/org/personal-todo.org" "Personal Todo List")
           "\n** TODO %?\n%i\n"
           :prepend nil
           :unnarrowed t
           :kill-buffer t)
          ("w" "Work templates")
          ("wt" "Work todo" entry
          (file+headline "~/Dropbox/org/work-todo.org" "Work Todo List")
          "\n** TODO %?\n%i\n"
          :prepend nil
          :unnarrowed t
          :kill-buffer t)
          ("wl" "Work todo with link" entry
          (file+headline "~/Dropbox/org/work-todo.org" "Work Todo List")
          "\n** TODO %?\n%i\n%a"
          :prepend nil
          :unnarrowed t
          :kill-buffer t))))

(setq org-journal-dir "~/Dropbox/org/journals/"
      org-journal-file-format "%Y-%m.org.gpg"
      org-journal-file-type "weekly"
      org-journal-date-format "%A, %d %B %Y"
      org-journal-start-on-weekday 0
      org-journal-enable-encryption t
      org-journal-encrypt-journal t)

(setq org-roam-directory "~/Dropbox/org/roam")

;; Let deft search files under root org directory.
;; We could use the org-directory variable instead of duplicating values
(setq deft-directory "~/Dropbox/org/"
   deft-recursive t
   ;; I don't like any summary, hence catch-all regexp. need to see if
   ;; an option to hide summary is there instead of this one.
   deft-strip-summary-regexp ".*$"
)

(after! org
  (setq org-agenda-files (append (file-expand-wildcards "~/Dropbox/org/*.org"))))

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-include-deadlines t
        org-agenda-dim-blocked-tasks t
        org-agenda-use-time-grid t
        org-agenda-compact-blocks nil
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-window-setup 'current-window
        ;; org-agenda-block-separator nil
        org-agenda-start-day nil ;; i.e. today
        org-agenda-span 3
        org-agenda-start-on-weekday nil)
  (setq org-super-agenda-groups
        '((:name "Today"
           :time-grid t
           :date today
           :order 1)
          (:name "To refile"
           :file-path "refile\\.org")
          (:name "Next to do"
           :todo "NEXT"
           :order 1)
          (:name "Important"
           :priority "A"
           :order 6)
          (:name "Due Today"
           :deadline today
           :order 2)
          (:name "Scheduled Soon"
           :scheduled future
           :order 8)
          (:name "Overdue"
           :deadline past
           :order 7)
          (:name "Meetings"
           :and (:todo "MEET" :scheduled future)
           :order 10)
          (:discard (:not (:todo "TODO")))))
  :config
  (org-super-agenda-mode))
