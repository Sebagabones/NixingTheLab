{
  config,
  inputs,
  lib,
  flake,
  pkgs,
  perSystem,
  ...
}:
{

  imports = [
    # perSystem.spicetify-nix.homeManagerModulesfor.spicetify
    # flake.homeModules.gnome
    # flake.homeModules.plasma
    ./mango.nix
    # flake.homeModules.miracle-wm
    ./theming.nix
    flake.homeModules.spotify
    inputs.nixcord.homeModules.nixcord
    flake.homeModules.emacs
    inputs.xremap-flake.homeManagerModules.default
  ];

  # qt.platformTheme.name = lib.mkForce "adwaita";
  # qt.platformTheme.name = lib.mkForce "kvantum";
  # qt.style.name = lib.mkForce "kvantum";

  catppuccin = {
    kvantum.enable = true;
    vscode.profiles.default.enable = false;
  };

  stylix = {
    opacity = {
      terminal = 0.8;
      applications = 0.8;
    };

    targets = {
      noctalia-shell.enable = true;
      qt.platform = "qtct";
      nixcord.enable = false;
      vscode = {
        enable = false;
      };
      qt = {
        enable = true;
      };
      foot = {
        enable = true;
        opacity.enable = true;
        colors = {
          enable = false;
          override = {
            base08 = config.lib.stylix.colors.base0F;
          };
        };
        fonts.enable = true;
      };
      emacs.enable = false;
      firefox = {
        profileNames = [ "default" ];
        firefoxGnomeTheme.enable = true;
      };
      bemenu = {
        enable = false;
      };
    };
  };

  # programs.bemenu = {
  #   enable = true;
  #   settings = {
  #     ignorecase = true;
  #     wrap = true;
  #     list = "10";
  #     counter = "always";
  #     prompt = "launch:";
  #     scrollbar = "always";
  #     prefix = "'|>'";
  #     fb = "${config.lib.stylix.colors.withHashtag.base02}";
  #     ff = "${config.lib.stylix.colors.withHashtag.base06}";
  #     nb = "${config.lib.stylix.colors.withHashtag.base01}";
  #     nf = "${config.lib.stylix.colors.withHashtag.base06}";
  #     tb = "${config.lib.stylix.colors.withHashtag.base01}";
  #     hb = "${config.lib.stylix.colors.withHashtag.base00}";
  #     tf = "${config.lib.stylix.colors.withHashtag.base0C}";
  #     hf = "${config.lib.stylix.colors.withHashtag.base0E}";
  #     af = "${config.lib.stylix.colors.withHashtag.base06}";
  #     ab = "${config.lib.stylix.colors.withHashtag.base02}";
  #     scb = "${config.lib.stylix.colors.withHashtag.base01}";
  #     scf = "${config.lib.stylix.colors.withHashtag.base0D}";
  #   };
  # };

  programs.foot = {
    enable = true;
    # theme = "tokyonight-night";
    settings =
      let
        rgb-hue-editor = import ./../../packages/rgb-hue-editor/rgb-hue-editor.nix { inherit lib config; };
        hueEditFunc = rgb-hue-editor {
          hue_change = 0;
          saturation_change = 75;
          light_change = 2;
        };
      in
      {
        main = {
          # font = "Berkeley Mono:size=12";
          bold-text-in-bright = "no";
          # dpi-aware = lib.mkForce "yes";
          box-drawings-uses-font-glyphs = "yes"; # Maybe enable this? idk
          initial-color-theme = "dark";
        };
        colors-dark = {
          alpha = config.stylix.opacity.terminal;
          foreground = config.lib.stylix.colors.base05;
          background = config.lib.stylix.colors.base00;
          regular0 = config.lib.stylix.colors.base00;
          regular1 = config.lib.stylix.colors.base0F;
          regular2 = config.lib.stylix.colors.base0B;
          regular3 = config.lib.stylix.colors.base0A;
          regular4 = config.lib.stylix.colors.base0D;
          regular5 = config.lib.stylix.colors.base0E;
          regular6 = config.lib.stylix.colors.base0C;
          regular7 = config.lib.stylix.colors.base05;
          bright0 = config.lib.stylix.colors.base03;
          bright1 = hueEditFunc "base0F";
          bright2 = hueEditFunc "base0B";
          bright3 = hueEditFunc "base0A";
          bright4 = hueEditFunc "base0D";
          bright5 = hueEditFunc "base0E";
          bright6 = hueEditFunc "base0C";
          bright7 = config.lib.stylix.colors.base07;
          "16" = config.lib.stylix.colors.base09;
          "17" = config.lib.stylix.colors.base0F;
          "18" = config.lib.stylix.colors.base01;
          "19" = config.lib.stylix.colors.base02;
          "20" = config.lib.stylix.colors.base04;
          "21" = config.lib.stylix.colors.base06;
        };

        scrollback = {
          lines = 100000;
        };
        mouse.hide-when-typing = "yes";

        # colors.alpha = "0.99";
      };
  };

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
      gtk-tabs-location = "top";
      gtk-titlebar-style = "native";
      app-notifications = "no-clipboard-copy";
      # window-decoration = false;
      # gtk-single-instance = true;
      adw-toolbar-style = "raised-border";
      window-theme = "ghostty";
    };
  };
  home.file.".face".source = ../../assests/Parrot.png; # https://www.pexels.com/photo/red-blue-and-green-bird-on-tree-1331819/
  home.sessionVariables.MOZ_USE_XINPUT2 = "1";

  # NOTE: Remember, when configuring your extensions, you have a webserver running in background that will send a page to 127.0.0.1:8231 as your newtab
  programs.firefox = {
    configPath = ".mozilla/firefox";
    # configPath = ".mozilla/firefox";
    enable = true;
    # preferences = {
    #   "widget.use-xdg-desktop-portal.file-picker" = 1;
    # };

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

        "browser.contentblocking.category" = "standard"; # not strict because it conflicts with adnauseam
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
        #adnauseam
        bitwarden
        lovely-forks
        refined-github
        vimium-c
        ublock-origin
        indie-wiki-buddy
        stylus # Go download json and import from https://catppuccin-userstyles-customizer.uncenter.dev/
        # One day see if Hide Google AI Overviews has been added
      ];
    };
  };

  # Create vimium config as a file that can be imported
  # TODO: At some point add stylix support
  home.file."${config.programs.firefox.configPath}/../vimum-c.json" = {
    text = builtins.toJSON {
      name = "Vimium C";
      "@time" = "01/06/2026, 10:10:18 pm";
      time = 1780323018260;
      environment = {
        extension = "2.12.3";
        platform = "linux";
        firefox = 151;
      };
      exclusionRules = [
        {
          passKeys = "";
          pattern = ":https://www.circuit2tikz.tf.fau.de/";
        }
      ];
      extAllowList = [
        "# extension id or hostname"
        "newtab-adapter@gdh1995.cn"
        "shortcut-forwarding-tool@gdh1995.cn"
        ""
      ];
      grabBackFocus = true;
      keyLayout = 18;
      linkHintNumbers = "asdfghjkl";
      newTabUrl = "http://127.0.0.1:8231";
      searchEngines = [
        "sn: https://searchix.ovh/?query=$s"
        "np: https://search.nixos.org/packages?channel=unstable&query=$s"
        ""
      ];
      searchUrl = "https://www.google.com/search?q=$s Google";
      userDefinedCss = [
        "/*"
        "vimium cattpuccin-mocha mauve theme"
        ""
        "Adapted from https://github.com/Dhanush-777x/vimium-c-catppuccin/blob/main/firefox/vimium-c.css"
        "*/"
        ""
        "/* #ui */"
        "/* ^ do not touch this line ^ */"
        ""
        "/* .R,.DHM,.HM,.IHS,.IH,.BH,.MH {"
        "    color: #bac2de;"
        "    background: #181825;"
        "} */"
        ""
        "body {"
        "    background-color: #11121d;!important"
        "}"
        "/* link hints */"
        ".LH {"
        "  border: 2px #cba6f7 solid;"
        "  background: #313244;"
        "  margin-top: -2px;"
        "  margin-left: -2px;"
        "  color: #c0caf5;"
        "  z-index: 0;"
        "  scale: 1.1;"
        "  font-family: Berkley Mono;"
        "  box-shadow: 0px 2px 11px rgb(0, 0, 0, 0.12);"
        "}"
        ""
        ".LH:before {"
        "  position: absolute;"
        "  background: #11121d;"
        "  top: 0;"
        "  left: 0;"
        "  right: 0;"
        "  bottom: 0;"
        "  content: \"\";"
        "  z-index: -1;"
        "}"
        ""
        ".D .LH {"
        "  border-color: #bb9af7;"
        "  color: #c0caf5;"
        "}"
        ""
        "/* hints matching chars */"
        ".MC {"
        "  color: #7199ee;"
        "}"
        ""
        ".D .MC {"
        "  color:#7199ee;"
        "}"
        ""
        "/* bottom hud */"
        ".HUD {"
        "  bottom: 1rem;"
        "  left: unset;"
        "  right: 1rem;"
        "  border: 1px #bb9af7 solid;"
        "  border-radius: 6px;"
        "  box-shadow: 0 3px 10px #232634;"
        "  padding: 0.5rem 1rem;"
        "  height: 1.5rem !important;"
        "  line-height: 21px;"
        "  text-transform: lowercase;"
        "  background: #181825;"
        "  color: #c0caf5;"
        "  max-width: 420px;"
        "  min-width: unset;"
        "  display: flex;"
        "  align-items: center;"
        "}"
        ""
        ".has-dark .HUD {"
        "  background: #11121d;"
        "}"
        ""
        ".HUD.UI {"
        "  min-width: 180px;"
        "  align-items: unset;"
        "}"
        ""
        ".Omnibar {"
        "  padding-bottom: 20px;"
        "}"
        ""
        ".HUD:after {"
        "  border: none;"
        "  background: #11121d;"
        "}"
        ""
        ".HUD.D:after {"
        "  background: #11121d;"
        "}"
        ""
        "/* #omni */"
        "/* ^ do not touch this line ^ */"
        ""
        "* {"
        "  font-family: \"Berkley Mono\" !important;"
        "}"
        ""
        ".transparent {"
        "  opacity: 0.96;"
        "}"
        ""
        "body {"
        "  border-radius: 16px;"
        "  border: 3px #bb9af7 solid;"
        "  box-shadow: 2 9px 15px #11121d;"
        "}"
        ""
        "body.has-dark {"
        "  border-color: #bb9af7;"
        "}"
        ""
        "body:after {"
        "  border: unset;"
        "}"
        ""
        "#bar {"
        "  background: #11121d;"
        "  border-radius: unset;"
        "  border-bottom: unset;"
        "  height: 36px;"
        "  padding: 9px 10px;"
        "  padding-bottom: 5px;"
        "}"
        ""
        ".has-dark #bar {"
        "  background: #11121d;"
        "}"
        ""
        "#bar::before {"
        "  content: \"❯\";"
        "  display: inline-block;"
        "  width: 1rem;"
        "  height: 16px;"
        "  position: absolute;"
        "  left: 1rem;"
        "  z-index: 300;"
        "  font-size: 10;"
        "  padding: 6px 0;"
        "  line-height: 1.6em;"
        "  text-align: right;"
        "  color: #c0caf5;"
        "  font-weight: bold;"
        "}"
        ""
        ".has-dark #bar::before {"
        "  color: #11121d;"
        "}"
        ""
        "#input {"
        "  border: none;"
        "  background: none;"
        "  box-shadow: unset;"
        "  font-size: 20px;"
        "  color: #a9b1d6;"
        "  padding-left: 40rem;"
        "}"
        ""
        ".has-dark #input {"
        "  color: #a9b1d6;"
        "}"
        ""
        "#toolbar {"
        "  top: 7px;"
        "  right: 14px;"
        "}"
        ""
        "#toolbar .button {"
        "  height: 23px;"
        "  width: 24px;"
        "  padding: 3px;"
        "  cursor: pointer;"
        "  border: 3px transparent solid;"
        "  position: relative;"
        "  opacity: 0;"
        "  transition: 100ms ease-in-out opacity;"
        "}"
        ""
        "#toolbar .button:hover {"
        "  background: unset;"
        "  opacity: 0;"
        "}"
        ""
        "#toolbar .button>svg {"
        "  opacity: 0;"
        "}"
        ""
        ""
        "#list {"
        "  background: #11121d;"
        "  border-radius: unset;"
        "  padding: 5px;"
        "  padding-bottom: 6px;"
        "}"
        ""
        ".has-dark #list {"
        "  background: #11121d;"
        "}"
        ""
        ".item {"
        "  padding: 6px 10px;"
        "  padding-top: 3px;"
        "  margin: 0 5px;"
        "  margin-top: -2px;"
        "  border-radius: 6px;"
        "  border: unset;"
        "  border: 3px transparent solid;"
        "  height: 44px;"
        "}"
        ""
        ".item::before {"
        "  position: absolute;"
        "  background: none;"
        "  top: 0;"
        "  left: 0;"
        "  right: 0;"
        "  bottom: 0;"
        "  content: \"\";"
        "  z-index: -1;"
        "}"
        ""
        ".item.s,"
        ".item:hover {"
        "  background-color: unset;"
        "  border: 3px#7199ee solid;"
        "}"
        ""
        ".has-dark .item.s,"
        ".has-dark .item:hover {"
        "  border: 3px#7199ee solid;"
        "}"
        ""
        ".item.s::before {"
        "  background-color: #313244;"
        "}"
        ""
        ".item:hover::before {"
        "  background-color: #313244;"
        "}"
        ""
        ".has-dark .item.s::before {"
        "  background-color: #313244;"
        "}"
        ""
        ".has-dark .item:hover::before {"
        "  background-color: #313244;"
        "}"
        ""
        ".item .icon {"
        "  width: 24px;"
        "  height: 24px;"
        "  padding-right: unset;"
        "  margin-right: 10px;"
        "  margin-top: 5px;"
        "  background-position: bottom right;"
        "}"
        ""
        ".has-dark .item .icon {"
        "  fill: #a0a8cd;"
        "  stroke: #a0a8cd;"
        "}"
        ""
        ".item .icon path {"
        "  opacity: 0.45;"
        "  position: absolute;"
        "  z-index: -1;"
        "  transform-origin: 0px 0px;"
        "  transform: scale(0.75);"
        "}"
        ""
        ".item .top {"
        "  color: #a9b1d6;"
        "  position: relative;"
        "  height: 30px;"
        "}"
        ""
        ".has-dark .item .top {"
        "  color: #313244;"
        "}"
        ""
        ".item .top .title {"
        "  font-size: 16;"
        "  line-height: 0.8em;"
        "  margin-top: 2px;"
        "  color: #a9b1d6"
        "}"
        ""
        ".item .top .title match {"
        "  color:#7199ee;"
        "}"
        ""
        ".has-dark .item .top .title match {"
        "  color:#7199ee;"
        "}"
        ""
        ".item .top .title:empty::after {"
        "  content: \"<blank>\";"
        "}"
        ""
        ".item .bottom {"
        "  margin-top: -12px;"
        "  padding-left: 14px;"
        "}"
        ""
        ".item .bottom a {"
        "  color: #a0a8cd;"
        "  opacity: 0.9;"
        "  font-size: 16;"
        "}"
        ""
        ".has-dark .item .bottom a {"
        "  color: #a0a8cd;"
        "  opacity: 0.9;"
        "}"
        ""
        ".item .bottom a match {"
        "  color: #b4befe;"
        "}"
        ""
        ".has-dark .item .bottom a match {"
        "  color: #b4befe;"
        "}"
        ""
        "/* #find */"
        "/* ^ do not touch this line ^ */"
        ""
        "* {"
        "  font-family: \"JetBrainsMono Nerd Font\" !important;"
        "  background: unset;"
        "}"
        ""
        ":host,"
        "body {"
        "  background-color: #11121d !important;"
        "  margin: 0 !important;"
        "  padding: 0 !important;"
        "}"
        ""
        ":host(.D),"
        "body.D {"
        "  background-color: #11121d !important;"
        "  color: #c0caf5 !important;"
        "}"
        ""
        ".r {"
        "  color: #c0caf5;"
        "  border: none;"
        "  border-radius: unset;"
        "  box-shadow: unset;"
        "  background: #11121d;"
        "  height: 10px;"
        "}"
        ""
        ".r.D {"
        "  background: #11121d;"
        "  color: #c0caf5;"
        "}"
        ""
        "#i {"
        "  color: #c0caf5;"
        "}"
        ""
        ".D #i {"
        "  color: #c0caf5;"
        "}"
        ""
        "body {"
        "  background-color: #11121d !important;;"
        "}"
        ""
      ];
      vimSync = true;
      ignoreCapsLock = 2;
    };
  };

  # Create auto tab discord config as a file that can be imported
  # TODO: At some point add stylix support
  home.file."${config.programs.firefox.configPath}/../auto-tab-discord.json" = {
    text = builtins.toJSON {
      "chrome.storage.local" = {
        "./plugins/blank/core.js" = true;
        "./plugins/dummy/core.js" = false;
        "./plugins/focus/core.js" = false;
        "./plugins/force/core.js" = false;
        "./plugins/new/core.js" = true;
        "./plugins/next/core.js" = false;
        "./plugins/previous/core.js" = false;
        "./plugins/trash/core.js" = false;
        "./plugins/unloaded/core.js" = true;
        "./plugins/youtube/core.js" = true;
        audio = true;
        battery = false;
        click = "click.popup";
        faqs = true;
        favicon = true;
        favicon-delay = 500;
        "force.hostnames" = [

        ];
        form = true;
        go-hidden = false;
        idle = false;
        idle-timeout = 300;
        last-update = 1780318211156;
        "link.context" = true;
        log = false;
        "max.single.discard" = 150;
        memory-enabled = false;
        memory-value = 60;
        mode = "time-based";
        "notification.permission" = false;
        number = 6;
        online = true;
        "page.context" = true;
        paused = true;
        period = 120;
        pinned = false;
        prepends = "💤";
        simultaneous-jobs = 10;
        startup-pinned = false;
        startup-release-pinned = false;
        startup-unpinned = false;
        "tab.context" = true;
        "trash.period" = 24;
        "trash.unloaded" = false;
        "trash.whitelist-url" = [

        ];
        whitelist = [

        ];
        whitelist-url = [

        ];
      };
      localStorage = {
        click = "popup";
      };
    };
  };

  programs.spotify-player = {
    enable = true;
  };
  programs.autorandr = {
    enable = true;
  };
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        enkia.tokyo-night
        tuttieee.emacs-mcx
        ms-python.python
        charliermarsh.ruff
        mkhl.direnv
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ];
    };
    profiles.default.userSettings = {
      # ...
      "workbench.colorTheme" = "Tokyo Night";
    };
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  }; # for VS-Code

  home.packages = with pkgs; [
    # brightnessctl
    swaybg
    overskride
    libinput
    pavucontrol
    teams-for-linux
    networkmanagerapplet
    wlr-randr
    wl-clipboard
    brightnessctl
    libreoffice-qt6-fresh
    kdePackages.spectacle # for emacs
    # For ELEC3020:
    jre8 # For RETRO
    platformio
    esptool
    # End ELEC3020
    # kdePackages.dolphin
    freecad
    povray
    openscad-unstable
    prusa-slicer
    bitwarden-desktop
    impression
    localsend
  ];

  # pointerCursor = {
  #   name = "Banana";
  #   size = 32;
  #   package = pkgs.banana-cursor;

  #   x11.enable = true;
  #   gtk.enable = true;
  # };
  services = {
    xremap = {
      enable = true;
      withWlroots = true;
      # serviceMode = "system";
      # userName = "bones";
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

  home.file."${config.xdg.configHome}/gtk-2.0/gtkrc".force = true;
  gtk = {
    enable = true;
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      force = true;
    };
    # gtk4.theme = config.gtk.theme;
    cursorTheme = {
      name = "Banana";
      size = 32;
      package = pkgs.banana-cursor;
    };
    # gtk4.theme = null;
  };
  programs.nixcord = {
    enable = true; # Enable Nixcord (It also installs Discord)
    vesktop.enable = true; # Vesktop
    # dorion.enable = true; # Dorion
    # quickCss = "some CSS"; # quickCSS file
    config = {
      transparent = true;
      useQuickCss = true; # use out quickCSS
      # themeLinks = [
      #   # or use an online theme
      #   "https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css"

      #      ];
      frameless = true; # Set some Vencord options
      plugins = {
        userMessagesPronouns = {
          enable = true;
        };

        #   hideAttachments.enable = true; # Enable a Vencord plugin
        #   # ignoreActivities = { # Enable a plugin and set some options
        #   #   enable = true;
        #   #   ignorePlaying = true;
        #   #   ignoreWatching = true;
        #   #   ignoredActivities = [ "someActivity" ];
        #   # };
      };
    };
  };
}
