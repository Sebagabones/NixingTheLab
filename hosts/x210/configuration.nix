{
  flake,
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxr05SaTIbofegcG8i63h61rmqymTtmfZbdqYBhmyNs";
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets";
  };

  age = {
    secrets = {
      wireless = {
        rekeyFile = ../../secrets/wifi.age;
        owner = "wpa_supplicant";
        group = "wpa_supplicant";
        mode = "0440";
      };
    };
  };
  networking.hostName = "x210";
  networking = {
    networkmanager = {
      enable = lib.mkForce false;
      wifi.powersave = true;
    };
    wireless = {
      secretsFile = config.age.secrets.wireless.path;
      enable = true;
      userControlled = true;
      networks = {
        "definitelyNotRunningAServerHere" = {
          priority = 30;
          authProtocols = [ "WPA-PSK" ];
          pskRaw = "ext:definitelyNotRunningAServerHere";
        };
        "UCC-5" = {
          priority = 3;
          authProtocols = [ "WPA-EAP" ];
          auth = ''
            eap=PEAP
            scan_ssid=1
            identity="bones"
            phase1="peaplabel=0"
            phase2="auth=MSCHAPV2"
            password=ext:pass_UCC5
          '';
        };
        "Unifi" = {
          priority = 1;
          authProtocols = [ "WPA-EAP" ];
          auth = ''
            scan_ssid=1
            eap=PEAP
            identity="23417131@student.uwa.edu.au"
            phase1="peaplabel=0"
            phase2="auth=MSCHAPV2"
            password=ext:pass_unifi
          '';
        };
      };
    };
    # useDHCP = true;
    useNetworkd = true;
  };
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.firewall = {
    enable = false;
  };

  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  systemd.services.cups-browsed.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  systemd.tpm2.enable = false;
  systemd.oomd.enable = false;
  services.mpd.startWhenNeeded = true;
  services.openssh.startWhenNeeded = true;
  services.system76-scheduler.enable = true;

  # If sleep breaks, this will eb why
  # systemd.sleep.settings.Sleep = {
  #
  #   AllowSuspend = "yes";
  #   AllowSuspendThenHibernate = "yes";
  #   AllowHibernation = "yes";
  #   MemorySleepMode = "deep";
  #   HibernateDelaySec = "1m";
  # };

  imports = [
    flake.nixosModules.base
    flake.nixosModules.gui
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/meteor-lake"
    "${inputs.nixos-hardware}/common/gpu/intel/meteor-lake"

  ];
  # nix = {
  #   # distributedBuilds = false;
  #   # optional, useful when the builder has a faster internet connection than yours
  #   extraOptions = "  builders-use-substitutes = true\n";
  # };
  environment.systemPackages = with pkgs; [
    wpa_supplicant_gui
  ];
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
  # boot.kernelParams = [ "mem_sleep_default=deep" ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
  services.displayManager.hiddenUsers = [ "lauren" ];
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
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # ControllerMode = "dual";
        # FastConnectable = true;
        Experimental = true;
      };
    };
  };
  # services.blueman.enable = true;
  stylix.enable = true;
  # services.nextdns = {
  #
  #   enable = true;
  #   arguments = [
  #     "-config"
  #     "c369fa"
  #     "-cache-size"
  #     "10MB"
  #   ];
  #
  # };
  # systemd.services.nextdns-activate = {
  #   script = ''
  #     /run/current-system/sw/bin/nextdns activate
  #   '';
  #   after = [ "nextdns.service" ];
  #   wantedBy = [ "multi-user.target" ];
  # };

  nix = {
    distributedBuilds = false; # You will probably need to set this to true to use the below:
    extraOptions = "  builders-use-substitutes = true\n";
    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        system = "aarch64-linux";
        maxJobs = 100;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
      {
        hostName = "eu.nixbuild.net";
        system = "armv7l-linux";
        maxJobs = 100;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
    ];
  };

  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
    PubkeyAcceptedKeyTypes ssh-ed25519
    ServerAliveInterval 60
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

}
