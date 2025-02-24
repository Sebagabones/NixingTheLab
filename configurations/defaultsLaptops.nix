{ modulesPath, lib, pkgs, nixpkgs, ... }:

{
   # imports = [
   #   ./defaultUsers.nix
   # ];

  # Users
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
  ];

  users.users.bones = {
    isNormalUser = true;
    home = "/home/bones";
    description = "Seb Gazey";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoMUhlkQdS+hGjOJhqa9jUE9x2E4i00+aWtQd0sk3F+ bones@bonesrunhome.lab.mahoosively.gay"
    ];
    hashedPassword =
      "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
  };
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
    # sapling
    # networkmanagerapplet
    # i3
    # lightdm
    # bash
  ];


  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  # environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # services.xserver = {
  #   enable = true;

  #   desktopManager = {
  #     xterm.enable = false;
  #   };

  #   displayManager = {
  #     lightdm = {
  #       enable = true;
  #       greeters.slick.enable = true;
  #     };
  #   };

  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       dmenu #application launcher most people use
  #       i3status # gives you the default i3 status bar
  #       i3lock #default i3 screen locker
  #       i3blocks #if you are planning on using i3blocks over i3status
  #    ];
  #   };
  # };
  # services.displayManager.defaultSession = "none+i3";

  # Networking
  networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.powersave = true;

  # System
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";



}
