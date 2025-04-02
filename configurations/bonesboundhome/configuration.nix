{ modulesPath, lib, pkgs, nixpkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./initialInstall/diskConfig.nix
    ./../../pkgs/fanControl/default.nix
    ./../defaults/defaultsServer.nix
    ./vms/boneswebhome.nix
    ./vms/nixtest.nix
    # ./vms/bonesdevhome.nix
  ];

  config = {
    boot.loader.grub = { efiSupport = true; };

    # Networking
    networking.useNetworkd = true;

    systemd.network = {
      enable = true;

      networks."10-lan" = {
        matchConfig.Name = [ "eno5" "vm-*" ];
        networkConfig.Bridge = "br0";
      };

      netdevs."br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };

    networking.useDHCP = false;

    networking.interfaces.eno2.useDHCP = true;
    networking.interfaces.eno3.useDHCP = true;
    networking.interfaces.eno5.useDHCP = true;

    # SSH
    services.openssh = {

      ports = [ 8909 ];
      openFirewall = true;
      listenAddresses = [
        {
          addr = "192.168.1.117";
          port = 8909;
        }
        {
          addr = "0.0.0.0";
          port = 8909;
        }
      ];
    };

    environment.systemPackages = with pkgs;
      [
        lazygit # This is here to make sure defaults works as expected, at some point move to default install packages for dev machines probably
      ];

    nixpkgs.config.allowUnfree = true;

    # Networking
    networking.hostName = "bonesboundhome";
    networking.firewall = {
      enable = false;
      allowedTCPPorts = [ 8909 9090 ];
      allowedUDPPorts = [ 8909 9090 ];
    };

    # VMs
    microvm.autostart = [
      "boneswebhome"
      # "bonesdevhome"
    ];
  };
}
