{ inputs, config, lib, pkgs, flake, ... }:

{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    flake.homeModules.niri
    ./wezterm.nix
    # ./themeing.nix
    # flake.nixos.themeing
  ];
  home.packages = with pkgs; [
    wezterm.terminfo
    atool
    httpie
    delta
    difftastic
    procs
    elvish
  ];

  home.sessionVariables = { TERM = "xterm-direct"; };

  programs = {
    niri.enable = true;
    fzf.enable = true;
    wezterm.enable = true;
    btop = {
      enable = true;
      settings = { update_ms = 100; };
    };
    fastfetch.enable = true;
    lazygit.enable = true;
    bemenu.enable = true;
  };

  programs.fd.enable = true;

  programs.ripgrep.enable = true;
  programs.emacs = { enable = true; };

  programs.git.enable = true;
  programs.bat.enable = true;

}
