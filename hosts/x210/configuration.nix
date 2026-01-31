{
  flake,
  inputs,
  lib,
  perSystem,
  pkgs,
  nixpkgs,
  config,
  ...
}:
{
  networking.hostName = "x210";
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    flake.nixosModules.gui
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/meteor-lake"
    "${inputs.nixos-hardware}/common/gpu/intel/meteor-lake"

  ];
  nix.distributedBuilds = false;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = "  builders-use-substitutes = true\n";

  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaWtBEVSXHRwujQDE0mgFwtTDNAU+rIlyt3HCGCKn2q"; # needs to be updated
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets";

  };
  rekey.secrets = { };
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_usb_sdmmc"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [
    "kvm_intel"
  ];

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     # CPU_MIN_PERF_ON_BAT = 0;
  #     # CPU_MAX_PERF_ON_BAT = 50;
  #     #Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 95; # 80 and above it stops charging
  #   };
  # };

  lollypops.deployment.group = "Personal";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  stylix.enable = true;
}
