{ modulesPath, lib, pkgs, nixpkgs, home-manager, ... }:

{
  imports = [ ./defaultUsers.nix ./defaultsAll.nix ];

  # Networking
  systemd.network.enable = true;
  networking.useNetworkd = true;

}
