{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.xremap-flake.nixosModules.default
    inputs.mangowm.nixosModules.mango
    ./theming.nix
  ];
  environment.systemPackages = with pkgs; [
    # pinentry-gnome3
    nextdns
  ];
  nixpkgs.overlays = [ ];
  stylix = {
    # image = ../../assests/background.png;
    image = ../../assests/CatsWithNix.png;

    targets = {
      qt = {
        enable = true;
      };
    };
    cursor = {
      package = pkgs.banana-cursor;
      name = "Banana";
      size = 32;
    };
  };
  # services.gnome.gcr-ssh-agent.enable = true;
  programs = {
    dconf.enable = true;
    xwayland.enable = true;
    ssh = {
      startAgent = true;
      # askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
      enableAskPassword = true;
    };
    mango = {
      # package = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (
      #   finalAttrs: previousAttrs: {
      #     patches = (previousAttrs.patches or [ ]) ++ [
      #       (pkgs.fetchpatch {
      #         url = "https://patch-diff.githubusercontent.com/raw/mangowm/mango/pull/676.diff";
      #         hash = "sha256-wRQiF2BHFHEipeU3K2gtBgm/Xr+oz9KfETJgCfttaoI=";
      #       })
      #     ];
      #     buildInputs = (previousAttrs.buildInputs or [ ]) ++ [
      #       pkgs.cjson
      #     ];
      #     # This was done at version = "0.14.0", applying this https://github.com/mangowm/mango/pull/676 ;
      #   }
      # );
      enable = true;
      addLoginEntry = true;
    };
    foot = {
      enable = true;
      # theme = "tokyonight-night";
      enableZshIntegration = true;
      xdg.serverAutostart = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
  };

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  # Packages

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
  # systemd.services.lyu  {
  #   # this service is "wanted by" (see systemd man pages, or other tutorials) the system
  #   # level that allows multiple users to login and interact with the machine non-graphically
  #   # (see the Red Hat tutorial or Arch Linux Wiki for more information on what each target means)
  #   # this is the "node" in the systemd dependency graph that will run the service
  #   wantedBy = [ "multi-user.target" ];
  #   # systemd service unit declarations involve specifying dependencies and order of execution
  #   # of systemd nodes; here we are saying that we want our service to start after the network has
  #   # set up (as our IRC client needs to relay over the network)
  #   after = [
  #     "systemd-user-sessions.service"
  #     "plymouth-quit-wait.service"
  #     "getty@%i.service"
  #   ];
  #   conflicts = "getty@%i.service";
  #   description = "TUI display manager";
  #   serviceConfig = {
  #     # see systemd man pages for more information on the various options for "Type": "notify"
  #     # specifies that this is a service that waits for notification from its predecessor (declared in
  #     # `after=`) before starting
  #     Type = "idle";
  #     # username that systemd will look for; if it exists, it will start a service associated with that user
  #     User = "username";
  #     # the command to execute when the service starts up
  #     # ExecStart = "${pkgs.screen}/bin/screen -dmS irc ${pkgs.irssi}/bin/irssi";
  #     ExecStart = "exec ${pkgs.kmscon}/bin/kmscon --vt=%I --seats=seat0 --no-drm --login -- ${pkgs.ly}/bin/ly --use-kmscon-vt";
  #     StandardInput = "tty";
  #     TTYPath = "/dev/%I";
  #     TTYReset = "yes";
  #     TTYVHangup = "yes";
  #   };
  # };
  systemd.services = {
    display-manager = {
      wants = [ "systemd-udev-settle.service" ];
      after = [ "systemd-udev-settle.service" ];

      serviceConfig = {
        UtmpIdentifier = "tty1";
        TTYVTDisallocate = "yes";
      };
    };
  };
  i18n.defaultLocale = "en_AU.UTF-8";
  environment.variables = {
    LANG = "en_AU.UTF-8";
    LC_ALL = "en_AU.UTF-8";
  };

  services = {
    kmscon = {
      enable = true;
      hwRender = true;
      useXkbConfig = true;
      fonts = [
        {
          name = "Berkeley Mono";
          package = pkgs.callPackage ../../packages/BerkeleyMono { inherit pkgs; };
        }
      ];

      extraConfig = ''
        font-engine=pango
        font-size=32
      '';
    };
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
    };
    displayManager = {
      enable = true;
      defaultSession = "mango";

      ly = {
        enable = true;
        settings = {
          full_color = true;
          animation = "colormix";
          animation_frame_delay = 50;
          colormix_col1 = "0x00${config.lib.stylix.colors.base0E}";
          colormix_col2 = "0X00${config.lib.stylix.colors.base0D}";
          colormix_col3 = "0x00${config.lib.stylix.colors.base00}";
          bg = "0x00${config.lib.stylix.colors.base00}";
          auth_fails = 3;
          hide_version_string = true;
          initial_info_text = "Still Alive Huh?";
        };
      };

      generic.execCmd = lib.mkForce ''
        exec ${pkgs.kmscon}/bin/kmscon \
          --font-engine pango \
          --font-name "Berkeley Mono" \
          --font-size 32 \
          --vt=1 \
          --login \
          -- \
          ${pkgs.ly}/bin/ly --use-kmscon-vt
      '';
    };

    desktopManager.plasma6.enable = false;

    dbus = {
      enable = true;
      # packages = [ pkgs.gcr ]; # allegedly helps with gnome pinentry
    };

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    libinput.enable = true;

    # blueman.enable = true;
    # udev.packages = [
    #   pkgs.platformio-core.udev
    #   pkgs.openocd
    # ]; # ELEC3020
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      startWhenNeeded = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    xremap = {
      # NOTE: not locked to a specific DE - useful as miracle-wm doesn't wlroots lol
      # LMAO, looks like this doesnt work on gnome - fix it sometime
      enable = false;
      serviceMode = "user";
      userName = "bones";
      config.modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "Ctrl";
          }; # globally remap CapsLock to Ctrl
        }
      ];
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;

    static-web-server =
      let # static webpage for firefox to load to as homepage
        indexHtml = pkgs.writeTextDir "index.html" ''
          <html>
            <body style="background-color:${config.lib.stylix.colors.withHashtag.base00}"></body>
          </html>
        '';
      in
      {
        enable = true;
        listen = "127.0.0.1:8231";
        root = indexHtml;
      };

    # logind = {
    #   enable = true;
    #   settings = {
    #     # Login = {
    #     #   HandleLidSwitch = "ignore";
    #     #   HandleLidSwitchExternalPower = "ignore";
    #     #   HandleLidSwitchDocked = "ignore";
    #     # };
    #   };
    # };
  };
  networking = {
    # useDHCP = true;
    networkmanager.enable = true;
  };

}
