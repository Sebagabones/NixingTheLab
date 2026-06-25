;;; default.el --- config -*- lexical-binding: t; no-byte-compile: t; -*-

(setq initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

;; Set-language-environment sets default-input-method, which is unwanted.
(setq default-input-method nil)

;; Ask the user whether to terminate asynchronous compilations on exit.
;; This prevents native compilation from leaving temporary files in /tmp.
(setq native-comp-async-query-on-exit t)

(setq enable-recursive-minibuffers t) ; Allow nested minibuffers

;; Keep the cursor out of the read-only portions of the.minibuffer
(setq minibuffer-prompt-properties
      '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;;; Display and user interface

;; By default, Emacs "updates" its ui more often than it needs to
(setq which-func-update-delay 1.0)
(setq idle-update-delay which-func-update-delay)  ;; Obsolete in >= 30.1

(defalias #'view-hello-file #'ignore)  ; Never show the hello file

;; No beeping or blinking
(setq visible-bell nil)
(setq ring-bell-function #'ignore)

;; Position underlines at the descent line instead of the baseline.
(setq x-underline-at-descent-line t)

(setq truncate-string-ellipsis "…")

(setq display-time-default-load-average nil) ; Omit load average

;;; Show-paren

(setq show-paren-delay 0.1
      show-paren-highlight-openparen t
      show-paren-when-point-inside-paren t
      show-paren-when-point-in-periphery t)

;;; Buffer management

(setq custom-buffer-done-kill t)

;; Disable auto-adding a new line at the bottom when scrolling.
(setq next-line-add-newlines nil)

;; This setting forces Emacs to save bookmarks immediately after each change.
;; Benefit: you never lose bookmarks if Emacs crashes.
(setq bookmark-save-flag 1)

(setq uniquify-buffer-name-style 'forward)

(setq remote-file-name-inhibit-cache 50)

;; Disable fontification during user input to reduce lag in large buffers.
;; Also helps marginally with scrolling performance.
;;(setq redisplay-skip-fontification-on-input t)

;;; Misc

(setq whitespace-line-column nil)  ; Use the value of `fill-column'.

;; Disable ellipsis when printing s-expressions in the message buffer
(setq eval-expression-print-length nil
      eval-expression-print-level nil)

;; This directs gpg-agent to use the minibuffer for passphrase entry
(setq epg-pinentry-mode 'loopback)

;; By default, Emacs stores sensitive authinfo credentials as unencrypted text
;; in your home directory. Use GPG to encrypt the authinfo file for enhanced
;; security.
(setq auth-sources (list "~/.authinfo.gpg"))

;;; `display-line-numbers-mode'

(setq-default display-line-numbers-width 3)
(setq-default display-line-numbers-widen t)

;;; imenu

;; Automatically rescan the buffer for Imenu entries when `imenu' is invoked
;; This ensures the index reflects recent edits.
(setq imenu-auto-rescan t)

;; Prevent truncation of long function names in `imenu' listings
(setq imenu-max-item-length 160)

;;; Tramp

(setq tramp-verbose 1)

;;; Files

;; Delete by moving to trash in interactive mode
(setq delete-by-moving-to-trash (not noninteractive))
(setq remote-file-name-inhibit-delete-by-moving-to-trash t)

;; Ignoring this is acceptable since it will redirect to the buffer regardless.
(setq find-file-suppress-same-file-warnings t)

;; Resolve symlinks to avoid duplicate buffers
(setq find-file-visit-truename t
      ;; Automatically follow a symlink to its source if that source is managed
      ;; by a version control system, rather than asking for permission.
      vc-follow-symlinks t)

;; Prefer vertical splits over horizontal ones
(setq split-width-threshold 170
      split-height-threshold nil)

;;; comint (general command interpreter in a window)

(setq ansi-color-for-comint-mode t
      comint-prompt-read-only t
      comint-buffer-maximum-size 4096)

;;; Compilation

(setq compilation-ask-about-save nil
      compilation-always-kill t
      compilation-scroll-output 'first-error)

;; Skip confirmation prompts when creating a new file or buffer
(setq confirm-nonexistent-file-or-buffer nil)

;;; Backup files

;; Disable the creation of lockfiles (e.g., .#filename).
;; Modern workflows rely on `global-auto-revert-mode' to handle external file
;; changes gracefully, making the restrictive nature of lockfiles unnecessary.
(setq create-lockfiles nil)

;; Disable backup files (e.g., filename~). Note that `auto-save-default'
;; remains enabled by default. Even with `make-backup-files' backups disabled,
;; Emacs will still generate temporary recovery files (e.g., #filename#) for
;; unsaved buffers. This protects your active work from sudden crashes while
;; ensuring the file system is cleaned up immediately upon a successful save.
(setq make-backup-files nil)

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory))))
(setq tramp-backup-directory-alist backup-directory-alist)
(setq backup-by-copying-when-linked t)
(setq backup-by-copying t)  ; Backup by copying rather renaming
(setq delete-old-versions t)  ; Delete excess backup versions silently
(setq version-control t)  ; Use version numbers for backup files
(setq kept-new-versions 5)
(setq kept-old-versions 5)

;;; VC

(setq vc-git-print-log-follow t)
(setq vc-git-diff-switches '("--histogram"))  ; Faster algorithm for diffing.

;;; Auto save

;; Enable auto-save to safeguard against crashes or data loss. The
;; `recover-file' or `recover-session' functions can be used to restore
;; auto-saved data.
(setq auto-save-no-message t)

(when noninteractive
  ;; The command line interface
  (setq enable-dir-local-variables nil)
  (setq case-fold-search nil))

;; Do not auto-disable auto-save after deleting large chunks of
;; text.
(setq auto-save-include-big-deletions t)

(setq auto-save-list-file-prefix
      (expand-file-name "autosave/" user-emacs-directory))
(setq tramp-auto-save-directory
      (expand-file-name "tramp-autosave/" user-emacs-directory))

(setq auto-save-file-name-transforms
      `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
         ,(file-name-concat auto-save-list-file-prefix "tramp-\\2-") sha1)
        ("\\`/\\([^/]+/\\)*\\([^/]+\\)\\'"
         ,(file-name-concat auto-save-list-file-prefix "\\2-") sha1)))

;; Ensure the directory for auto-save session logs exists with restricted
;; permissions.
(when auto-save-default
  (let ((auto-save-dir (file-name-directory auto-save-list-file-prefix)))
    (unless (file-exists-p auto-save-dir)
      (with-file-modes #o700
        (make-directory auto-save-dir t)))))

;; Auto save options
(setq kill-buffer-delete-auto-save-files t)

;; Remove duplicates from the kill ring to reduce clutter
(setq kill-do-not-save-duplicates t)

;;; Auto revert
;; Auto-revert in Emacs is a feature that automatically updates the contents of
;; a buffer to reflect changes made to the underlying file.

;; Revert other buffers (e.g, Dired)
(setq global-auto-revert-non-file-buffers t)
(setq global-auto-revert-ignore-modes '(Buffer-menu-mode))  ; Resolve issue #29

;;; recentf

;; `recentf' is an that maintains a list of recently accessed files.
(setq recentf-max-saved-items 300) ; default is 20
(setq recentf-max-menu-items 15)
(setq recentf-auto-cleanup 'mode)

;;; saveplace

;; Enables Emacs to remember the last location within a file upon reopening.
(setq save-place-file (expand-file-name "saveplace" user-emacs-directory))
(setq save-place-limit 600)

;;; savehist

;; `savehist-mode' is an Emacs feature that preserves the minibuffer history
;; between sessions.
(setq history-length 300)
(setq savehist-additional-variables
      '(register-alist                   ; macros
        mark-ring global-mark-ring       ; marks
        search-ring regexp-search-ring)) ; searches

;;; Frames and windows

(setq resize-mini-windows 'grow-only)

;; The native border "uses" a pixel of the fringe on the rightmost
;; splits, whereas `window-divider-mode' does not.
(setq window-divider-default-bottom-width 1
      window-divider-default-places t
      window-divider-default-right-width 1)

;;; Scrolling

;; Enables faster scrolling. This may result in brief periods of inaccurate
;; syntax highlighting, which should quickly self-correct.
(setq fast-but-imprecise-scrolling t)

;; Move point to top/bottom of buffer before signaling a scrolling error.
(setq scroll-error-top-bottom t)

;; Keep screen position if scroll command moved it vertically out of the window.
(setq scroll-preserve-screen-position t)

;; Emacs recenters the window when the cursor moves past `scroll-conservatively'
;; lines beyond the window edge. A value over 101 disables recentering; the
;; default (0) is too eager. Here it is set to 20 for a balanced behavior.
(setq scroll-conservatively 20)

;; 1. Preventing automatic adjustments to `window-vscroll' for long lines.
;; 2. Resolving the issue of random half-screen jumps during scrolling.
(setq auto-window-vscroll nil)

;; Horizontal scrolling
(setq hscroll-margin 2
      hscroll-step 1)
;;; Cursor

;; The blinking cursor is distracting and interferes with cursor settings in
;; some minor modes that try to change it buffer-locally (e.g., Treemacs).
(when (bound-and-true-p blink-cursor-mode)
  (blink-cursor-mode -1))

;; Don't blink the paren matching the one at point, it's too distracting.
(setq blink-matching-paren nil)

;; Reduce rendering/line scan work by not rendering cursors or regions in
;; non-focused windows.
(setq highlight-nonselected-windows nil)

;;; Text editing, indent, font, and formatting

;; Avoid automatic frame resizing when adjusting settings.
                                        ;(setq global-text-scale-adjust-resizes-frames nil)

;; A longer delay can be annoying as it causes a noticeable pause after each
;; deletion, disrupting the flow of editing.
(setq delete-pair-blink-delay 0.03)

;; Continue wrapped lines at whitespace rather than breaking in the
;; middle of a word.
(setq-default word-wrap t)

;; Disable wrapping by default due to its performance cost.
(setq-default truncate-lines t)

;; If enabled and `truncate-lines' is disabled, soft wrapping will not occur
;; when the window is narrower than `truncate-partial-width-windows' characters.
(setq truncate-partial-width-windows nil)

;; Configure automatic indentation to be triggered exclusively by newline and
;; DEL (backspace) characters.
(setq-default electric-indent-chars '(?\n ?\^?))

;; Prefer spaces over tabs. Spaces offer a more consistent default compared to
;; 8-space tabs. This setting can be adjusted on a per-mode basis as needed.
(setq-default indent-tabs-mode nil
              tab-width 4)

;; Enable indentation and completion using the TAB key
(setq tab-always-indent 'complete)
(setq tab-first-completion 'word-or-paren-or-punct)

;; Perf: Reduce command completion overhead.
(setq read-extended-command-predicate #'command-completion-default-include-p)

;; Enable multi-line commenting which ensures that `comment-indent-new-line'
;; properly continues comments onto new lines.
(setq comment-multi-line t)

;; Ensures that empty lines within the commented region are also commented out.
;; This prevents unintended visual gaps and maintains a consistent appearance.
(setq comment-empty-lines t)

;; We often split terminals and editor windows or place them side-by-side,
;; making use of the additional horizontal space.
(setq-default fill-column 80)

;; Disable the obsolete practice of end-of-line spacing from the typewriter era.
(setq sentence-end-double-space nil)

;; According to the POSIX, a line is defined as "a sequence of zero or more
;; non-newline characters followed by a terminating newline".
(setq require-final-newline t)

;; Eliminate delay before highlighting search matches
(setq lazy-highlight-initial-delay 0)

;;; Filetype

;; Do not notify the user each time Python tries to guess the indentation offset
(setq python-indent-guess-indent-offset-verbose nil)

(setq sh-indent-after-continuation 'always)

;;; Dired and ls-lisp

(setq dired-free-space nil
      dired-dwim-target t  ; Propose a target for intelligent moving/copying
      dired-deletion-confirmer 'y-or-n-p
      dired-filter-verbose nil
      dired-recursive-deletes 'top
      dired-recursive-copies 'always
      dired-vc-rename-file t
      dired-create-destination-dirs 'ask
      ;; Suppress Dired buffer kill prompt for deleted dirs
      dired-clean-confirm-killing-deleted-buffers nil)

;; This is a higher-level predicate that wraps `dired-directory-changed-p'
;; with additional logic. This `dired-buffer-stale-p' predicate handles remote
;; files, wdired, unreadable dirs, and delegates to dired-directory-changed-p
;; for modification checks.
(setq auto-revert-remote-files nil)
(setq dired-auto-revert-buffer 'dired-buffer-stale-p)

;; dired-omit-mode
(setq dired-omit-verbose nil
      dired-omit-files (concat "\\`[.]\\'"))

(setq ls-lisp-verbosity nil)
(setq ls-lisp-dirs-first t)

;;; Ediff

;; Configure Ediff to use a single frame and split windows horizontally
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

;;; Help

;; Enhance `apropos' and related functions to perform more extensive searches
(setq apropos-do-all t)

;; Fixes #11: Prevents help command completion from triggering autoload.
;; Loading additional files for completion can slow down help commands and may
;; unintentionally execute initialization code from some libraries.
(setq help-enable-completion-autoload nil)
(setq help-enable-autoload nil)
(setq help-enable-symbol-autoload nil)
(setq help-window-select t)  ;; Focus new help windows when opened

;;; Eglot

(setq eglot-report-progress nil)  ; Prevent minibuffer spam
(setq eglot-autoshutdown t)  ; Shut down after killing last managed buffer

;; A setting of nil or 0 means Eglot will not block the UI at all, allowing
;; Emacs to remain fully responsive, although LSP features will only become
;; available once the connection is established in the background.
(setq eglot-sync-connect 0)

;; Activate Eglot in cross-referenced non-project files
(setq eglot-extend-to-xref t)

;; Eglot optimization
;; This reduces log clutter to improves performance.
(setq jsonrpc-event-hook nil)
;; Reduce memory usage and avoid cluttering *EGLOT events* buffer
(setq eglot-events-buffer-size 0)  ; Deprecated
(setq eglot-events-buffer-config '(:size 0 :format short))

;;; Flymake

(setq flymake-show-diagnostics-at-end-of-line nil)
(setq flymake-wrap-around nil)

;;; hl-line-mode

;; Highlighting the current window, reducing clutter and improving performance
(setq hl-line-sticky-flag nil)
(setq global-hl-line-sticky-flag nil)

;;; icomplete

;; Do not delay displaying completion candidates in `fido-mode' or
;; `fido-vertical-mode'
(setq icomplete-compute-delay 0.01)

;;; flyspell

;; Improves flyspell performance by preventing messages from being displayed for
;; each word when checking the entire buffer.
(setq flyspell-issue-message-flag nil)
(setq flyspell-issue-welcome-flag nil)

;;; ispell

;; In Emacs 30 and newer, disable Ispell completion to avoid annotation errors
;; when no `ispell' dictionary is set.
(setq text-mode-ispell-word-completion nil)

(setq ispell-silently-savep t)

;;; ibuffer

(setq ibuffer-formats
      '((mark modified read-only locked
              " " (name 55 55 :left :elide)
              " " (size 8 -1 :right)
              " " (mode 18 18 :left :elide) " " filename-and-process)
        (mark " " (name 16 -1) " " filename)))

;;; xref

;; Enable completion in the minibuffer instead of the definitions buffer
(setq xref-show-definitions-function 'xref-show-definitions-completing-read
      xref-show-xrefs-function 'xref-show-definitions-completing-read)

;;; abbrev

;; Ensure the abbrev_defs file is stored in the correct location when
;; `user-emacs-directory' is modified, as it defaults to ~/.emacs.d/abbrev_defs
;; regardless of the change.
(setq abbrev-file-name (expand-file-name "abbrev_defs" user-emacs-directory))

(setq save-abbrevs 'silently)

;;; dabbrev

(setq dabbrev-upcase-means-case-search t)

(setq dabbrev-ignored-buffer-modes
      '(archive-mode image-mode docview-mode tags-table-mode
                     pdf-view-mode tags-table-mode))

(setq dabbrev-ignored-buffer-regexps
      '(;; - Buffers starting with a space (internal or temporary buffers)
        "\\` "
        ;; Tags files such as ETAGS, GTAGS, RTAGS, TAGS, e?tags, and GPATH,
        ;; including versions with numeric extensions like <123>
        "\\(?:\\(?:[EG]?\\|GR\\)TAGS\\|e?tags\\|GPATH\\)\\(<[0-9]+>\\)?"))

;;; Remove warnings from narrow-to-region, upcase-region...

(dolist (cmd '(list-timers narrow-to-region narrow-to-page
                           upcase-region downcase-region
                           list-threads erase-buffer scroll-left
                           dired-find-alternate-file set-goal-column))
  (put cmd 'disabled nil))

;;; Load post init

;; Allow for shorter responses: "y" for yes and "n" for no.
(setq read-answer-short t)
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory))))
(setq tramp-backup-directory-alist backup-directory-alist)
(setq backup-by-copying-when-linked t)
(setq backup-by-copying t)  ; Backup by copying rather renaming
(setq delete-old-versions t)  ; Delete excess backup versions silently
(setq version-control t)  ; Use version numbers for backup files
(setq kept-new-versions 5)
(setq kept-old-versions 5)


;; Increase how much is read from processes in a single chunk
(setq read-process-output-max (* 2 1024 1024))  ; 1024kb

(setq process-adaptive-read-buffering nil)

;; Don't ping things that look like domain names.
(setq ffap-machine-p-known 'reject)

(setq warning-minimum-level :error)
(setq warning-suppress-types '((lexical-binding)))


;; In PGTK, this timeout introduces latency. Reducing it from the default 0.1
;; improves responsiveness of childframes and related packages.
(when (boundp 'pgtk-wait-for-event-timeout)
  (setq pgtk-wait-for-event-timeout 0.001))

;; Disable warnings from the legacy advice API. They aren't useful.
(setq ad-redefinition-action 'accept)

(setq default-input-method "Tex")
;; Ensure adding the following compile-angel code at the very beginning
;; of your `~/.emacs.d/post-init.el` file, before all other packages.
(use-package compile-angel
  :ensure t
  :demand t
  :custom
  ;; Set `compile-angel-verbose` to nil to suppress output from compile-angel.
  ;; Drawback: The minibuffer will not display compile-angel's actions.
  (compile-angel-verbose t)

  :config
  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; `use-package', you'll need to explicitly add `(require 'use-package)` at
  ;; the top of your init file.
  ;; (push "/init.el" compile-angel-excluded-path-suffixes)
  ;; (push "/default.el" compile-angel-excluded-path-suffixes)
  ;; (push "/early-init.el" compile-angel-excluded-path-suffixes)
                                        ;  (push "/pre-init.el" compile-angel-excluded-files)
                                        ; (push "/post-init.el" compile-angel-excluded-files)
                                        ;(push "/pre-early-init.el" compile-angel-excluded-files)
                                        ;(push "/post-early-init.el" compile-angel-excluded-files)

  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files before they are loaded.
  (compile-angel-on-load-mode))

;;My themeing
(mapc #'disable-theme custom-enabled-themes)  ; Disable all active themes


(setq default-input-method "Tex")
;; Ensure adding the following compile-angel code at the very beginning
;; of your `~/.emacs.d/post-init.el` file, before all other packages.
(use-package compile-angel
  :ensure t
  :demand t
  :custom
  ;; Set `compile-angel-verbose` to nil to suppress output from compile-angel.
  ;; Drawback: The minibuffer will not display compile-angel's actions.
  (compile-angel-verbose t)

  :config
  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; `use-package', you'll need to explicitly add `(require 'use-package)` at
  ;; the top of your init file.
  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)

  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files before they are loaded.
  (compile-angel-on-load-mode))

;;My themeing
(mapc #'disable-theme custom-enabled-themes)  ; Disable all active themes

;; (use-package neotree
;;   :bind ("C-c C-t" . neotree-toggle))


(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; for treemacs users
  (doom-themes-treemacs-theme "doom-tokyo-night")

  :config
  (add-to-list 'default-frame-alist '(alpha-background . 95))

  (defgroup doom-tokyo-dark-theme nil
    "Options for doom-themes"
    :group 'doom-themes)

  (defcustom doom-tokyo-dark-brighter-modeline nil
    "If non-nil, more vivid colors will be used to style the mode-line."
    :group 'doom-tokyo-dark-theme
    :type 'boolean)

  (defcustom doom-tokyo-dark-brighter-comments nil
    "If non-nil, comments will be highlighted in more vivid colors."
    :group 'doom-tokyo-dark-theme
    :type 'boolean)

  (defcustom doom-tokyo-dark-comment-bg doom-tokyo-dark-brighter-comments
    "If non-nil, comments will have a subtle, darker background. Enhancing their legibility."
    :group 'doom-tokyo-dark-theme
    :type 'boolean)

  (defcustom doom-tokyo-dark-padded-modeline nil
    "If non-nil, adds a 4px padding to the mode-line. Can be an integer to determine the exact padding."
    :group 'doom-tokyo-dark-theme
    :type '(choice integer boolean))

  (def-doom-theme doom-tokyo-dark
      "A clean, dark theme that celebrates the lights of downtown Tokyo at night, combined with Base16-Stylix backgrounds."

    ;; name         default   256       16
    ((bg         '("#11121d" nil       nil            ))
     (bg-alt     '("#1a1b2a" nil       nil            ))
     (base0      '("#2f3549" "#2f3549" "black"        ))
     (base1      '("#444b6a" "#444b6a" "brightblack"  ))
     (base2      '("#535977" "#535977" "brightblack"  ))
     (base3      '("#656b88" "#656b88" "brightblack"  ))
     (base4      '("#787c99" "#787c99" "brightblack"  ))
     (base5      '("#9099c0" "#9099c0" "brightblack"  ))
     (base6      '("#a0aad2" "#a0aad2" "brightblack"  ))
     (base7      '("#b0bae3" "#b0bae3" "brightblack"  ))
     (base8      '("#c0caf5" "#c0caf5" "white"        ))
     (fg-alt     '("#c0caf5" "#c0caf5" "brightwhite"  ))
     (fg         '("#a9b1d6" "#a9b1d6" "white"        ))

     (grey       base4)
     (red        '("#f7768e" "#f7768e" "red"          ))
     (orange     '("#ff9e64" "#ff9e64" "brightred"    ))
     (green      '("#73daca" "#73daca" "green"        ))
     (teal       '("#2ac3de" "#2ac3de" "brightgreen"  ))
     (yellow     '("#e0af68" "#e0af68" "yellow"       ))
     (blue       '("#7aa2f7" "#7aa2f7" "brightblue"   ))
     (dark-blue  '("#565f89" "#565f89" "blue"         ))
     (magenta    '("#bb9af7" "#bb9af7" "magenta"      ))
     (violet     '("#9aa5ce" "#9aa5ce" "brightmagenta"))
     (cyan       '("#b4f9f8" "#b4f9f8" "brightcyan"   ))
     (dark-cyan  '("#7dcfff" "#7dcfff" "cyan"         ))
     ;; Additional custom colors
     (dark-green '("#9ece6a" "#9ece6a" "green"        ))
     (brown      '("#cfc9c2" "#cfc9c2" "yellow"       ))

     ;; face categories -- required for all themes
     (highlight      cyan)
     (vertical-bar   (doom-lighten bg 0.05))
     (selection      base0)
     (builtin        red)
     (comments       (if doom-tokyo-dark-brighter-comments base5 base1))
     (doc-comments   (doom-lighten (if doom-tokyo-dark-brighter-comments base5 base1) 0.25))
     (constants      orange)
     (functions      blue)
     (keywords       magenta)
     (methods        blue)
     (operators      dark-cyan)
     (type           base8)
     (strings        dark-green)
     (variables      base8)
     (numbers        orange)
     (region         base0)
     (error          red)
     (warning        yellow)
     (success        green)
     (vc-modified    orange)
     (vc-added       green)
     (vc-deleted     red)

     ;; custom categories
     (hidden      `(,(car bg) "black" "black"))
     (-modeline-bright doom-tokyo-dark-brighter-modeline)
     (-modeline-pad
      (when doom-tokyo-dark-padded-modeline
        (if (integerp doom-tokyo-dark-padded-modeline) doom-tokyo-dark-padded-modeline 4)))

     (modeline-fg     'unspecified)
     (modeline-fg-alt base5)

     (modeline-bg
      (if -modeline-bright
          base3
        `(,(doom-darken (car bg) 0.15) ,@(cdr base0))))
     (modeline-bg-l
      (if -modeline-bright
          base3
        `(,(doom-darken (car bg) 0.1) ,@(cdr base0))))
     (modeline-bg-inactive   (doom-darken bg 0.1))
     (modeline-bg-inactive-l `(,(car bg) ,@(cdr base1))))


    ;; --- Extra Faces ------------------------
    (
     ((line-number-current-line &override) :foreground base8)
     ((line-number &override) :foreground comments :background (doom-darken bg 0.025))

     (font-lock-comment-face
      :foreground comments
      :background (if doom-tokyo-dark-comment-bg (doom-lighten bg 0.05) 'unspecified))
     (font-lock-doc-face
      :inherit 'font-lock-comment-face
      :foreground doc-comments)

   ;;; Doom Modeline
     (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
     (doom-modeline-buffer-path :foreground base8 :weight 'normal)
     (doom-modeline-buffer-file :foreground brown :weight 'normal)

     (mode-line
      :background modeline-bg :foreground modeline-fg
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
     (mode-line-inactive
      :background modeline-bg-inactive :foreground modeline-fg-alt
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
     (mode-line-emphasis
      :foreground (if -modeline-bright base8 highlight))
     (mode-line-buffer-id
      :foreground highlight)

   ;;; Indentation
     (whitespace-indentation :background bg)
     (whitespace-tab :background bg)

   ;;; Ivy
     (ivy-subdir :foreground blue)
     (ivy-minibuffer-match-face-1 :foreground green :background bg-alt)
     (ivy-minibuffer-match-face-2 :foreground orange :background bg-alt)
     (ivy-minibuffer-match-face-3 :foreground red :background bg-alt)
     (ivy-minibuffer-match-face-4 :foreground yellow :background bg-alt)

   ;;; Elscreen
     (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")

   ;;; Solaire
     (solaire-mode-line-face
      :inherit 'mode-line
      :background modeline-bg-l
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
     (solaire-mode-line-inactive-face
      :inherit 'mode-line-inactive
      :background modeline-bg-inactive-l
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))

   ;;; Telephone
     (telephone-line-accent-active
      :inherit 'mode-line
      :background (doom-lighten bg 0.2))
     (telephone-line-accent-inactive
      :inherit 'mode-line
      :background (doom-lighten bg 0.05))
     (telephone-line-evil-emacs
      :inherit 'mode-line
      :background dark-blue)

   ;;;; rainbow-delimiters
     (rainbow-delimiters-depth-1-face :foreground fg)
     (rainbow-delimiters-depth-2-face :foreground blue)
     (rainbow-delimiters-depth-3-face :foreground orange)
     (rainbow-delimiters-depth-4-face :foreground green)
     (rainbow-delimiters-depth-5-face :foreground cyan)
     (rainbow-delimiters-depth-6-face :foreground yellow)
     (rainbow-delimiters-depth-7-face :foreground teal)

   ;;; Treemacs
     (treemacs-root-face :foreground magenta :weight 'bold :height 1.2)
     (doom-themes-treemacs-root-face :foreground magenta :weight 'ultra-bold :height 1.2)
     (doom-themes-treemacs-file-face :foreground fg-alt)
     (treemacs-directory-face :foreground base8)
     (treemacs-file-face :foreground fg)
     (treemacs-git-modified-face :foreground green)
     (treemacs-git-renamed-face :foreground yellow)

   ;;; Magit
     (magit-section-heading :foreground blue)
     (magit-branch-remote   :foreground orange)
     (magit-diff-our :foreground (doom-darken red 0.2) :background (doom-darken red 0.7))
     (magit-diff-our-highlight :foreground red :background (doom-darken red 0.5) :weight 'bold)
     (magit-diff-removed :foreground (doom-darken red 0.2) :background (doom-darken red 0.7))
     (magit-diff-removed-highlight :foreground red :background (doom-darken red 0.5) :weight 'bold)

     ;; --- Major-Mode Faces -------------------
   ;;; elisp
     (highlight-quoted-symbol :foreground yellow)

   ;;; js2-mode
     (js2-function-param :foreground yellow)
     (js2-object-property :foreground green)

   ;;; typescript-mode
     (typescript-this-face :foreground red)
     (typescript-access-modifier-face :foreground brown)

   ;;; rjsx-mode
     (rjsx-tag :foreground red)
     (rjsx-text :foreground violet)
     (rjsx-attr :foreground magenta :slant 'italic :weight 'medium)
     (rjsx-tag-bracket-face :foreground (doom-darken red 0.3))

   ;;; css-mode / scss-mode
     (css-property              :foreground blue)
     (css-selector              :foreground teal)
     (css-pseudo-class          :foreground orange)

   ;;; markdown-mode
     (markdown-markup-face :foreground violet)
     (markdown-header-face :inherit 'bold :foreground dark-cyan)
     (markdown-blockquote-face :foreground violet :background (doom-lighten bg 0.04))
     (markdown-table-face :foreground violet :background (doom-lighten bg 0.04))
     ((markdown-code-face &override) :foreground dark-cyan :background (doom-lighten bg 0.04))

   ;;; org-mode
     (org-hide :foreground hidden)
     (org-block :background (doom-darken base2 0.65))
     (org-block-begin-line :background (doom-darken base2 0.65) :foreground comments :extend t)
     (solaire-org-hide-face :foreground hidden)

   ;;; web-mode
     (web-mode-json-context-face :foreground brown)
     (web-mode-json-key-face :foreground teal)
   ;;;; Block
     (web-mode-block-delimiter-face :foreground yellow)
   ;;;; Code
     (web-mode-constant-face :foreground constants)
     (web-mode-variable-name-face :foreground variables)
   ;;;; CSS
     (web-mode-css-pseudo-class-face :foreground orange)
     (web-mode-css-property-name-face :foreground blue)
     (web-mode-css-selector-face :foreground teal)
     (web-mode-css-function-face :foreground yellow)
   ;;;; HTML
     (web-mode-html-attr-engine-face :foreground yellow)
     (web-mode-html-attr-equal-face :foreground operators)
     (web-mode-html-attr-name-face :foreground magenta)
     (web-mode-html-tag-bracket-face :foreground (doom-darken red 0.3))
     (web-mode-html-tag-face :foreground red))

    ;; --- extra variables ---------------------
    ;; ()
    )

  (enable-theme 'doom-tokyo-dark)
  ;; (load-theme 'doom-tokyo-night t)

  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


(use-package base16-theme
  :ensure t
  :defer t
  )

(use-package catppuccin-theme
  :ensure t
  :defer t
  :config
  (setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
  ;; (load-theme 'catppuccin :no-confirm)
  ;; (catppuccin-reload)
  )


(use-package  solaire-mode
  :ensure t
  :config
  ;; (add-to-list 'solaire-mode-themes-to-face-swap "doom-tokyo-night")
  :custom
  (solaire-global-mode +1)
  )
;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(add-hook 'after-init-hook #'global-auto-revert-mode)

;; recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(add-hook 'after-init-hook #'(lambda()
                               (let ((inhibit-message t))
                                 (recentf-mode 1))))

(with-eval-after-load "recentf"
  (add-hook 'kill-emacs-hook #'recentf-cleanup))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(add-hook 'after-init-hook #'savehist-mode)

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(add-hook 'after-init-hook #'save-place-mode)

;; When auto-save-visited-mode is enabled, Emacs will auto-save file-visiting
;; buffers after a certain amount of idle time if the user forgets to save it
;; with save-buffer or C-x s for example.
;;
;; This is different from auto-save-mode: auto-save-mode periodically saves
;; all modified buffers, creating backup files, including those not associated
;; with a file, while auto-save-visited-mode only saves file-visiting buffers
;; after a period of idle time, directly saving to the file itself without
;; creating backup files.
(setq auto-save-visited-interval 5)   ; Save after 5 seconds if inactivity
(auto-save-visited-mode 1)


(setq split-width-threshold 120)
(setq split-height-threshold nil)

(use-package eldoc
  :ensure t
  :defer t
  )

(use-package eldoc-box
  :ensure t
  :hook (eldoc-mode . eldoc-box-hover-at-point-mode)
  )

;; Corfu enhances in-buffer completion by displaying a compact popup with
;; current candidates, positioned either below or above the point. Candidates
;; can be selected by navigating up or down.
(use-package corfu
  :custom
  (corfu-auto t)               ;; Enable auto completion
  (corfu-preselect 'directory) ;; Select the first candidate, except for directories

  :ensure t
  ;; :custom
  :commands (corfu-mode global-corfu-mode)
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))
  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)

  (corfu-popupinfo-delay '(0.5 . 0.25))
  (corfu-popupinfo-max-height 30)
  ;; Enable Corfu
  :config
  ;; Free the RET key for less intrusive behavior.
  (keymap-unset corfu-map "RET")
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (keymap-set corfu-map "M-q" #'corfu-quick-complete)
  (keymap-set corfu-map "C-q" #'corfu-quick-insert)
  (corfu-history-mode)
  )

;; Cape, or Completion At Point Extensions, extends the capabilities of
;; in-buffer completion. It integrates with Corfu or the default completion UI,
;; by providing additional backends through completion-at-point-functions.
(use-package cape
  :ensure t
  :commands (cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

;; Vertico provides a vertical completion interface, making it easier to
;; navigate and select from completion candidates (e.g., when `M-x` is pressed).
(use-package vertico
  ;; (Note: It is recommended to also enable the savehist package.)
  :ensure t
  :config
  (vertico-mode))


;; Vertico leverages Orderless' flexible matching capabilities, allowing users
;; to input multiple patterns separated by spaces, which Orderless then
;; matches in any order against the candidates.
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring



;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
;; In addition to that, Marginalia also enhances Vertico by adding rich
;; annotations to the completion candidates displayed in Vertico's interface.
(use-package marginalia
  :ensure t
  :commands (marginalia-mode marginalia-cycle)
  ;; :init
  ;; :defer t
  ;; (marginalia-mode))
  :hook (after-init . marginalia-mode))

;; Embark integrates with Consult and Vertico to provide context-sensitive
;; actions and quick access to commands based on the current selection, further
;; improving user efficiency and workflow within Emacs. Together, they create a
;; cohesive and powerful environment for managing completions and interactions.
(use-package embark
  ;; Embark is an Emacs package that acts like a context menu, allowing
  ;; users to perform context-sensitive actions on selected items
  ;; directly from the completion interface.
  :ensure t
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Consult offers a suite of commands for efficient searching, previewing, and
;; interacting with buffers, file contents, and more, improving various tasks.
(use-package consult
  :ensure t
  :bind (;; C-c bindings in x`mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("C-s" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Aggressive asynchronous that yield instantaneous results. (suitable for
  ;; high-performance systems.) Note: Minad, the author of Consult, does not
  ;; recommend aggressive values.
  ;; Read: https://github.com/minad/consult/discussions/951
  ;;
  ;; immediate feedback from Consult.
  (setq consult-async-input-debounce 0.02
        consult-async-input-throttle 0.05
        consult-async-refresh-delay 0.02)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   ;; consult--source-bookmark consult--source-file-register
   ;; consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

;; The built-in outline-minor-mode provides structured code folding in modes
;; such as Emacs Lisp and Python, allowing users to collapse and expand sections
;; based on headings or indentation levels. This feature enhances navigation and
;; improves the management of large files with hierarchical structures.
(use-package outline-indent
  :ensure t
  :commands outline-indent-minor-mode

  :custom
  (outline-indent-ellipsis " ▼ ")

  :init
  ;; The minor mode can also be automatically activated for a certain modes.
  (add-hook 'python-mode-hook #'outline-indent-minor-mode)
  (add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)

  (add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
  (add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode))


;; The stripspace Emacs package provides stripspace-local-mode, a minor mode
;; that automatically removes trailing whitespace and blank lines at the end of
;; the buffer when saving.
(use-package stripspace
  :ensure t
  :commands stripspace-local-mode

  ;; Enable for prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode))

  :custom
  ;; The `stripspace-only-if-initially-clean' option:
  ;; - nil to always delete trailing whitespace.
  ;; - Non-nil to only delete whitespace when the buffer is clean initially.
  ;; (The initial cleanliness check is performed when `stripspace-local-mode'
  ;; is enabled.)
  (stripspace-only-if-initially-clean nil)

  ;; Enabling `stripspace-restore-column' preserves the cursor's column position
  ;; even after stripping spaces. This is useful in scenarios where you add
  ;; extra spaces and then save the file. Although the spaces are removed in the
  ;; saved file, the cursor remains in the same position, ensuring a consistent
  ;; editing experience without affecting cursor placement.
  (stripspace-restore-column t))

;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu
  :ensure t
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :config
  (global-unset-key (kbd "C-z")))


;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
;; (use-package undo-fu-session
;;   :ensure t
;;   :hook (after-init . undo-fu-session-global-mode))
(use-package undo-fu-session
  :ensure t
  :init
  (undo-fu-session-global-mode))

;; Give Emacs sessions-bar a style similar to Vim's
(use-package vim-tab-bar
  :ensure t
  :commands vim-tab-bar-mode
  :hook (after-init . vim-tab-bar-mode))

(use-package ox-gfm
  :ensure t
  :init
  (eval-after-load "org"
    '(require 'ox-gfm nil t)))

;; (use-package olivetti
;;   :ensure t
;;   :custom
;;   (olivetti-body-width 86)
;;   :config
;;   (setq olivetti-style t))

(use-package org-modern-indent
  ;;:vc (:url "https://github.com/jdtsmith/org-modern-indent"   :rev :newest)
  :ensure t
  :hook org-mode)

(use-package org-bullets-mode
  :ensure org-bullets
  :config
  (setq org-bullets-bullet-list '("◉"))
  :hook org-mode)

;; (use-package org-modern
;;                  :ensure t
;;                  :custom
;;                  (org-modern-hide-stars nil)		; adds extra indentation
;;                  (org-modern-table nil)
;;                  (org-modern-list
;;                   '(;; (?- . "-")
;;                     (?* . "•")
;;                     (?+ . "‣")))
;;                  :config
;;                  (setq
;;                   org-auto-align-tags t
;;                   org-tags-column 0
;;                   org-fold-catch-invisible-edits 'show-and-error
;;                   org-special-ctrl-a/e t
;;                   org-insert-heading-respect-content t
;;
;;                   ;; ;; Don't style the following
;;                   ;; org-modern-tag nil
;;                   ;; org-modern-priority nil
;;                   ;; org-modern-todo nil
;;                   ;; org-modern-table nil
;;
;;                   ;; Agenda styling
;;                   org-agenda-tags-column 0
;;                   org-agenda-block-separator ?─
;;                   org-agenda-time-grid
;;                   '((daily today require-timed)
;; 	                (800 1000 1200 1400 1600 1800 2000)
;; 	                " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
;;                   org-agenda-current-time-string
;;                   "⭠ now ─────────────────────────────────────────────────")
;;                  :hook
;;                  (org-mode . org-modern-mode)
;;                  (org-agenda-finalize . org-modern-agenda)
;;                  (org-mode . global-org-modern-mode))

(use-package org-appear
  :ensure t
  :commands (org-appear-mode)
  :hook     (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t)  ;; Must be activated for org-appear to work
  (setq org-appear-autoemphasis   t   ;; Show bold, italics, verbatim, etc.
        org-appear-autolinks      t   ;; Show links
        org-appear-autosubmarkers t)) ;; Show sub- and superscripts

(use-package org-fragtog
  :ensure t

  :after org
  :hook (org-mode . org-fragtog-mode))

(use-package engrave-faces
  :ensure t
  :after ox-latex
  :init
  (setq org-latex-src-block-backend 'engraved
        ;; org-latex-engraved-theme 'doom-tokyo-night))
        ))

(use-package org-attach-screenshot
  :ensure t
  :bind ("C-c C-x s" . org-attach-screenshot)
  :config (setq org-attach-screenshot-dirfunction
		(lambda ()
		  (progn (cl-assert (buffer-file-name))
			 (concat (file-name-sans-extension (buffer-file-name))
				 "-att")))
		org-attach-screenshot-command-line "spectacle -o %f"))

;; (use-package org-sidebar
;;   :vc (:url "https://github.com/alphapapa/org-sidebar"   :rev :newest)
;;   ;; :straight (:type git :host github :repo "alphapapa/org-sidebar")
;;   :ensure t
;;   )

;; org mode is a major mode designed for organizing notes, planning, task
;; management, and authoring documents using plain text with a simple and
;; expressive markup syntax. It supports hierarchical outlines, TODO lists,
;; scheduling, deadlines, time tracking, and exporting to multiple formats
;; including HTML, LaTeX, PDF, and Markdown.
(use-package org
  :ensure t
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)
  :hook
  (org-mode . visual-line-mode)
  ;; (org-mode . olivetti-mode)
  (org-mode . org-indent-mode)
  ;; (org-mode . org-modern-indent-mode)

  :config
  (setopt org-directory "~/Org/")
  ;; lualatex setup from https://stackoverflow.com/questions/41568410/configure-org-mode-to-use-lualatex
  (setopt org-babel-latex-preamble
          (lambda (_)
            "\\documentclass[tikz]{standalone}"))

  (setopt org-latex-create-formula-image-program 'dvisvgm)
  (org-babel-do-load-languages 'org-babel-load-languages '((latex . t)))
  (setopt org-babel-latex-pdf-svg-process "pdf2svg %F %O")

  (setopt org-latex-pdf-process
          '("lualatex --shell-escape -interaction=nonstopmode -output-directory=%o %f"
            "biber %b"
            ;; "latexmk  -shell-escape -f -pdf -%latex -interaction=nonstopmode -output-directory=%o %f"
            "lualatex --shell-escape -interaction=nonstopmode -output-directory=%o %f"
            "lualatex --shell-escape -interaction=nonstopmode -output-directory=%o %f"))
  ;; (setopt org-latex-pdf-process
  ;;       '("lualatex -pdflatex=-shell-escape -interaction nonstopmode %f"
  ;;         "lualatex -shell-escape -interaction nonstopmode %f"))

  (setopt luasvg '(luasvg :programs ("dvilualatex""dvisvgm") :description "dvi > svg" :message
                          "you need to install the programs: lualatex and dvisvgm."
                          :image-input-type "dvi" :image-output-type "svg" :image-size-adjust
                          (1.7 . 1.5) :latex-compiler
                          ("dvilualatex -interaction nonstopmode -output-directory %o %f")
                          :image-converter
                          ("dvisvgm %f --no-fonts --exact-bbox --scale=%S --output=%O")))

  (add-to-list 'org-preview-latex-process-alist luasvg)
  (setopt org-preview-latex-default-process 'luasvg)
  (require 'ox-latex)
  ;; (add-to-list 'org-latex-packages-alist '("" "minted" nil))
  (setopt org-latex-minted-options
          '(("frame" "leftline")
            ("linenos" "true")
            ("numberblanklines" "false")
            ("showspaces" "false")
            ("breaklines" "true")
            ("bgcolor" "{CtpMantle}")
            ))
  (setq org-latex-src-block-backend 'minted)
  ;; (setopt org-latex-engraved-options
  ;;         '(("frame" "leftline")
  ;;           ("linenos" "true")
  ;;           ("numberblanklines" "false")
  ;;           ("showspaces" "false")
  ;;           ("breaklines" "true")
  ;;           ))
  (setopt org-latex-src-block-backend 'engraved)
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :weight bold :height 1.8))))
   '(org-level-2 ((t (:inherit outline-2 :weight bold :height 1.7))))
   '(org-level-3 ((t (:inherit outline-3 :weight bold :height 1.5))))
   '(org-level-4 ((t (:inherit outline-4 :weight bold :height 1.4))))
   '(org-level-5 ((t (:inherit outline-5 :weight bold :height 1.3))))
   '(org-level-6 ((t (:inherit outline-6 :weight bold :height 1.2))))
   '(org-level-7 ((t (:inherit outline-7 :weight bold :height 1.1))))
   '(org-level-8 ((t (:inherit outline-8 :weight bold :height 1.0))))
   '(org-todo ((t (:weight bold))))
   )

  (setopt org-todo-keywords
          '((sequence "TODO(t)" "|" "DONE(d)")
            (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
            (sequence "|" "CANCELED(c)")))

  (setopt org-publish-project-alist
          '(
            ("org-notes"
             :base-directory "~/Org/"
             :publishing-function org-html-publish-to-html
             :publishing-directory "~/Org/public"
             ;; :section-numbers nil
             ;; :with-toc nil
             :recursive "t")
            ;; :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/.tufte.css\" /><link rel=\"stylesheet\" type=\"text/css\" href=\"css/.srctufte.css\"/><link rel=\"stylesheet\" type=\"text/css\" href=\"css/.style.css\" />")
            ;; :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"~/Org/.style.css\" />"))
            ("org-static"
             :base-directory "~/Org/css/"
             :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory "~/Org/public"
             :recursive t
             :publishing-function org-publish-attachment
             )
            ("org" :components ("org-notes" "org-static")))
          )

  ;; (add-to-list 'org-latex-packages-alist '("" "xcolor" nil))
  (add-to-list 'org-latex-packages-alist '("" "fvextra" nil))
  (add-to-list 'org-latex-packages-alist '("" "upquote" nil))
  (add-to-list 'org-latex-packages-alist '("" "booktabs" nil))

  ;; (add-to-list 'org-latex-packages-alist '("" "lineno" nil))

  ;; (add-to-list 'org-latex-packages-alist '("" "hyperref" nil))
  ;; (add-to-list 'org-latex-packages-alist '("" "geometry" nil))
  ;; (customize-set-variable 'org-format-latex-header
  ;;                         (concat org-format-latex-header "\n\\setlength{\\parindent}{0pt}\n\\hypersetup{colorlinks=false, hidelinks=true}\n\\newgeometry{vmargin={15mm}, hmargin={17mm,17mm}}"))

  (defun org-html--format-image (source attributes info) ;base64 encodes images on export to HTML
    (format "<img src=\"data:image/%s;base64,%s\"%s />"
            (or (file-name-extension source) "")
            (base64-encode-string
             (with-temp-buffer
	       (insert-file-contents-literally source)
	       (buffer-string)))
            (file-name-nondirectory source)))
  :custom
  (org-preview-latex-default-process 'luasvg)
  (org-hide-leading-stars t)
  (org-html-validation-link nil)
  (org-startup-indented t)
  (org-edit-src-content-indentation 0)
  (org-link-search-must-match-exact-headline nil)
  (org-fontify-done-headline t)
  (org-fontify-todo-headline t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t)
  (org-latex-compiler "lualatex")
  (org-adapt-indentation t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-agenda-tags-column 0)
  (org-ellipsis "…")
  (org-latex-tables-booktabs t)
  (org-footnote-auto-adjust t)
  (org-lowest-priority ?F "Gives us priorities A through F")  ;;Gives us priorities A through F
  (org-default-priority ?E "If an item has no priority, it is considered [#E]") ;; If an item has no priority, it is considered [#E].


  (org-priority-faces
   (quote ((?A :background "#1a1b26"
               :foreground "#bb9af7"
               :weight bold
               )
           (?B :background "#1a1b26"
               :foreground "#7aa2f7"
               :weight bold)
           (?C :background "#1a1b26"
               :foreground "#7dcfff"
               :weight bold)))))

(defun org-show-todo-tree ()
  "Create new indirect buffer with sparse tree of undone TODO items."
  (interactive)
  (clone-indirect-buffer "*org TODO undone*" t)
  (org-show-todo-tree nil)
  (org-remove-occur-highlights))

(use-package citeproc
  :ensure t
  :defer t
  )


(use-package htmlize
  :ensure t
  :defer t)

;; The markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).
(use-package markdown-mode
  :ensure t
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :init
  (setq markdown-command "multimarkdown")

  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))

;; Tree-sitter in Emacs is an incremental parsing system introduced in Emacs 29
;; that provides precise, high-performance syntax highlighting. It supports a
;; broad set of programming languages, including Bash, C, C++, C#, CMake, CSS,
;; Dockerfile, Go, Java, JavaScript, JSON, Python, Rust, TOML, TypeScript, YAML,
;; Elisp, Lua, Markdown, and many others.
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  ;; (delete 'cpp treesit-auto-langs)
  ;; (delete 'c treesit-auto-langs)
  ;; (treesit-auto-add-to-auto-mode-alist '((awk bash bibtex blueprint c cpp c-sharp clojure cmake commonlisp css dart
  ;;                                             dockerfile elixir glsl go gomod heex html janet java javascript json julia
  ;;                                             kotlin latex lua magik make markdown nix nu org perl proto python r ruby
  ;;                                             rust scala sql surface toml tsx typescript typst verilog vhdl vue wast wat
  ;;                                             wgsl yaml)))
  (setopt treesit-font-lock-level 4)
  (add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.\\(fs\\|fsx\\|fsscript\\)\\'" . fsharp-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.fsi\\'" . fsharp-ts-signature-mode))

  (treesit-auto-add-to-auto-mode-alist)
  (global-treesit-auto-mode)
  )

;; A file and project explorer for Emacs that displays a structured tree
;; layout, similar to file browsers in modern IDEs. It functions as a sidebar
;; in the left window, providing a persistent view of files, projects, and
;; other elements.
;; (use-package treemacs
;;                  ;; :ensure t
;;                  :elpaca nil
;;                  :commands (treemacs
;;                             treemacs-select-window
;;                             treemacs-delete-other-windows
;;                             treemacs-select-directory
;;                             treemacs-bookmark
;;                             treemacs-find-file
;;                             treemacs-find-tag)
;;
;;                  :bind
;;                  (:map global-map
;;                        ("M-0"       . treemacs-select-window)
;;
;;                        ("C-x t 1"   . treemacs-delete-other-windows)
;;                        ("C-x t t"   . treemacs)
;;                        ("C-x t d"   . treemacs-select-directory)
;;                        ("C-x t B"   . treemacs-bookmark)
;;                        ("C-x t C-t" . treemacs-find-file)
;;                        ("C-x t M-t" . treemacs-find-tag))
;;
;;                  :init
;;                  (with-eval-after-load 'winum
;;                    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
;;
;;                  :config
;;                  (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
;;                        treemacs-deferred-git-apply-delay        0.5
;;                        treemacs-directory-name-transformer      #'identity
;;                        treemacs-display-in-side-window          t
;;                        treemacs-eldoc-display                   'simple
;;                        treemacs-file-event-delay                2000
;;                        treemacs-file-extension-regex            treemacs-last-period-regex-value
;;                        treemacs-file-follow-delay               0.2
;;                        treemacs-file-name-transformer           #'identity
;;                        treemacs-follow-after-init               t
;;                        treemacs-expand-after-init               t
;;                        treemacs-find-workspace-method           'find-for-file-or-pick-first
;;                        treemacs-git-command-pipe                ""
;;                        treemacs-goto-tag-strategy               'refetch-index
;;                        treemacs-header-scroll-indicators        '(nil . "^^^^^^")
;;                        treemacs-hide-dot-git-directory          t
;;                        treemacs-indentation                     2
;;                        treemacs-indentation-string              " "
;;                        treemacs-is-never-other-window           nil
;;                        treemacs-max-git-entries                 5000
;;                        treemacs-missing-project-action          'ask
;;                        treemacs-move-files-by-mouse-dragging    t
;;                        treemacs-move-forward-on-expand          nil
;;                        treemacs-no-png-images                   nil
;;                        treemacs-no-delete-other-windows         t
;;                        treemacs-project-follow-cleanup          nil
;;                        treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
;;                        treemacs-position                        'left
;;                        treemacs-read-string-input               'from-child-frame
;;                        treemacs-recenter-distance               0.1
;;                        treemacs-recenter-after-file-follow      nil
;;                        treemacs-recenter-after-tag-follow       nil
;;                        treemacs-recenter-after-project-jump     'always
;;                        treemacs-recenter-after-project-expand   'on-distance
;;                        treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
;;                        treemacs-project-follow-into-home        nil
;;                        treemacs-show-cursor                     nil
;;                        treemacs-show-hidden-files               t
;;                        treemacs-silent-filewatch                nil
;;                        treemacs-silent-refresh                  nil
;;                        treemacs-sorting                         'alphabetic-asc
;;                        treemacs-select-when-already-in-treemacs 'move-back
;;                        treemacs-space-between-root-nodes        t
;;                        treemacs-tag-follow-cleanup              t
;;                        treemacs-tag-follow-delay                1.5
;;                        treemacs-text-scale                      nil
;;                        treemacs-user-mode-line-format           nil
;;                        treemacs-user-header-line-format         nil
;;                        treemacs-wide-toggle-width               70
;;                        treemacs-width                           35
;;                        treemacs-width-increment                 1
;;                        treemacs-width-is-initially-locked       t
;;                        treemacs-workspace-switch-cleanup        nil)
;;
;;                  ;; The default width and height of the icons is 22 pixels. If you are
;;                  ;; using a Hi-DPI display, uncomment this to double the icon size.
;;                  ;; (treemacs-resize-icons 44)
;;
;;                  (treemacs-follow-mode t)
;;                  (treemacs-filewatch-mode t)
;;                  (treemacs-fringe-indicator-mode 'always)
;;
;;                  ;;(when treemacs-python-executable
;;                  ;;  (treemacs-git-commit-diff-mode t))
;;
;;                  (pcase (cons (not (null (executable-find "git")))
;;                               (not (null treemacs-python-executable)))
;;                    (`(t . t)
;;                     (treemacs-git-mode 'deferred))
;;                    (`(t . _)
;;                     (treemacs-git-mode 'simple)))
;;
;;                  (treemacs-hide-gitignored-files-mode nil))


(use-package ispell
  :ensure nil
  :commands (ispell ispell-minor-mode)
  :config
  ;; NOTE: Fix for [https://github.com/nixos/nixpkgs/issues/476684]
  (setenv "ASPELL_CONF" (concat "data-dir " "/etc/profiles/per-user/bones/lib/aspell"))
  ;; Set the ispell program name to aspell
  (setq ispell-program-name "aspell")
  ;; (ispell-change-dictionary "english")
  ;; Configures Aspell's suggestion mode to "ultra", which provides more
  ;; aggressive and detailed suggestions for misspelled words. The language
  ;; is set to "en_US" for US English, which can be replaced with your desired
  ;; language code (e.g., "en_GB" for British English, "de_DE" for German).

  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_AU")))

;; The flyspell package is a built-in Emacs minor mode that provides
;; on-the-fly spell checking. It highlights misspelled words as you type,
;; offering interactive corrections.
(use-package flyspell
  :ensure nil
  :commands flyspell-mode
  :hook
  ((prog-mode . flyspell-prog-mode)
   (text-mode . ;; (lambda()
              ;; (if (or (derived-mode-p 'yaml-mode)
              ;;         (derived-mode-p 'yaml-ts-mode)
              ;;         (derived-mode-p 'ansible-mode))
              ;;     (flyspell-prog-mode )
              flyspell-mode))
  ;; ))))
  :config
  ;; Remove strings from Flyspell
  (setq flyspell-prog-text-faces (delq 'font-lock-string-face
                                       flyspell-prog-text-faces))

  ;; Remove doc from Flyspell
  (setq flyspell-prog-text-faces (delq 'font-lock-doc-face
                                       flyspell-prog-text-faces)))

;; Apheleia is an Emacs package designed to run code formatters (e.g., Shfmt,
;; Black and Prettier) asynchronously without disrupting the cursor position.
(use-package apheleia
  :ensure t
  :commands (apheleia-mode
             apheleia-global-mode)
  :hook ((prog-mode . apheleia-mode))
  :config
  ;; Replace default (black) to use ruff for sorting import and formatting.
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  ;; turn off apheleia for go mode
  (defun app/lsp-gopls-after-open-hook ()
    (apheleia-mode -1)
    (flycheck-mode -1))
  (add-hook 'lsp-gopls-after-open-hook 'app/lsp-gopls-after-open-hook) ;from https://emacs.stackexchange.com/a/72882
  )

;; Enables automatic indentation of code while typing
(use-package aggressive-indent
  :ensure t
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;; Highlights function and variable definitions in Emacs Lisp mode
(use-package highlight-defined
  :ensure t
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;; Prevent parenthesis imbalance
;; (use-package paredit
;;   :ensure t
;;   :commands paredit-mode
;;   :hook
;;   (emacs-lisp-mode . paredit-mode)
;;   :config
;;   (define-key paredit-mode-map (kbd "RET") nil))

;; Helpful is an alternative to the built-in Emacs help that provides much more
;; contextual information.
(use-package helpful
  :ensure t
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  :custom
  (helpful-max-buffers 7))


;; Configure the `tab-bar-show` variable to 1 to display the tab bar exclusively
;; when multiple tabs are open:
(setopt tab-bar-show 1)

;; Prevent Emacs from saving customization information to a custom file
(setq custom-file null-device)

(use-package nerd-icons
  :ensure t)

;; (use-package fira-code-mode
;;   :custom (fira-code-mode-disabled-ligatures '("[]" "x" "//" "||" "lambda" "or" "and"))  ; ligatures you don't want
;;   :hook (prog-mode org-mode))                                         ; mode to enable fira-code-mode in

(set-face-attribute 'default nil :font "Berkeley Mono 12")


(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures
   'prog-mode
   '(; Group A
     ".." ".=" "..." "..<" "::" ":::" ":=" "::=" ";;" ";;;" "??" "???"
     ".?" "?." ":?" "?:" "?=" "**" "***" "/*" "*/" "/**"
                                        ; Group B
     "<-" "->" "-<" ">-" "<--" "-->" "<<-" "->>" "-<<" ">>-" "<-<" ">->"
     "<-|" "|->" "-|" "|-" "||-" "<!--" "<#--" "<=" "=>" ">=" "<==" "==>"
     "<<=" "=>>" "=<<" ">>=" "<=<" ">=>" "<=|" "|=>" "<=>" "<==>" "||="
     "|=" "//=" "/="
                                        ; Group C
     "<<" ">>" "<<<" ">>>" "<>" "<$" "$>" "<$>" "<+" "+>" "<+>" "<:" ":<"
     "<:<" ">:" ":>" "<~" "~>" "<~>" "<<~" "<~~" "~~>" "~~" "<|" "|>"
     "<|>" "<||" "||>" "<|||" "|||>" "</" "/>" "</>" "<*" "*>" "<*>" ":?>"
                                        ; Group D
     "#(" "#{" "#[" "]#" "#!" "#?" "#=" "#_" "#_(" "##" "###" "####"
                                        ; Group E
     "[|" "|]" "[<" ">]" "{!!" "!!}" "{|" "|}" "{{" "}}" "{{--" "--}}"
     "{!--" "//" "///" "!!"
                                        ; Group F
     "www" "@_" "&&" "&&&" "&=" "~@" "++" "+++" "/\\" "\\/" "_|_" "||"
                                        ; Group G
     "=:" "=:=" "=!=" "==" "===" "=/=" "=~" "~-" "^=" "__" "!=" "!==" "-~"
     "--" "---"))
  (ligature-set-ligatures
   'org-mode
   '(                                        ; Group B
     "<-" "->" "-<" ">-" "<--" "-->" "<<-" "->>" "-<<" ">>-" "<-<" ">->"
     "<-|" "|->" "-|" "|-" "||-" "<!--" "<#--" "<=" "=>" ">=" "<==" "==>"
     "<<=" "=>>" "=<<" ">>=" "<=<" ">=>" "<=|" "|=>" "<=>" "<==>" "||="
     "|=" "//=" "/="
                                        ; Group C
     "<<" ">>" "<<<" ">>>" "<>" "<$" "$>" "<$>" "<+" "+>" "<+>" "<:" ":<"
     "<:<" ">:" ":>" "<~" "~>" "<~>" "<<~" "<~~" "~~>" "~~" "<|" "|>"
     "<|>" "<||" "||>" "<|||" "|||>" "</" "/>" "</>" "<*" "*>" "<*>" ":?>"
                                        ; Group D
     "#(" "#{" "#[" "]#" "#!" "#?" "#=" "#_" "#_(" "##" "###" "####"
                                        ; Group E
     "[|" "|]" "[<" ">]" "{!!" "!!}" "{|" "|}" "{{" "}}" "{{--" "--}}"
     "{!--" "//" "///" "!!"
                                        ; Group F
     "www" "@_" "&&" "&&&" "&=" "~@" "++" "+++" "/\\" "\\/" "_|_" "||"
                                        ; Group G
     "=:" "=:=" "=!=" "==" "===" "=/=" "=~" "~-" "^=" "__" "!=" "!==" "-~"
     "--" "---"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; (set-fontset-font t nil "Fira Code Symbol" nil 'append)


;; Allow Emacs to upgrade built-in packages, such as Org mode
(setq package-install-upgrade-built-in t)

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display of line numbers in the buffer:
;; (setq-default display-line-numbers-type 'relative)
(setq-default display-line-numbers-type 't)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :init (which-key-mode 1)
  :custom
  (which-key-mode)
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
  ;; Enables `pixel-scroll-precision-mode' on all operating systems and Emacs
  ;; versions, except for emacs-mac.
  ;;
  ;; Enabling `pixel-scroll-precision-mode' is unnecessary with emacs-mac, as
  ;; this version of Emacs natively supports smooth scrolling.
  ;; https://bitbucket.org/mituharu/emacs-mac/commits/65c6c96f27afa446df6f9d8eff63f9cc012cc738
  (setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
  (pixel-scroll-precision-mode 1))

;; Display the time in the modeline
(add-hook 'after-init-hook #'display-time-mode)

;; Paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)

;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(add-hook 'after-init-hook #'winner-mode)

;; Replace selected text with typed text
;; (delete-selection-mode 1)

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'reverse)
  (uniquify-separator "•")
  (uniquify-after-kill-buffer-p t))

;; Window dividers separate windows visually. Window dividers are bars that can
;; be dragged with the mouse, thus allowing you to easily resize adjacent
;; windows.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Dividers.html
(add-hook 'after-init-hook #'window-divider-mode)

;; Dired buffers: Automatically hide file details (permissions, size,
;; modification date, etc.) and all the files in the `dired-omit-files' regular
;; expression for a cleaner display.
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Hide files from dired
(setq dired-omit-files (concat "\\`[.]\\'"
                               "\\|\\(?:\\.js\\)?\\.meta\\'"
                               "\\|\\.\\(?:elc|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                               "\\|^\\.DS_Store\\'"
                               "\\|^\\.\\(?:svn\\|git\\)\\'"
                               "\\|^\\.ccls-cache\\'"
                               "\\|^__pycache__\\'"
                               "\\|^\\.project\\(?:ile\\)?\\'"
                               "\\|^flycheck_.*"
                               "\\|^flymake_.*"))
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)

(setq epg-gpg-program "gpg2")
(setenv "GPG_AGENT_INFO" nil)

(setq auth-sources '("~/.authinfo.gpg"))
;; Improve Emacs responsiveness by deferring fontification during input
;;
;; NOTE: This may cause delayed syntax highlighting in certain cases
(setq redisplay-skip-fontification-on-input t)



(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


;; (setq visible-bell t)
(electric-pair-mode)

(use-package transient
  :ensure t)

(use-package magit
  :bind ("C-x g" . magit)
  :after transient
  :ensure t
  :after
  (setq magit-diff-refine-hunk 't)
  )

(use-package forge
  :after magit
  :ensure t)
;; :straight (:host github :repo "magit/forge" :branch "main" ))


(use-package difftastic
  :ensure t
  :demand t
  :bind (:map magit-blame-read-only-mode-map
              ("D" . difftastic-magit-show)
              ("S" . difftastic-magit-show))
  :config
  (eval-after-load 'magit-diff
    '(transient-append-suffix 'magit-diff '(-1 -1)
       [("D" "Difftastic diff (dwim)" difftastic-magit-diff)
        ("S" "Difftastic show" difftastic-magit-show)])))

(use-package magit-delta
  :ensure t
  :after transient
  :hook (magit-mode . magit-delta-mode)
  :config
  (setq magit-delta-delta-args
        `("--syntax-theme" "tokyoNightNight"
          ;; `("--syntax-theme" "Dracula"
          "--max-line-distance" "0.6"
          "--true-color" "always"
          "--color-only")))

(defun myfun/toggle-magit-delta ()
  "Toggle delta in magit."
  (interactive)
  (magit-delta-mode
   (if magit-delta-mode
       -1
     1))
  (magit-refresh))

(with-eval-after-load 'magit
  (transient-append-suffix 'magit-diff '(-1 -1 -1)
    '("D" "Toggle magit-delta" myfun/toggle-magit-delta))) ;Borrowed from https://shivjm.blog/better-magit-diffs/


(use-package hydra
  :ensure t
  :after magit
  :config                               ;From https://github.com/alphapapa/unpackaged.el#smerge-mode
  (defhydra unpackaged/smerge-hydra
    (:color pink :hint nil :post (smerge-auto-leave))
    "
^Move^       ^Keep^               ^Diff^                 ^Other^
^^-----------^^-------------------^^---------------------^^-------
_n_ext       _b_ase               _<_: upper/base        _C_ombine
_p_rev       _u_pper              _=_: upper/lower       _r_esolve
^^           _l_ower              _>_: base/lower        _k_ill current
^^           _a_ll                _R_efine
^^           _RET_: current       _E_diff
"
    ("n" smerge-next)
    ("p" smerge-prev)
    ("b" smerge-keep-base)
    ("u" smerge-keep-upper)
    ("l" smerge-keep-lower)
    ("a" smerge-keep-all)
    ("RET" smerge-keep-current)
    ("\C-m" smerge-keep-current)
    ("<" smerge-diff-base-upper)
    ("=" smerge-diff-upper-lower)
    (">" smerge-diff-base-lower)
    ("R" smerge-refine)
    ("E" smerge-ediff)
    ("C" smerge-combine-with-next)
    ("r" smerge-resolve)
    ("k" smerge-kill-current)
    ("ZZ" (lambda ()
            (interactive)
            (save-buffer)
            (bury-buffer))
     "Save and bury buffer" :color blue)
    ("q" nil "cancel" :color blue))
  :hook (magit-diff-visit-file . (lambda ()
                                   (when smerge-mode
                                     (unpackaged/smerge-hydra/body)))))


(use-package hl-todo
  :ensure t
  :hook (prog-mode . global-hl-todo-mode)
  :config (setq hl-todo-keyword-faces
                '(("TODO"   . nerd-icons-green)
                  ("HACK"  . nerd-icons-orange)
                  ("NOTE" . nerd-icons-maroon)
                  ("FIXME:" . nerd-icons-lred)
                  ("WARN"   . nerd-icons-red)
                  ("HERE"   . nerd-icons-blue-alt)
                  ))
  )

(use-package consult-todo :demand t   :ensure t
  )

(use-package magit-todos
  :ensure t
  :after magit
  :config (magit-todos-mode 1)
  )

(use-package exec-path-from-shell
  :ensure t
  :defer t
  :init
  (setq exec-path-from-shell-arguments nil)
  (exec-path-from-shell-initialize))

;; (use-package company
;;   :defer t
;;   :bind
;;   (:map company-active-map
;;         ("<tab>" . company-complete-selection))
;;   :init
;;   (global-company-mode))

(use-package projectile
  :ensure t
  :defer t
  :init
  (projectile-mode)

  :config
  (setq projectile-auto-cleanup-known-projects t)
  )

(use-package rg
  :ensure t
  :after transient
  :defer t
  :bind (("C-c r" . rg)))


;; (use-package flycheck
;;   :preface
;;
;;   (defun mp-flycheck-eldoc (callback &rest _ignored)
;;     "Print flycheck messages at point by calling CALLBACK."
;;     (when-let ((flycheck-errors (and flycheck-mode (flycheck-overlay-errors-at (point)))))
;;       (mapc
;;        (lambda (err)
;;          (funcall callback
;;                   (format "%s: %s"
;;                           (let ((level (flycheck-error-level err)))
;;                             (pcase level
;;                               ('info (propertize "I" 'face 'flycheck-error-list-info))
;;                               ('error (propertize "E" 'face 'flycheck-error-list-error))
;;                               ('warning (propertize "W" 'face 'flycheck-error-list-warning))
;;                               (_ level)))
;;                           (flycheck-error-message err))
;;                   :thing (or (flycheck-error-id err)
;;                              (flycheck-error-group err))
;;                   :face 'font-lock-doc-face))
;;        flycheck-errors)))
;;
;;   (defun mp-flycheck-prefer-eldoc ()
;;     (add-hook 'eldoc-documentation-functions #'mp-flycheck-eldoc nil t)
;;     (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
;;     (setq flycheck-display-errors-function nil)
;;     (setq flycheck-help-echo-function nil))
;;
;;   :hook ((flycheck-mode . mp-flycheck-prefer-eldoc))
;;   :defer t
;;   :hook (after-init . global-flycheck-mode)
;;
;;   :config
;;   (setq flycheck-highlighting-mode "lines")
;;   (setq lsp-diagnostics-provider :none)
;;   )
;;
;;
;; (use-package flycheck-inline
;;   :after flycheck
;;   :hook (flycheck-mode . flycheck-inline-mode))

(use-package flymake
  :ensure t
  :defer t
  )

(use-package flymake-ruff
  :ensure t
  :hook (python-ts-mode . flymake-ruff-load))

(use-package scad-mode
  :ensure t)

;; (use-package scad-preview
;;   :after scad-mode
;;   :ensure t
;;   ;; :straight (:host github :repo "zk-phi/scad-preview" :branch "master")
;;   :vc (:url "https://github.com/zk-phi/scad-preview"   :rev :newest)
;;
;;   )
;;
;; (use-package scad-dbus
;;   :after scad-mode
;;   :ensure t
;;   ;; :straight (:host github :repo "Lenbok/scad-dbus" :branch "master")
;;   :vc (:url "https://github.com/Lenbok/scad-dbus"   :rev :newest)
;;
;;   :bind (:map scad-mode-map ("C-c o" . 'hydra-scad-dbus/body)))

;; ;; LSP setup from https://emacs-lsp.github.io/lsp-mode/page/installation/
;; (use-package lsp-mode
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")
;;   (setq lsp-completion-provider :none)
;;   :ensure t
;;   :hook(
;;         ;; (python-mode . lsp-deferred)
;;         (python-ts-mode . lsp-deferred)
;;         (nix-mode . lsp-deferred)
;;         (c-mode . lsp-deferred)
;;         (c++-mode . lsp-deferred)
;;         (scad-mode . lsp-deferred)
;;         (go-mode . lsp-deferred)
;;         (go-ts-mode . lsp-deferred)
;;         (ada-mode . lsp-deferred)
;;         (ada-ts-mode . lsp-deferred)
;;
;;         ;; Add more major modes here
;;         (lsp-mode . lsp-enable-which-key-integration))
;;   :config
;;   ;; python configuration
;;   (setq lsp-disabled-clients '(pylsp pyright))
;;
;;   ;; end python configuration
;;
;;   :commands  (lsp lsp-deferred))
;;
;; ;; (use-package lsp-pyright
;; ;;   :ensure t
;; ;;   :custom (lsp-pyright-langserver-command "basedpyright") ;; or pyright
;; ;;   :hook ((python-mode python-ts-mode) . (lambda ()
;; ;;                                           (require 'lsp-pyright)
;; ;;                                           (lsp-deferred))))  ; or lsp
;;
;; (use-package lsp-ui
;;   :defer t
;;   :after lsp-mode
;;   :bind (("C-c c l f" . lsp-ui-doc-focus-frame)
;;          ("C-c c l u" . lsp-ui-doc-unfocus-frame))
;;   ;;:commands lsp-ui-mode                 ;
;;
;;   :config
;;   (lsp-ui-peek-mode)
;;   (setq lsp-ui-doc-enable t
;;         lsp-ui-doc-header t
;;         lsp-ui-imenu t
;;         lsp-ui-doc-include-signature t
;;         lsp-ui-doc-show-with-cursor t
;;         lsp-ui-doc-position 'top
;;         lsp-ui-doc-side 'right
;;         lsp-ui-doc-delay 0.5
;;         lsp-ui-sideline-show-code-actions t
;;         lsp-ui-sideline-show-hover t
;;         lsp-ui-sideline-show-symbol t
;;         lsp-ui-peek-always-show t
;;         lsp-ui-sideline-delay 0.05))

;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; ;;(use-package lsp-treemacs :commands lsp-treemacs-errors-list) ;

(use-package jsonrpc
  :ensure t
  :defer t
  )

(use-package project
  :ensure t
  :defer t
  )

(use-package eglot
  :ensure t
  :hook
  (fsharp-ts-mode-hook . eglot-ensure))


(use-package fsharp-ts-mode

  :ensure t
  :demand t

  :bind (:map fsharp-ts-mode-map
              ("C-c f" . fsharp-ts-main-transient)
              ("C-c C-d" . fsharp-ts-eglot-generate-doc-comment)
              )

  :hook ((fsharp-ts-mode . fsharp-ts-repl-minor-mode)
         (fsharp-ts-mode . fsharp-ts-dotnet-mode)
         (fsharp-ts-mode . eglot-ensure)
         (fsharp-ts-mode . prettify-symbols-mode)
         (fsharp-ts-mode . fsharp-ts-info-mode)
         (fsharp-ts-mode . fsharp-ts-lens-mode)
         (fsharp-ts-mode . outline-minor-mode)
         )

  :config
  (require 'fsharp-ts-eglot)
  (require 'fsharp-ts-lens)
  (require 'fsharp-ts-info)
  (require 'transient)

  (setq fsharp-ts-eglot-server-install-dir "/etc/profiles/per-user/bones/bin/")
  (setq fsharp-ts-eglot--installed-version-cache "0.83.0")

  (transient-define-prefix fsharp-ts-main-transient ()
    [:class transient-columns
            [ "Base"
              ("a" "Switch between .fs and .fsi" ff-find-other-file)
              ("c" "Run compilation" compile)
              (">" "Indent region by one level" fsharp-ts-mode-shift-region-right)
              ("<" "Dedent region by one level" fsharp-ts-mode-shift-region-left)
              ("g" "Generate references.fsx buffer" fsharp-ts-repl-generate-references-file )
              ("s" "Display type signature of symbol at point" fsharp-ts-eglot-signature-at-point)
              ]

            ["Docs"
             ("d d" "Generate XML doc comment stub for definition" fsharp-ts-eglot-generate-doc-comment)
             ("d D" "Look up symbol in .NET docs" fsharp-ts-mode-doc-at-point)
             ("d f" "Open the F# documentation home page" fsharp-ts-mode-browse-fsharp-docs)
             ("d s" "Search FSDN by type signature (e.g., string -> int)" fsharp-ts-mode-search-by-signature)
             ("d S" "Open MSDN docs for symbol" fsharp-ts-eglot-f1-help)
             ("d p" "Show documentation for symbol at point" fsharp-ts-info-show)
             ]
            [".fsproj"
             ("p u" "Move file up in compilation order" fsharp-ts-eglot-fsproj-move-file-up)
             ("p d" "Move file down in compilation order" fsharp-ts-eglot-fsproj-move-file-down)
             ("p a" "Add file to the project" fsharp-ts-eglot-fsproj-add-file)
             ("p r" "Remove file from the project" fsharp-ts-eglot-fsproj-remove-file)
             ]
            ]
    [:class transient-columns

            ["REPL"
             ("r b"   "Send entire buffer" fsharp-ts-repl-send-buffer)
             ("r c"   "Send definition at point" fsharp-ts-repl-send-definition)
             ("r TAB" "Interrupt the REPL process" fsharp-ts-repl-interrupt)
             ("r k"   "Clear the REPL buffer" fsharp-ts-repl-clear-buffer)
             ("r l"   "Load file via #load directive" fsharp-ts-repl-load-file)
             ("r p"   "Send project references to REPL        " fsharp-ts-repl-send-project-references)
             ("r r"   "Send region" fsharp-ts-repl-send-region)
             ("r z"   "Start or switch to the REPL" fsharp-ts-repl-switch-to-repl)]

            ["Dotnet"
             ("D R" "Restore NuGet packages" fsharp-ts-dotnet-restore)
             ("D b" "Build project" fsharp-ts-dotnet-build)
             ("D c" "Clean build output" fsharp-ts-dotnet-clean)
             ("D d" "Run arbitrary command" fsharp-ts-dotnet-command) ;TODO make a transient interface for this
             ("D f" "Format code" fsharp-ts-dotnet-format)
             ("D p" "Find nearest .fsproj"   fsharp-ts-dotnet-find-project-file)
             ("D r" "Run project" fsharp-ts-dotnet-run)
             ("D t" "Run tests" fsharp-ts-dotnet-test)]
            ]
    )

  :custom
  (fsharp-ts-guess-indent-offset t)
  (fsharp-ts-eglot-linter t)
  (fsharp-ts-eglot-unused-opens-analyzer t)
  (fsharp-ts-eglot-unused-declarations-analyzer t)
  (fsharp-ts-eglot-simplify-name-analyzer t)
  (fsharp-ts-eglot-unnecessary-parens-analyzer t)
  (fsharp-ts-eglot-enable-analyzers t)
  (fsharp-ts-eglot-code-lenses t)
  (fsharp-ts-eglot-inlay-hints t)
  (fsharp-ts-eglot-pipeline-hints t))

(use-package ob-fsharp
  :ensure t
  ;; :straight t
  :config
  (add-to-list 'org-babel-load-languages '(fsharp . t)))

(use-package ccls
  :ensure t
  :config
  (setq ccls-sem-highlight-method 'font-lock)
  ;; alternatively, (setq ccls-sem-highlight-method 'overlay)

  ;; For rainbow semantic highlighting
  (ccls-use-default-rainbow-sem-highlight)
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))


;; (use-package treemacs-projectile :after (treemacs projectile))


(use-package dap-mode
  :defer t
  :ensure t :after lsp-mode
  :config
  (require 'dap-python)
  (require 'dap-ui)
  ;; (require 'dap-lldb)
  ;; (require 'dap-cpptools)
  (require 'dap-gdb)
  (setq dap-mode t)
  (setq dap-ui-mode t)
  ;; enables mouse hover support
  (setq dap-tooltip-mode t)
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  (setq tooltip-mode t)
  (setq dap-ui-controls-mode t)
  )

(use-package avy
  :ensure t
  :bind
  ("C-c SPC" . avy-goto-char))


(use-package ace-window
  :ensure t
  :bind
  ("C-c o" . other-window)
  ("C-x o" . ace-select-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; (use-package treemacs-nerd-icons
;;                  :config
;;                  (treemacs-load-theme "nerd-icons"))

(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))

(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/backups/" t)))

(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(customize-set-variable
 'tramp-backup-directory-alist backup-directory-alist)

;; (use-package eshell-follow
;;   :defer t
;;   :after eshell)

;;some jankness either I made or stole from somewhere that I have forgotten

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) (line-beginning-position 2)))))

(defadvice kill-ring-save (after keep-transient-mark-active ())
  "Override the deactivation of the mark."
  (setq deactivate-mark nil))
(ad-activate 'kill-ring-save)

(defadvice backward-kill-word (around delete-pair activate)
  "Remove the word backwards from cursor."
  (if (eq (char-syntax (char-before)) ?\()
      (progn
        (backward-char 1)
        (save-excursion
          (forward-sexp 1)
          (delete-char -1))
        (forward-char 1)
        (append-next-kill)
        (kill-backward-chars 1))
    ad-do-it))

(defun acg/with-mark-active (&rest args)
  "Keep mark active after command. Unusre what ARGS is. To be used as advice AFTER any function that set variable `deactivate-mark' to t."
  (setq deactivate-mark nil))

(with-eval-after-load 'newcomment
  (advice-add 'comment-or-uncomment-region :after #'acg/with-mark-active))

(setq cd2/region-command 'cd2/comment-or-uncomment-lines)

(use-package comment-dwim-2
  ;; :ensure t
  :bind
  ("M-;" . comment-dwim-2))

(defun kill-line-or-region ()
  "Kill region if active only or kill line normally."
  (interactive)
  (if (region-active-p)
      (call-interactively 'kill-region)
    (call-interactively 'kill-line)))

(global-set-key (kbd "C-k") 'kill-line-or-region)

(defun backward-kill-region-or-word ()
  "Kill region if active only or kill line normally."
  (interactive)
  (if (region-active-p)
      (call-interactively 'kill-region)
    (call-interactively 'backward-kill-word)))
(global-set-key (kbd "C-w") 'backward-kill-region-or-word)


;;ivy/counsel/swiper/setup
(use-package counsel
  :ensure t
  :bind
  (("C-s" . swiper-isearch)
   ("C-c C-r" . ivy-resume)
   ("<f6>" . ivy-resume)
   ("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f" . counsel-describe-function)
   ("<f1> v" . counsel-describe-variable)
   ("<f1> o" . counsel-describe-symbol)
   ("<f1> l" . counsel-find-library)
   ("<f2> i" . counsel-info-lookup-symbol)
   ("<f2> u" . counsel-unicode-char)
   ("C-c g" . counsel-git)
   ("C-c j" . counsel-git-grep)
   ("C-c k" . counsel-ag)
   ("C-x l" . counsel-locate)
   ("C-S-o" . counsel-rhythmbox)
   ("C-M-j" . 'counsel-switch-buffer)
   :map minibuffer-local-map
   ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-mode t)
  (setopt ivy-use-virtual-buffers t)
  (setopt enable-recursive-minibuffers t)
  (setopt ivy-toggle-fuzzy t)
  (setq ivy-initial-inputs-alist nil)
  ;; Enable this if you want `swiper' to use it:
  ;; (setopt search-default-mode #'char-fold-to-regexp)
  ;; (define-key counsel-find-file-map (kbd "TAB") #'ivy-alt-done) ;you may need to uncomment this if the line beneath isn't working
  (define-key counsel-find-file-map (kbd "<tab>") #'ivy-alt-done)
  )


(use-package counsel-ag-popup
  :ensure t
  :after counsel
  :defer t
  :bind
  (("C-c s" . counsel-ag-popup)))


(use-package ivy-prescient
  :ensure t
  :after counsel
  :config
  (ivy-prescient-mode 1)
  (prescient-persist-mode 1))


(use-package corfu-prescient
  :ensure t
  :after corfu
  :config
  (corfu-prescient-mode 1))


(setq completion-preview-sort-function #'prescient-completion-sort)

;; additions from https://zzamboni.org/post/my-doom-emacs-configuration-with-commentary/
(setq kill-whole-line t)


(use-package nix-mode
  :after lsp-mode
  :ensure t
  :hook
  (nix-mode . lsp-deferred) ;; So that envrc mode will work
  :custom
  (lsp-disabled-clients '((nix-mode . nix-nil))) ;; Disable nil so that nixd will be used as lsp-server
  :config
  (setq lsp-nix-nixd-server-path "nixd"
        lsp-nix-nixd-formatting-command [ "nixfmt" ]
        lsp-nix-nixd-nixpkgs-expr "import <nixpkgs> { }"
        lsp-nix-nixd-nixos-options-expr "(builtins.getFlake \"/home/nb/nixos\").nixosConfigurations.mnd.options"
        lsp-nix-nixd-home-manager-options-expr "(builtins.getFlake \"/home/nb/nixos\").homeConfigurations.\"nb@mnd\".options"))

(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")

(use-package nix-modeline
  :ensure t
  :after nix-mode
  :commands (nix-modeline-mode)
  :config
  (setq nix-modeline-idle-text ""))


;; git gutter from https://ianyepan.github.io/posts/emacs-git-gutter/
(use-package git-gutter
  :ensure t
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :ensure t
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom)
  )


(use-package vundo
  :ensure t
  :bind ("M-/" . vundo)
  :config
  (setq vundo-glyph-alist vundo-unicode-symbols))

;; (use-package direnv
;;   :config
;;   (direnv-mode))

(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package color-identifiers-mode
  :ensure t
  :hook (after-init . global-color-identifiers-mode)
  :config
  (setq color-identifiers:extra-face-attributes '(:weight bold)))

(use-package buffer-terminator
  :ensure t
  :custom
  ;; Enable/Disable verbose mode to log buffer cleanup events
  (buffer-terminator-verbose nil)

  ;; Set the inactivity timeout (in seconds) after which buffers are considered
  ;; inactive (default is 30 minutes):
  (buffer-terminator-inactivity-timeout (* 30 60)) ; 30 minutes

  ;; Define how frequently the cleanup process should run (default is every 10
  ;; minutes):
  (buffer-terminator-interval (* 10 60)) ; 10 minutes

  :config
  (buffer-terminator-mode 1))


(use-package numpydoc
  :ensure t
  :after python
  :bind ("C-c C-n" . numpydoc-generate))

(use-package pyvenv
  :ensure t
  :after python)

(use-package uv
  :ensure t
  ;; :vc (:url "https://github.com/johannes-mueller/uv.el"   :rev :newest)
  :bind ("C-c C-U" . uv))

;; ELEC3020
(use-package platformio-mode
  :ensure t
  :hook (
         (c++-mode . (lambda ()
                       (lsp-deferred)
                       )
                   )))
;; (use-package ccls
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;          (lambda () (require 'ccls) (lsp))))
;;

(use-package vterm-toggle
  :ensure t
  ;; :hook (after-init . vterm-toggle)
  :bind
  ("C-c t" . vterm-toggle-cd)
  ("C-x c" . vterm-copy-mode)



  :config
  (setq vterm-toggle-fullscreen-p nil)
  ;; Protect vterm-specific variables
  (with-eval-after-load 'vterm
    (define-key vterm-mode-map [(control return)] #'vterm-toggle-insert-cd)
    (define-key vterm-copy-mode-map [(control return)] #'vterm-toggle-insert-cd))

  (add-to-list 'display-buffer-alist
               `((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (when buffer
                       (with-current-buffer buffer
                         (or (derived-mode-p 'vterm-mode)
                             (string-prefix-p vterm-buffer-name (buffer-name buffer)))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.4)))
  )

(use-package tabspaces
  :ensure t
  ;; use this next line only if you also use straight, otherwise ignore it.
  ;; :straight (:type git :host github :repo "mclear-tools/tabspaces")
  :hook (after-init . tabspaces-mode) ;; use this only if you want the minor-mode loaded at startup.
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*"))
  (tabspaces-initialize-project-with-todo nil)
  ;; sessions
  (tabspaces-session t)
  (tabspaces-session-auto-restore nil)
  (tab-bar-new-tab-choice "*scratch*"))
;; Filter Buffers for Consult-Buffer
;; Define a helper for clarity


;; (with-eval-after-load 'consult
;;   ;; hide full buffer list (still available with "b" prefix)
;;   (consult-customize consult--source-buffer :hidden t :default nil)
;;   ;; set consult-workspace buffer list
;;   (defvar consult--source-workspace
;;     (list :name     "Workspace Buffers"
;;           :narrow   ?w
;;           :history  'buffer-name-history
;;           :category 'buffer
;;           :state    #'consult--buffer-state
;;           :default  t
;;           :items    (lambda () (consult--buffer-query
;;                                 ;; :predicate #'tabspaces--local-buffer-p
;;                                 :sort 'visibility
;;                                 :as #'buffer-name)))
;;
;;     "Set workspace buffer list for consult-buffer.")
;;   (add-to-list 'consult-buffer-sources 'consult--source-workspace))

(use-package simple-comment-markup
  ;; :ensure t
  ;; :straight (:type git :host nil :repo "https://code.tecosaur.net/tec/simple-comment-markup.git")
  ;;:vc (:url "https://code.tecosaur.net/tec/simple-comment-markup"   :rev :newest) ;
  :ensure t
  :hook (prog-mode . simple-comment-markup-mode)
  )

(use-package screenshot
  :ensure t

  ;;  :vc (:url "https://github.com/tecosaur/screenshot"   :rev :newest)

  :config
  (setq screenshot-line-numbers-p 't)
  (setq screenshot-relative-line-numbers-p 't)
  (setq screenshot-min-width 80)
  (setq screenshot-max-width 80)
  (setq screenshot-truncate-lines-p nil)

  (setq screenshot-text-only-p nil)

  ;; (setq screenshot-font-family "FireCode")
  ;; (setq screenshot-font-size 12)

  (setq screenshot-border-width 10)
  (setq screenshot-border-width 10)
  (setq screenshot-radius 0)
  (setq screenshot-shadow-offset-horizontal 0)
  (setq screenshot-shadow-offset-vertical 0))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  )

(use-package yaml-mode
  :ensure t
  )

(use-package ponylang-mode
  :ensure t
  :init
  (setq ponylang-banner 2)
  :config
  :bind-keymap
  ("C-c p" . ponylang-menu))

(use-package flycheck-pony
  :ensure t
  :config
  (setq create-lockfiles nil))


;; (use-package go-mode
;;   :ensure t)


(use-package doxymacs
  :ensure t
  ;; :straight (doxymacs :type git :host github :repo "pniedzielski/doxymacs")
  ;;:vc (:url "https://github.com/pniedzielski/doxymacs"   :rev :newest)
  :hook ((prog-mode . doxymacs-mode) (font-lock-mode . doxymacs-font-lock))
  :bind (:map prog-mode-map
              ;; Lookup documentation for the symbol at point.
              ("C-c d ?" . doxymacs-lookup)
              ;; Rescan your Doxygen tags file.
              ("C-c d r" . doxymacs-rescan-tags)
              ;; Prompt you for a Doxygen command to enter, and its
              ;; arguments.
              ("C-c d RET" . doxymacs-insert-command)
              ;; Insert a Doxygen comment for the next function.
              ("C-c d f" . doxymacs-insert-function-comment)
              ;; Insert a Doxygen comment for the current file.
              ("C-c d i" . doxymacs-insert-file-comment)
              ;; Insert a Doxygen comment for the current member.
              ("C-c d ;" . doxymacs-insert-member-comment)
              ;; Insert a blank multi-line Doxygen comment.
              ("C-c d m" . doxymacs-insert-blank-multiline-comment)
              ;; Insert a blank single-line Doxygen comment.
              ("C-c d s" . doxymacs-insert-blank-singleline-comment)
              ;; Insert a grouping comments around the current region.
              ("C-c d @" . doxymacs-insert-grouping-comments))
  :config
  ;; (doxymacs-font-lock)
  ;; (font-lock-add-keywords nil doxymacs--doxygen-keywords) ;should be the same as doxymacs-font-lock
  :custom
  ;; Configure source code <-> Doxygen tag file <-> Doxygen HTML
  ;; documentation mapping:
  ;;   - Files in /home/me/project/foo/ have their tag file at
  ;;     http://someplace.com/doc/foo/foo.xml, and HTML documentation
  ;;     at http://someplace.com/doc/foo/.
  ;;   - Files in /home/me/project/bar/ have their tag file at
  ;;     ~/project/bar/doc/bar.xml, and HTML documentation at
  ;;     file:///home/me/project/bar/doc/.
  ;; This must be configured for Doxymacs to function!
  (doxymacs-doxygen-dirs
   '(("^/home/bones/Storage/Uniwork/.gitJankness/ELEC3020_Project/"
      "~/home/bones/Storage/Uniwork/.gitJankness/ELEC3020_Project/project.xml"
      "file::///home/bones/Storage/Uniwork/.gitJankness/ELEC3020_Project/doc/")
     )))

(use-package package-lint   :ensure t)

(use-package cicode-mode
  ;; :straight (cicode-mode :type git :host github :repo "Sebagabones/cicode-mode.el")
  ;; :vc (:url "https://github.com/Sebagabones/cicode-mode.el"   :rev :newest)
  :ensure t
  )


;; (setf use-default-font-for-symbols nil)
;; (set-fontset-font t 'unicode "Noto Emoji" nil 'append)
(set-fontset-font t 'unicode "Berkeley Mono" nil 'prepend)
;; (setq inhibit-compacting-font-caches t)
;; (set-fontset-font t 'unicode (font-spec :family "Berkeley Mono") nil 'prepend)
;; (set-fontset-font t nil  (font-spec :family "Berkeley Mono") nil )

(use-package ement   :ensure t)

;; (define-derived-mode irc-log-mode fundamental-mode "IRC Log"
;;   "Major mode for viewing IRC-style logs - mostly for org mode."
;;   (setq font-lock-defaults
;;         '((
;;            ("^\\[\\([0-9:]+\\)\\]" 1 'font-lock-comment-face)   ; timestamps
;;            ("Seb" 0 'font-lock-keyword-face)       ; nicknames
;;            ("<\\([^>]+\\)>" 1 'font-lock-constant-face)       ; nicknames
;;            ("\\*\\*\\(.*?\\)\\*\\*" 1 'org-macro-face)     ; actions
;;            ("\\(https?://[^ ]+\\)" 1 'button-face)))))  ; URLs

;; (with-eval-after-load 'org-src(add-to-list 'org-src-lang-modes '("irc-log" . irc-log)))

(use-package indent-bars
  :ensure t
  :hook ((python-ts-mode python-mode c-ts-mode c-mode c++-ts-mode c++-mode yaml-ts-mode nix-ts-mode nix-mode toml-ts-mode rust-ts-mode ) . indent-bars-mode)
  :config
  (setq
   indent-bars-color '(highlight :face-bg t :blend 0.8)
   indent-bars-pattern ". . . ."
   indent-bars-color-by-depth '(:palette (outline-1 outline-2 outline-3 outline-4 outline-5 outline-6 outline-7 outline-8) :blend 0.8)
   indent-bars-highlight-current-depth '(:blend 1.0 :width 0.2 :pad 0.1 :pattern ". . ." :zigzag 0)
   indent-bars-pad-frac 0.3
   indent-bars-ts-highlight-current-depth '(no-inherit) ; equivalent to nil
   indent-bars-ts-color-by-depth '(no-inherit)
   indent-bars-ts-color '(inherit fringe :face-bg t :blend 0.2)

   )
  :custom
  (indent-bars-treesit-support t)

  ;; Python
  (indent-bars-no-descend-lists t)
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
				       if_statement with_statement while_statement)))
  (indent-bars-treesit-ignore-blank-lines-types '("module"))

  ;; C
  (indent-bars-treesit-wrap '((c argument_list parameter_list init_declarator parenthesized_expression)))
  ;; Rust
  (indent-bars-treesit-wrap '((rust arguments parameters)))
  (indent-bars-treesit-scope '((rust trait_item impl_item
                                     macro_definition macro_invocation
                                     struct_item enum_item mod_item
                                     const_item let_declaration
                                     function_item for_expression
                                     if_expression loop_expression
                                     while_expression match_expression
                                     match_arm call_expression
                                     token_tree token_tree_pattern
                                     token_repetition)))
  ;; TOML

  (indent-bars-treesit-wrap '((toml
                               table array comment)))
  ;; YAML

  (indent-bars-treesit-wrap '((yaml
                               block_mapping_pair comment)))
  )
(use-package gpr-ts-mode
  :ensure t
  )
(use-package ada-ts-mode
  :ensure t
  )
(use-package  haskell-mode
  :ensure t)

(use-package math-at-point
  :ensure t
  ;; :straight (math-at-point :type git :host github :repo "shankar2k/math-at-point")
  ;;:vc (:url "https://github.com/shankar2k/math-at-point"   :rev :newest)
  :bind ("C-=" . math-at-point)
  :hook org-mode)

;; (use-package ascii-art-to-unicode
;;   :ensure t)

(use-package uniline
  :ensure t
  :bind ("C-*" . uniline-mode)
  )
