{ flake, inputs, lib, perSystem, pkgs, nixpkgs, config, ... }:
let
  zfsCompatibleKernelPackages = lib.filterAttrs (name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken))
    pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last
    (lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version))
      (builtins.attrValues zfsCompatibleKernelPackages));
in {
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

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = latestKernelPackage;
    kernelModules = [ "mgag200" ]; # we love the Matrox G200

  };

  fileSystems = {
    "/storage/main" = {
      device = "zdata/storage/main";
      fsType = "zfs";
    };
    "/storage/immich" = {
      device = "zdata/storage/immich";
      fsType = "zfs";
    };
    "/storage/git" = {
      device = "zdata/storage/git";
      fsType = "zfs";
    };
  };
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
    listenAddresses = [{
      addr = "0.0.0.0";
      port = 1621;
    }];
  };

  environment.systemPackages = with pkgs; [ ];

  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 1621 9090 ];
    allowedUDPPorts = [ 1621 9090 ];
  };

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
