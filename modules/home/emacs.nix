{
  config,
  pkgs,
  inputs,
  ...
}:
let
  emacsInstallation = "${config.home.homeDirectory}/.emacs.d";
in
{
  # Automatically install Emacs config from here.
  # TODO: work out why this isn’t working anymore - maybe the removal of archiver? dunno - orrr maybe it was to do with xdg movement, idk that seems weird too though
  # home.mutableFile.${emacsInstallation} = {
  #   url = "https://github.com/Sebagabones/myEmacsConfig.git";
  #   type = "git";
  # };
  # Enable Emacs server for them quicknotes.
  services.emacs = {
    enable = true;
    socketActivation.enable = true;
  };

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

  programs.emacs = {
    enable = true;
    package = (
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
    # package = (
    #   pkgs.emacsWithPackagesFromUsePackage {
    #     config = ./emacs.el;
    #     defaultInitFile = true;
    #   }
    # );
    # extraPackages = epkgs: [
    #   epkgs.org-noter-pdftools
    #   epkgs.org-pdftools
    #   epkgs.pdf-tools
    #   epkgs.vterm
    #   epkgs.vterm-toggle
    #   epkgs.tabspaces
    #   epkgs.pyvenv
    #   epkgs.numpydoc
    #   epkgs.git-gutter
    #   epkgs.latex-pretty-symbols
    #   epkgs.treemacs
    #   epkgs.treemacs-projectile
    #   epkgs.lsp-treemacs
    #   epkgs.treemacs-nerd-icons
    #   epkgs.elpaca
    #   epkgs.base16-theme
    #   epkgs.solaire-mode
    #   epkgs.corfu
    #   epkgs.cape
    #   epkgs.vertico
    #   epkgs.orderless
    #   epkgs.marginalia
    #   epkgs.org
    #   epkgs.use-package
    #   epkgs.embark
    #   epkgs.embark-consult
    #   epkgs.outline-indent
    #   epkgs.stripspace
    #   epkgs.undo-fu
    #   epkgs.hl-todo
    #   epkgs.consult-todo
    #   epkgs.magit-todos
    #   epkgs.vim-tab-bar
    #   epkgs.ox-gfm
    #   epkgs.org-modern
    #   epkgs.org-appear
    #   epkgs.org-fragtog
    #   epkgs.engrave-faces
    #   epkgs.org-attach-screenshot
    #   epkgs.org-sidebar
    #   epkgs.htmlize
    #   epkgs.markdown-mode
    #   epkgs.flycheck
    #   epkgs.ccls
    #   epkgs.color-identifiers-mode
    #   epkgs.platformio-mode
    #   epkgs.counsel
    #   epkgs.magit
    #   epkgs.difftastic
    #   epkgs.scad-mode
    #   epkgs.lsp-pyright
    #   epkgs.git-gutter-fringe
    #   epkgs.direnv
    #   epkgs.forge
    #   epkgs.rg
    #   epkgs.ivy-prescient
    #   epkgs.corfu-prescient
    #   epkgs.embark
    #   epkgs.embark-consult
    #   epkgs.rainbow-delimiters
    #   epkgs.highlight-defined
    #   epkgs.aggressive-indent
    #   epkgs.rmsbolt
    #   epkgs.apheleia
    #   epkgs.flycheck-inline
    #   epkgs.clipetty
    #   epkgs.ace-jump-mode
    #   epkgs.dap-mode
    #   epkgs.hydra
    #   epkgs.magit-delta
    #   epkgs.transient
    #   epkgs.which-key
    #   epkgs.fira-code-mode
    #   epkgs.nerd-icons
    #   epkgs.helpful
    #   epkgs.compile-angel
    #   epkgs.package-lint
    #   epkgs.fsharp-ts-mode
    #   epkgs.eglot
    #   epkgs.treesit-grammars.with-all-grammars
    #   epkgs.uniline
    # ];
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
