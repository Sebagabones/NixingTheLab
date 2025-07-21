{
  flake,
  pkgs,
  perSystem,
  ...
}:

{
  imports = [
    flake.homeModules.miracle-wm
    ./theming.nix
  ];

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

  programs.fuzzel = {
    enable = true;
  };
  programs.bemenu = {
    enable = true;
    settings = {
      line-height = 28;
      prompt = "open";
      ignorecase = true;
      list = 5;
    };
  };
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      unfocused-split-opacity = 0.95;

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
      gtk-tabs-location = "hidden";
      # window-decoration = false;
      gtk-single-instance = true;
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
        adnauseam
        # bitwarden
        lovely-forks
        react-devtools
        refined-github
        vimium
      ];
    };
  };

  programs.spotify-player = {
    enable = true;
  };
  programs.autorandr = {
    enable = true;
  };
  programs.waybar = {
    enable = true;
  };
  programs.wofi = {
    enable = true;
  };
  home.packages = with pkgs; [
    swaybg
    teams-for-linux
    discord
    networkmanagerapplet
    wlr-randr
    wl-clipboard
    # kdePackages.dolphin
  ];

  # pointerCursor = {
  #   name = "Banana";
  #   size = 32;
  #   package = pkgs.banana-cursor;
  #   x11.enable = true;
  #   gtk.enable = true;
  # };

  # gtk = {
  #   enable = true;
  #   cursorTheme = {
  #     name = "Banana";
  #     size = 32;
  #     package = pkgs.banana-cursor;
  #   };
  # };

}
