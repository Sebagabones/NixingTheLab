{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./theming.nix ];
  environment.systemPackages = with pkgs; [ lightdm ];
  # programs.niri = {
  #   enable = true;
  # };
  stylix = {
    cursor = {
      package = pkgs.banana-cursor;
      name = "Banana";
      size = 32;
    };
  };

  services = {
    blueman.enable = true;
    udev.packages = [ pkgs.platformio-core pkgs.openocd ]; # ELEC3020
  };
}
