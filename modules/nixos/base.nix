{
  config,
  lib,
  pkgs,
  inputs,
  flake,
  ...
}:
{

  imports = [
    inputs.lollypops.nixosModules.default
    inputs.catppuccin.nixosModules.catppuccin
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    flake.nixosModules.podman
    flake.nixosModules.builders
    # inputs.determinate.nixosModules.default
    ./theming.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    grub.enable = false;
  };
  # Lollypops
  # Generate lollypops deployment configurations for all hosts
  lollypops.deployment = {
    config-dir = "/var/src/lollypops";
    deploy-method = "copy";
    ssh = {
      host = "${config.networking.hostName}";
      user = lib.mkDefault "root";
    };
    sudo.enable = false;
  };

  # Hostname
  networking.hosts = {
    "127.0.0.1" = [ "${config.networking.hostName}" ];
  };
  # Users
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      min-free = 100 * 1024 * 1024;
      max-free = 1024 * 1024 * 1024;
      max-jobs = "auto";
      cores = 0;
    };
    gc = {
      automatic = false;
      randomizedDelaySec = "1800";
      # options = "--delete-older-than +7";
      # TODO: Go look at https://git.scottworley.com/nix-profile-gc
    };
    optimise.automatic = true;
  };
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbb35UUZb29bK6mv+LnHyfnhUtX9n7952K8RCpWxq1Q bones@resuscitated"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBt1AaEyY9HIs6qhdW7IrlpWiCTWdm8gqblW6Hvu1naU bones@insanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6+WU+Zq90kEknj/hdU0T/oAX0quQojFxfZHe3tkP5L bones@pandemonium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0v56VlLL/6BNK8rNW+fIMIYSgTURqi2H9ZumDbudtL bones@x210"
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd/R+9O+PTJlJFCXD+dzHZl2+Hobu6DkyR1dc3Quvc3 root@x210" # TODO: may need to remove, testing with remote builders
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd/R+9O+PTJlJFCXD+dzHZl2+Hobu6DkyR1dc3Quvc3 root@x210"
      ];
    };

    users.bones = {
      isNormalUser = true;
      home = "/home/bones";
      description = "Seb Gazey";
      extraGroups = [
        "qemu-libvirtd"
        "libvirtd"
        "kvm"
        "wheel"
        "networkmanager"
        "wpa_supplicant"
        "podman"
        "plugdev"
        "dialout"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBt1AaEyY9HIs6qhdW7IrlpWiCTWdm8gqblW6Hvu1naU bones@insanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbb35UUZb29bK6mv+LnHyfnhUtX9n7952K8RCpWxq1Q bones@resuscitated"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6+WU+Zq90kEknj/hdU0T/oAX0quQojFxfZHe3tkP5L bones@pandemonium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0v56VlLL/6BNK8rNW+fIMIYSgTURqi2H9ZumDbudtL bones@x210"
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd/R+9O+PTJlJFCXD+dzHZl2+Hobu6DkyR1dc3Quvc3 root@x210" # TODO: may need to remove, testing with remote builders
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEr5q176XJAVnENyX9toOXp4fIZ7B0RKTF9Vh6yOYhxY bones@motsugo"
      ];
      hashedPassword = "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
    };
    users.lauren = {
      isNormalUser = true;
      home = "/home/lauren";
      description = "Lauren Pudney";
      extraGroups = [
        "qemu-libvirtd"
        "libvirtd"
        "kvm"
        "wheel"
        "networkmanager"
        "wpa_supplicant"
        "podman"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGchFYZLrQ2V3pTnRsXJ8sAZQ8zU3GPZTsaJ/nZulr15 lauren@sebisthebest"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEOFO+HMXrlRI0LttK+KVeKV/XuDy4Vvb8VpLTZkN0S lauren@pandemonium"
      ];
      hashedPassword = "$y$j9T$/Qj7yKmjZ775/eVyUcfOe1$eLVuG6FckmVT.tNOJZCqqqxwUZ.0GSApSVboIWHOdb2";
    };
  };
  services.udev.packages = [ pkgs.libphidget22 ];
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ACTION=="add", ATTRS{idVendor}=="06c2", ATTRS{idProduct}=="00[3-a][0-f]", MODE="666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"
  '';
  # GPG things
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  environment = {
    pathsToLink = [ "/share/zsh" ]; # gets ZSH completion for system packages (e.g. systemd).
    sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet/";
    };
    systemPackages = with pkgs; [
      # ghostty.terminfo
      zsh
      curl
      dhcpcd
      lm_sensors
      gcc
      grc
      clang
      wget
      screen
      uutils-coreutils-noprefix
      ripgrep
      bat
      git
      fd
      btop
      sqlite
      pkg-config
      gnat
      lshw
      pciutils
    ];
  };
  programs.zsh.enable = true;
  programs.ssh = {
    # for remote building
    extraConfig = "
     Host deposition
       hostname deposition.lab.mahoosively.gay
       port 5876

     Host insanity
       hostname insanity.lab.mahoosively.gay
       port 22
       proxyJump pandemonium

     Host pandemonium
       hostname mahoosively.gay
       port 7656

     Host rocinante
       hostname rocinante.lab.mahoosively.gay
       port 8909

     Host ucc
       hostname ssh.ucc.asn.au

     Host *
       addKeysToAgent no
       compression yes
       controlMaster no
       controlPath ~/.ssh/master-%r@%n:%p
       controlPersist no
       forwardAgent no
       hashKnownHosts no
       serverAliveCountMax 3
       serverAliveInterval 0
       userKnownHostsFile ~/.ssh/known_hosts
    ";
  };
  # programs.fish.useBabelfish = true;

  # System
  time.timeZone = "Australia/Perth";
  hardware.enableAllFirmware = true;
  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = true;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  # Nix Settings
  nix.settings = {
    download-buffer-size = 671088640;
    substituters = [ "http://cache.mahoosively.gay" ];
    trusted-public-keys = [ "cache.mahoosively.gay:VEmKWBBlwZmKaPeVvsfjZAdKPJkDh9Zqi2fdWl1gZQg=" ];
  };

  # Lollypops
  systemd.tmpfiles.settings = {
    "lollipops" = {
      "/var/src/lollypops" = {
        d = {
          group = "root";
          mode = "0755";
          user = "root";
        };
      };
    };
  };
  home-manager = {
    backupFileExtension = "backup";
  };
  fonts.packages = with pkgs; [
    xauth
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    fira-code-symbols
    fira-code
  ];

  stylix.enable = true;

  # Services

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libz
      libusb-compat-0_1
      # Add any missing dynamic libraries for unpackaged programs

      # here, NOT in environment.systemPackages

    ];
  };
  programs.direnv = {
    enable = true;
  };

}
