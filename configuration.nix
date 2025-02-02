{ modulesPath, lib, pkgs, ... }:


{

  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ./disk-config.nix  ./pkgs/fanControl/fanControl.nix];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # SSH
  services.openssh = {
    enable = true;
    ports = [ 8909 ];
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin =
        "yes"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "bonesboundhome";
  networking.domain = "lab.mahoosively.gay";
  networking.defaultGateway = "192.168.1.1";

  #My pkgs




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
  ];

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  # Users
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

    ];
    hashedPassword =
      "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
  };

  system.stateVersion = "24.11";
}
