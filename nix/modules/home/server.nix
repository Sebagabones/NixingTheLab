{ inputs, lib, flake, pkgs, perSystem, ... }: {
  imports = [ flake.homeModules.emacs ];
  # qt.platformTheme.name = lib.mkForce "adwaita";
  # qt.platformTheme.name = lib.mkForce "kvantum";
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

}
