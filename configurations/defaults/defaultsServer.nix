{ modulesPath, lib, pkgs, nixpkgs, ... }:

{
   imports = [
     ./defaultUsers.nix
     ./defaultsAll.nix
   ];

  # Cockpit
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = { WebService = { AllowUnencrypted = true; }; };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    cockpit
  ];


  # Networking
  systemd.network.enable = true;
  networking.useNetworkd = true;

  # # Users
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nix.settings.trusted-users = [ "root" "@wheel" ];

  # users.mutableUsers = false;
  # users.defaultUserShell = pkgs.fish;

  # users.users.root.openssh.authorizedKeys.keys = [
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
  # ];

  # users.users.bones = {
  #   isNormalUser = true;
  #   home = "/home/bones";
  #   description = "Seb Gazey";
  #   extraGroups = [ "wheel" "networkmanager" ];
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoMUhlkQdS+hGjOJhqa9jUE9x2E4i00+aWtQd0sk3F+ bones@bonesrunhome.lab.mahoosively.gay"
  #   ];
  #   hashedPassword =
  #     "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
  # };
}
