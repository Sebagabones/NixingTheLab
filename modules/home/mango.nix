{
  config,
  lib,
  pkgs,
  perSystem,
  inputs,
  ...
}:
let
  terminal = lib.getExe config.programs.foot.package;
  firefox = lib.getExe config.programs.firefox.package;
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.mangowm.hmModules.mango
  ];
  programs.bemenu.enable = true;

  wayland.windowManager.mango =
    # TODO: Sometime look into Axis Bindings with mouse
    # let
    #   mango_pkg = final: prev: {
    #     sl = prev.sl.overrideAttrs (old: {
    #       patches = (old.patches or [ ]) ++ [
    #         (prev.fetchpatch {
    #           url = "https://github.com/charlieLehman/sl/commit/e20abbd7e1ee26af53f34451a8f7ad79b27a4c0a.patch";
    #           hash = "07sx98d422589gxr8wflfpkdd0k44kbagxl3b51i56ky2wfix7rc";
    #         })
    #         # # alternatively if you have a local patch,
    #         # /path/to/file.patch
    #         # # or a relative path (relative to the current nix file)
    #         # ./relative.patch
    #       ];
    #     });
    #   };
    # in
    {
      # package = pkgs.callPackage ./mango-patched-for-ten.nix { };
      # package = ;
      package = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (
        finalAttrs: previousAttrs: {
          patches = (previousAttrs.patches or [ ]) ++ [
            (pkgs.fetchpatch {
              url = "https://patch-diff.githubusercontent.com/raw/mangowm/mango/pull/676.diff";
              hash = "sha256-wRQiF2BHFHEipeU3K2gtBgm/Xr+oz9KfETJgCfttaoI=";
            })
          ];
          buildInputs = (previousAttrs.buildInputs or [ ]) ++ [
            pkgs.cjson
          ];
          # This was done at version = "0.14.0", applying this https://github.com/mangowm/mango/pull/676 ;
        }
      );
      enable = true;
      autostart_sh = ''
        env QT_QPA_PLATFORMTHEME=qt6ct noctalia-shell &
        wlr-randr --output eDP-1 --scale 1.25 &
        # echo "Xft.dpi: 140" | xrdb -merge &
        # gsettings set org.gnome.desktop.interface text-scaling-factor 1.4 &
      '';
      topPrefixes = [ "exec-once" ];
      # extraConfig = "exec-once=${pkgs.swaybg}/bin/swaybg -c 11111b ";
      extraConfig = "exec-once=${pkgs.swaybg}/bin/swaybg -c ${config.lib.stylix.colors.base00} ";

      settings = {
        env = [
          "BEMENU_SCALE,2.5"
          #   "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          #   "QT_WAYLAND_FORCE_DPI,125"
        ];
        # Window effects
        blur = 1;
        blur_optimized = 1;
        blur_params = {
          radius = 5;
          num_passes = 2;
        };
        border_radius = 10;
        focused_opacity = 0.95;
        unfocused_opacity = 0.6;

        borderpx = 0;

        # Animations - use underscores for multi-part keys
        animations = 1;
        animation_type_open = "fade";
        animation_type_close = "fade";
        animation_duration_open = 300;
        animation_duration_close = 300;
        trackpad_natural_scrolling = 1;
        mouse_accel_profile = 2;
        mouse_accel_speed = 0.5;
        # Or use nested attrs (will be flattened with underscores)
        animation_curve = {
          open = "0.46,1.0,0.29,1";
          close = "0.08,0.92,0,1";
        };
        windowrule = [
          "tags:3,appid:emacs"
          "tags:2,appid:firefox"
          "tags:4,appid:spotify"
          "tags:5,appid:discord"
        ];
        tagrule = [
          "id:1,layout_name:dwindle"
          "id:2,layout_name:dwindle"
          "id:3,layout_name:dwindle"
          "id:4,layout_name:dwindle"
          "id:5,layout_name:dwindle"
          "id:6,layout_name:dwindle"
          "id:7,layout_name:dwindle"
          "id:8,layout_name:dwindle"
          "id:9,layout_name:vertical_scroller"
          "id:10,layout_name:scroller"
        ];
        # switchbind = [
        #   "HandleLidSwitch=ignore"
        # ];
        # Use lists for duplicate keys like bind and tagrule
        circle_layout = [
          "dwindle"
          "monocle"
          "floating"
        ];
        bind = [
          "SUPER,d,spawn,bemenu-run -w -i -l 10 --counter always -w  --scrollbar always -P '|>' --prompt 'launch:' --fb '#2F3549' --ff '#CBCCD1' --nb '#1a1b2a' --nf '#CBCCD1' --tb '#1a1b2a' --hb '#11121d' --tf '#7DCFFF' --hf '#BB9AF7' --af '#CBCCD1' --ab '#2F3549' --scb '#1a1b2a' --scf '#7199EE' "
          "SUPER,Return,spawn,${terminal}"
          "SUPER,w,spawn,${firefox}"

          "ALT,R,setkeymode,resize" # Enter resize mode

          # "SUPER+SHIFT,f,togglefloating"
          "SUPER+SHIFT,f,switch_layout" # TODO: Fix this
          "SUPER,q,killclient"
          "SUPER+SHIFT,r,reload_config"
          # "SUPER,l,spawn,"

          "SUPER,Left,focusdir,left"
          "SUPER,Down,focusdir,down"
          "SUPER,Up,focusdir,up"
          "SUPER,Right,focusdir,right"

          "SUPER+SHIFT,Left,exchange_client,left"
          "SUPER+SHIFT,Down,exchange_client,down"
          "SUPER+SHIFT,Up,exchange_client,up"
          "SUPER+SHIFT,Right,exchange_client,right"

          "SUPER,1,view,1"
          "SUPER,2,view,2"
          "SUPER,3,view,3"
          "SUPER,4,view,4"
          "SUPER,5,view,5"
          "SUPER,6,view,6"
          "SUPER,7,view,7"
          "SUPER,8,view,8"
          "SUPER,9,view,9"
          "SUPER,0,view,10"

          "SUPER+SHIFT,1,tag,1"
          "SUPER+SHIFT,2,tag,2"
          "SUPER+SHIFT,3,tag,3"
          "SUPER+SHIFT,4,tag,4"
          "SUPER+SHIFT,5,tag,5"
          "SUPER+SHIFT,6,tag,6"
          "SUPER+SHIFT,7,tag,7"
          "SUPER+SHIFT,8,tag,8"
          "SUPER+SHIFT,9,tag,9"
          "SUPER+SHIFT,0,tag,10"

          # noctalia
          "SUPER+SHIFT,e,spawn,noctalia-shell ipc call sessionMenu toggle"
          "SUPER,space,spawn,noctalia-shell ipc call launcher toggle"
          "SUPER,s,spawn,noctalia-shell ipc call controlCenter toggle"
          "SUPER,comma,spawn,noctalia-shell ipc call settings toggle"

          # Media keys
          "NONE,XF86AudioRaiseVolume,spawn,noctalia-shell ipc call volume increase"
          "NONE,XF86AudioLowerVolume,spawn,noctalia-shell ipc call volume decrease"
          "NONE,XF86AudioMute,spawn,noctalia-shell ipc call volume muteOutput"
          "NONE,XF86MonBrightnessUp,spawn,noctalia-shell ipc call brightness increase"
          "NONE,XF86MonBrightnessDown,spawn,noctalia-shell ipc call brightness decrease"
          "NONE,Print,spawn,noctalia-shell ipc call plugin:screen-toolkit annotate"
          "SUPER,Print,spawn,noctalia-shell ipc call plugin:screen-toolkit toggle"

        ];

        mousebind = [
          "SUPER,btn_left,moveresize,curmove"
          "SUPER,btn_right,moveresize,curresize"
        ];

        # Keymodes (submaps) for modal keybindings
        keymode = {
          resize = {
            bind = [
              "NONE,Left,resizewin,-10,0"
              "NONE,Escape,setkeymode,default"
            ];
          };
        };
      };
    };
  programs.noctalia-shell = {
    enable = true;
    # TODO: Look into hooks for screen lid for locking - also go and setup idle screen turn off lol
    # Plugin management (sources and states)
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        catwalk = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screen-toolkit = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };

    };
    pluginSettings = {
      catwalk = {
        minimumThreshold = 25;
        hideBackground = true;
      };
    };
    # Main shell configuration
    settings = {
      settingsVersion = 53;

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        lockOnSuspend = true;
        translucentWidgets = false;
        showChangelogOnStartup = true;
        clockFormat = "hh\\nmm";
        clockStyle = "custom";
        enableShadows = false;
        animationSpeed = 1.25;
        showScreenCorners = true;
        forceBlackScreenCorners = true;

      };

      ui = {
        fontDefault = "Berkeley Mono";
        fontFixed = "Berkeley Mono";
        panelBackgroundOpacity = lib.mkForce 0.93;
        tooltipsEnabled = true;
        panelsAttachedToBar = true;
      };

      appLauncher = {
        enableClipPreview = true;
        enableClipboardHistory = false;
        sortByMostUsed = true;
        iconMode = "tabler";
        viewMode = "list";
        terminalCommand = "xterm -e";
        position = "center";
      };

      audio = {
        visualizerType = "linear";
        cavaFrameRate = 30;
        volumeStep = 5;
      };

      bar = {
        barType = "simple";
        density = "default";
        floating = false;
        fontScale = 1;
        position = "top";
        # backgroundOpacity = lib.mkForce 0.93;
        frameRadius = 12;
        useSeparateOpacity = true;
        backgroundOpacity = lib.mkForce 0.0;
        widgets = {
          left = [
            { id = "plugin:catwalk"; }
            { id = "plugin:screen-toolkit"; }

          ];
          center = [
            {
              id = "Workspace";
              characterCount = 2;
              showBadge = true;
            }
          ];
          right = [
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
            }
            {
              id = "Volume";
              displayMode = "onhover";
            }
            {
              id = "Battery";
              displayMode = "icon-always";
              deviceNativePath = "__default__";
              hideIfIdle = false;
              hideIfNotDetected = true;
              showNoctaliaPerformance = true;
              showPowerProfiles = true;
            }
            {
              id = "ControlCenter";
              icon = "analyze";
            }
          ];
        };
      };

      controlCenter = {
        position = "close_to_bar_button";
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };

      notifications = {
        enabled = true;
        location = "top_right";
        # backgroundOpacity = 1;
      };
      location = {
        name = "Perth, Australia";
        weatherEnabled = true;
        weatherShowEffects = true;
        weatherTaliaMascotAlways = false;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherTimezone = false;
        hideWeatherCityName = false;
        autoLocate = false;
      };
      home.file.".cache/noctalia/wallpapers.json" = {
        text = builtins.toJSON {
          # defaultWallpaper = ../../assests/background.png;
          defaultWallpaper = ../../assests/CatsWithNix.png;
        };
      };
      wallpaper = {
        enabled = true;
        automationEnabled = true;
        transitionType = [
          "honeycomb"
        ];
        # directory = "${config.home.homeDirectory}/noctalia/.wallpapers";
        # transitionType = "random";
        # wallpaperChangeMode = "random";
      };

      colorSchemes = {
        # predefinedScheme = "Catppuccin";
        darkMode = true;
        useWallpaperColors = false;
        generationMethod = "vibrant";
      };
    };
  };
  # Packages for screen-toolkit
  home.packages = with pkgs; [
    grim
    slurp
    hyprpicker
    wl-clipboard
    tesseract
    imagemagick
    zbar
    curl
    translate-shell
    wl-screenrec
    ffmpeg
    gifski
    jq
    python3Packages.pygobject3
    xdg-desktop-portal
    evtest
  ];
}
