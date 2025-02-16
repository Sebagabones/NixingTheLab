{ modulesPath, lib, pkgs, nixpkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./../../diskConfig.nix
    ./../../pkgs/fanControl/default.nix
    ./../defaults.nix
    ./vms/boneswebhome.nix
    # ./vms/bonesdevhome.nix
  ];



  config = {
  #   nixConfig = {
  #     extra-substituters = [ "https://microvm.cachix.org" ];
  #     extra-trusted-public-keys = [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  #   };

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    # efiInstallAsRemovable = true;
  };

  # Networking
  systemd.network.networks."5-lan" = {
    matchConfig.Name = ["eno2" "eno4"];
    networkConfig = {
      # Name = ["eno2" "eno4"];
      Gateway = "192.168.1.1";
      DNS = [ "192.168.1.2" ];
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
      linkConfig.RequiredForOnline = "no";
  };

  systemd.network.networks."10-lan" = {
    matchConfig.Name = [ "eno5" "vm-*" ];
    networkConfig = { Bridge = "br0"; };
  };

  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = [ "192.168.1.150/24"];
      Gateway = "192.168.1.1";
      DNS = [ "192.168.1.2" ];
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };



  # SSH
  services.openssh.ports = [ 8909 ];

  environment.systemPackages = with pkgs; [
    lazygit                     # This is here to make sure defaults works as expected, at some point move to default install packages for dev machines probably
  ];

  # Networking
  networking.hostName = "bonesboundhome";

  system.stateVersion = "24.11";

  # VMs
  microvm.autostart = [
    "boneswebhome"
    # "bonesdevhome"
  ];

  };

}
