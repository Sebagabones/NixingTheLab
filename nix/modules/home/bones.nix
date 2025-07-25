{ inputs, config, lib, pkgs, flake, ... }:

{
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
