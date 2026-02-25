{
  flake,
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  networking.hostName = "deposition";
  networking.domain = "lab.mahoosively.gay";
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    ./disk.nix
    ./klipper.nix
    "${inputs.nixos-hardware}/common/pc/ssd"
  ];

  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBT6wiyDEWiXUrips2uj1Bk9IQGsQFHlFg9sXpm0ghcD";
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets/";
  };
  age.secrets = {
    wifi.rekeyFile = ../../secrets/wifi.age;
  };
  nix = {
    distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    extraOptions = "  builders-use-substitutes = true\n";
    settings.max-jobs = lib.mkForce 0;
  };
  boot = {
    initrd.availableKernelModules = [
      "uhci_hcd"
      "ehci_pci"
      "ahci"
      "firewire_ohci"
      "usb_storage"
      "sd_mod"
      "sr_mod"
      "sdhci_pci"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader.grub = {
      enable = true;
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Networking
  networking = {

    nameservers = [ "192.168.1.1" ];
    networkmanager = {
      enable = true;
      wifi.powersave = true;
      ensureProfiles = {
        environmentFiles = [
          config.age.secrets.wifi.path
        ];
        profiles = {
          definitelyNotRunningAServerHere = {
            connection = {
              id = "definitelyNotRunningAServerHere";
              type = "wifi";
            };
            ipv4 = {
              method = "auto";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "definitelyNotRunningAServerHere";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$DEFINITELYNOTRUNNINGASERVERHERE_PSK";
            };
          };
        };
      };
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [
        5876
        8080
        80
        443
        9090
      ];
      allowedUDPPorts = [
        5876
        80
        443
        8080
        9090
      ];
    };
  };

  # SSH
  services.openssh = {
    ports = [ 5876 ];
    openFirewall = true;
    listenAddresses = [
      # {
      #   addr = "192.168.1.117";
      #   port = 8909;
      # }
      {
        addr = "0.0.0.0";
        port = 5876;
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    xterm
    avrdude
    klipper-genconf
    klipper-estimator
    klipper-firmware
    super-slicer
  ];

  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.dbus.enable = true;

  lollypops.deployment = {
    group = "Servers";
    ssh.opts = [ " -p 5876" ];
  };

  stylix.enable = true;
  services.moonraker = {
    user = "root";
    enable = true;
    address = "0.0.0.0";
    settings = {
      octoprint_compat = { };
      history = { };
      authorization = {
        force_logins = false;
        cors_domains = [
          "*.local"
          "*.lan"
          "*://app.fluidd.xyz"
          "*://my.mainsail.xyz"
          "*.lab.mahoosively.gay"
        ];
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.1.0/24"
          "FE80::/10"
          "::1/128"
        ];
      };
    };
  };
  services.fluidd.enable = true;
  services.fluidd.nginx.locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
  services.nginx.clientMaxBodySize = "1000m";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.getty = {
    autologinUser = "bones";
    autologinOnce = true;
  };
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 100;

      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 75;

    };
  };
  systemd.services.ModemManager.enable = false;
  systemd.services."dbus-org.freedesktop.ModemManager1".enable = false;

}
