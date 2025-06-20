{ flake, inputs, lib, perSystem, pkgs, nixpkgs, ... }: {
  networking.hostName = "insanity";
  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/alder-lake"
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/common/gpu/amd"
    "${inputs.nixos-hardware}/common/pc"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Packages
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    i3
    lightdm
    konsole
    firefox
    spotify
    discord
    wezterm
    arandr
  ];

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  services.xserver = {
    enable = true;

    desktopManager = { xterm.enable = false; };

    displayManager = {
      lightdm = {
        enable = true;
        greeters.slick.enable = true;
        background = ./backgroundFR.jpg;
      };
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
      ];
    };
  };
  services.displayManager.defaultSession = "none+i3";

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;

  lollypops.deployment.group = "Personal";
}
