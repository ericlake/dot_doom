;;; org-config.el -*- lexical-binding: t; -*-

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/"
      org-use-speed-commands t
      org-log-done-with-time t)

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
        '(("WAIT" . +org-todo-onhold)
          ("PROJECT" . +org-todo-project)
          ("TODO" . +org-todo-active)
          ("NEXT" . +org-todo-next))))

(after! org
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline "~/Dropbox/org/personal-todo.org" "Personal Todo List")
           "** TODO %?\n%i\n"
           :prepend nil
           :unnarrowed t
           :kill-buffer t)
          ("w" "Work templates")
          ("wt" "Work todo" entry
          (file+headline "~/Dropbox/org/work-todo.org" "Work Todo List")
          "** TODO %?\n%i\n"
          :prepend nil
          :unnarrowed t
          :kill-buffer t)
          ("wl" "Work todo with link" entry
          (file+headline "~/Dropbox/org/work-todo.org" "Work Todo List")
          "** TODO %?\n%i\n%a"
          :prepend nil
          :unnarrowed t
          :kill-buffer t))))

(setq org-journal-dir "~/Dropbox/org/journals/"
      org-journal-file-format "%Y-%m.org"
      org-journal-file-type "weekly"
      org-journal-date-format "%A, %d %B %Y"
      org-journal-start-on-weekday 0)

(setq org-roam-directory "~/Dropbox/org/roam")

;; Let deft search files under root org directory.
;; We could use the org-directory variable instead of duplicating values
(setq deft-directory "~/Dropbox/org/"
   deft-recursive t
   ;; I don't like any summary, hence catch-all regexp. need to see if
   ;; an option to hide summary is there instead of this one.
   deft-strip-summary-regexp ".*$"
)

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      ;; org-agenda-block-separator nil
      ;; org-agenda-compact-blocks nil
      org-agenda-start-day nil ;; i.e. today
      ; org-agenda-span 10
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
