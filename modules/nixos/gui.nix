{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.mangowm.nixosModules.mango
    inputs.xremap-flake.nixosModules.default
    ./theming.nix
  ];
  environment.systemPackages = with pkgs; [
    # pinentry-gnome3
    nextdns
  ];
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
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
      # startAgent = true;
      # askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
      enableAskPassword = true;
    };
    mango = {
      # package =
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
    pam.services.login.enableGnomeKeyring = true;
  };

  i18n.defaultLocale = "en_AU.UTF-8";
  environment.variables = {
    LANG = "en_AU.UTF-8";
    LC_ALL = "en_AU.UTF-8";
  };

  services = {
    seatd.enable = true;
    # kmscon = {
    #   enable = true;

    #       useXkbConfig = true;

    #       config = {
    #     font-engine = "pango";
    #     font-size = lib.mkForce 32;
    #     font-name = "Berkeley Mono";
    #     hwaccel = true;
    #   };
    # };
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
    };
    displayManager = {
      enable = true;
      ly =
        let
          # TODO: Set this up with stylix
          BLACK = "1A1B2A";
          DARK_RED = "7199EE";
          DARK_GREEN = "87AF5F";
          DARK_YELLOW = "D7AF87";
          DARK_BLUE = "8787AF";
          DARK_MAGENTA = "BD53A5";
          DARK_CYAN = "5FAFAF";
          LIGHT_GRAY = "E5E5E5";
          DARK_GRAY = "2B2B2B";
          RED = "BB9AF7";
          GREEN = "98E34D";
          YELLOW = "FFD75F";
          BLUE = "7373C9";
          MAGENTA = "D633B2";
          CYAN = "44C9C9";
          WHITE = "FFFFFF";
          setPalette = pkgs.writeShellScript "ly-palette" ''
              # if [ "$TERM" = "linux" ]; then

                 	COLORS="${BLACK} ${DARK_RED} ${DARK_GREEN} ${DARK_YELLOW} ${DARK_BLUE} ${DARK_MAGENTA} ${DARK_CYAN} ${LIGHT_GRAY} ${DARK_GRAY} ${RED} ${GREEN} ${YELLOW} ${BLUE} ${MAGENTA} ${CYAN} ${WHITE}"

                 	i=0
            	while [ $i -lt 16 ]; do
            		printf "\033]P%x%s" ''${i} "$(echo "$COLORS" | cut -d ' ' -f$(( i + 1)))"

                 		i=$(( i + 1 ))
            	done

                 	clear # for fixing background artifacting after changing color
              # fi
          '';
        in
        {
          x11Support = false;
          enable = true;
          settings = {
            use_kmscon_vt = true;
            start_cmd = "${setPalette}";
            full_color = true;
            animation = "colormix";
            animation_frame_delay = 50;
            # colormix_col1 = "0x0087AF5F";
            # colormix_col2 = "0x00BD53A5";
            # colormix_col3 = "0x008787AF";
            # bg = "0x00";
            auth_fails = 3;
            hide_version_string = true;
            initial_info_text = "Still Alive Huh?";
          };
        };
      # generic.execCmd = lib.mkForce ''
      #   exec ${pkgs.kmscon}/bin/kmscon --term=linux --font-engine unifont --vt=tty1 --login -- /run/current-system/sw/bin/ly --use-kmscon-vt
      # '';
    };

    # desktopManager.plasma6.enable = false;

    dbus = {
      enable = true;
      # packages = [ pkgs.gcr ]; # allegedly helps with gnome pinentry
    };
    gnome.gnome-keyring.enable = true;
    # pulseaudio.enable = false;
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
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
    xremap = {
      # TODO: Look into setting up https://github.com/xremap/xremap/blob/master/example/emacs.yml
      withWlroots = true;
      enable = true;
      config.modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "LeftCtrl";
            # "LeftCtrl" = "CapsLock";
            "Menu" = "Tab";
          };
        }
      ];
    };
  };
  networking = {
    # useDHCP = true;
    networkmanager.enable = true;
  };

}
