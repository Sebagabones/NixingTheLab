{ flake, inputs, lib, perSystem, pkgs, nixpkgs, config, ... }:
let
  sshPort = 8909;

  zfsCompatibleKernelPackages = lib.filterAttrs (name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken))
    pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last
    (lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version))
      (builtins.attrValues zfsCompatibleKernelPackages));
in {
  networking = {
    hostName = "rocinante";
    hostId = "52006401";
    domain = "lab.mahoosively.gay";
  };
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/broadwell"
    "${inputs.nixos-hardware}/common/pc/ssd"
    # "${inputs.nixos-hardware}/common/pc"
  ];

  age.rekey = {
    hostPubkey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaWtBEVSXHRwujQDE0mgFwtTDNAU+rIlyt3HCGCKn2q"; # needs to be updated
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets";

  };
  rekey.secrets = { };
  boot = {
    zfs = {
      devNodes = "/dev/disk/by-uuid";
      extraPools = [ "zroot" "zdonttrust" ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "ata_piix"
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "aacraid"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      supportedFilesystems = [ "zfs" ];
    };

    supportedFilesystems = [ "zfs" ];
    kernelPackages = latestKernelPackage;
    kernelModules = [ "mgag200" "kvm-intel" ]; # we love the Matrox G200
  };

  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  fileSystems = {
    "/storage/main" = {
      device = "zdata/mainStorage";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/storage/immich" = {
      device = "zdata/immich";
      fsType = "zfs";
      options = [ "zfsutil" ];

    };
    "/storage/git" = {
      device = "zdata/git";
      fsType = "zfs";
      options = [ "zfsutil" ];

    };
  };
  fileSystems."/donttrust" = {
    device = "zdonttrust";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
  services.zfs.autoScrub = {
    enable = true;
    pools = [ "zdata" ];
  };
  # Networking
  systemd.network = { enable = true; };
  networking.useDHCP = false;
  networking.nameservers = [ "192.168.1.1" ];
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;

  # SSH
  services.openssh = {
    ports = [ sshPort ];
    openFirewall = true;
    listenAddresses = [{
      addr = "0.0.0.0";
      port = sshPort;
    }];
  };

  environment.systemPackages = with pkgs; [ ];

  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ sshPort ];
    allowedUDPPorts = [ sshPort ];
  };

  # Packages
  # environment.systemPackages = with pkgs; [
  # ];

  hardware = {
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.dbus.enable = true;

  lollypops.deployment = {
    group = "Servers";
    ssh.opts = [ " -p ${toString sshPort}" ];
  };

  stylix.enable = true;
}
