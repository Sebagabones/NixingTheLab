{ modulesPath, lib, pkgs, nixpkgs, home-manager, ... }: {

  # Users
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMojSoe7FKyrInx8Wqiu3C6vVKJwraI8znT1c+2pm9a+ bones@bonesboundhome"

  ];

  users.users.bones = {
    isNormalUser = true;
    home = "/home/bones";
    description = "Seb Gazey";
    extraGroups = [ "qemu-libvirtd" "libvirtd" "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoMUhlkQdS+hGjOJhqa9jUE9x2E4i00+aWtQd0sk3F+ bones@bonesrunhome.lab.mahoosively.gay"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMojSoe7FKyrInx8Wqiu3C6vVKJwraI8znT1c+2pm9a+ bones@bonesboundhome"
    ];
    hashedPassword =
      "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
  };

  users.users.alech = {
    isNormalUser = true;
    home = "/home/alech";
    description = "Alec";
    extraGroups = [ "qemu-libvirtd" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHptYZoEd0jYsARmRZgqtqyD7+e4aNfTIX1PW7aA1XUI alech@Alecs-Macbook.modem"
    ];
    hashedPassword =
      "$y$j9T$Kp6CdprmJjT9dqFL7Czz//$ioBXcMKdjQN7uPGhRrpcdsmz5tPB0sSMFWRFAkPEIr9";
  };

}
