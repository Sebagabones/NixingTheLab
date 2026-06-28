{
  config,
  pkgs,
  nixpkgs,
  inputs,
  ...
}:
let
  emacsInstallation = "${config.home.homeDirectory}/.emacs.d";
  myEmacs = (
    pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs.el;
      defaultInitFile = true;
      package = pkgs.emacs-pgtk;
      override =
        epkgs:
        epkgs
        // {

          # org-modern-indent
          org-modern-indent = pkgs.callPackage ./emacsPkgs/org-modern-indent.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
          };

          # fsharp-ts-mode
          fsharp-ts-mode = pkgs.callPackage ./emacsPkgs/fsharp-ts-mode.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
          };

          # uv.el
          uv = pkgs.callPackage ./emacsPkgs/uv-el.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
            inherit (epkgs) tomlparse;
            inherit (epkgs) transient;
          };

          # simple-comment-markup
          simple-comment-markup = pkgs.callPackage ./emacsPkgs/simple-comment-markup.nix {
            inherit (pkgs) fetchgit;
            inherit (epkgs) melpaBuild;
          };

          # screenshot
          screenshot = pkgs.callPackage ./emacsPkgs/screenshot.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
            inherit (epkgs) posframe;
          };

          # doxymacs
          doxymacs = pkgs.callPackage ./emacsPkgs/doxymacs.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
          };

          # cicode-mode
          cicode-mode = pkgs.callPackage ./emacsPkgs/cicode-mode-el.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
            inherit (epkgs) ht;
          };

          # math-at-point
          math-at-point = pkgs.callPackage ./emacsPkgs/math-at-point.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
          };

          # comment-dwim-2
          comment-dwim-2 = pkgs.callPackage ./emacsPkgs/comment-dwim-2.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) melpaBuild;
          };

        };
      extraEmacsPackages = epkgs: [
        epkgs.comment-dwim-2
      ];
    }
  );
in
{
  # Automatically install Emacs config from here.
  # TODO: work out why this isn’t working anymore - maybe the removal of archiver? dunno - orrr maybe it was to do with xdg movement, idk that seems weird too though
  # home.mutableFile.${emacsInstallation} = {
  #   url = "https://github.com/Sebagabones/myEmacsConfig.git";
  #   type = "git";
  # };

  home.packages =
    with pkgs;
    let
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-basic
          dvisvgm
          dvipng # for preview and export as html
          wrapfig
          amsmath
          ulem
          hyperref
          capt-of
          fontspec
          listings
          xcolor
          koma-script
          multirow
          lstfiracode
          fvextra
          upquote
          lineno
          tcolorbox
          latexmk
          minted
          enumitem
          catppuccinpalette
          pdfcol
          caption
          latex-graphics-dev
          booktabs
          framed
          changepage
          svg
          transparent
          moreverb
          xkeyval
          standalone
          luatex85
          pdflscape
          etoc
          titlesec
          preview
          luatex
          semantex
          sectsty
          graphviz
          leftindex
          mathtools
          circuitikz
          xfrac
          soulpos
          microtype
          setspace
          biblatex
          fancyhdr
          tocbibind
          ;

        nicematrix = {
          pkgs = [
            (pkgs.runCommand "nicematrix"
              {
                src = pkgs.fetchurl {
                  url = "https://raw.githubusercontent.com/fpantigny/nicematrix/106b00df06a78228b314d447bbb33dc16da54e89/nicematrix.sty";
                  sha256 = "sha256-xlZjF/+l52AotGJ/wvfaRGIX6LEeksnFRjTFkT6x5do=";
                };
                passthru = {
                  pname = "nicematrix";
                  version = "7.9a";
                  tlType = "run";
                };
              }
              "
        mkdir -p $out/tex/latex/nicematrix/
        cp $src $out/tex/latex/nicematrix/nicematrix.sty
      "
            )
          ];
        };
      };
    in
    [
      delta
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      # (aspellWithDicts (
      #   dicts: with dicts; [
      #     en
      #     en-computers
      #     en-science
      #   ]
      # )) # https://github.com/nixos/nixpkgs/issues/476684
      hunspellDicts.en-au
      hunspellDicts.en_GB-large
      basedpyright
      multimarkdown
      nixfmt
      openscad-lsp
      lemminx
      gopls
      go
      gotools
      go-tools
      ccls
      ruff
      ty
      imagemagick
      ghostscript_headless
      gnupg
      # Remote connection to gui emacs session
      waypipe
      prettier
      inkscape
      pdf2svg
      tex
      mermaid-cli
      gdb
      biber
      dotnet-sdk
      fsautocomplete
      fsharp
      tree-sitter-grammars.tree-sitter-fsharp
      # The following is requried, but is currently in ./bones.nix
      # (python3.withPackages (python-pkgs:
      # with python-pkgs; [
      #   pygments
      #   latexminted
      #   catppuccin
      # ]))
    ];

  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = myEmacs;
  };
  programs.emacs = {
    enable = true;
    package = myEmacs;
  };
  # home.file.".emacs.d/early-init.el".text = ''
  #   ;;; early-init.el -*- lexical-binding: t; -*-
  #   (setq package-enable-at-startup nil)
  #   (setq gc-cons-threshold most-positive-fixnum)
  #   (add-to-list 'default-frame-alist '(alpha-background . 95))
  #   (menu-bar-mode -1)
  #   (tool-bar-mode -1)
  #   (scroll-bar-mode -1)
  # '';
  home.file = {
    ".emacs.d/early-init.el" = {
      text = ''
        ;;; early-init.el --- Early Init -*- lexical-binding: t; -*-

        (defun ar/show-welcome-buffer ()
          "Show *Welcome* buffer."
          (with-current-buffer (get-buffer-create "*Welcome*")
            (setq truncate-lines t)
            (let* ((buffer-read-only nil)
                   (image-path "~/NixingTheLab/assests/emacs.svg")
                   (image (create-image image-path))
                   (size (image-size image))
                   (height (cdr size))
                   (width (car size))
                   (top-margin (floor (/ (- (window-height) height) 2)))
                   (left-margin (floor (/ (- (window-width) width) 2))))
              ;; --- body starts here ---
              (erase-buffer)
              (setq mode-line-format nil)
              (goto-char (point-min))
              (insert (make-string top-margin ?\n))
              (insert (make-string left-margin ?\s))
              (insert-image image)
              (insert "\n\n\n")
              (setq cursor-type nil)
              (read-only-mode +1)
              (switch-to-buffer (current-buffer))
              (redisplay t)
              (local-set-key (kbd "q") (lambda () (interactive) (kill-buffer (current-buffer)))))))



        (when (< (length command-line-args) 2)
          (add-hook 'emacs-startup-hook
                    (lambda ()
                      (when (display-graphic-p)
                        (ar/show-welcome-buffer)))
                    -100))


        (defun ar/show-welcome-buffer ()
          "Show *Welcome* buffer."
          (with-current-buffer (get-buffer-create "*Welcome*")
            (setq truncate-lines t)
            (let* ((buffer-read-only nil)
                   (image-path "~/NixingTheLab/assests/emacs.svg")
                   (image (create-image image-path))
                   (size (image-size image))
                   (height (cdr size))
                   (width (car size))
                   (top-margin (floor (/ (- (window-height) height) 2)))
                   (left-margin (floor (/ (- (window-width) width) 2))))
              ;; --- body starts here ---
              (erase-buffer)
              (setq mode-line-format nil)
              (goto-char (point-min))
              (insert (make-string top-margin ?\n))
              (insert (make-string left-margin ?\s))
              (insert-image image)
              (insert "\n\n\n")
              (setq cursor-type nil)
              (read-only-mode +1)
              (switch-to-buffer (current-buffer))
              (redisplay t)
              (local-set-key (kbd "q") (lambda () (interactive) (kill-buffer (current-buffer)))))))



        (when (< (length command-line-args) 2)
          (add-hook 'emacs-startup-hook
                    (lambda ()
                      (when (display-graphic-p)
                        (ar/show-welcome-buffer)))
                    -100))
        (setq gc-cons-threshold most-positive-fixnum)
        (setq gc-cons-percentage 1.0)
        (setq load-prefer-newer t)
        (setq jka-compr-verbose nil)
        (setq byte-compile-warnings nil
              byte-compile-verbose nil)

        (setq initial-scratch-message nil)
        (setq inhibit-startup-screen t)

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

        ;;; Performance: Miscellaneous options

        ;; Font compacting can be very resource-intensive, especially when rendering
        ;; icon fonts on Windows. This will increase memory usage.
        (setq inhibit-compacting-font-caches nil)

        (when (not noninteractive)
          ;; Resizing the Emacs frame can be costly when changing the font. Disable this
          ;; to improve startup times with fonts larger than the system default.
          (setq frame-resize-pixelwise nil)

          ;; Without this, Emacs will try to resize itself to a specific column size
          (setq frame-inhibit-implied-resize nil)

          ;; A second, case-insensitive pass over `auto-mode-alist' is time wasted.
          ;; No second pass of case-insensitive search over auto-mode-alist.
          (setq auto-mode-case-fold nil)

          ;; Reduce *Message* noise at startup. An empty scratch buffer (or the
          ;; dashboard) is more than enough, and faster to display.
          (setq inhibit-startup-screen t
                inhibit-startup-echo-area-message user-login-name)
          (setq initial-buffer-choice nil
                inhibit-startup-buffer-menu t
                inhibit-x-resources t)

          ;; Disable bidirectional text scanning for a modest performance boost.
          (setq-default bidi-display-reordering 'left-to-right
                        bidi-paragraph-direction 'left-to-right)

          ;; Give up some bidirectional functionality for slightly faster re-display.
          (setq bidi-inhibit-bpa nil)

          ;; Remove "For information about GNU Emacs..." message at startup
          (advice-add 'display-startup-echo-area-message :override #'ignore)

          ;; Suppress the vanilla startup screen completely. We've disabled it with
          ;; `inhibit-startup-screen', but it would still initialize anyway.
          (advice-add 'display-startup-screen :override #'ignore)


          ;; Unset command line options irrelevant to the current OS. These options
          ;; are still processed by `command-line-1` but have no effect.
          (unless (eq system-type 'darwin)
            (setq command-line-ns-option-alist nil))
          (unless (memq initial-window-system '(x pgtk))
            (setq command-line-x-option-alist nil)))

        ;;; Security
        (setq gnutls-verify-error t)  ; Prompts user if there are certificate issues
        (setq tls-checktrust t)  ; Ensure SSL/TLS connections undergo trust verification
        (setq gnutls-min-prime-bits 3072)  ; Stronger GnuTLS encryption

        ;; This results in a more compact output that emphasizes performance
        (setq use-package-expand-minimally t)


      '';
      executable = false;
    };
  };
  # Add org-protocol support.
  xdg.desktopEntries.org-protocol = {
    name = "org-protocol";
    exec = "emacsclient -- %u";
    mimeType = [ "x-scheme-handler/org-protocol" ];
    terminal = false;
    comment = "Intercept calls from emacsclient to trigger custom actions";
    noDisplay = true;
  };

  xdg.mimeApps.defaultApplications = {
    "application/json" = [ "emacs.desktop" ];
    "text/org" = [ "emacs.desktop" ];
    "text/plain" = [ "emacs.desktop" ];
    "x-scheme-handler/org-protocol" = [ "org-protocol.desktop" ];
  };

}
