{ config, lib, pkgs, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.arc-menu
    gnomeExtensions.space-bar
  ];
  stylix.targets.qt.platform = "qtct";
}
