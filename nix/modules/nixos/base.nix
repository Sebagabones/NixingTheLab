{ modulesPath, config, lib, pkgs, inputs, nixpkgs, home-manager, ... }: {

  imports = [ inputs.lollypops.nixosModules.lollypops ];

  # Lollypops
  # Generate lollypops deployment configurations for all hosts
  lollypops.deployment = {
    config-dir = "/var/src/lollypops";
    deploy-method = "copy";
    ssh.host = "${config.networking.hostName}";
    ssh.user = "root";
    ssh.command = "ssh";
    ssh.opts = [ "-p" "22" ];
    sudo.enable = false;
  };

  # Users
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;

  users.users.root = {

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMojSoe7FKyrInx8Wqiu3C6vVKJwraI8znT1c+2pm9a+ bones@bonesboundhome"

    ];
  };
  users.users.bones = {
    isNormalUser = true;
    home = "/home/bones";
    description = "Seb Gazey";
    extraGroups = [ "qemu-libvirtd" "libvirtd" "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/tDV1v2CN6VqwEgq86fV5M9k7/L5pEFNbe1XYe28P+ bones@revitalised"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN12V+UEifCUlKMCvngUp96LgUrw/aDp0zKLgVnHJ0Op bones@sanity"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoMUhlkQdS+hGjOJhqa9jUE9x2E4i00+aWtQd0sk3F+ bones@bonesrunhome.lab.mahoosively.gay"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMojSoe7FKyrInx8Wqiu3C6vVKJwraI8znT1c+2pm9a+ bones@bonesboundhome"
    ];
    hashedPassword =
      "$y$j9T$ag5S35mvZrqGflNCwyFku/$vaAnqMkW1rY3IyCq7jyuuC.ErYpq1eQqhGXYmB23Gf4";
  };

  # Packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    lm_sensors
    dhcpcd
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    gcc
    btop
    screen
    bat
    ripgrep
    fd
    delta
    uutils-coreutils
  ];

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  # System
  time.timeZone = "Australia/Perth";

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

}
