{
  flake,
  pkgs,
  ...
}:
{
  imports = [ flake.homeModules.emacs ];
  # qt.platformTheme.name = lib.mkForce "adwaita";
  home.packages = [ pkgs.cage ];
  qt.platformTheme.name = null;

  stylix.targets = {
    qt.enable = false;
    qt.platform = null;
    emacs.enable = false;

  };
}
