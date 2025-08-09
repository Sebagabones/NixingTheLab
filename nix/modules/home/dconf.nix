# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, config, pkgs, inputs, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/break-reminders" = { selected-breaks = [ "eyesight" ]; };

    "org/gnome/desktop/break-reminders/eyesight" = { play-sound = true; };

    "org/gnome/desktop/interface" = {
      accent-color = "purple";
      color-scheme = "prefer-dark";
      cursor-size = 32;
      cursor-theme = "Banana";
      document-font-name = "JetBrains Mono NF  11";
      enable-animations = true;
      font-name = "JetBrains Mono NF 12";
      gtk-theme = "adw-gtk3";
      monospace-font-name = "JetBrains Mono NF 12";
      overlay-scrolling = true;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screen-time-limits" = {
      daily-limit-enabled = false;
      grayscale = false;
    };

    "org/gnome/desktop/session" = { idle-delay = mkUint32 300; };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      # maximize = [ "<Super>Up" ];
      maximize-horizontally = [ "<Shift><Super>Page_Down" ];
      maximize-vertically = [ "<Shift><Super>Page_Up" ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-10 = [ "<Super><Shift>0" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
      # move-to-workspace-left = [ "<Shift><Super>Left" ];
      # move-to-workspace-right = [ "<Shift><Super>Right" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-10 = [ "<Super>0" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      # switch-to-workspace-left = [ "<Super>Left" ];
      # switch-to-workspace-right = [ "<Super>Right" ];
      toggle-fullscreen = [ "<Super>f" ];
      unmaximize = [ "<Shift><Super>minus" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 10;
      workspace-names = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
      logout = [ "<Shift><Super>e" ];
      search = [ "<Super>d" ];
      www = [ "<Super>w" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Super>Return";
        command = "ghostty";
        name = "Ghostty";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Super>t";
        command = "spotify";
        name = "Spotify";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
      {
        binding = "<Super>b";
        command = "discord";
        name = "Discord";
      };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disabled-extensions = [ "tilingshell@ferrarodomenico.com" ];
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
        "blur-my-shell@aunetx"
        "space-bar@luchrioh"
        "pop-shell@system76.com"
      ];
      last-selected-power-profile = "performance";
      welcome-dialog-last-shown-version = "48.2";
    };

    "org/gnome/shell/app-switcher" = { current-workspace-only = true; };

    "org/gnome/shell/extensions/blur-my-shell" = { settings-version = 2; };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.46;
      sigma = 10;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      enable-all = false;
      sigma = 29;
      whitelist = [ ];
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.6;
      override-background = true;
      pipeline = "pipeline_default";
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
      unblur-in-overview = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
      blur-original-panel = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      brightness = 0.6;
      pipeline = "pipeline_default";
      sigma = 30;
      static-blur = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      blur = true;
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accent-color-icon = false;
      accessibility-menu = true;
      background-menu = true;
      controls-manager-spacing-size = 0;
      dash = true;
      dash-icon-size = 0;
      double-super-to-appgrid = true;
      max-displayed-search-results = 0;
      osd = true;
      overlay-key = true;
      panel = true;
      panel-in-overview = true;
      ripple-box = true;
      search = true;
      show-apps-button = true;
      startup-status = 1;
      support-notifier-showed-version = 34;
      support-notifier-type = 0;
      theme = true;
      window-demands-attention-focus = false;
      window-picker-icon = true;
      window-preview-caption = true;
      window-preview-close-button = true;
      workspace = true;
      workspace-background-corner-size = 0;
      workspace-popup = true;
      workspace-wrap-around = false;
      workspaces-in-app-grid = true;
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = true;
      hint-color-rgba =
        "rgba(${config.lib.stylix.colors.base0D-rgb-r}, ${config.lib.stylix.colors.base0D-rgb-g}, ${config.lib.stylix.colors.base0D-rgb-b}, 1)";
      search = [ "<Meta>minus" ];
      show-title = false;
      smart-gaps = true;
      tile-by-default = true;
      tile-enter = [ "<Super>equal" ];
      toggle-floating = [ "<Shift><Super>space" ];
      focus-right = [ "<Super>Right" ];
      focus-left = [ "<Super>Left" ];
      tile-move-right = [ "<Shift><Super>Right" ];
      tile-move-left = [ "<Shift><Meta>Left" ];
    };

    "org/gnome/shell/extensions/space-bar/appearance" = {
      application-styles =
        ".space-bar {n  -natural-hpadding: 12px;n}nn.space-bar-workspace-label.active {n  margin: 0 4px;n  background-color: rgba(255,255,255,0.3);n  color: rgba(255,255,255,1);n  border-color: rgba(0,0,0,0);n  font-weight: 700;n  border-radius: 4px;n  border-width: 0px;n  padding: 3px 8px;n}nn.space-bar-workspace-label.inactive {n  margin: 0 4px;n  background-color: rgba(0,0,0,0);n  color: rgba(255,255,255,1);n  border-color: rgba(0,0,0,0);n  font-weight: 700;n  border-radius: 4px;n  border-width: 0px;n  padding: 3px 8px;n}nn.space-bar-workspace-label.inactive.empty {n  margin: 0 4px;n  background-color: rgba(0,0,0,0);n  color: rgba(255,255,255,0.5);n  border-color: rgba(0,0,0,0);n  font-weight: 700;n  border-radius: 4px;n  border-width: 0px;n  padding: 3px 8px;n}";
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = false;
      smart-workspace-names = true;
      toggle-overview = false;
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      enable-move-to-workspace-shortcuts = true;
      open-menu = [ "<Shift><Super>w" ];
    };

    "org/gnome/shell/extensions/space-bar/state" = { version = 33; };

    "org/gnome/shell/extensions/user-theme" = { name = "Stylix"; };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "<Shift><Super>n" ];
      switch-to-application-1 = [ ];
      switch-to-application-10 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };

  };
}
