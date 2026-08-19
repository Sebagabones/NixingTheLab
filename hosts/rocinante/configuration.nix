{
  flake,
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  sshPort = 8909;

  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  nixpkgs.hostPlatform = "x86_64-linux";

  nixpkgs.pkgs = import inputs.nixpkgs {
    inherit (config.nixpkgs.hostPlatform) system;
    overlays = [
      inputs.emacs.overlays.default
      inputs.agenix-rekey.overlays.default
    ];
    config = {
      allowUnfree = true;
      cudaSupport = true;
      # cudaCapabilities = [ "8.0" ];
    };
  };
  networking = {
    hostName = "rocinante";
    hostId = "52006401";
    domain = "lab.mahoosively.gay";
  };

  system.stateVersion = "26.05";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/broadwell"
    "${inputs.nixos-hardware}/common/gpu/nvidia/pascal"
    "${inputs.nixos-hardware}/common/pc/ssd"
    # "${inputs.nixos-hardware}/common/pc"
  ];

  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaWtBEVSXHRwujQDE0mgFwtTDNAU+rIlyt3HCGCKn2q"; # needs to be updated
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets";
  };

  rekey.secrets = { };
  systemd.services."mdmonitor".environment = {
    MDADM_MONITOR_ARGS = "--scan --syslog";
  };

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = false;
      };
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
      systemd-boot.enable = false;
    };
    swraid = {
      enable = true;
      mdadmConf = ''
        HOMEHOST ${config.networking.hostName}
        MAILADDR=TODO@SetThisUp
      '';
    };

    zfs = {
      forceImportRoot = false;
      devNodes = "/dev/disk/by-id";
      extraPools = [
        "zroot"
        "zdata"
        "zdonttrust"
      ];
    };

    initrd = {
      systemd.enable = true;
      kernelModules = [
        "nvidia"
        "i915"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      availableKernelModules = [
        "ata_piix"
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "aacraid"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "mpt3sas"
      ];
      supportedFilesystems = [
        "zfs"
        "xfs"
      ];
    };

    supportedFilesystems = [
      "zfs"
      "xfs"
    ];
    kernelPackages = latestKernelPackage;
    kernelModules = [
      "mgag200"
      "kvm-intel"
    ]; # we love the Matrox G200
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.zfs = {
    autoScrub = {
      enable = true;
      pools = [
        "zdata"
        "zroot"
        "zdonttrust"
      ];
    };
    autoSnapshot = {
      enable = true;
    };
  };
  # Networking
  systemd.network = {
    enable = true;
  };
  networking.useDHCP = false;
  networking.nameservers = [ "192.168.1.1" ];
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;

  # SSH
  services.openssh = {
    ports = [ sshPort ];
    openFirewall = true;
    listenAddresses = [
      {
        addr = "0.0.0.0";
        port = sshPort;
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    gpu-burn
    nvtopPackages.nvidia
  ];

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
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.dbus.enable = true;

  lollypops.deployment = {
    group = "Servers";
    ssh.opts = [ " -p ${toString sshPort}" ];
  };

  stylix.enable = true;
}
