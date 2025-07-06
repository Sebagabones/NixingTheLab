{ inputs, config, lib, pkgs, flake, ... }:

{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    flake.homeModules.themeing
    # flake.homeModules.gui
  ];
  home.packages = with pkgs; [
    ghostty.terminfo
    atool
    httpie
    delta
    difftastic
    procs
  ];

  home.sessionVariables = { TERM = "xterm-direct"; };

  programs = {

    fzf.enable = true;
    btop = {
      enable = true;
      settings = { update_ms = 100; };
    };
    fastfetch.enable = true;
    lazygit.enable = true;
  };

  programs.fd.enable = true;

  programs.ripgrep.enable = true;
  programs.emacs = { enable = true; };

  programs.git.enable = true;
  programs.bat.enable = true;

}
