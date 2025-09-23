{ flake, inputs, lib, perSystem, pkgs, nixpkgs, ... }: {
  networking.hostName = "bonesboundhome";
  networking.domain = "lab.mahoosively.gay";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/sandy-bridge"
    "${inputs.nixos-hardware}/common/pc/ssd"
    # "${inputs.nixos-hardware}/common/pc"
  ];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = { efiSupport = true; };

  # Networking
  systemd.network = {
    enable = true;

    networks = {
      "10-lan" = {
        matchConfig.Name = [ "eno5" "vm-*" ];
        networkConfig.Bridge = "br0";
      };

      "br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };
  };

  networking = {
    useDHCP = false;
    nameservers = [ "192.168.1.1" ];
    interfaces = {
      eno2.useDHCP = true;
      eno3.useDHCP = true;
      eno5.useDHCP = true;
    };
  };

  # SSH
  services.openssh = {

    ports = [ 8909 ];
    openFirewall = true;
    listenAddresses = [
      # {
      #   addr = "192.168.1.117";
      #   port = 8909;
      # }
      {
        addr = "0.0.0.0";
        port = 8909;
      }
    ];
  };

  environment.systemPackages = with pkgs;
    [
      perSystem.self.fanControl # Fan control for the IBM servers
    ];

  systemd.services."fanControl" = {
    enable = true;
    after = [ "network.target" ];
    description = "Fan Speed Service";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${perSystem.self.fanControl}/bin/tempChecker";
      Restart = "always";
      RuntimeMaxSec = "30m";
      RestartSec = "1s";
      SyslogIdentifier = "fanControl";
      User = "root";
      Group = "root";
    };
    wantedBy = [ "multi-user.target" ];
  };

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

  lollypops.deployment = {
    group = "Servers";
    ssh.opts = [ " -p 8909" ];
  };
  home-manager.backupFileExtension = "backup";

  stylix.enable = true;
}
