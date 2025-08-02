{ inputs, config, lib, pkgs, flake, perSystem, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-basic dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
    #(setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  });
in {
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    ./mutable-files.nix
    flake.homeModules.git
    flake.homeModules.theming
    flake.homeModules.emacs

    # flake.homeModules.gui
  ];
  home.packages = with pkgs; [
    ghostty.terminfo
    atool
    httpie
    nixd
    delta
    # difftastic
    procs
    python3
    cmatrix
    aspell
    aspellDicts.en
    hunspellDicts.en-au
    hunspellDicts.en_GB-large
    aspellDicts.en-computers
    aspellDicts.en-science
    gnupg
    tex
    multimarkdown # used for emacs export markdown
    python311Packages.weasyprint
    pandoc
  ];

  home.sessionVariables = { TERM = "xterm-direct"; };

  programs = {
    fzf.enable = true;
    btop = {
      enable = true;
      settings = {
        update_ms = 100;
        theme-background = false;
      };
    };
    fastfetch.enable = true;
    lazygit.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    emacs = { enable = true; };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        prettybat
        batpipe
        batgrep
        batwatch
      ];
    };
  };

}
