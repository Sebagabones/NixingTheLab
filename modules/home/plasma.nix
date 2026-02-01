{
  inputs,
  lib,
  flake,
  nixpkgs,
  pkgs,
  config,
  perSystem,
  ...
}:
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
  home.file.".face".source = ../../assests/Parrot.png; # https://www.pexels.com/photo/red-blue-and-green-bird-on-tree-1331819/
  stylix = {
    targets.kde = {
      enable = false;
      useWallpaper = true;
      # decorations = "kwin4_decoration_qml_plastik";
    };
  };
  home.packages = with pkgs; [
    # papirus-icon-theme
    (catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "mauve";
    })
    kdePackages.krohnkite
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "classic" ];
    })
    (catppuccin-kvantum.override {
      accent = "mauve";
      variant = "mocha";
    })
    kdePackages.qtstyleplugin-kvantum
  ];
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    panels = [
      # Windows-like panel at the bottom
      {
        location = "top";
        widgets = [
          "org.kde.plasma.kickoff"
          # {
          #   kickerdash = {
          #     search = {
          #       expandSearchResults = true;
          #     };
          #   };
          # }
          {
            pager = {
              general = {
                showWindowOutlines = true;
                showApplicationIconsOnWindowOutlines = true;
                displayedText = "desktopNumber";
              };
            };
          }
          # "org.kde.plasma.pager"
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
              ];
            };
          }

          # { plasmaPanelColorizer = { general = { enable = true; }; }; }

          # {
          #   plasmusicToolbar = {
          #     songText = {
          #       scrolling = {
          #         behavior = "alwaysScroll";
          #       };
          #     };
          #   };
          # }

          {
            systemMonitor = {
              title = "CPU Usage/Temp";
              showTitle = false;
              displayStyle = "org,kde.ksysguard.piechart";
              sensors = [
                {
                  name = "cpu/all/usage";
                  label = "CPU Usage (%)";
                  color = "${config.lib.stylix.colors.base0D-rgb-r}, ${config.lib.stylix.colors.base0D-rgb-g}, ${config.lib.stylix.colors.base0D-rgb-b},  ";
                }
              ];
              totalSensors = [ "cpu/all/temperature" ];
            };
          }

          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
    workspace = {
      iconTheme = "Papirus";
      lookAndFeel = "Catppuccin-Mocha-Mauve";
      cursor.theme = "Banana";
      splashScreen = {
        theme = "org.kde.breeze.desktop";
        engine = "KSplashQML";
      };
      wallpaper = ../../assests/background.png;
      # theme = "default";
      widgetStyle = "Windows";
      # windowDecorations = {
      #   library = "org.kde.kwin.aurorae";
      #   theme = "kwin4_decoration_qml_plastik";
      # };
    };
    kscreenlocker.appearance.wallpaper = ../../assests/background.png;
    krunner = {
      position = "center";
      historyBehavior = "enableSuggestions";
      shortcuts = {
        launch = "Meta+d";
      };
    };
    shortcuts = {
      ActivityManager.switch-to-activity-2d1286e0-0620-4f4d-8692-472acee6b87d = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      kaccess."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      kmix.decrease_microphone_volume = "Microphone Volume Down";
      kmix.decrease_volume = "Volume Down";
      kmix.decrease_volume_small = "Shift+Volume Down";
      kmix.increase_microphone_volume = "Microphone Volume Up";
      kmix.increase_volume = "Volume Up";
      kmix.increase_volume_small = "Shift+Volume Up";
      kmix.mic_mute = [
        "Microphone Mute"
        "Meta+Volume Mute"
      ];
      kmix.mute = "Volume Mute";
      ksmserver."Halt Without Confirmation" = [ ];
      ksmserver."Lock Session" = [
        "Meta+L"
        "Screensaver"
      ];
      ksmserver."Log Out" = "Ctrl+Alt+Del";
      ksmserver."Log Out Without Confirmation" = [ ];
      ksmserver.LogOut = [ ];
      ksmserver.Reboot = [ ];
      ksmserver."Reboot Without Confirmation" = [ ];
      ksmserver."Shut Down" = [ ];
      kwin."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      kwin."Cycle Overview" = [ ];
      kwin."Cycle Overview Opposite" = [ ];
      kwin."Decrease Opacity" = [ ];
      kwin."Edit Tiles" = "Meta+T";
      kwin.Expose = "Ctrl+F9";
      kwin.ExposeAll = [
        "Ctrl+F10"
        "Launch (C)"
      ];
      kwin.ExposeClass = "Ctrl+F7";
      kwin.ExposeClassCurrentDesktop = [ ];
      kwin."Grid View" = "Meta+G";
      kwin."Increase Opacity" = [ ];
      kwin."Kill Window" = "Meta+Ctrl+Esc";
      kwin.KrohnkiteBTreeLayout = [ ];
      kwin.KrohnkiteColumnsLayout = [ ];
      kwin.KrohnkiteDecrease = [ ];
      kwin.KrohnkiteFloatAll = "Meta+Shift+F";
      kwin.KrohnkiteFloatingLayout = [ ];
      kwin.KrohnkiteFocusDown = "Meta+Down";
      kwin.KrohnkiteFocusLeft = "Meta+Left";
      kwin.KrohnkiteFocusNext = [ ];
      kwin.KrohnkiteFocusPrev = [ ];
      kwin.KrohnkiteFocusRight = "Meta+Right";
      kwin.KrohnkiteFocusUp = "Meta+Up";
      kwin.KrohnkiteGrowHeight = "Meta+Ctrl+J";
      kwin.KrohnkiteIncrease = "Meta+I";
      kwin.KrohnkiteMonocleLayout = "Meta+F";
      kwin.KrohnkiteNextLayout = "Meta+\\\\,none";
      kwin.KrohnkitePreviousLayout = "Meta+|";
      kwin.KrohnkiteQuarterLayout = [ ];
      kwin.KrohnkiteRotate = [ ];
      kwin.KrohnkiteRotatePart = [ ];
      kwin.KrohnkiteSetMaster = [ ];
      kwin.KrohnkiteShiftDown = "Meta+Shift+Down";
      kwin.KrohnkiteShiftLeft = [ ];
      kwin.KrohnkiteShiftRight = [ ];
      kwin.KrohnkiteShiftUp = "Meta+Shift+Up";
      kwin.KrohnkiteShrinkHeight = "Meta+Ctrl+K";
      kwin.KrohnkiteShrinkWidth = "Meta+Ctrl+H";
      kwin.KrohnkiteSpiralLayout = [ ];
      kwin.KrohnkiteSpreadLayout = [ ];
      kwin.KrohnkiteStackedLayout = [ ];
      kwin.KrohnkiteStairLayout = [ ];
      kwin.KrohnkiteTileLayout = [ ];
      kwin.KrohnkiteToggleFloat = "Meta+Space";
      kwin.KrohnkiteTreeColumnLayout = [ ];
      kwin.KrohnkitegrowWidth = "Meta+Ctrl+L";
      kwin.KrohnkitetoggleDock = [ ];
      kwin."Move Tablet to Next Output" = [ ];
      kwin.MoveMouseToCenter = "Meta+F6";
      kwin.MoveMouseToFocus = "Meta+F5";
      kwin.MoveZoomDown = [ ];
      kwin.MoveZoomLeft = [ ];
      kwin.MoveZoomRight = [ ];
      kwin.MoveZoomUp = [ ];
      kwin.Overview = [ ];
      kwin."Setup Window Shortcut" = [ ];
      kwin."Show Desktop" = [ ];
      kwin."Switch One Desktop Down" = "Meta+Ctrl+Down";
      kwin."Switch One Desktop Up" = "Meta+Ctrl+Up";
      kwin."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      kwin."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      kwin."Switch Window Down" = "Meta+Alt+Down";
      kwin."Switch Window Left" = "Meta+Alt+Left";
      kwin."Switch Window Right" = "Meta+Alt+Right";
      kwin."Switch Window Up" = "Meta+Alt+Up";
      kwin."Switch to Desktop 1" = "Meta+1";
      kwin."Switch to Desktop 10" = "Meta+0";
      kwin."Switch to Desktop 11" = [ ];
      kwin."Switch to Desktop 12" = [ ];
      kwin."Switch to Desktop 13" = [ ];
      kwin."Switch to Desktop 14" = [ ];
      kwin."Switch to Desktop 15" = [ ];
      kwin."Switch to Desktop 16" = [ ];
      kwin."Switch to Desktop 17" = [ ];
      kwin."Switch to Desktop 18" = [ ];
      kwin."Switch to Desktop 19" = [ ];
      kwin."Switch to Desktop 2" = "Meta+2";
      kwin."Switch to Desktop 20" = [ ];
      kwin."Switch to Desktop 3" = "Meta+3";
      kwin."Switch to Desktop 4" = "Meta+4";
      kwin."Switch to Desktop 5" = "Meta+5";
      kwin."Switch to Desktop 6" = "Meta+6";
      kwin."Switch to Desktop 7" = "Meta+7";
      kwin."Switch to Desktop 8" = "Meta+8";
      kwin."Switch to Desktop 9" = "Meta+9";
      kwin."Switch to Next Desktop" = [ ];
      kwin."Switch to Next Screen" = [ ];
      kwin."Switch to Previous Desktop" = [ ];
      kwin."Switch to Previous Screen" = [ ];
      kwin."Switch to Screen 0" = [ ];
      kwin."Switch to Screen 1" = [ ];
      kwin."Switch to Screen 2" = [ ];
      kwin."Switch to Screen 3" = [ ];
      kwin."Switch to Screen 4" = [ ];
      kwin."Switch to Screen 5" = [ ];
      kwin."Switch to Screen 6" = [ ];
      kwin."Switch to Screen 7" = [ ];
      kwin."Switch to Screen Above" = [ ];
      kwin."Switch to Screen Below" = [ ];
      kwin."Switch to Screen to the Left" = [ ];
      kwin."Switch to Screen to the Right" = [ ];
      kwin."Toggle Night Color" = [ ];
      kwin."Toggle Window Raise/Lower" = [ ];
      kwin."Walk Through Windows" = [
        "Meta+Tab"
        "Alt+Tab"
      ];
      kwin."Walk Through Windows (Reverse)" = [
        "Meta+Shift+Tab"
        "Alt+Shift+Tab"
      ];
      kwin."Walk Through Windows Alternative" = [ ];
      kwin."Walk Through Windows Alternative (Reverse)" = [ ];
      kwin."Walk Through Windows of Current Application" = [
        "Meta+`"
        "Alt+`"
      ];
      kwin."Walk Through Windows of Current Application (Reverse)" = [
        "Meta+~"
        "Alt+~"
      ];
      kwin."Walk Through Windows of Current Application Alternative" = [ ];
      kwin."Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
      kwin."Window Above Other Windows" = [ ];
      kwin."Window Below Other Windows" = [ ];
      kwin."Window Close" = "Meta+Q";
      kwin."Window Custom Quick Tile Bottom" = [ ];
      kwin."Window Custom Quick Tile Left" = [ ];
      kwin."Window Custom Quick Tile Right" = [ ];
      kwin."Window Custom Quick Tile Top" = [ ];
      kwin."Window Fullscreen" = [ ];
      kwin."Window Grow Horizontal" = [ ];
      kwin."Window Grow Vertical" = [ ];
      kwin."Window Lower" = [ ];
      kwin."Window Maximize" = "Meta+PgUp";
      kwin."Window Maximize Horizontal" = [ ];
      kwin."Window Maximize Vertical" = [ ];
      kwin."Window Minimize" = "Meta+PgDown";
      kwin."Window Move" = [ ];
      kwin."Window Move Center" = [ ];
      kwin."Window No Border" = [ ];
      kwin."Window On All Desktops" = [ ];
      kwin."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      kwin."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      kwin."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      kwin."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      kwin."Window One Screen Down" = [ ];
      kwin."Window One Screen Up" = [ ];
      kwin."Window One Screen to the Left" = [ ];
      kwin."Window One Screen to the Right" = [ ];
      kwin."Window Operations Menu" = "Alt+F3";
      kwin."Window Pack Down" = [ ];
      kwin."Window Pack Left" = [ ];
      kwin."Window Pack Right" = [ ];
      kwin."Window Pack Up" = [ ];
      kwin."Window Quick Tile Bottom" = [ ];
      kwin."Window Quick Tile Bottom Left" = [ ];
      kwin."Window Quick Tile Bottom Right" = [ ];
      kwin."Window Quick Tile Left" = [ ];
      kwin."Window Quick Tile Right" = [ ];
      kwin."Window Quick Tile Top" = [ ];
      kwin."Window Quick Tile Top Left" = [ ];
      kwin."Window Quick Tile Top Right" = [ ];
      kwin."Window Raise" = [ ];
      kwin."Window Resize" = [ ];
      kwin."Window Shrink Horizontal" = [ ];
      kwin."Window Shrink Vertical" = [ ];
      kwin."Window to Desktop 1" = "Meta+!";
      kwin."Window to Desktop 10" = "Meta+)";
      kwin."Window to Desktop 11" = [ ];
      kwin."Window to Desktop 12" = [ ];
      kwin."Window to Desktop 13" = [ ];
      kwin."Window to Desktop 14" = [ ];
      kwin."Window to Desktop 15" = [ ];
      kwin."Window to Desktop 16" = [ ];
      kwin."Window to Desktop 17" = [ ];
      kwin."Window to Desktop 18" = [ ];
      kwin."Window to Desktop 19" = [ ];
      kwin."Window to Desktop 2" = "Meta+@";
      kwin."Window to Desktop 20" = [ ];
      kwin."Window to Desktop 3" = "Meta+#";
      kwin."Window to Desktop 4" = "Meta+$";
      kwin."Window to Desktop 5" = "Meta+%";
      kwin."Window to Desktop 6" = "Meta+^";
      kwin."Window to Desktop 7" = "Meta+&";
      kwin."Window to Desktop 8" = "Meta+*";
      kwin."Window to Desktop 9" = "Meta+(";
      kwin."Window to Next Desktop" = [ ];
      kwin."Window to Next Screen" = [ ];
      kwin."Window to Previous Desktop" = [ ];
      kwin."Window to Previous Screen" = [ ];
      kwin."Window to Screen 0" = [ ];
      kwin."Window to Screen 1" = [ ];
      kwin."Window to Screen 2" = [ ];
      kwin."Window to Screen 3" = [ ];
      kwin."Window to Screen 4" = [ ];
      kwin."Window to Screen 5" = [ ];
      kwin."Window to Screen 6" = [ ];
      kwin."Window to Screen 7" = [ ];
      kwin.disableInputCapture = "Meta+Shift+Esc";
      kwin.view_actual_size = [ ];
      kwin.view_zoom_in = [
        "Meta++"
        "Meta+="
      ];
      kwin.view_zoom_out = "Meta+-";
      mediacontrol.mediavolumedown = [ ];
      mediacontrol.mediavolumeup = [ ];
      mediacontrol.nextmedia = "Media Next";
      mediacontrol.pausemedia = "Media Pause";
      mediacontrol.playmedia = [ ];
      mediacontrol.playpausemedia = "Media Play";
      mediacontrol.previousmedia = "Media Previous";
      mediacontrol.stopmedia = "Media Stop";
      org_kde_powerdevil."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      org_kde_powerdevil."Decrease Screen Brightness" = "Monitor Brightness Down";
      org_kde_powerdevil."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      org_kde_powerdevil.Hibernate = "Hibernate";
      org_kde_powerdevil."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      org_kde_powerdevil."Increase Screen Brightness" = "Monitor Brightness Up";
      org_kde_powerdevil."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      org_kde_powerdevil.PowerDown = "Power Down";
      org_kde_powerdevil.PowerOff = "Power Off";
      org_kde_powerdevil.Sleep = "Sleep";
      org_kde_powerdevil."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      org_kde_powerdevil."Turn Off Screen" = [ ];
      org_kde_powerdevil.powerProfile = [
        "Battery"
      ];
      plasmashell."Slideshow Wallpaper Next Image" = [ ];
      plasmashell."activate application launcher" = [
        "Alt+F1"
      ];
      plasmashell."activate task manager entry 1" = [ ];
      plasmashell."activate task manager entry 10" = [ ];
      plasmashell."activate task manager entry 2" = [ ];
      plasmashell."activate task manager entry 3" = [ ];
      plasmashell."activate task manager entry 4" = [ ];
      plasmashell."activate task manager entry 5" = [ ];
      plasmashell."activate task manager entry 6" = [ ];
      plasmashell."activate task manager entry 7" = [ ];
      plasmashell."activate task manager entry 8" = [ ];
      plasmashell."activate task manager entry 9" = [ ];
      plasmashell.clear-history = [ ];
      plasmashell.clipboard_action = "Meta+Ctrl+X";
      plasmashell.cycle-panels = "Meta+Alt+P";
      plasmashell.cycleNextAction = [ ];
      plasmashell.cyclePrevAction = [ ];
      plasmashell.edit_clipboard = [ ];
      plasmashell."manage activities" = [ ];
      plasmashell."next activity" = "Meta+A";
      plasmashell."previous activity" = "Meta+Shift+A";
      plasmashell.repeat_action = [ ];
      plasmashell."show dashboard" = "Ctrl+F12";
      plasmashell.show-barcode = [ ];
      plasmashell.show-on-mouse-pos = "Meta+V";
      plasmashell."switch to next activity" = [ ];
      plasmashell."switch to previous activity" = [ ];
      plasmashell."toggle do not disturb" = [ ];
      "services/com.mitchellh.ghostty.desktop"._launch = "Meta+Return";
      "services/firefox.desktop"._launch = "Meta+W";
      "services/discord.desktop"._launch = "Meta+B";

    };
    configFile = {
      baloofilerc.General.dbVersion = 2;
      baloofilerc.General."exclude filters" =
        "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
      baloofilerc.General."exclude filters version" = 9;
      kactivitymanagerdrc.activities."2d1286e0-0620-4f4d-8692-472acee6b87d" = "Default";
      kactivitymanagerdrc.main.currentActivity = "2d1286e0-0620-4f4d-8692-472acee6b87d";
      kded5rc.Module-device_automounter.autoload = false;

      kdeglobals.KDE.AnimationDurationFactor = 0.35355339059327373;
      kdeglobals.WM.activeBackground = "30,30,46";
      kdeglobals.WM.activeBlend = "249,226,175";
      kdeglobals.WM.activeForeground = "205,214,244";
      kdeglobals.WM.inactiveBackground = "30,30,46";
      kdeglobals.WM.inactiveBlend = "69,71,90";
      kdeglobals.WM.inactiveForeground = "205,214,244";
      kdeglobals.KDE.widgetStyle = "Windows";
      kwinrc."org.kde.kdecoration2".theme = "kwin4_decoration_qml_plastik";
      ksplashrc.KSplash.Theme = "org.kde.breeze.desktop";

      kwinrc.Desktops.Id_1 = "b35962ee-be7f-401b-8a56-580cb149d3b5";
      kwinrc.Desktops.Id_10 = "e2a5f9b0-5407-4380-ac51-d19a569d0b8d";
      kwinrc.Desktops.Id_2 = "0b7bf014-4fb4-42b0-98af-bbe486858d61";
      kwinrc.Desktops.Id_3 = "7c1269c5-7360-4b8a-9cbe-f31cd63fe9f0";
      kwinrc.Desktops.Id_4 = "33331143-0ef1-4737-a271-d64886a71664";
      kwinrc.Desktops.Id_5 = "01ae9022-4ff6-4c2a-b986-009599f48c63";
      kwinrc.Desktops.Id_6 = "26e1fa62-5e87-4146-94c8-d9e3ae76094e";
      kwinrc.Desktops.Id_7 = "93c60cd4-b90c-4e38-afac-6290727bc793";
      kwinrc.Desktops.Id_8 = "e2e61a31-a41b-45df-860d-69b1cbea956c";
      kwinrc.Desktops.Id_9 = "eefec68d-81c9-4f93-b5a3-7018ed71847a";
      kwinrc.Desktops.Number = {
        value = 10;
        immutable = true;
      };
      kwinrc.Desktops.Rows = 1;
      kwinrc.Plugins.desktopchangeosdEnabled = true;
      kwinrc.Plugins.fadedesktopEnabled = true;
      kwinrc.Plugins.krohnkiteEnabled = true;
      kwinrc.Plugins.slideEnabled = false;
      kwinrc.Script-desktopchangeosd.PopupHideDelay = 250;
      kwinrc.Script-krohnkite.spiralLayoutOrder = 1;
      kwinrc.Script-krohnkite.tileLayoutOrder = 4;
      kwinrc.Tiling.padding = 4;
      kwinrc."Tiling/01ae9022-4ff6-4c2a-b986-009599f48c63/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/0b7bf014-4fb4-42b0-98af-bbe486858d61/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/26e1fa62-5e87-4146-94c8-d9e3ae76094e/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/33331143-0ef1-4737-a271-d64886a71664/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/7c1269c5-7360-4b8a-9cbe-f31cd63fe9f0/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/93c60cd4-b90c-4e38-afac-6290727bc793/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/b35962ee-be7f-401b-8a56-580cb149d3b5/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/e2a5f9b0-5407-4380-ac51-d19a569d0b8d/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/e2e61a31-a41b-45df-860d-69b1cbea956c/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc."Tiling/eefec68d-81c9-4f93-b5a3-7018ed71847a/3ab34133-75f7-4b7a-be9e-3c1dcd5d7b5b".tiles =
        ''{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'';
      kwinrc.Xwayland.Scale = 1;
      plasma-localerc.Formats.LANG = "en_GB.UTF-8";
      spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
      spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";
    };
    dataFile = {

    };
  };
}
