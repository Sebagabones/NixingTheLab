{ modulesPath, lib, pkgs, nixpkgs, ... }:

{
   imports = [
     ./defaultUsers.nix
   ];

  # Packages
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    lm_sensors
    dhcpcd
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    gcc
    btop
    screen
    bat
    sapling
    nm-applet
    i3
    lightdm
  ];


  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      lightdm = {
        enable = true;
        greeters.slick.enable = true;
      };
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };

  # Networking
  networking.networkmanager.enable = true;
  users.users.bones.extraGroups = [ "networkmanager" ];
  networking.networkmanager.wifi.powersave = true;

  # System
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";



}
