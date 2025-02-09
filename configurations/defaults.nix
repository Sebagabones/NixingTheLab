{ modulesPath, lib, pkgs, ... }:

{
  # Cockpit
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = { WebService = { AllowUnencrypted = true; }; };
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = ["root" "@wheel"];


  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin =
        "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
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
    cockpit
  ];
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;


  # Networking
  networking.networkmanager.enable = true;
  networking.domain = "lab.mahoosively.gay";
  networking.defaultGateway = "192.168.1.1";


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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoMUhlkQdS+hGjOJhqa9jUE9x2E4i00+aWtQd0sk3F+ bones@bonesrunhome.lab.mahoosively.gay"
    ];
    hashedPassword =
      "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
  };
}
