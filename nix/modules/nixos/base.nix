{ modulesPath, config, lib, pkgs, inputs, nixpkgs, home-manager, ... }: {

  imports = [
    inputs.lollypops.nixosModules.lollypops
    inputs.xremap-flake.nixosModules.default
    ./theming.nix
  ];

  # Lollypops
  # Generate lollypops deployment configurations for all hosts
  lollypops.deployment = {
    config-dir = "/var/src/lollypops";
    deploy-method = "copy";
    ssh.host = "${config.networking.hostName}";
    sudo.enable = false;
  };
  # Hostname
  networking.hosts = { "127.0.0.1" = [ "${config.networking.hostName}" ]; };
  # Users
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  nix = {
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
      options = "--delete-older-than 7d";
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
      ];
    };

    users.bones = {
      isNormalUser = true;
      home = "/home/bones";
      description = "Seb Gazey";
      extraGroups = [ "qemu-libvirtd" "libvirtd" "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBt1AaEyY9HIs6qhdW7IrlpWiCTWdm8gqblW6Hvu1naU bones@insanity"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoMUhlkQdS+hGjOJhqa9jUE9x2E4i00+aWtQd0sk3F+ bones@bonesrunhome.lab.mahoosively.gay"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMojSoe7FKyrInx8Wqiu3C6vVKJwraI8znT1c+2pm9a+ bones@bonesboundhome"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbb35UUZb29bK6mv+LnHyfnhUtX9n7952K8RCpWxq1Q bones@resuscitated"
      ];
      hashedPassword =
        "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
    };
  };

  # Packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "archiver-3.5.1" ];
  };

  environment.systemPackages = with pkgs; [
    ghostty.terminfo
    zsh
    curl
    dhcpcd
    lm_sensors
    gcc
    grc
    wget
    screen
    uutils-coreutils
    # fishPlugins.done
    # fishPlugins.grc
    # fishPlugins.fzf-fish
    # fishPlugins.forgit
    # fishPlugins.hydro
    ripgrep
    bat
    git
    fd
    btop
    nixfmt-classic # move this to emacs when you have set it up
    sqlite
  ];
  programs.zsh.enable = true;
  # programs.fish.useBabelfish = true;

  # System
  time.timeZone = "Australia/Perth";
  hardware.enableRedistributableFirmware = true;
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
  ];

  stylix.enable = true;

  environment.pathsToLink =
    [ "/share/zsh" ]; # gets ZSH completion for system packages (e.g. systemd).
  # Services
  services.xremap = {
    # NOTE: not locked to a specific DE - useful as miracle-wm doesn't wlroots lol
    serviceMode = "user";
    userName = "bones";
    config.modmap = [{
      name = "Global";
      remap = { "CapsLock" = "Ctrl"; }; # globally remap CapsLock to Ctrl
    }];
  };
}
