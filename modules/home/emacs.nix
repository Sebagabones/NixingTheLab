{ config, lib, pkgs, ... }:
let
  userCfg = config.users.bones;
  cfg = userCfg.programs.emacs;
  emacsInstallation = "${config.home.homeDirectory}/.emacs.d";

in {
  # Automatically install Emacs config from here.
  home.mutableFile.${emacsInstallation} = {
    url = "https://github.com/Sebagabones/myEmacsConfig.git";
    type = "git";
  };
  # Enable Emacs server for them quicknotes.
  services.emacs = {
    enable = true;
    socketActivation.enable = true;
  };

  home.packages = with pkgs;
    let
      tex = (pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-basic dvisvgm dvipng # for preview and export as html
          wrapfig amsmath ulem hyperref capt-of fontspec listings xcolor
          koma-script multirow lstfiracode fvextra upquote lineno tcolorbox
          latexmk minted enumitem catppuccinpalette pdfcol caption
          latex-graphics-dev booktabs framed changepage;
      });
    in [
      delta
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      hunspellDicts.en-au
      hunspellDicts.en_GB-large
      basedpyright
      multimarkdown
      nixfmt-classic
      openscad-lsp
      ccls
      imagemagick
      ghostscript_headless
      gnupg
      # Remote connection to gui emacs session
      cage
      waypipe
    ];

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.org-noter-pdftools
      epkgs.org-pdftools
      epkgs.pdf-tools
      epkgs.vterm
      epkgs.vterm-toggle
      epkgs.tabspaces
      epkgs.pyvenv
      epkgs.numpydoc
      epkgs.git-gutter
      epkgs.nix-modeline
      epkgs.nix-mode
      epkgs.latex-pretty-symbols
      epkgs.treemacs
      epkgs.treemacs-projectile
      epkgs.lsp-treemacs
      epkgs.treemacs-nerd-icons
      epkgs.elpaca
      epkgs.base16-theme
      epkgs.solaire-mode
      epkgs.corfu
      epkgs.cape
      epkgs.vertico
      epkgs.orderless
      epkgs.marginalia
      epkgs.org
      epkgs.use-package
      epkgs.embark
      epkgs.embark-consult
      epkgs.outline-indent
      epkgs.stripspace
      epkgs.undo-fu
      epkgs.hl-todo
      epkgs.consult-todo
      epkgs.magit-todos
      epkgs.vim-tab-bar
      epkgs.ox-gfm
      epkgs.org-modern
      epkgs.org-appear
      epkgs.org-fragtog
      epkgs.engrave-faces
      epkgs.org-attach-screenshot
      epkgs.org-sidebar
      epkgs.htmlize
      epkgs.markdown-mode
      epkgs.flycheck
      epkgs.ccls
      epkgs.color-identifiers-mode
      epkgs.platformio-mode
      epkgs.counsel
      epkgs.magit
      epkgs.difftastic
      epkgs.scad-mode
      epkgs.lsp-pyright
      epkgs.git-gutter-fringe
      epkgs.direnv
      epkgs.forge
      epkgs.rg
      epkgs.ivy-prescient
      epkgs.corfu-prescient
      epkgs.embark
      epkgs.embark-consult
      epkgs.rainbow-delimiters
      epkgs.highlight-defined
      epkgs.aggressive-indent
      epkgs.rmsbolt
      epkgs.apheleia
      epkgs.flycheck-inline
      epkgs.clipetty
      epkgs.ace-jump-mode
      epkgs.dap-mode
      epkgs.hydra
      epkgs.magit-delta
      epkgs.transient
      epkgs.which-key
      epkgs.fira-code-mode
      epkgs.nerd-icons
      epkgs.helpful
      epkgs.compile-angel
    ];
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
