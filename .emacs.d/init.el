(require `package)
(setq package-archives `(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install `use-package))

(require `use-package)
(setq use-package-always-ensure t)

(defun dan/set-fonts()
  ;; We only want to set fonts in a graphic environment
  (when (display-graphic-p)
    (set-face-attribute `default nil :font "Jetbrains mono" :height 150)
    (set-face-attribute `variable-pitch nil :font "Noto sans" :height 150)
    (copy-face `default `fixed-pitch)
    ;; Set emoji and glyph fonts
    (set-fontset-font t 'symbol "Apple Color Emoji" nil 'prepend)
    (set-fontset-font t 'symbol "Noto Color Emoji" nil 'prepend)
    (set-fontset-font t 'symbol "Segoe UI Emoji" nil 'prepend)
    (set-fontset-font t 'symbol "UbuntuMono Nerd Font" nil 'prepend)))

;; Set the fonts when we initialize
(add-hook `after-init-hook `dan/set-fonts)
;; Set the fonts when we create a new frame from daemon mode
(add-hook `server-after-make-frame-hook `dan/set-fonts)

;; Make emacs more minimal looking
(setq inhibit-startup-message t)      ;; Don't load startup screen
(scroll-bar-mode -1)                  ;; Don't show scroll bar
(tool-bar-mode -1)                    ;; Don't show tool bar
(tooltip-mode -1)                     ;; Don't show tooltips
(menu-bar-mode -1)                    ;; Don't show Menu Bar
(set-fringe-mode 10)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode `(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

;; Set the colour scheme
(use-package doom-themes
  :demand t
  :config
  (load-theme `doom-dracula t))

(use-package evil
  :demand t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :demand t
  :after evil
  :config
  (evil-collection-init))

(use-package ivy)

(use-package counsel)

(use-package helpful
  :custom
  (counsel-describe-function-function `helpful-callable)
  (counsel-describe-variable-function `helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package helm
  :bind
  ("M-x" . helm-M-x)
  ("C-x b" . helm-buffers-list)
  ("C-x C-f" . helm-find-files))

(use-package helm-ag)

(use-package general
  :demand t
  :config
  (general-create-definer dan/leader-keys
    :keymaps `(normal visual emacs)
    :prefix "SPC"))

(general-define-key
 "<escape>" `keyboard-escape-quit)

(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
  "Scale Text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("q" nil "quit" :exit t))

(dan/leader-keys
  "ts" `(hydra-text-scale/body :whichkey "scale text"))

(defun dan/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)
  (dan/set-org-fonts)
  (ivy-mode 1))

(use-package org
  :demand t
  :hook (org-mode . dan/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list `("◉")))

;; Changes bullets into bullets
(font-lock-add-keywords `org-mode
                        `(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(defun dan/set-org-fonts ()
  (dolist (face `((org-level-1 . 1.5)
                  (org-level-2 . 1.4)
                  (org-level-3 . 1.3)
                  (org-level-4 . 1.2)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.05)))
    (set-face-attribute (car face) nil :weight `bold :height (cdr face)))

(set-face-attribute `org-document-title nil :height 300)
(set-face-attribute `org-block nil :foreground nil :background "#353848" :inherit `fixed-pitch)
(set-face-attribute `org-code nil :inherit `(shadow fixed-pitch))
(set-face-attribute `org-table nil :background "#353848" :inherit `(shadow fixed-pitch))
(set-face-attribute `org-indent nil :inherit `(org-hide fixed-pitch))
(set-face-attribute `org-verbatim nil :inherit `(shadow fixed-pitch))
(set-face-attribute `org-special-keyword nil :inherit `(font-lock-comment-face fixed-pitch))
(set-face-attribute `org-meta-line nil :inherit `(font-lock-comment-face fixed-pitch))
(set-face-attribute `org-checkbox nil :inherit `fixed-pitch))

(defun dan/org-mode-visual-fill()
  (setq visual-fill-column-width 125)
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . dan/org-mode-visual-fill))

(setq org-agenda-files
      `("~/Dropbox/Org/"))
(setq org-agenda-start-with-log-mode t)
(setq org-log-done `time)
(setq org-log-into-drawer t)

(defun dan/org-agenda-config ()
  (define-key org-agenda-mode-map "j" 'evil-next-line)
  (define-key org-agenda-mode-map "k" 'evil-previous-line))

(add-hook `org-agenda-mode-hook `dan/org-agenda-config)

(setq org-todo-keywords `((sequence "TODO(t)" "IN PROGRESS(p)" "|" "DONE(d!)")))

(setq org-refile-targets
      `(("~/Dropbox/Org/archive.org" :maxlevel . 1)
        ("~/Dropbox/Org/todo.org" :maxlevel . 1)))

(advice-add `org-refile :after `org-save-all-org-buffers)

(setq org-capture-templates
      `(("t" "Todo" entry (file+headline "~/Dropbox/Org/todo.org" "Inbox") "* TODO %?\n %U\n %a\n %i" :empty-lines 1)))

(use-package org-projectile
  :demand t
  :config
  (org-projectile-per-project)
  (setq org-projectile-per-project-filepath "TODO.org")
  (setq org-projectile-capture-template "* TODO %?\n %U\n %a\n %i")
  (setq org-agenda-files (seq-filter 'file-readable-p (delete-dups (append org-agenda-files (org-projectile-todo-files))))))

(setq browse-url-mailto-function 'browse-url-generic)
(setq browse-url-generic-program "thunderbird")

(dan/leader-keys
  "o" `(:ignore t :which-key "Org")
  "oc" `(org-capture :which-key "Capture")
  "oa" `(org-agenda :which-key "Agenda")
  "op" `(org-projectile-capture-for-current-project :which-key "Project Capture")
  "pc" `(org-projectile-capture-for-current-project :which-key "Org Capture"))

(use-package yasnippet
  :demand t
  :init
  (yas-global-mode 1)
  (setq yas-snippet-dirs `("~/.emacs.d/snippets")))

(defun dan/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments `(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode 1))

(add-hook `lsp-mode `dan/lsp-mode-setup)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(add-hook `python-mode `lsp)

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-annot-activate-created-annotations t)
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  (define-key pdf-view-mode-map (kbd "C-r") 'isearch-backward)
  (add-hook 'pdf-view-mode-hook (lambda ()
                                  (bms/pdf-midnite-amber))) ; automatically turns on midnight-mode for pdfs
  )

(use-package auctex-latexmk
  :ensure t
  :config
  (auctex-latexmk-setup)
  (setq auctex-latexmk-inherit-TeX-PDF-mode t))

(use-package reftex
  :ensure t
  :defer t
  :config
  (setq reftex-cite-prompt-optional-args t)) ;; Prompt for empty optional arguments in cite

(use-package company-auctex
  :ensure t
  :init (company-auctex-init))

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . latex-mode)
  :config (progn
            (setq TeX-source-correlate-mode t)
            (setq TeX-source-correlate-method 'synctex)
            (setq TeX-auto-save t)
            (setq TeX-parse-self t)
            (setq-default TeX-master "main.tex")
            (setq reftex-plug-into-AUCTeX t)
            (pdf-tools-install)
            (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
                  TeX-source-correlate-start-server t)
            ;; Update PDF buffers after successful LaTeX runs
            (add-hook 'TeX-after-compilation-finished-functions
                      #'TeX-revert-document-buffer)
            (add-hook 'LaTeX-mode-hook
                      (lambda ()
                        (reftex-mode t)
                        (flyspell-mode t)))
            ))

(add-hook `tex-mode `lsp)

(setq font-latex-fontify-script nil)

(use-package haskell-mode)

(use-package evil-nerd-commenter)

(dan/leader-keys
  "c" `(evilnc-comment-or-uncomment-lines :which-key "comment"))

(use-package company
  :demand t
  :config
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package magit)

(use-package forge
  :after magit)

(dan/leader-keys
  "g" `(:ignore t :which-key "git")
  "gg" `(magit-status :which-key "status")
  "gl" `(magit-log-current :which-key "log"))

(use-package projectile
  :demand t
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/repos")
    (setq projectile-project-search-path `("~/repos")))
  (setq projectile-switch-project-action `helm-projectile-find-file))

(use-package helm-projectile
  :init (helm-projectile-on))

(dan/leader-keys
  "p" `(:ignore t :which-key "Projectile")
  "pp" `(projectile-switch-project :which-key "Switch Project")
  "pf" `(projectile-find-file :which-key "Find Files")
  "pg" `(projectile-ag :which-key "Project Grep"))

(use-package which-key
  :init
  (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(setq backup-directiory-alist `(("." . "~/fileBackups")))
