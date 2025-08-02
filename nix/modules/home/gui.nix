{ flake, pkgs, perSystem, ... }:

{
  imports = [ flake.homeModules.miracle-wm ./theming.nix ];

  stylix = {
    targets = {
      bemenu = {
        enable = true;
        alternate = true;
      };
      firefox = {
        profileNames = [ "default" ];
        firefoxGnomeTheme.enable = true;
      };
    };

  };

  # programs.niri = {
  #   enable = true;
  # };

  programs.fuzzel = { enable = true; };
  # programs.bemenu = {
  #   enable = true;
  #   settings = {
  #     line-height = 28;
  #     prompt = "open";
  #     ignorecase = true;
  #     list = 5;
  #   };
  # };
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    enableZshIntegration = true;
    # enableFishIntegration = true;
    settings = {
      unfocused-split-opacity = 0.5;
      background-opacity = 0.9;
      window-padding-x = 4;
      window-padding-y = 4;
      window-padding-balance = true;
      window-padding-color = "extend";
      keybind = [
        "ctrl+shift+left=goto_split:left"
        "ctrl+shift+right=goto_split:right"
        "ctrl+shift+up=goto_split:up"
        "ctrl+shift+down=goto_split:down"
        "shift+left=previous_tab"
        "shift+right=next_tab"
        "ctrl+shift+]=new_split:down"
        "ctrl+shift+[=new_split:right"
      ];
      gtk-tabs-location = "right";
      gtk-adwaita = true;
      # window-decoration = false;
      # gtk-single-instance = true;
      adw-toolbar-style = "raised-border";
      window-theme = "ghostty";
    };
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "full-screen-api.ignore-widgets" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        "browser.startup.page" = 3; # load last visited
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "never";

        "browser.contentblocking.category" =
          "standard"; # not strict because it conflicts with adnauseam
        "layout.css.visited_links_enabled" = false;

        "signon.rememberSignons" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "browser.uidensity" = 0;
        "browser.tabs.inTitlebar" = 1;
        # "widget.gtk.rounded-bottom-corners.enabled" = true;
        "browser.theme.dark-private-windows" = false;

        "general.smoothScroll" = true;
      };
      extensions.packages = with perSystem.firefox-addons; [
        adnauseam
        # bitwarden
        lovely-forks
        react-devtools
        refined-github
        vimium
      ];
    };
  };

  programs.spotify-player = { enable = true; };
  programs.autorandr = { enable = true; };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        # position = "left";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ ];
        modules-right = [
          # "mpd"
          # "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "battery#bat2"
          "clock"
        ];

        "sway/mode" = { format = ''<span style="italic">{}</span>''; };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
          # scroll-step = 1;
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-disconnected = "󰖪";
          format-ethernet = "󰈀";
          tooltip = true;
          tooltip-format = "{signalStrength}%";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory = { format = "{}% "; };

        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
          # thermal-zone = 2;
          # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
          # device = "acpi_video1";
        };

        battery = {
          states = {
            warning = 45;
            critical = 20;
            # good = 95;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% 󱊦";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
          # format-good = "";
          # format-full = "";
        };

        "battery#bat2" = { bat = "BAT2"; };

        clock = {
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = "{:%Y-%m-%d}";
          # timezone = "America/New_York";
        };

      };
    };

  };
  programs.wofi = { enable = true; };
  home.packages = with pkgs; [
    # brightnessctl
    swaybg
    libinput
    pavucontrol
    spotify
    teams-for-linux
    discord
    networkmanagerapplet
    wlr-randr
    wl-clipboard
    brightnessctl
    libreoffice-qt6-fresh
    # kdePackages.dolphin
  ];

  # pointerCursor = {
  #   name = "Banana";
  #   size = 32;
  #   package = pkgs.banana-cursor;

  #   x11.enable = true;
  #   gtk.enable = true;
  # };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Banana";
      size = 32;
      package = pkgs.banana-cursor;
    };
  };

}
