{ config, lib, pkgs, ... }:
let
  userCfg = config.users.bones;
  cfg = userCfg.programs.emacs;
  emacsInstallation = "${config.home.homeDirectory}/.emacs.d";
in {
  config = {
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

    programs.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      extraPackages = epkgs: [
        epkgs.org-noter-pdftools
        epkgs.org-pdftools
        epkgs.pdf-tools
        epkgs.vterm
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
        pkgs.basedpyright
        pkgs.multimarkdown
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
  };
}
