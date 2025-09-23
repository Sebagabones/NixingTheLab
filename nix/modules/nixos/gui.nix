{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./theming.nix ];
  environment.systemPackages = with pkgs; [ ];

  stylix = {
    cursor = {
      package = pkgs.banana-cursor;
      name = "Banana";
      size = 32;
    };
  };
  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
  };

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      desktopManager = { xterm.enable = false; };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    dbus.enable = true;

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    libinput.enable = true;

    blueman.enable = true;
    udev.packages = [ pkgs.platformio-core.udev pkgs.openocd ]; # ELEC3020
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [ cups-filters cups-browsed ];
    };
  };
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
  };

}
