{ flake, inputs, lib, perSystem, pkgs, nixpkgs, ... }: {
  networking.hostName = "rocinante";
  networking.domain = "lab.mahoosively.gay";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/broadwell"
    "${inputs.nixos-hardware}/common/pc/ssd"
    # "${inputs.nixos-hardware}/common/pc"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  systemd.network = { enable = true; };
  networking.useDHCP = false;
  networking.nameservers = [ "192.168.1.1" ];
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;

  # SSH
  services.openssh = {

    ports = [ 1621 ];
    openFirewall = true;
    listenAddresses = [
      # {
      #   addr = "192.168.1.117";
      #   port = 8909;
      # }
      {
        addr = "0.0.0.0";
        port = 1621;
      }
    ];
  };

  environment.systemPackages = with pkgs; [ ];

  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 1621 9090 ];
    allowedUDPPorts = [ 1621 9090 ];
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
    ssh.opts = [ " -p 1621" ];
  };
  home-manager.backupFileExtension = "backup";

  stylix.enable = true;
}
