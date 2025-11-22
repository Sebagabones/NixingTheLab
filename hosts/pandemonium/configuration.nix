{ flake, inputs, lib, perSystem, pkgs, nixpkgs, config, ... }:
let
  sshPort = 7656;
  sshPortString = "";
in {
  networking.hostName = "pandemonium";
  networking.domain = "lab.mahoosively.gay";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/skylake"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./website.nix

  ];
  age.rekey = {
    hostPubkey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3uJxriXS2Y22lRjah2eVWHu9GfKS8JkNbrYE2FXWZz";
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets/";
  };
  age.secrets = { secret1.rekeyFile = ../../secrets/secret1.age; };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot = {
    # swraid = {
    #   enable = true;
    #   mdadmConf = ''
    #     MAILADDR=TODO@SetThisUp
    #   '';
    # };
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "megaraid_sas"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" "mgag200" ];
    extraModulePackages = [ ];
  };
  networking.hostId = "f70e81b8";
  # Networking
  # systemd.network = {
  #   enable = true;
  #
  #   networks = {
  #     "10-lan" = {
  #       matchConfig.Name = [ "eno5" "vm-*" ];
  #       networkConfig.Bridge = "br0";
  #     };
  #
  #     "br0" = {
  #       netdevConfig = {
  #         Name = "br0";
  #         Kind = "bridge";
  #       };
  #     };
  #   };
  # };

  networking = {
    useDHCP = true;
    nameservers = [ "192.168.1.1" ];
    # interfaces = {
    #   eno2.useDHCP = true;
    #   eno3.useDHCP = true;
    #   eno5.useDHCP = true;
    # };
  };

  # SSH
  services.openssh = {

    ports = [ sshPort ];
    openFirewall = true;
    listenAddresses = [
      # {
      #   addr = "192.168.1.117";
      #   port = 8909;
      # }
      {
        addr = "0.0.0.0";
        port = sshPort;
      }
    ];
  };
  services.dbus.enable = true;

  systemd.services."mdmonitor".environment = {
    MDADM_MONITOR_ARGS = "--scan --syslog";
  };

  environment.systemPackages = with pkgs;
    [
      # perSystem.self.fanControl # Fan control for the IBM servers
    ];

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
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  lollypops.deployment = {
    group = "Servers";
    ssh.opts = [ " -p ${toString sshPort}" ];
  };
  home-manager.backupFileExtension = "backup";

  stylix.enable = true;
}
