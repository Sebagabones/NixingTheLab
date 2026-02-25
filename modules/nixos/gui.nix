{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.xremap-flake.nixosModules.default
    ./theming.nix
  ];
  environment.systemPackages = with pkgs; [
    pinentry-gnome3
  ];

  stylix = {
    image = ../../assests/background.png;
    targets.qt = {
      enable = true;
    };
    cursor = {
      package = pkgs.banana-cursor;
      name = "Banana";
      size = 32;
    };
  };
  services.gnome.gcr-ssh-agent.enable = false;
  programs = {
    dconf.enable = true;
    xwayland.enable = true;
    ssh = {
      startAgent = true;
      askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
      enableAskPassword = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
  };

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  # Packages

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    desktopManager.plasma6.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gcr ]; # allegedly helps with gnome pinentry
    };

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    libinput.enable = true;

    blueman.enable = true;
    udev.packages = [
      pkgs.platformio-core.udev
      pkgs.openocd
    ]; # ELEC3020
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
    xremap = {
      # NOTE: not locked to a specific DE - useful as miracle-wm doesn't wlroots lol
      # LMAO, looks like this doesnt work on gnome - fix it sometime
      enable = true;
      serviceMode = "user";
      userName = "bones";
      config.modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "Ctrl";
          }; # globally remap CapsLock to Ctrl
        }
      ];
    };
  };
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
  };

}
