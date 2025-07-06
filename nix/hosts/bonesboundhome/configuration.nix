{ flake, inputs, lib, perSystem, pkgs, nixpkgs, ... }: {
  networking.hostName = "bonesboundhome";
  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/sandy-bridge"
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/common/pc/hdd"
    "${inputs.nixos-hardware}/common/pc"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
       perSystem.self.fancontrol
      ];

    nixpkgs.config.allowUnfree = true;

    # Networking
    networking.firewall = {
      enable = false;
      allowedTCPPorts = [ 8909 9090 ];
      allowedUDPPorts = [ 8909 9090 ];
    };


  boot.kernelModules = [ "mgag200" ]; # we love the Matrox G200
  # Packages
  # environment.systemPackages = with pkgs; [
  # ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.dbus.enable = true;

  # Networking

  lollypops.deployment.group = "Servers";
  # home-manager.backupFileExtension = "backup";

  stylix.enable = true;
}
