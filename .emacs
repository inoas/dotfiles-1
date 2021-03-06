;; Personal info
(setq user-full-name    "Stephen Whitmore"
      user-mail-address "sww@eight45.net")

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Enable file encryption
(require 'epa-file)
(epa-file-enable)

;; Package management
(package-initialize)
;(add-to-list 'package-archives
;             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; Save a few keystrokes
(fset 'yes-or-no-p 'y-or-n-p)

;; Make META play nicely on X
(setq x-alt-keysym 'meta)

;; Reload any loaded buffer if it changes on disk.
(global-auto-revert-mode t)

(global-set-key (kbd "M-o") 'kill-this-buffer)

;; Easier buffer navigation.
(global-set-key (kbd "M-j") 'next-buffer)
(global-set-key (kbd "M-k") 'previous-buffer)

;; Easier window navigation.
(global-set-key (kbd "C-.") 'other-window)
(global-set-key (kbd "C-,") 'prev-window)
(defun prev-window ()
  (interactive)
  (other-window -1))

;; Default font.
(set-face-attribute 'default nil :font "Ubuntu Mono" :height 120)
(add-to-list 'default-frame-alist '(font .  "Ubuntu Mono 12.0"))

;; Default browser.
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")

;; Paste the system clipboard into emacs.
(global-set-key (kbd "C-x C-p") 'x-clipboard-yank)

;; I <3 visual line mode
(global-visual-line-mode 1)

;; Prefer side-by-side when there's room.
(setq split-width-threshold 140)

;; Programming preferences.
(setq-default indent-tabs-mode nil)
(setq c-basic-offset 2)
(setq-default tab-width 2)
(setq-default js-indent-level 2)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

(defun curl (url)
  "Fetches the raw data at URL and prints it to the current buffer."
  (interactive "sURL to fetch: ")
  (insert (shell-command-to-string (concat "curl -Ls " url))))

(defun npm-readme (module)
  "Opens a new buffer with the readme of the given module."
  (interactive "sModule name: ")
  (let ((buffer (get-buffer-create (generate-new-buffer-name "README.md"))))
    (pop-to-buffer buffer)
    (insert (shell-command-to-string (concat "npm --cache-min=999999999 info " module " readme")))
    (with-current-buffer buffer (funcall 'markdown-mode))
    (beginning-of-buffer)
    (kill-line)
    )
  )

;; eval-and-replace
;; via http://emacsredux.com/blog/2013/06/21/eval-and-replace/
(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))
(global-set-key (kbd "C-x e") 'eval-and-replace)

;; Save backup files to /tmp.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; org-mode
(setq org-log-done 'time)
(setq org-startup-indented t)
(setq org-agenda-files (list "~/dd/dd.org" "~/dd/dd.org_archive"))
(define-key global-map "\C-ca" 'org-agenda)
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT-ACTION(n)" "STARTED(s@/!)" "WAITING(w@/!)" "APPT(a)" "DEFERRED(D@/!)" "DELEGATED(g@/!)" "PROJECT(p)" "|" "DONE(d!)" "CANCELLED(x@/!)")))
(setq org-todo-keyword-faces
      '(("PROJECT" . (:foreground "medium sea green" :weight bold :underline t))
        ("WAITING" . "dark orange")))
(setq org-agenda-start-on-weekday nil)
(setq org-ellipsis "⤷")

;(setq org-agenda-custom-commands
;      '(("h" "Agenda and Home-related tasks"
;         ((agenda)
;          (tags-todo "home")
;          (tags "garden"
;                ((org-agenda-sorting-strategy '(priority-up)))))
;         ((org-agenda-sorting-strategy '(priority-down))))
;        ("o" "Agenda and Office-related tasks"
;         ((agenda)
;          (tags-todo "work")
;          (tags "office")))))

;; Always make sure an 'Effort' is set when clocking in to a task.
(add-hook 'org-clock-in-prepare-hook
          'my/org-mode-ask-effort)
(defun my/org-mode-ask-effort ()
  "Ask for an effort estimate when clocking in."
  (unless (org-entry-get (point) "Effort")
    (let ((effort
           (completing-read
            "Effort: "
            (org-entry-get-multivalued-property (point) "Effort"))))
      (unless (equal effort "")
        (org-set-property "Effort" effort)))))

;; Task dependencies
(setq org-enforce-todo-dependencies t)
(setq org-track-ordered-property-with-tag t)
(setq org-agenda-dim-blocked-tasks t)

;; org-capture
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates  ; TODO(sww): update this; horribly out of date!!!
      '(("t" "Todo" entry (file+headline "~/new.org" "Inbox") "* TODO %^{Task}%?\n")
        ("d" "Dd Todo" entry (file+headline "~/dd/dd.org" "Inbox") "* TODO %^{Task}%?\n")
        ;("o" "Today Task" entry (file+headline "~/life.org" "Tasks") "* TODO %^{Task}\nSCHEDULED: %t\n%?" :immediate-finish t)
        ;("j" "Journal" entry (file+datetree "~/org/journal.org") "* %?\nEntered on %U\n  %i\n  %a")
        ))

;; TODO(sww): incorporate these into their respective sections.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-safe-themes
   (quote
    ("2f5b8b4d2f776fd59c9f9a1d6a45cdb75a883c10a9426f9a50a4fea03b1e4d89" default)))
 '(org-deadline-warning-days 5)
 '(org-default-notes-file "~/life.org")
 '(org-habit-graph-column 45)
 '(org-habit-preceding-days 14)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(package-selected-packages (quote (paredit cider markdown-mode magit)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))

(eval-after-load 'org-agenda
  '(progn
     (define-key org-agenda-mode-map (kbd "s-<tab>") 'show-todo-org)
     (define-key org-agenda-mode-map (kbd "<return>") 'org-agenda-goto)))

(eval-after-load "org"
  '(progn
     (define-prefix-command 'org-todo-state-map)
     (define-key org-mode-map "\C-cx" 'org-todo-state-map)
     (define-key org-mode-map "\C-\M-j" 'org-insert-todo-heading)
     (define-key org-todo-state-map "x"
       #'(lambda nil (interactive) (org-todo "CANCELLED")))
     (define-key org-todo-state-map "t"
       #'(lambda nil (interactive) (org-todo "TODO")))
     (define-key org-todo-state-map "d"
       #'(lambda nil (interactive) (org-todo "DONE")))
     (define-key org-todo-state-map "f"
       #'(lambda nil (interactive) (org-todo "DEFERRED")))
     (define-key org-todo-state-map "l"
       #'(lambda nil (interactive) (org-todo "LGTM")))
     (define-key org-todo-state-map "s"
       #'(lambda nil (interactive) (org-todo "STARTED")))
     (define-key org-todo-state-map "w"
       #'(lambda nil (interactive) (org-todo "WAITING")))))

(add-to-list 'load-path "~/.emacs.d/themes/emacs-color-theme-solarized/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
;(load-theme 'solarized t)

;; I <3 visual line mode
(global-visual-line-mode 1)
