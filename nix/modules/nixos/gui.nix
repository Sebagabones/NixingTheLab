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
  programs = { dconf.enable = true; };
  services = {
    blueman.enable = true;
    udev.packages = [ pkgs.platformio-core.udev pkgs.openocd ]; # ELEC3020
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
  };
}
