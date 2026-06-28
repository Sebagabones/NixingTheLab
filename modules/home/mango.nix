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
  bemenu = "bemenu-run -w -i -l 10 --counter always -w --scrollbar always -P '|>' --prompt 'launch:' --fb '#2F3549' --ff '#CBCCD1' --nb '#1a1b2a' --nf '#CBCCD1' --tb '#1a1b2a' --hb '#11121d' --tf '#7DCFFF' --hf '#BB9AF7' --af '#CBCCD1' --ab '#2F3549' --scb '#1a1b2a' --scf '#7199EE'";
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.dms.homeModules.dank-material-shell
    inputs.danksearch.homeModules.default
    inputs.mangowm.hmModules.mango
  ];
  # programs.bemenu.enable = true;

  wayland.windowManager.mango =
    let
      lock-screen = pkgs.writeShellScript "lock-screen.sh" ''
        noctalia-shell ipc call lockScreen lock && systemctl suspend
      '';
      unlock-screen = pkgs.writeShellScript "unlock-screen.sh" ''
        wlr-randr --output eDP-1 --on
      '';
    in
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
        # env QT_QPA_PLATFORMTHEME=qt6ct noctalia-shell &
        wlr-randr --output eDP-1 --scale 1.25 &
        # echo "Xft.dpi: 140" | xrdb -merge &
        # gsettings set org.gnome.desktop.interface text-scaling-factor 1.4 &
      '';
      topPrefixes = [ "exec-once" ];
      # extraConfig = "exec-once=${pkgs.swaybg}/bin/swaybg -c 11111b ";
      extraConfig = ''
        exec-once=${pkgs.swaybg}/bin/swaybg -c ${config.lib.stylix.colors.base00}
        source=~/.config/mango/dms/colors.conf
        source=~/.config/mango/dms/layout.conf
        source=~/.config/mango/dms/outputs.conf
        exec-once=dms run
        exec-once=wl-paste --type text --watch cliphist store
      '';

      settings = {
        env = [
          "BEMENU_SCALE,2.5"
          "QT_QPA_PLATFORM,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "QT_QPA_PLATFORMTHEME,gtk3"
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
        animation_type_open = "zoom";
        animation_type_close = "zoom";
        animation_duration_open = 350;
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

        switchbind = [
          # "HandleLidSwitch=ignore"
          # "fold,spawn,${lock-screen}"
          # "unfold,spawn,${unlock-screen}"
        ];

        # circle_layout = "dwindle,monocle,floating";

        bind = [
          # "SUPER,d,spawn,${bemenu} "
          "SUPER,d,spawn,dms ipc call spotlight toggle"
          "SUPER,v,spawn,dms ipc call clipboard toggle"
          "SUPER,m,spawn,dms ipc call processlist focusOrToggle"
          "SUPER,comma,spawn,dms ipc call settings focusOrToggle"
          "SUPER,n,spawn,dms ipc call notifications toggle"
          "SUPER,Return,spawn,${terminal}"
          "SUPER,w,spawn,${firefox}"

          "ALT,R,setkeymode,resize" # Enter resize mode

          "SUPER+SHIFT,space,togglefloating"
          "SUPER+SHIFT,f,togglemaximizescreen"
          "SUPER,tab,focusstack"
          "SUPER,q,killclient"
          "SUPER+SHIFT,r,reload_config"
          # "SUPER,l,spawn,${lock-screen}"
          "SUPER,l,spawn,dms ipc call lock lock"
          "NONE,XF86AudioRaiseVolume,spawn,dms ipc call audio increment 3"
          "NONE,XF86AudioLowerVolume,spawn,dms ipc call audio decrement 3"
          "NONE,XF86AudioMute,spawn,dms ipc call audio mute"

          "NONE,XF86MonBrightnessUp,spawn,dms ipc call brightness increment 5 backlight:intel_backlight "
          "NONE,XF86MonBrightnessDown,spawn,dms ipc call brightness decrement 5 backlight:intel_backlight "
          "SUPER+SHIFT,l,quit"

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

          #
          "SUPER+SHIFT,e,spawn,dms ipc call powermenu toggle"

          # # noctalia
          # "SUPER+SHIFT,e,spawn,noctalia-shell ipc call sessionMenu toggle"
          # "SUPER,space,spawn,noctalia-shell ipc call launcher toggle"
          # "SUPER,s,spawn,noctalia-shell ipc call controlCenter toggle"
          # "SUPER,comma,spawn,noctalia-shell ipc call settings toggle"

          #          # Media keys
          # "NONE,XF86AudioRaiseVolume,spawn,noctalia-shell ipc call volume increase"
          # "NONE,XF86AudioLowerVolume,spawn,noctalia-shell ipc call volume decrease"
          # "NONE,XF86AudioMute,spawn,noctalia-shell ipc call volume muteOutput"
          # "NONE,XF86MonBrightnessUp,spawn,noctalia-shell ipc call brightness increase"
          # "NONE,XF86MonBrightnessDown,spawn,noctalia-shell ipc call brightness decrease"
          # "NONE,Print,spawn,noctalia-shell ipc call plugin:screen-toolkit annotate"
          # "SUPER,Print,spawn,noctalia-shell ipc call plugin:screen-toolkit toggle"

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
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;

    # systemd = {
    #   enable = true; # Systemd service for auto-start
    #   restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
    # };
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableClipboardPaste = true; # Pasting items from the clipboard (wtype)x
    settings = {
      currentThemeName = "custom";
      currentThemeCategory = "generic";
      registryThemeVariants = {
      };
      matugenScheme = "scheme-tonal-spot";
      runUserMatugenTemplates = true;
      matugenTargetMonitor = "";
      popupTransparency = 1.0;
      dockTransparency = 1.0;
      widgetBackgroundColor = "sch";
      widgetColorMode = "default";
      controlCenterTileColorMode = "primary";
      buttonColorMode = "primary";
      cornerRadius = 12;
      niriLayoutGapsOverride = -1;
      niriLayoutRadiusOverride = -1;
      niriLayoutBorderSize = -1;
      hyprlandLayoutGapsOverride = -1;
      hyprlandLayoutRadiusOverride = -1;
      hyprlandLayoutBorderSize = -1;
      mangoLayoutGapsOverride = -1;
      mangoLayoutRadiusOverride = -1;
      mangoLayoutBorderSize = -1;
      use24HourClock = true;
      showSeconds = false;
      padHours12Hour = false;
      useFahrenheit = false;
      windSpeedUnit = "ms";
      nightModeEnabled = false;
      animationSpeed = 1;
      customAnimationDuration = 500;
      syncComponentAnimationSpeeds = true;
      popoutAnimationSpeed = 1;
      popoutCustomAnimationDuration = 150;
      modalAnimationSpeed = 1;
      modalCustomAnimationDuration = 150;
      enableRippleEffects = true;
      blurEnabled = false;
      blurForegroundLayers = true;
      blurLayerOutlineOpacity = 0.12;
      blurBorderColor = "outline";
      blurBorderCustomColor = "#ffffff";
      blurBorderOpacity = 0.35;
      wallpaperFillMode = "Fill";
      blurredWallpaperLayer = false;
      blurWallpaperOnOverview = false;
      showLauncherButton = true;
      showWorkspaceSwitcher = true;
      showFocusedWindow = true;
      showWeather = true;
      showMusic = true;
      showClipboard = true;
      showCpuUsage = true;
      showMemUsage = true;
      showCpuTemp = true;
      showGpuTemp = true;
      selectedGpuIndex = 0;
      enabledGpuPciIds = [

      ];
      showSystemTray = true;
      systemTrayIconTintMode = "none";
      systemTrayIconTintSaturation = 50;
      systemTrayIconTintStrength = 135;
      showClock = true;
      showNotificationButton = true;
      showBattery = true;
      showControlCenterButton = true;
      showCapsLockIndicator = true;
      controlCenterShowNetworkIcon = true;
      controlCenterShowBluetoothIcon = true;
      controlCenterShowAudioIcon = true;
      controlCenterShowAudioPercent = false;
      controlCenterShowVpnIcon = true;
      controlCenterShowBrightnessIcon = false;
      controlCenterShowBrightnessPercent = false;
      controlCenterShowMicIcon = false;
      controlCenterShowMicPercent = false;
      controlCenterShowBatteryIcon = false;
      controlCenterShowPrinterIcon = false;
      controlCenterShowScreenSharingIcon = true;
      showPrivacyButton = true;
      privacyShowMicIcon = false;
      privacyShowCameraIcon = false;
      privacyShowScreenShareIcon = false;
      controlCenterWidgets = [
        {
          enabled = true;
          id = "volumeSlider";
          width = 50;
        }
        {
          enabled = true;
          id = "brightnessSlider";
          width = 50;
        }
        {
          enabled = true;
          id = "wifi";
          width = 50;
        }
        {
          enabled = true;
          id = "bluetooth";
          width = 50;
        }
        {
          enabled = true;
          id = "audioOutput";
          width = 50;
        }
        {
          enabled = true;
          id = "audioInput";
          width = 50;
        }
        {
          enabled = true;
          id = "nightMode";
          width = 50;
        }
        {
          enabled = true;
          id = "darkMode";
          width = 50;
        }
      ];
      showWorkspaceIndex = true;
      showWorkspaceName = true;
      showWorkspacePadding = false;
      workspaceScrolling = false;
      showWorkspaceApps = false;
      workspaceDragReorder = true;
      maxWorkspaceIcons = 3;
      workspaceAppIconSizeOffset = 0;
      groupWorkspaceApps = true;
      workspaceFollowFocus = true;
      showOccupiedWorkspacesOnly = false;
      reverseScrolling = false;
      dwlShowAllTags = true;
      workspaceColorMode = "default";
      workspaceOccupiedColorMode = "schh";
      workspaceUnfocusedColorMode = "s";
      workspaceUrgentColorMode = "default";
      workspaceFocusedBorderEnabled = false;
      workspaceFocusedBorderColor = "primary";
      workspaceFocusedBorderThickness = 2;
      workspaceNameIcons = {
      };
      waveProgressEnabled = true;
      scrollTitleEnabled = true;
      audioVisualizerEnabled = true;
      audioScrollMode = "volume";
      audioWheelScrollAmount = 5;
      clockCompactMode = false;
      focusedWindowCompactMode = false;
      runningAppsCompactMode = true;
      barMaxVisibleApps = 0;
      barMaxVisibleRunningApps = 0;
      barShowOverflowBadge = true;
      appsDockHideIndicators = false;
      appsDockColorizeActive = false;
      appsDockActiveColorMode = "primary";
      appsDockEnlargeOnHover = false;
      appsDockEnlargePercentage = 125;
      appsDockIconSizePercentage = 100;
      keyboardLayoutNameCompactMode = false;
      runningAppsCurrentWorkspace = true;
      runningAppsGroupByApp = false;
      runningAppsCurrentMonitor = false;
      appIdSubstitutions = [
        {
          pattern = "Spotify";
          replacement = "spotify";
          type = "exact";
        }
        {
          pattern = "beepertexts";
          replacement = "beeper";
          type = "exact";
        }
        {
          pattern = "home assistant desktop";
          replacement = "homeassistant-desktop";
          type = "exact";
        }
        {
          pattern = "com.transmissionbt.transmission";
          replacement = "transmission-gtk";
          type = "contains";
        }
        {
          pattern = "^steam_app_(\\d+)$";
          replacement = "steam_icon_$1";
          type = "regex";
        }
      ];
      centeringMode = "index";
      clockDateFormat = "yyyy-MM-dd";
      lockDateFormat = "yyyy-MM-dd";
      greeterRememberLastSession = true;
      greeterRememberLastUser = true;
      greeterEnableFprint = false;
      greeterEnableU2f = false;
      greeterWallpaperPath = "";
      mediaSize = 1;
      appLauncherViewMode = "list";
      spotlightModalViewMode = "list";
      browserPickerViewMode = "grid";
      browserUsageHistory = {
      };
      appPickerViewMode = "grid";
      filePickerUsageHistory = {
      };
      sortAppsAlphabetically = false;
      appLauncherGridColumns = 4;
      spotlightCloseNiriOverview = true;
      spotlightSectionViewModes = {
      };
      appDrawerSectionViewModes = {
      };
      niriOverviewOverlayEnabled = true;
      dankLauncherV2Size = "compact";
      dankLauncherV2BorderEnabled = false;
      dankLauncherV2BorderThickness = 2;
      dankLauncherV2BorderColor = "primary";
      dankLauncherV2ShowFooter = false;
      dankLauncherV2UnloadOnClose = false;
      useAutoLocation = false;
      weatherEnabled = true;
      networkPreference = "auto";
      iconTheme = "System Default";
      cursorSettings = {
        dwl = {
          cursorHideTimeout = 0;
        };
        hyprland = {
          hideOnKeyPress = false;
          hideOnTouch = false;
          inactiveTimeout = 0;
        };
        niri = {
          hideAfterInactiveMs = 0;
          hideWhenTyping = false;
        };
        size = 24;
        theme = "System Default";
      };
      launcherLogoMode = "os";
      launcherLogoCustomPath = "";
      launcherLogoColorOverride = "primary";
      launcherLogoColorInvertOnMode = false;
      launcherLogoBrightness = 0.5;
      launcherLogoContrast = 1;
      launcherLogoSizeOffset = 0;
      fontFamily = "Berkeley Mono";
      monoFontFamily = "Berkeley Mono";
      fontWeight = 400;
      fontScale = 1;
      notepadUseMonospace = true;
      notepadFontFamily = "";
      notepadFontSize = 14;
      notepadShowLineNumbers = false;
      notepadTransparencyOverride = -1;
      notepadLastCustomTransparency = 0.7;
      soundsEnabled = true;
      useSystemSoundTheme = false;
      soundNewNotification = true;
      soundVolumeChanged = true;
      soundPluggedIn = true;
      acMonitorTimeout = 0;
      acLockTimeout = 300;
      acSuspendTimeout = 0;
      acSuspendBehavior = 0;
      acProfileName = "";
      batteryMonitorTimeout = 180;
      batteryLockTimeout = 180;
      batterySuspendTimeout = 1800;
      batterySuspendBehavior = 2;
      batteryProfileName = "";
      batteryChargeLimit = 100;
      lockBeforeSuspend = true;
      loginctlLockIntegration = true;
      fadeToLockEnabled = true;
      fadeToLockGracePeriod = 5;
      fadeToDpmsEnabled = true;
      fadeToDpmsGracePeriod = 5;
      launchPrefix = "";
      brightnessDevicePins = {
      };
      wifiNetworkPins = {
      };
      bluetoothDevicePins = {
      };
      audioInputDevicePins = {
      };
      audioOutputDevicePins = {
      };
      gtkThemingEnabled = false;
      qtThemingEnabled = false;
      syncModeWithPortal = true;
      terminalsAlwaysDark = false;
      muxType = "tmux";
      muxUseCustomCommand = false;
      muxCustomCommand = "";
      muxSessionFilter = "";
      runDmsMatugenTemplates = true;
      matugenTemplateGtk = true;
      matugenTemplateNiri = true;
      matugenTemplateHyprland = true;
      matugenTemplateMangowc = true;
      matugenTemplateQt5ct = true;
      matugenTemplateQt6ct = true;
      matugenTemplateFirefox = true;
      matugenTemplatePywalfox = true;
      matugenTemplateZenBrowser = true;
      matugenTemplateVesktop = true;
      matugenTemplateEquibop = true;
      matugenTemplateGhostty = true;
      matugenTemplateKitty = true;
      matugenTemplateFoot = true;
      matugenTemplateAlacritty = true;
      matugenTemplateNeovim = false;
      matugenTemplateWezterm = true;
      matugenTemplateDgop = true;
      matugenTemplateKcolorscheme = true;
      matugenTemplateVscode = true;
      matugenTemplateEmacs = true;
      matugenTemplateZed = true;
      showDock = false;
      dockAutoHide = false;
      dockSmartAutoHide = false;
      dockGroupByApp = false;
      dockOpenOnOverview = false;
      dockPosition = 1;
      dockSpacing = 4;
      dockBottomGap = 0;
      dockMargin = 0;
      dockIconSize = 40;
      dockIndicatorStyle = "circle";
      dockBorderEnabled = false;
      dockBorderColor = "surfaceText";
      dockBorderOpacity = 1;
      dockBorderThickness = 1;
      dockIsolateDisplays = false;
      dockLauncherEnabled = false;
      dockLauncherLogoMode = "apps";
      dockLauncherLogoCustomPath = "";
      dockLauncherLogoColorOverride = "";
      dockLauncherLogoSizeOffset = 0;
      dockLauncherLogoBrightness = 0.5;
      dockLauncherLogoContrast = 1;
      dockMaxVisibleApps = 0;
      dockMaxVisibleRunningApps = 0;
      dockShowOverflowBadge = true;
      notificationOverlayEnabled = false;
      notificationPopupShadowEnabled = true;
      notificationPopupPrivacyMode = false;
      modalDarkenBackground = true;
      lockScreenShowPowerActions = true;
      lockScreenShowSystemIcons = true;
      lockScreenShowTime = true;
      lockScreenShowDate = true;
      lockScreenShowProfileImage = true;
      lockScreenShowPasswordField = true;
      lockScreenShowMediaPlayer = true;
      lockScreenPowerOffMonitorsOnLock = false;
      lockAtStartup = false;
      enableFprint = false;
      maxFprintTries = 15;
      enableU2f = false;
      u2fMode = "or";
      lockScreenActiveMonitor = "all";
      lockScreenInactiveColor = "#000000";
      lockScreenNotificationMode = 0;
      hideBrightnessSlider = false;
      notificationTimeoutLow = 5000;
      notificationTimeoutNormal = 5000;
      notificationTimeoutCritical = 0;
      notificationCompactMode = false;
      notificationPopupPosition = 0;
      notificationAnimationSpeed = 1;
      notificationCustomAnimationDuration = 400;
      notificationHistoryEnabled = true;
      notificationHistoryMaxCount = 50;
      notificationHistoryMaxAgeDays = 7;
      notificationHistorySaveLow = true;
      notificationHistorySaveNormal = true;
      notificationHistorySaveCritical = true;
      notificationRules = [

      ];
      osdAlwaysShowValue = false;
      osdPosition = 5;
      osdVolumeEnabled = true;
      osdMediaVolumeEnabled = true;
      osdMediaPlaybackEnabled = false;
      osdBrightnessEnabled = true;
      osdIdleInhibitorEnabled = true;
      osdMicMuteEnabled = true;
      osdCapsLockEnabled = true;
      osdPowerProfileEnabled = false;
      osdAudioOutputEnabled = true;
      powerActionConfirm = true;
      powerActionHoldDuration = 0.5;
      powerMenuActions = [
        "reboot"
        "logout"
        "poweroff"
        "lock"
        "suspend"
        "restart"
        "hibernate"
      ];
      powerMenuDefaultAction = "logout";
      powerMenuGridLayout = true;
      customPowerActionLock = "";
      customPowerActionLogout = "mmsg dispatch quit";
      customPowerActionSuspend = "";
      customPowerActionHibernate = "";
      customPowerActionReboot = "";
      customPowerActionPowerOff = "";
      updaterHideWidget = false;
      updaterUseCustomCommand = false;
      updaterCustomCommand = "";
      updaterTerminalAdditionalParams = "";
      displayNameMode = "system";
      screenPreferences = {
        wallpaper = [
          "all"
        ];
      };
      showOnLastDisplay = {
      };
      niriOutputSettings = {
      };
      hyprlandOutputSettings = {
      };
      displayProfiles = {
      };
      activeDisplayProfile = {
      };
      displayProfileAutoSelect = false;
      displayShowDisconnected = false;
      displaySnapToEdge = true;
      barConfigs = [
        {
          autoHide = false;
          autoHideDelay = 250;
          borderColor = "secondary";
          borderEnabled = false;
          borderOpacity = 1;
          borderThickness = 1;
          bottomGap = 0;
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];
          enabled = true;
          fontScale = 1;
          gothCornerRadiusOverride = true;
          gothCornerRadiusValue = 12;
          gothCornersEnabled = false;
          id = "default";
          innerPadding = 4;
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          name = "Main Bar";
          noBackground = true;
          openOnOverview = false;
          popupGapsAuto = true;
          popupGapsManual = 4;
          position = 0;
          removeWidgetPadding = false;
          rightWidgets = [
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            "controlCenterButton"
          ];
          screenPreferences = [
            "all"
          ];
          showOnLastDisplay = true;
          spacing = 4;
          squareCorners = false;
          transparency = 0;
          visible = true;
          widgetOutlineColor = "primary";
          widgetOutlineEnabled = false;
          widgetOutlineOpacity = 1;
          widgetTransparency = 0;
        }
      ];
      desktopClockEnabled = false;
      desktopClockStyle = "analog";
      desktopClockTransparency = 0.8;
      desktopClockColorMode = "primary";
      desktopClockCustomColor = {
        r = 1;
        g = 1;
        b = 1;
        a = 1;
        hsvHue = -1;
        hsvSaturation = 0;
        hsvValue = 1;
        hslHue = -1;
        hslSaturation = 0;
        hslLightness = 1;
        valid = true;
      };
      desktopClockShowDate = true;
      desktopClockShowAnalogNumbers = false;
      desktopClockShowAnalogSeconds = true;
      desktopClockX = -1;
      desktopClockY = -1;
      desktopClockWidth = 280;
      desktopClockHeight = 180;
      desktopClockDisplayPreferences = [
        "all"
      ];
      systemMonitorEnabled = false;
      systemMonitorShowHeader = true;
      systemMonitorTransparency = 0.8;
      systemMonitorColorMode = "primary";
      systemMonitorCustomColor = {
        r = 1;
        g = 1;
        b = 1;
        a = 1;
        hsvHue = -1;
        hsvSaturation = 0;
        hsvValue = 1;
        hslHue = -1;
        hslSaturation = 0;
        hslLightness = 1;
        valid = true;
      };
      systemMonitorShowCpu = true;
      systemMonitorShowCpuGraph = true;
      systemMonitorShowCpuTemp = true;
      systemMonitorShowGpuTemp = false;
      systemMonitorGpuPciId = "";
      systemMonitorShowMemory = true;
      systemMonitorShowMemoryGraph = true;
      systemMonitorShowNetwork = true;
      systemMonitorShowNetworkGraph = true;
      systemMonitorShowDisk = true;
      systemMonitorShowTopProcesses = false;
      systemMonitorTopProcessCount = 3;
      systemMonitorTopProcessSortBy = "cpu";
      systemMonitorGraphInterval = 60;
      systemMonitorLayoutMode = "auto";
      systemMonitorX = -1;
      systemMonitorY = -1;
      systemMonitorWidth = 320;
      systemMonitorHeight = 480;
      systemMonitorDisplayPreferences = [
        "all"
      ];
      systemMonitorVariants = [

      ];
      desktopWidgetPositions = {
      };
      desktopWidgetGridSettings = {
      };
      desktopWidgetInstances = [

      ];
      desktopWidgetGroups = [

      ];
      builtInPluginSettings = {
        dms_settings_search = {
          trigger = "?";
        };
      };
      clipboardEnterToPaste = false;
      launcherPluginVisibility = {
      };
      launcherPluginOrder = [

      ];
      configVersion = 5;
    };
    #     settings = {
    #   theme = "dark";
    #   dynamicTheming = true;
    #   # Add any other settings here
    # };
    #
    # session = {
    #   isLightMode = false;
    #   # Add any other session state settings here
    # };
    #
    # clipboardSettings = {
    #   maxHistory = 25;
    #   maxEntrySize = 5242880;
    #   autoClearDays = 1;
    #   clearAtStartup = true;
    #   disabled = false;
    #   disableHistory = false;
    #   disablePersist = true;
    # };
  };
  programs.dsearch = {
    enable = true;

    # Use a custom package (optional)
    package = pkgs.dsearch;
    # config = {
    #   listen_addr = ":43654";
    #   max_file_bytes = 5242880;  # 5MB
    #   worker_count = 8;
    #
    #   index_paths = [
    #     {
    #       path = "~/Documents";
    #       max_depth = 0;  # No limit
    #       exclude_hidden = false;
    #       exclude_dirs = [ ];
    #     }
    #     {
    #       path = "~/Projects";
    #       max_depth = 8;
    #       exclude_hidden = true;
    #       exclude_dirs = [ "node_modules" "venv" "target" ".git" "dist" "build" ];
    #     }
    #     {
    #       path = "/mnt/shared";
    #       max_depth = 5;
    #       watch = false;  # Disable watchers for network mount
    #       exclude_dirs = [ ".cache" ];
    #     }
    #   ];
    # };
  };

  programs.noctalia-shell = {
    enable = false;
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
        slowbongo = {
          enabled = false;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        fancy-audiovisualizer = {
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
      settingsVersion = 59;
      appLauncher = {
        autoPasteClipboard = false;
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWrapText = true;
        customLaunchPrefix = "";
        customLaunchPrefixEnabled = false;
        density = "default";
        enableClipPreview = true;
        enableClipboardChips = true;
        enableClipboardHistory = false;
        enableClipboardSmartIcons = true;
        enableSessionSearch = true;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        iconMode = "tabler";
        ignoreMouseInput = false;
        overviewLayer = false;
        pinnedApps = [

        ];
        position = "center";
        screenshotAnnotationTool = "";
        showCategories = true;
        showIconBackground = false;
        sortByMostUsed = true;
        terminalCommand = "xterm -e";
        viewMode = "list";
      };

      audio = {
        mprisBlacklist = [

        ];
        preferredPlayer = "";
        spectrumFrameRate = 30;
        spectrumMirrored = true;
        visualizerType = "linear";
        volumeFeedback = false;
        volumeFeedbackSoundFile = "";
        volumeOverdrive = false;
        volumeStep = 5;
      };

      bar = {
        autoHideDelay = 500;
        autoShowDelay = 150;
        backgroundOpacity = lib.mkForce 0;
        barType = "simple";
        capsuleColorKey = "none";
        capsuleOpacity = 1.0;
        contentPadding = 2;
        density = "default";
        displayMode = "always_visible";
        enableExclusionZoneInset = true;
        fontScale = 1;
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = false;
        marginHorizontal = 4;
        marginVertical = 4;
        middleClickAction = "none";
        middleClickCommand = "";
        middleClickFollowMouse = false;
        monitors = [

        ];
        mouseWheelAction = "none";
        mouseWheelWrap = true;
        outerCorners = true;
        position = "top";
        reverseScroll = false;
        rightClickAction = "controlCenter";
        rightClickCommand = "";
        rightClickFollowMouse = true;
        screenOverrides = [

        ];
        showCapsule = true;
        showOnWorkspaceSwitch = true;
        showOutline = false;
        useSeparateOpacity = true;
        widgetSpacing = 6;
        widgets = {
          center = [
            {
              clockColor = "none";
              customFont = "";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
            }
            {
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              fontWeight = "bold";
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "index";
              occupiedColor = "secondary";
              pillSize = 0.6;
              showApplications = false;
              showApplicationsHover = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
            {
              defaultSettings = {
                colorHistory = [

                ];
                detectedRecorder = "";
                filenameFormat = "";
                gifMaxSeconds = 30;
                installedLangs = [
                  "eng"
                ];
                paletteColors = [

                ];
                recordCopyToClipboard = false;
                recordSkipConfirmation = false;
                screenshotPath = "";
                selectedOcrLang = "eng";
                transAvailable = false;
                videoPath = "";
              };
              id = "plugin:screen-toolkit";
            }
          ];
          left = [
            {
              defaultSettings = {
                hideBackground = false;
                minimumThreshold = 10;
              };
              id = "plugin:catwalk";
            }
            {
              colorName = "secondary";
              hideWhenIdle = true;
              id = "AudioVisualizer";
              width = 200;
            }
          ];
          right = [
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Network";
              textColor = "none";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Bluetooth";
              textColor = "none";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
              textColor = "none";
            }
            {
              compactMode = true;
              diskPath = "/";
              iconColor = "none";
              id = "SystemMonitor";
              showCpuCores = false;
              showCpuFreq = false;
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskAvailable = false;
              showDiskUsage = false;
              showDiskUsageAsPercent = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkStats = false;
              showSwapUsage = false;
              textColor = "none";
              useMonospaceFont = true;
              usePadding = false;
            }
            {
              iconColor = "none";
              id = "PowerProfile";
            }
            {
              deviceNativePath = "__default__";
              displayMode = "icon-always";
              hideIfIdle = false;
              hideIfNotDetected = true;
              id = "Battery";
              showNoctaliaPerformance = true;
              showPowerProfiles = true;
            }
            {
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              colorizeSystemText = "none";
              customIconPath = "";
              enableColorization = true;
              icon = "analyze";
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };

      brightness = {
        backlightDeviceMappings = [

        ];
        brightnessStep = 5;
        enableDdcSupport = false;
        enforceMinimum = true;
      };

      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
        ];
      };

      colorSchemes = {
        darkMode = true;
        generationMethod = "vibrant";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        monitorForColors = "";
        predefinedScheme = "Noctalia (default)";
        schedulingMode = "off";
        syncGsettings = true;
        useWallpaperColors = false;
      };

      controlCenter = {
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
        diskPath = "/";
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "WallpaperSelector";
            }
            {
              id = "NoctaliaPerformance";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
      };

      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        gridSnapScale = false;
        monitorWidgets = [

        ];
        overviewEnabled = true;
      };

      dock = {
        animationSpeed = 1;
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "auto_hide";
        dockType = "floating";
        enabled = true;
        floatingRatio = 1;
        groupApps = false;
        groupClickAction = "cycle";
        groupContextMenuMode = "extended";
        groupIndicatorStyle = "dots";
        inactiveIndicators = false;
        indicatorColor = "primary";
        indicatorOpacity = 0.6;
        indicatorThickness = 3;
        launcherIcon = "";
        launcherIconColor = "none";
        launcherPosition = "end";
        launcherUseDistroLogo = false;
        monitors = [

        ];
        onlySameOutput = true;
        pinnedApps = [

        ];
        pinnedStatic = false;
        position = "bottom";
        showDockIndicator = false;
        showLauncherIcon = false;
        sitOnFrame = false;
        size = 1;
      };

      general = {
        allowPanelsOnScreenWithoutBar = true;
        allowPasswordWithFprintd = false;
        animationDisabled = false;
        animationSpeed = 1.25;
        autoStartAuth = false;
        avatarImage = "/home/bones/.face";
        boxRadiusRatio = 1;
        clockFormat = "hh\\nmm";
        clockStyle = "digital";
        compactLockScreen = false;
        dimmerOpacity = 0.2;
        enableBlurBehind = true;
        enableLockScreenCountdown = true;
        enableLockScreenMediaControls = true;
        enableShadows = false;
        forceBlackScreenCorners = true;
        iRadiusRatio = 1;
        keybinds = {
          keyDown = [
            "Down"
          ];
          keyEnter = [
            "Return"
            "Enter"
          ];
          keyEscape = [
            "Esc"
          ];
          keyLeft = [
            "Left"
          ];
          keyRemove = [
            "Del"
          ];
          keyRight = [
            "Right"
          ];
          keyUp = [
            "Up"
          ];
        };
        language = "";
        lockOnSuspend = true;
        lockScreenAnimations = true;
        lockScreenBlur = 1.0;
        lockScreenCountdownDuration = 1000;
        lockScreenMonitors = [

        ];
        lockScreenTint = 0;
        passwordChars = true;
        radiusRatio = 1;
        reverseScroll = false;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false;
        showScreenCorners = true;
        showSessionButtonsOnLockScreen = true;
        smoothScrollEnabled = true;
        telemetryEnabled = false;
      };

      hooks = {
        colorGeneration = "";
        darkModeChange = "";
        enabled = false;
        performanceModeDisabled = "";
        performanceModeEnabled = "";
        screenLock = "";
        screenUnlock = "";
        session = "";
        startup = "";
        wallpaperChange = "";
      };

      idle = {
        customCommands = "[]";
        enabled = false;
        fadeDuration = 5;
        lockCommand = "";
        lockTimeout = 660;
        resumeLockCommand = "";
        resumeScreenOffCommand = "";
        resumeSuspendCommand = "";
        screenOffCommand = "";
        screenOffTimeout = 600;
        suspendCommand = "";
        suspendTimeout = 1800;
      };

      location = {
        analogClockInCalendar = false;
        autoLocate = false;
        firstDayOfWeek = -1;
        hideWeatherCityName = false;
        hideWeatherTimezone = false;
        name = "Perth, Australia";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = false;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
        weatherTaliaMascotAlways = false;
      };

      network = {
        bluetoothAutoConnect = true;
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 60000;
        bluetoothRssiPollingEnabled = false;
        disableDiscoverability = false;
        networkPanelView = "wifi";
        wifiDetailsViewMode = "grid";
      };

      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = false;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "4000";
      };

      noctaliaPerformance = {
        disableDesktopWidgets = true;
        disableWallpaper = true;
      };

      notifications = {
        clearDismissed = true;
        criticalUrgencyDuration = 15;
        density = "default";
        enableBatteryToast = true;
        enableKeyboardLayoutToast = true;
        enableMarkdown = false;
        enableMediaToast = false;
        enabled = true;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [

        ];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = false;
        saveToHistory = {
          critical = true;
          low = true;
          normal = true;
        };
        sounds = {
          criticalSoundFile = "";
          enabled = false;
          excludedApps = "discord,firefox,chrome,chromium,edge";
          lowSoundFile = "";
          normalSoundFile = "";
          separateSounds = false;
          volume = 0.5;
        };
      };

      osd = {
        autoHideMs = 2000;
        enabled = true;
        enabledTypes = [
          0
          1
          2
        ];
        location = "top_right";
        monitors = [

        ];
        overlayLayer = true;
      };

      plugins = {
        autoUpdate = false;
        notifyUpdates = true;
      };

      sessionMenu = {
        countdownDuration = 3000;
        enableCountdown = true;
        largeButtonsLayout = "single-row";
        largeButtonsStyle = true;
        position = "center";
        powerOptions = [
          {
            action = "lock";
            enabled = true;
            keybind = "1";
          }
          {
            action = "suspend";
            enabled = true;
            keybind = "2";
          }
          {
            action = "hibernate";
            enabled = true;
            keybind = "3";
          }
          {
            action = "reboot";
            enabled = true;
            keybind = "4";
          }
          {
            action = "logout";
            enabled = true;
            keybind = "5";
          }
          {
            action = "shutdown";
            enabled = true;
            keybind = "6";
          }
          {
            action = "rebootToUefi";
            enabled = true;
            keybind = "7";
          }
        ];
        showHeader = true;
        showKeybinds = true;
      };

      systemMonitor = {
        batteryCriticalThreshold = 5;
        batteryWarningThreshold = 20;
        cpuCriticalThreshold = 90;
        cpuWarningThreshold = 80;
        criticalColor = "";
        diskAvailCriticalThreshold = 10;
        diskAvailWarningThreshold = 20;
        diskCriticalThreshold = 90;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = false;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        memCriticalThreshold = 90;
        memWarningThreshold = 80;
        swapCriticalThreshold = 90;
        swapWarningThreshold = 80;
        tempCriticalThreshold = 90;
        tempWarningThreshold = 80;
        useCustomColors = false;
        warningColor = "";
      };

      templates = {
        activeTemplates = [

        ];
        enableUserTheming = false;
      };

      ui = {
        boxBorderEnabled = false;
        fontDefault = "Berkeley Mono";
        fontDefaultScale = 1;
        fontFixed = "Berkeley Mono";
        fontFixedScale = 1;
        panelBackgroundOpacity = lib.mkForce 0.93;
        panelsAttachedToBar = true;
        scrollbarAlwaysVisible = true;
        settingsPanelMode = "attached";
        settingsPanelSideBarCardStyle = false;
        tooltipsEnabled = true;
        translucentWidgets = false;
      };

      home.file.".cache/noctalia/wallpapers.json" = {
        text = builtins.toJSON {
          # defaultWallpaper = ../../assests/background.png;
          defaultWallpaper = ../../assests/CatsWithNix.png;
        };
      };
      wallpaper = {
        automationEnabled = true;
        directory = "/home/bones/Pictures/Wallpapers";
        enableMultiMonitorDirectories = false;
        enabled = true;
        favorites = [

        ];
        fillColor = "#000000";
        fillMode = "crop";
        hideWallpaperFilenames = false;
        linkLightAndDarkWallpapers = true;
        monitorDirectories = [

        ];
        overviewBlur = 0.4;
        overviewEnabled = false;
        overviewTint = 0.6;
        panelPosition = "follow_bar";
        randomIntervalSec = 300;
        setWallpaperOnAllMonitors = true;
        showHiddenFiles = false;
        skipStartupTransition = false;
        solidColor = "#1a1a2e";
        sortOrder = "name";
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = [
          "honeycomb"
        ];
        useOriginalImages = false;
        useSolidColor = false;
        useWallhaven = false;
        viewMode = "single";
        wallhavenApiKey = "";
        wallhavenCategories = "111";
        wallhavenOrder = "desc";
        wallhavenPurity = "100";
        wallhavenQuery = "";
        wallhavenRatios = "";
        wallhavenResolutionHeight = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenSorting = "relevance";
        wallpaperChangeMode = "random";
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
    gcr
    wayland-logout
    # dpms-off
    # perSystem.self.wlr-dpms
  ];
}
