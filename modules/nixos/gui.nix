{
  lib,
  pkgs,
  inputs,
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

  stylix = {
    image = ../../assests/background.png;
    targets.qt = {
      enable = true;
    };
    cursor = {
      package = pkgs.banana-cursor;
      name = "Banana";
      size = 32;
    };
  };
  # services.gnome.gcr-ssh-agent.enable = false;
  programs = {
    dconf.enable = true;
    xwayland.enable = true;
    ssh = {
      startAgent = true;
      askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
      enableAskPassword = true;
    };
    mango = {
      enable = false;
      addLoginEntry = true;
    };
    foot = {
      enable = true;
      theme = "tokyonight-night";
      enableZshIntegration = true;
      xdg.serverAutostart = true;
      settings = {
        main = {
          font = "Berkeley Mono";
          bold-text-in-bright = "no";
          dpi-aware = "yes";
          box-drawings-uses-font-glyphs = "no"; # Maybe enable this? idk
        };
        scrollback = {
          lines = 100000;
        };
        mouse.hide-when-typing = "yes";
        # colors.alpha = "0.99";
      };
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
          colormix_col1 = "0x00CBA6F7";
          colormix_col2 = "0X0074C7EC";
          colormix_col3 = "0x0011111B";
          bg = "0x0011111B";
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

    desktopManager.plasma6.enable = true;

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
    udev.packages = [
      pkgs.platformio-core.udev
      pkgs.openocd
    ]; # ELEC3020
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    xremap = {
      # NOTE: not locked to a specific DE - useful as miracle-wm doesn't wlroots lol
      # LMAO, looks like this doesnt work on gnome - fix it sometime
      enable = true;
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
  };
  networking = {
    useDHCP = true;
  };

}
