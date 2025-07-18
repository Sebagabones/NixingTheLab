{ flake, pkgs, perSystem, ... }:

{
  imports = [ flake.homeModules.niri ./theming.nix ];

  programs.niri = { enable = true; };

  programs.bemenu = { enable = true; };
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
      ];
      gtk-tabs-location = "hidden";
      gtk-single-instance = true;
    };
  };

  programs.firefox = {
    enable = true;
    profiles = {
      bones = {
        isDefault = true;
        # bookmarks, extensions, search engines...
        extensions.packages = with perSystem.firefox-addons; [
          ublock-origin
          vimium
        ];

        extraConfig = "widget.use-xdg-desktop-portal.file-picker = 1";
        settings =
          { # from https://github.com/TLATER/dotfiles/blob/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix
            # Performance settings
            "gfx.webrender.all" = true; # Force enable GPU acceleration
            "media.ffmpeg.vaapi.enabled" = true;
            "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

            # Hide the "sharing indicator", it's especially annoying
            # with tiling WMs on wayland
            "privacy.webrtc.legacyGlobalIndicator" = false;

            # Actual settings
            "app.shield.optoutstudies.enabled" = false;
            "app.update.auto" = false;
            "browser.bookmarks.restore_default_bookmarks" = false;
            "browser.contentblocking.category" = "strict";
            "browser.ctrlTab.recentlyUsedOrder" = true;
            "browser.discovery.enabled" = false;
            "browser.laterrun.enabled" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
              false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
              false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" =
              "";
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" =
              "";
            "browser.newtabpage.activity-stream.section.highlights.includePocket" =
              false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.pinned" = false;
            "browser.protections_panel.infoMessage.seen" = true;
            "browser.quitShortcut.disabled" = true;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.ssb.enabled" = true;
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.urlbar.placeholderName" = "DuckDuckGo";
            "browser.urlbar.suggest.openpage" = false;
            "datareporting.policy.dataSubmissionEnable" = false;
            "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_ever_enabled" = true;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "extensions.pocket.enabled" = false;
            "identity.fxaccounts.enabled" = false;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
          };

      };
    };
    nativeMessagingHosts =
      [ pkgs.plasma5Packages.plasma-browser-integration ]; # we love KDE

  };
  programs.spotify-player = { enable = true; };
  programs.autorandr = { enable = true; };

  home.packages = with pkgs; [
    discord
    networkmanagerapplet
    wlr-randr
    kdePackages.dolphin
  ];

  stylix = {

    image = ../../assests/background.png;

    cursor = {
      package = pkgs.banana-cursor;
      name = "banana-cursor";
      size = 24;
    };
    targets = {
      bemenu = {
        alternate = true;
        enable = true;
      };
      firefox.profileNames = [ "bones" ];
    };

  };

}
