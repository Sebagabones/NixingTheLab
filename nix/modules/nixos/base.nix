{ modulesPath, config, lib, pkgs, inputs, nixpkgs, flake, home-manager, ... }: {

  imports = [
    inputs.lollypops.nixosModules.default
    inputs.catppuccin.nixosModules.catppuccin
    flake.nixosModules.podman
    flake.nixosModules.builders
    ./theming.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    grub.enable = false;
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "archiver-3.5.1" ];
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
  networking.hosts = { "127.0.0.1" = [ "${config.networking.hostName}" ]; };
  # Users
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      min-free = 100 * 1024 * 1024;
      max-free = 1024 * 1024 * 1024;
      max-jobs = "auto";
      cores = 0;
    };
    gc = {
      automatic = true;
      randomizedDelaySec = "1800";
      options = "--delete-older-than 18d";
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMojSoe7FKyrInx8Wqiu3C6vVKJwraI8znT1c+2pm9a+ bones@bonesboundhome"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbb35UUZb29bK6mv+LnHyfnhUtX9n7952K8RCpWxq1Q bones@resuscitated"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBt1AaEyY9HIs6qhdW7IrlpWiCTWdm8gqblW6Hvu1naU bones@insanity"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwmEjBMtkztDKVI7BHWhfgfGDxi0W5foZVn/f+/NTPh bones@pandemonium"
      ];
    };

    users.bones = {
      isNormalUser = true;
      home = "/home/bones";
      description = "Seb Gazey";
      extraGroups =
        [ "qemu-libvirtd" "libvirtd" "wheel" "networkmanager" "podman" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBt1AaEyY9HIs6qhdW7IrlpWiCTWdm8gqblW6Hvu1naU bones@insanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoMUhlkQdS+hGjOJhqa9jUE9x2E4i00+aWtQd0sk3F+ bones@bonesrunhome.lab.mahoosively.gay"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMojSoe7FKyrInx8Wqiu3C6vVKJwraI8znT1c+2pm9a+ bones@bonesboundhome"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbb35UUZb29bK6mv+LnHyfnhUtX9n7952K8RCpWxq1Q bones@resuscitated"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwmEjBMtkztDKVI7BHWhfgfGDxi0W5foZVn/f+/NTPh bones@pandemonium"
      ];
      hashedPassword =
        "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
    };
  };

  # GPG things
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty.terminfo
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
  ];
  programs.zsh.enable = true;
  # programs.fish.useBabelfish = true;

  # System
  time.timeZone = "Australia/Perth";
  hardware.enableAllFirmware = true;
  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin =
        "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  # Nix Settings
  nix.settings = { download-buffer-size = 671088640; };

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
  home-manager.backupFileExtension = "backup";
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    fira-code-symbols
    fira-code
  ];

  stylix.enable = true;

  environment.pathsToLink =
    [ "/share/zsh" ]; # gets ZSH completion for system packages (e.g. systemd).
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
  programs.direnv = { enable = true; };

}
