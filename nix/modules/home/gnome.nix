{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./dconf.nix ];
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.space-bar
    # gnomeExtensions.just-perfection
    # gnomeExtensions.arc-menu
  ];

}
