{ inputs, lib, flake, pkgs, perSystem, ... }: {
  imports = [ flake.homeModules.emacs ];
  # qt.platformTheme.name = lib.mkForce "adwaita";
  home.packages = [ pkgs.cage ];
  qt.platformTheme.name = null;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
  };
  stylix.targets = {
    qt.enable = false;
    qt.platform = null;
  };
}
